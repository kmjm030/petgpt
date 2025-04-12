package com.mc.controller;

import com.mc.app.dto.Address;
import com.mc.app.dto.Customer;
import com.mc.app.service.AddressService;
import com.mc.app.service.CustomerService;
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
@RequestMapping("/address")
public class AddressController {

    private final CustomerService custService;
    private final AddressService addrService;

    @RequestMapping("")
    public String address(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {
        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer)session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login";  // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 마이페이지를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/address?id=" + loggedInCustomer.getCustId();  // 자신의 마이페이지만 보여줌
        }
        log.info("hi" + loggedInCustomer.getCustId());

        List<Address> address = addrService.findAllByCustomer(id);

        model.addAttribute("address", address);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Address");
        model.addAttribute("centerPage", "pages/mypage/address.jsp");
        return "index";
    }
}
