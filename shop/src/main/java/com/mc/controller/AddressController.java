package com.mc.controller;

import com.mc.app.dto.Address;
import com.mc.app.dto.Customer;
import com.mc.app.service.AddressService;
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

    private final AddressService addrService;

    @RequestMapping("")
    public String address(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {
        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login"; // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 마이페이지를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/address?id=" + loggedInCustomer.getCustId(); // 자신의 마이페이지만 보여줌
        }
        log.info("hi" + loggedInCustomer.getCustId());

        List<Address> address = addrService.findAllByCustomer(id);

        model.addAttribute("address", address);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Address");
        model.addAttribute("viewName", "address");
        model.addAttribute("centerPage", "pages/mypage/address.jsp");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model, HttpSession session) throws Exception {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Address Add");
        model.addAttribute("viewName", "address_add");
        model.addAttribute("centerPage", "pages/mypage/address_add.jsp");
        return "index";
    }

    @RequestMapping("/mod")
    public String mod(Model model, HttpSession session, @RequestParam("addrKey") int addrKey) throws Exception {

        Address address = addrService.findById(addrKey);

        model.addAttribute("address", address);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Address Detail");
        model.addAttribute("viewName", "address_detail");
        model.addAttribute("centerPage", "pages/mypage/address_detail.jsp");
        return "index";
    }

    @RequestMapping("/addimpl")
    public String addimpl(Model model, @RequestParam("custId") String custId, Address address) throws Exception {

        if ("Y".equals(address.getAddrDef())) {
            List<Address> addrList = addrService.findAllByCustomer(custId);
            for (Address addr : addrList) {
                addr.setAddrDef("N");
                addrService.mod(addr);
            }
        } else {
            address.setAddrDef("N");
        }

        address.setCustId(custId);
        addrService.add(address);
        return "redirect:/address?id=" + custId;
    }

    @RequestMapping("/updateimpl")
    public String updateimpl(Model model, @RequestParam("custId") String custId, Address address) throws Exception {

        if ("Y".equals(address.getAddrDef())) {
            List<Address> addrList = addrService.findAllByCustomer(custId);
            for (Address addr : addrList) {
                addr.setAddrDef("N");
                addrService.mod(addr);
            }
        } else {
            address.setAddrDef("N");
        }
        addrService.mod(address);
        return "redirect:/address/mod?addrKey=" + address.getAddrKey();
    }

    @RequestMapping("/delimpl")
    public String derlimpl(Model model, @RequestParam("addrKey") int addrKey, HttpSession session) throws Exception {
        String custId = session.getId();
        addrService.del(addrKey);
        return "redirect:/address?id=" + custId;
    }
}
