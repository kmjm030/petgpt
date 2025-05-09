package com.mc.controller;

import com.mc.app.dto.Address;
import com.mc.app.dto.Coupon;
import com.mc.app.dto.Customer;
import com.mc.app.service.AddressService;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@Slf4j
@RequiredArgsConstructor
public class LoginController {

    final CustomerService custService;
    final AddressService addrService;
    final CouponService couponService;

    @RequestMapping("/goregister")
    public String goregister(Model model, Customer cust, Address address) throws Exception {
        log.info(cust.toString());
        custService.add(cust);
        address.setAddrDef("Y");
        address.setAddrName("기본배송지");
        address.setAddrTel(cust.getCustPhone());
        addrService.add(address);
        Coupon coupon = Coupon.builder().custId(cust.getCustId()).couponName("회원가입 축하 쿠폰")
                .couponPrice(5000).couponMaxPrice(5000).couponType("정액")
                .couponUse("미사용").build();
        couponService.add(coupon);

        model.addAttribute("centerPage", "pages/login.jsp");
        return "index";
    }

    // 로그인 페이지 보여주기 (GET 요청 처리)
    @GetMapping("/gologin")
    public String showLoginPage(Model model, HttpSession session,
            @RequestParam(name = "redirectURL", required = false) String redirectURL) { // Explicitly name the parameter
        if (redirectURL != null && !redirectURL.isEmpty()) {
            session.setAttribute("redirectURL", redirectURL);
        } else {
            session.removeAttribute("redirectURL");
        }
        // 독립적인 로그인 페이지로 리다이렉션
        return "redirect:/signin";
    }

    // 로그인 처리 (POST 요청 처리)
    @PostMapping("/loginimpl")
    public String loginProcess(Model model, @RequestParam("id") String id,
            @RequestParam("pwd") String pwd,
            HttpSession httpSession) throws Exception {

        Customer dbCust = custService.get(id);
        if (dbCust != null && pwd.equals(dbCust.getCustPwd())) {
            httpSession.setAttribute("cust", dbCust);

            String redirectURL = (String) httpSession.getAttribute("redirectURL");
            httpSession.removeAttribute("redirectURL");

            if (redirectURL != null && !redirectURL.isEmpty()) {
                return "redirect:" + redirectURL;
            } else {
                return "redirect:/";
            }
        }
        // 로그인 실패 시 signin 페이지로 리다이렉트하고 오류 메시지 전달
        model.addAttribute("msg", "아이디 또는 패스워드가 일치하지 않습니다.");
        return "redirect:/signin";
    }

    @RequestMapping(value = "/signout", method = {RequestMethod.GET, RequestMethod.POST})
    public String logout(Model model, HttpSession httpSession, HttpServletResponse response) throws Exception {
        log.info("로그아웃 메서드 호출됨");
        if (httpSession != null) {
            Customer cust = (Customer) httpSession.getAttribute("cust");
            if (cust != null) {
                log.info("로그아웃: 사용자 ID {}", cust.getCustId());
            }
            httpSession.invalidate(); // 로그인해서 깃발 꽂아놨던 것을 없앰
            log.info("사용자 로그아웃 처리 완료 - 세션 무효화됨");
        } else {
            log.info("로그아웃: 세션이 이미 없음");
        }
        log.info("로그아웃 후 홈으로 리다이렉트");
        return "redirect:/";
    }

}
