package com.mc.controller;

import com.mc.app.dto.Item;
import com.mc.app.dto.QnaBoard;
import com.mc.app.service.ItemService;
import com.mc.app.service.QnaBoardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collections;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MainController {

    private final ItemService itemService;
    private final QnaBoardService qnaBoardService;

    @GetMapping("/")
    public String home(Model model) {

        int limit = 8; 
        List<Item> bestSellerList; 

        try {
            bestSellerList = itemService.getBestSellingItems(limit); 

            for (Item item : bestSellerList) {
                try {
                    List<QnaBoard> reviews = qnaBoardService.findReviewByItem(item.getItemKey());
                    int reviewCount = reviews.size();

                    double totalScore = 0;
                    for (QnaBoard review : reviews) {
                        totalScore += review.getBoardScore();
                    }
                    double avgScore = reviewCount > 0 ? Math.round((totalScore / reviewCount) * 10) / 10.0 : 0;

                    item.setAvgScore(avgScore);
                    item.setReviewCount(reviewCount);
                } catch (Exception e) {
                    log.error("상품 평점 및 리뷰 개수 계산 중 오류 발생: {}", e.getMessage());
                    item.setAvgScore(0.0);
                    item.setReviewCount(0);
                }
            }

        } catch (Exception e) {
            log.error("Error fetching best selling items: {}", e.getMessage());
            e.printStackTrace(); 
            model.addAttribute("errorMessage", "베스트셀러 상품 목록을 불러오는 중 오류가 발생했습니다.");
            bestSellerList = Collections.emptyList(); 
        }

        model.addAttribute("bestSellerList", bestSellerList);

        model.addAttribute("currentPage", "home");
        model.addAttribute("pageTitle", "Home");
        model.addAttribute("viewName", "home");
        model.addAttribute("centerPage", "pages/home.jsp");
        return "index";
    }

    @GetMapping("/about")
    public String about(Model model, @RequestParam(value = "location", required = false) String location) {
        if(location!=null){
          model.addAttribute("location", location);
        }
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
        return "redirect:/signin";
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
        // signin.jsp를 독립적인 페이지로 사용
        model.addAttribute("pageTitle", "로그인");
        return "pages/signin";
    }

    @GetMapping("/ai-analysis")
    public String aiAnalysisPage(Model model) {
        return "pages/ai_analysis";
    }

    @GetMapping("/insta")
    public String instagramPage() {
        return "pages/insta/insta";
    }
}
