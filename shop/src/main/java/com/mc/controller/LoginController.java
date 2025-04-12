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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Slf4j
@RequiredArgsConstructor
public class LoginController {

    final CustomerService custService;
    final AddressService addrService;

    @RequestMapping("/goregister")
    public String goregister(Model model, Customer cust, Address address) throws Exception {
        log.info(cust.toString());
        custService.add(cust);
        address.setAddrDef("Y");
        address.setAddrName("기본배송지");
        address.setAddrTel(cust.getCustPhone());
        address.setAddrReq(null);
        addrService.add(address);
        model.addAttribute("centerPage", "pages/login.jsp");
        return "index";
    }

    // 로그인 페이지 보여주기 (GET 요청 처리)
    @GetMapping("/gologin")
    public String showLoginPage(Model model) {
        model.addAttribute("centerPage", "pages/login.jsp");
        return "index";
    }

    // 로그인 처리 (POST 요청 처리)
    @PostMapping("/loginimpl") // 경로 변경 및 POST 매핑
    public String loginProcess(Model model, @RequestParam("id") String id,
                               @RequestParam("pwd") String pwd,
                               HttpSession httpSession) throws Exception {

        Customer dbCust = custService.get(id);
        if(dbCust != null && pwd.equals(dbCust.getCustPwd())){
            httpSession.setAttribute("cust", dbCust);
            return "redirect:/";
        }
        model.addAttribute("centerPage", "pages/login.jsp");
        model.addAttribute("msg", "아이디 또는 패스워드가 일치하지 않습니다.");
        return "index";
    }

    @RequestMapping("/logout")
    public String logout(Model model, HttpSession httpSession) throws Exception {
        if(httpSession != null){
            httpSession.invalidate();       // 로그인해서 깃발 꽂아놨던 것을 없앰
        }
        return "redirect:/";
    }


}
