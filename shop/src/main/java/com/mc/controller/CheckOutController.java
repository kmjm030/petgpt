package com.mc.controller;

import com.mc.app.dto.Address;
import com.mc.app.dto.Coupon;
import com.mc.app.dto.Customer;
import com.mc.app.service.AddressService;
import com.mc.app.service.CartService;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/checkout")
public class CheckOutController {

    private final CartService cartService;
    private final CustomerService custService;
    private final AddressService addrService;
    private final CouponService couponService;

    @GetMapping("")
    public String checkOut(Model model, HttpSession session) throws Exception {

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/gologin";
        }
        String custId = loggedInCustomer.getCustId();
        List<Map<String, Object>> cartItems = cartService.getCartWithItems(custId);
        Customer cust = custService.get(custId);

        long totalCartPrice = calculateTotal(cartItems);
        Address defAddress = null;
        List<Address> addrList = addrService.findAllByCustomer(custId);
        for (Address address : addrList) {
            if(address.getAddrDef().equals("Y")){
                defAddress = address;
            }
        }

        List<Coupon> coupons = couponService.findByCustId(custId);

        model.addAttribute("coupons", coupons);
        model.addAttribute("defAddress", defAddress);
        model.addAttribute("addrList", addrList);
        model.addAttribute("cust", cust);
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalCartPrice", totalCartPrice);
        model.addAttribute("centerPage", "pages/checkout.jsp");
        return "index";
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
