package com.mc.controller;

import com.mc.app.service.CustomerService;
import com.mc.app.service.ItemService;
import com.mc.app.service.TotalOrderService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MainController {

    final CustomerService custService;
    final ItemService itemService;
    final TotalOrderService totalOrderService;

    @Value("${app.url.websocket-server-url}")
    String websocketServerUrl;

    @GetMapping("/")
    public String root(HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/views/login.jsp";
        }
        return "redirect:/main";
    }

    @RequestMapping("/main")
    public String main(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/views/login.jsp";

        try {
            int custCount = custService.getCount();
            int todayJoinCount = custService.getTodayJoinCount();
            model.addAttribute("custCount", custCount);
            model.addAttribute("todayJoinCount", todayJoinCount);
        } catch (Exception e) {
            log.error("[MainController] Error loading customer data: {}", e.getMessage());
            model.addAttribute("custCount", 0);
            model.addAttribute("todayJoinCount", 0);
        }

        try {
            int itemCount = itemService.get().size();
            model.addAttribute("itemCount", itemCount);
        } catch (Exception e) {
            log.error("[MainController] Error loading item count: {}", e.getMessage());
            model.addAttribute("itemCount", 0);
        }

        try {
            int orderCount = totalOrderService.getOrderCount();
            model.addAttribute("orderCount", orderCount);
        } catch (Exception e) {
            log.error("[MainController] Error loading order count: {}", e.getMessage());
            model.addAttribute("orderCount", 0);
        }

        try {
            int todayRevenue = totalOrderService.getTodayRevenue();
            model.addAttribute("todayRevenue", todayRevenue);
        } catch (Exception e) {
            log.error("[MainController] Error loading today revenue: {}", e.getMessage());
            model.addAttribute("todayRevenue", 0);
        }

        try {
            Map<String, Integer> orderStatusMap = totalOrderService.getOrderStatusCountMap();
            model.addAttribute("orderStatusMap", orderStatusMap);
        } catch (Exception e) {
            log.error("[MainController] Error loading order status count: {}", e.getMessage());
            model.addAttribute("orderStatusMap", new HashMap<>());
        }

        model.addAttribute("serverurl", websocketServerUrl);
        model.addAttribute("center", "center");
        return "index";
    }

    @RequestMapping("/ws")
    public String ws(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/views/login.jsp";
        }
        model.addAttribute("serverurl", websocketServerUrl);
        model.addAttribute("center", "ws");
        return "index";
    }
}
