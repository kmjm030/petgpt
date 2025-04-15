package com.mc.controller;

import com.mc.app.dto.Item;
import com.mc.app.service.ItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final ItemService itemService;

    private List<Item> getItemList() {
        List<Item> itemList = new ArrayList<>();
        try {
            itemList.add(itemService.get(10));
            itemList.add(itemService.get(11));
            itemList.add(itemService.get(12));
            itemList.add(itemService.get(13));
            itemList.add(itemService.get(14));
            itemList.add(itemService.get(20));
            itemList.add(itemService.get(21));
        } catch (Exception e) {
            System.out.println("아이템 목록 조회 중 오류 발생: " + e.getMessage());
        }
        return itemList;
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("currentPage", "home");
        List<Item> itemList = getItemList();
        model.addAttribute("itemList", itemList);
        model.addAttribute("pageTitle", "Home");
        model.addAttribute("centerPage", "pages/home.jsp");
        return "index";
    }

    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "About Us");
        model.addAttribute("centerPage", "pages/about.jsp");
        return "index";
    }

    @GetMapping("/signup")
    public String signup(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Sign up");
        model.addAttribute("centerPage", "pages/signup.jsp");
        return "index";
    }

    @GetMapping("/login")
    public String login(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Log In");
        model.addAttribute("centerPage", "pages/login.jsp");
        return "index";
    }

    @GetMapping("/shopdetails")
    public String shopDetails(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Shop Details");
        model.addAttribute("centerPage", "pages/shop_details.jsp");
        return "index";
    }

    @GetMapping("/shoppingcart")
    public String shoppingCart(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Shopping Cart");
        model.addAttribute("centerPage", "pages/shopping_cart.jsp");
        return "index";
    }

    @GetMapping("/checkout")
    public String checkOut(Model model) {
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Check Out");
        model.addAttribute("centerPage", "pages/checkout.jsp");
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
}