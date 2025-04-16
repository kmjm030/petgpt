package com.mc.controller;

import com.mc.app.dto.Cart;
import com.mc.app.dto.Customer;
import com.mc.app.service.CartService;
import com.mc.app.service.ItemService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/cart")
public class CartController {
    final CartService cartService;
    final ItemService itemService;

    @RequestMapping("")
    public String cart(Model model, HttpSession session) throws Exception { 
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/gologin";
        }
        String custId = loggedInCustomer.getCustId(); 
        List<Map<String, Object>> cartItems = cartService.getCartWithItems(custId); 
        // 총액 계산 로직
        long totalCartPrice = calculateTotal(cartItems);
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalCartPrice", totalCartPrice);
        model.addAttribute("centerPage", "pages/shopping_cart.jsp");
        return "index";
    }
    @RequestMapping("/del")
    public String del(Model model, @RequestParam("itemKey") int itemKey, @RequestParam(value = "optionKey", required = false) Integer optionKey, HttpSession session) throws Exception {
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/gologin";
        }
        String custId = loggedInCustomer.getCustId();
        cartService.del(custId, itemKey, optionKey);
        return "redirect:/cart";
    }

    @RequestMapping("/add")
    public String add(Model model, Cart cart, HttpSession session) throws Exception { 
        Customer loggedInCustomer = (Customer) session.getAttribute("cust"); 

        if (loggedInCustomer == null) {
            return "redirect:/gologin";
        }

        String custId = loggedInCustomer.getCustId();
        cart.setCustId(custId);
        cartService.add(cart);
        return "redirect:/cart"; 
    }

    // Ajax 요청을 위한 별도의 add 메소드
    @RequestMapping(value = "/add/ajax", method = RequestMethod.POST) 
    @ResponseBody 
    public Map<String, Object> addCartItemAjax(@RequestBody Cart cart, HttpSession session) { 
        Map<String, Object> response = new HashMap<>();
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");

        if (loggedInCustomer == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            response.put("redirectUrl", "/gologin"); 
            return response;
        }

        String custId = loggedInCustomer.getCustId();
        cart.setCustId(custId);

        try {
            cartService.add(cart); 
            response.put("success", true);
        } catch (Exception e) {
            log.error("장바구니 추가 오류", e);
            response.put("success", false);
            response.put("message", "장바구니 추가 중 오류가 발생했습니다.");
        }

        return response; 
    }
 
    @PostMapping("/add/batch/ajax") 
    @ResponseBody                  
    public Map<String, Object> addCartItemsBatchAjax(@RequestBody List<Cart> cartItems, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");

        if (loggedInCustomer == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            response.put("redirectUrl", "/gologin"); 
            return response;
        }

        String custId = loggedInCustomer.getCustId();

        if (cartItems == null || cartItems.isEmpty()) {
            response.put("success", false);
            response.put("message", "장바구니에 담을 상품 정보가 없습니다.");
            return response;
        }

        try {
            int addedCount = 0;
            for (Cart cart : cartItems) {
                if (cart.getCartCnt() > 0) { 
                    cart.setCustId(custId); 
                    cartService.add(cart); 
                    addedCount++;
                } else {
                    log.warn("장바구니 추가 요청 건너뜀 (수량 0 이하): {}", cart);
                }
            }

            if (addedCount > 0) {
                response.put("success", true);
                response.put("message", "선택하신 " + addedCount + "개 상품 옵션을 장바구니에 담았습니다.");
            } else {
                response.put("success", false); 
                response.put("message", "장바구니에 담을 유효한 상품이 없습니다.");
            }

        } catch (Exception e) {
            log.error("장바구니 일괄 추가 처리 중 오류 발생 - CustID: {}", custId, e);
            response.put("success", false);
            response.put("message", "장바구니 추가 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }

        return response;
    }
 
    @RequestMapping("/updateQuantity")
    @ResponseBody
    public Map<String, Object> updateQuantity(@RequestBody Cart cart, HttpSession session) { 
        Map<String, Object> response = new HashMap<>();
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        
        if (loggedInCustomer == null) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return response;
        }

        if (!loggedInCustomer.getCustId().equals(cart.getCustId())) {
            log.warn("보안 경고 (수량 업데이트): 세션 ID({})와 장바구니 요청 ID({}) 불일치", loggedInCustomer.getCustId(), cart.getCustId());
            response.put("success", false);
            response.put("message", "잘못된 접근입니다.");
            return response;
        }

        String custId = loggedInCustomer.getCustId();
        cart.setCustId(custId);

        try {
            cartService.mod(cart);

            List<Map<String, Object>> cartItems = cartService.getCartWithItems(custId);

            long totalCartPrice = calculateTotal(cartItems);

            response.put("success", true);
            response.put("cartItems", cartItems);
            response.put("totalCartPrice", totalCartPrice);

        } catch (Exception e) {
            log.error("장바구니 수량 변경 오류", e);
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    private long calculateTotal(List<Map<String, Object>> cartItems) {
        long total = 0;
        if (cartItems != null) {
            for (Map<String, Object> item : cartItems) {
                try {
                    Number priceNum = (Number) item.get("item_price");
                    Number countNum = (Number) item.get("cart_cnt");

                    if (priceNum != null && countNum != null) {
                        long price = priceNum.longValue();
                        int count = countNum.intValue();
                        total += price * count;
                    }
                } catch (Exception e) {
                    log.error("총액 계산 중 오류 발생 (item: {}): {}", item, e.getMessage());
                }
            }
        }
        return total;
    }

}
