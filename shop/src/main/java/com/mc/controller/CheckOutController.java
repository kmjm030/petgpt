package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
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
    private final TotalOrderService totalOrderService;
    private final OrderDetailService orderDetailService;
    private final AddressService addressService;
    private final ItemService itemService;

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
            if (address.getAddrDef().equals("Y")) {
                defAddress = address;
            }
        }

        List<Coupon> coupons = couponService.findUsableByCustId(custId);
        session.setAttribute("cartItems", cartItems);

        model.addAttribute("coupons", coupons);
        model.addAttribute("defAddress", defAddress);
        model.addAttribute("addrList", addrList);
        model.addAttribute("cust", cust);
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalCartPrice", totalCartPrice);
        model.addAttribute("viewName", "checkout");
        model.addAttribute("centerPage", "pages/checkout.jsp");
        return "index";
    }

    @RequestMapping("/orderimpl")
    public String orderimpl(Model model, Address address, TotalOrder totalOrder, HttpSession session,
            @RequestParam("custId") String custId,
            @RequestParam(value = "addrSave", required = false) String addrSave,
            @RequestParam("orderTotalPrice") int orderTotalPrice,
            @RequestParam(value = "couponId", required = false) Integer couponId) throws Exception {

        // 세션에서 cartItems 꺼내기
        List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("cartItems");

        // 쿠폰 사용완료로 바꾸기

        TotalOrder order = totalOrder;
        if (couponId != null) {
            Coupon coupon = couponService.get(couponId);
            if (coupon != null) {
                coupon.setCouponUse("Y");
                couponService.mod(coupon);
            }
            order.setCouponId(couponId);
        } else {
            order.setCouponId(0);
        }
        // TotalOrder 저장하기

        order.setCustId(custId);
        order.setOrderAddr(address.getAddrAddress());
        order.setOrderAddrDetail(address.getAddrDetail());
        order.setOrderAddrRef(address.getAddrRef());
        order.setOrderHomecode(address.getAddrHomecode());
        order.setOrderTotalPrice(orderTotalPrice);
        order.setItemKey((int) cartItems.get(0).get("item_key"));
        totalOrderService.add(order);

        int orderKey = order.getOrderKey();

        // OrderDetail 저장하기
        if (cartItems != null && !cartItems.isEmpty()) {
            for (Map<String, Object> item : cartItems) {
                int itemKey = (int) item.get("item_key");
                int cnt = (int) item.get("cart_cnt");
                int optionKey = item.get("option_key") != null ? (int) item.get("option_key") : 0;
                int price = (int) item.get("item_price");
                int additional = item.get("additional_price") != null ? (int) item.get("additional_price") : 0;
                int finalPrice = price + additional;

                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setItemKey(itemKey);
                orderDetail.setOptionKey(optionKey);
                orderDetail.setOrderKey(orderKey);
                orderDetail.setOrderDetailPrice(finalPrice);
                orderDetail.setOrderDetailCount(cnt);

                orderDetailService.add(orderDetail);
            }
        }

        // 배송지 저장하기
        if (addrSave != null && addrSave.equals("Y")) {
            Address addr = address;
            addr.setCustId(custId);
            addr.setAddrName(order.getRecipientName());
            addr.setAddrTel(order.getRecipientPhone());
            addr.setAddrDef("N");
            addressService.add(addr);
        }

        session.removeAttribute("cartItems"); // 사용 후 정리!
        return "redirect:/checkout/success";

    }

    @RequestMapping("/success")
    public String success(Model model, HttpSession session) throws Exception {
        model.addAttribute("centerPage", "pages/order_success.jsp");
        return "index";
    }

    @RequestMapping("/orderlist")
    public String orderlist(Model model, HttpSession session, @RequestParam("id") String id) throws Exception {
        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login"; // 로그인 페이지로 리다이렉트
        }

        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/orderlist?id=" + loggedInCustomer.getCustId(); // 자신의 마이페이지만 보여줌
        }

        List<TotalOrder> orderList = totalOrderService.findAllByCust(id);
        Map<Integer, String> itemNames = new HashMap<>();

        for (TotalOrder order : orderList) {
            Item item = itemService.get(order.getItemKey());
            itemNames.put(order.getOrderKey(), item.getItemName());
        }

        model.addAttribute("orderList", orderList);
        model.addAttribute("itemNames", itemNames);

        model.addAttribute("orderList", orderList);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Order List");
        model.addAttribute("centerPage", "pages/mypage/order.jsp");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, HttpSession session, @RequestParam("orderKey") int orderKey) throws Exception {
        TotalOrder order = totalOrderService.get(orderKey);
        List<OrderDetail> orderDetails = orderDetailService.findAllByOrder(orderKey);

        Map<Integer, Item> itemMap = new HashMap<>();
        for (OrderDetail od : orderDetails) {
            int itemKey = od.getItemKey();
            if (!itemMap.containsKey(itemKey)) {
                Item item = itemService.get(itemKey); // itemService에서 단건 조회
                itemMap.put(itemKey, item);
            }
        }

        model.addAttribute("order", order);
        model.addAttribute("orderDetails", orderDetails);
        model.addAttribute("itemMap", itemMap);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Order Detail");
        model.addAttribute("centerPage", "pages/mypage/order_detail.jsp");
        return "index";
    }

    @RequestMapping("/delimpl")
    public String delimpl(Model model, HttpSession session, @RequestParam("orderKey") int orderKey) throws Exception {
        TotalOrder order = totalOrderService.get(orderKey);
        Coupon coupon = couponService.get(order.getCouponId());
        if (coupon != null) {
            coupon.setCouponUse("N");
            couponService.mod(coupon);
        }
        totalOrderService.del(orderKey);

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        return "redirect:/checkout/orderlist?id=" + loggedInCustomer.getCustId();
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
