package com.mc.controller;

import com.mc.app.dto.Item;
import com.mc.app.service.ItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final ItemService itemService;

    @GetMapping("/")
    public String home(Model model) {

        int limit = 8; // 가져올 상품 개수
        List<Item> bestSellerList; // try 블록 밖에서 선언

        try {
            // 초기 로드 시 기본 목록 (예: 베스트셀러) 조회
            bestSellerList = itemService.getBestSellingItems(limit); // 예외 발생 가능성 있음
        } catch (Exception e) {
            // 예외 처리: 로그를 남기거나 사용자에게 오류 메시지 전달
            System.err.println("Error fetching best selling items: " + e.getMessage()); // 또는 로거 사용
            e.printStackTrace(); // 개발 중 상세 오류 확인
            model.addAttribute("errorMessage", "베스트셀러 상품 목록을 불러오는 중 오류가 발생했습니다.");
            bestSellerList = Collections.emptyList(); // 빈 목록으로 초기화하여 JSP 오류 방지
            // 또는 bestSellerList = new ArrayList<>();
        }

        model.addAttribute("bestSellerList", bestSellerList);

        model.addAttribute("currentPage", "home");
        model.addAttribute("pageTitle", "Home");
        model.addAttribute("viewName", "home");
        model.addAttribute("centerPage", "pages/home.jsp");
        return "index";
    }

    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "About Us");
        model.addAttribute("viewName", "about");
        model.addAttribute("centerPage", "pages/about.jsp");
        return "index";
    }

    @GetMapping("/signup")
    public String signup(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Sign up");
        model.addAttribute("viewName", "signup");
        model.addAttribute("centerPage", "pages/signup.jsp");
        return "index";
    }

    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Log In");
        model.addAttribute("viewName", "login");
        model.addAttribute("centerPage", "pages/login.jsp");
        return "index";
    }

    @GetMapping("/shopdetails")
    public String shopDetails(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Shop Details");
        model.addAttribute("viewName", "shop-details");
        model.addAttribute("centerPage", "pages/shop_details.jsp");
        return "index";
    }

    @GetMapping("/shoppingcart")
    public String shoppingCart(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Shopping Cart");
        model.addAttribute("viewName", "shopping-cart");
        model.addAttribute("centerPage", "pages/shopping_cart.jsp");
        return "index";
    }

    @GetMapping("/faq")
    public String faq(Model model) {
        return "redirect:/";
    }

    @GetMapping("/signin")
    public String signin(Model model) {
        return "redirect:/";
    }

    @GetMapping("/ai-analysis")
    public String aiAnalysisPage(Model model) {
        return "pages/ai_analysis";
    }
}