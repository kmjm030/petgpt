package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.Item;
import com.mc.app.dto.Like;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import com.mc.app.service.ItemService;
import com.mc.app.service.LikeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class CustomerController {

    String dir = "mypage/";

    private final CustomerService custService;
    private final LikeService likeService;
    private final ItemService itemService;


    @GetMapping("")
    public String mypage(Model model, @RequestParam("id") String id, HttpSession session) throws Exception{

        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer)session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login";  // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 마이페이지를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/mypage?id=" + loggedInCustomer.getCustId();  // 자신의 마이페이지만 보여줌
        }

        Customer cust = custService.get(id);
        model.addAttribute("cust", cust);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "MyPage");
        model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
        return "index";
    }

    @RequestMapping("/updateimpl")
    public String updateimpl(Model model, Customer cust,
                             @RequestParam("newPwd") String newPwd) throws Exception {

        // 현재 비밀번호 확인
        Customer dbCust = custService.get(cust.getCustId());
        if (dbCust == null) {
            model.addAttribute("msg", "사용자 정보를 찾을 수 없습니다.");
            model.addAttribute("cust", cust);
            return "redirect:/mypage?id=" + cust.getCustId(); // 사용자 정보 없음
        } else if (!dbCust.getCustPwd().equals(cust.getCustPwd())) {
            model.addAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
            model.addAttribute("cust", cust);
            return "redirect:/mypage?id=" + cust.getCustId(); // 비밀번호 불일치 시 에러 메시지 출력
        }

        if (newPwd != null && !newPwd.trim().isEmpty()) {
            cust.setCustPwd(newPwd);
        }

        custService.mod(cust);
        return "redirect:/mypage?id=" + dbCust.getCustId();
    }

    @RequestMapping("/like")
    public String like(Model model, @RequestParam("id") String id) throws Exception {

        List<Like> likes = likeService.getLikesByCustomer(id);
        List<Item> items = new ArrayList<>();
        for (Like like : likes) {
            Item item = itemService.get(like.getItemKey());
            items.add(item);
        }

        model.addAttribute("items", items);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Like Page");
        model.addAttribute("centerPage", "pages/mypage/like.jsp");
        return "index";
    }

    @RequestMapping("/likedelimpl")
    public String likedelimpl(Model model, @RequestParam("itemKey") int itemKey,
                                            @RequestParam("id") String custId) throws Exception {
        likeService.deleteForMypage(custId, itemKey);
        return "redirect:/mypage/like?id=" + custId;
    }



}
