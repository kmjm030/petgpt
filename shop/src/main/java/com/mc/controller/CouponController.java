package com.mc.controller;

import com.mc.app.dto.Coupon;
import com.mc.app.dto.Customer;
import com.mc.app.service.CouponService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/coupon")
public class CouponController {

    final CouponService couponService;

    @RequestMapping("")
    public String coupon(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/signin";
        }
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/mypage?id=" + loggedInCustomer.getCustId(); 
        }
        List<Coupon> coupons = couponService.findUsableByCustId(id);

        model.addAttribute("coupons", coupons);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Coupon Page");
        model.addAttribute("viewName", "coupon");
        model.addAttribute("centerPage", "pages/mypage/coupon.jsp");
        return "index";
    }

}
