package com.mc.controller;

import com.mc.app.dto.Item;
import com.mc.app.dto.TotalOrder;
import com.mc.app.service.CustomerService;
import com.mc.app.service.ItemService;
import com.mc.app.service.TotalOrderService;
import com.mc.app.service.AdminNoticeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MainController {
    private final CustomerService custService;
    private final ItemService itemService;
    private final TotalOrderService totalOrderService;
    private final AdminNoticeService adminNoticeService;

    @Value("${app.url.websocket-server-url}")
    private String websocketServerUrl;

    @GetMapping("/")
    public String root(HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/views/login.jsp";
        }
        return "redirect:/main";
    }

    @RequestMapping("/main")
    public String main(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/views/login.jsp";
        }
        try {
            model.addAttribute("custCount", custService.getCount());
            model.addAttribute("todayJoinCount", custService.getTodayJoinCount());
        } catch (Exception e) {
            log.error("[MainController] 고객 수 로드 실패: {}", e.getMessage());
            model.addAttribute("custCount", 0);
            model.addAttribute("todayJoinCount", 0);
        }
        try {
            model.addAttribute("itemCount", itemService.get().size());
        } catch (Exception e) {
            log.error("[MainController] 상품 수 로드 실패: {}", e.getMessage());
            model.addAttribute("itemCount", 0);
        }
        try {
            model.addAttribute("orderCount", totalOrderService.getOrderCount());
        } catch (Exception e) {
            log.error("[MainController] 주문 수 로드 실패: {}", e.getMessage());
            model.addAttribute("orderCount", 0);
        }
        try {
            model.addAttribute("todayRevenue", totalOrderService.getTodayRevenue());
        } catch (Exception e) {
            log.error("[MainController] 오늘 매출 로드 실패: {}", e.getMessage());
            model.addAttribute("todayRevenue", 0);
        }
        try {
            model.addAttribute("orderStatusMap", totalOrderService.getOrderStatusCountMap());
        } catch (Exception e) {
            log.error("[MainController] 주문 상태 로드 실패: {}", e.getMessage());
            model.addAttribute("orderStatusMap", new HashMap<>());
        }
        List<String> alerts = new ArrayList<>();
        try {
            itemService.getItemsWithLowStock(5).forEach(item ->
                    alerts.add("[상품] '" + item.getItemName() + "' 재고 " + item.getStock() + "개 이하"));
        } catch (Exception e) {
            log.warn("[MainController] 알림(재고) 오류: {}", e.getMessage());
        }
        try { int uq = totalOrderService.getUnansweredQnaCount();
            if (uq>0) alerts.add("[문의] 미답변 Q&A " + uq + "건");
        } catch (Exception e) {
            log.warn("[MainController] 알림(Q&A) 오류: {}", e.getMessage());
        }
        try { int fr = totalOrderService.getFlaggedReviewCount();
            if (fr>0) alerts.add("[리뷰] 신고된 리뷰 " + fr + "건");
        } catch (Exception e) {
            log.warn("[MainController] 알림(리뷰) 오류: {}", e.getMessage());
        }
        model.addAttribute("adminAlerts", alerts);
        try {
            model.addAttribute("adminNotices", adminNoticeService.getRecentNotices());
        } catch (Exception e) {
            log.warn("[MainController] 공지사항 로드 실패: {}", e.getMessage());
            model.addAttribute("adminNotices", new ArrayList<>());
        }
        model.addAttribute("serverurl", websocketServerUrl);
        model.addAttribute("center", "center");
        return "index";
    }

    @RequestMapping("/today")
    public String todayJoinList(Model model) {
        try { model.addAttribute("todayJoinedList", custService.getTodayJoinedCustomers()); }
        catch (Exception e) { model.addAttribute("todayJoinedList", null); }
        model.addAttribute("center", "cust/todayList");
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

    @GetMapping("/totalorder")
    public String showTotalOrders(Model model) throws Exception {
        List<TotalOrder> orders = totalOrderService.getAll();
        model.addAttribute("totalorderList", orders);

        Map<Integer,String> itemNameMap = itemService.get()
                .stream()
                .collect(Collectors.toMap(
                        Item::getItemKey,
                        Item::getItemName
                ));
        model.addAttribute("itemNameMap", itemNameMap);
        model.addAttribute("center", "totalorder");
        return "index";
    }

    @GetMapping("/totalorder/{orderKey}")
    public String showOrderDetail(@PathVariable int orderKey, Model model) throws Exception {
        model.addAttribute("totalorder", totalOrderService.getOne(orderKey));
        model.addAttribute("center", "totalorder_detail");
        return "index";
    }
}