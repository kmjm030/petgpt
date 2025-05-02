package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
            model.addAttribute("totalRevenue", totalOrderService.getTotalRevenue());
        } catch (Exception e) {
            log.error("[MainController] 총 매출 로드 실패: {}", e.getMessage());
            model.addAttribute("totalRevenue", 0);
        }

        try {
            model.addAttribute("orderStatusMap", totalOrderService.getOrderStatusCountMap());
        } catch (Exception e) {
            log.error("[MainController] 주문 상태 로드 실패: {}", e.getMessage());
            model.addAttribute("orderStatusMap", new HashMap<>());
        }

        try {
            model.addAttribute("topItemList", totalOrderService.getTop10Items());
        } catch (Exception e) {
            log.warn("[MainController] TOP10 로드 실패: {}", e.getMessage());
            model.addAttribute("topItemList", new ArrayList<>());
        }

        List<String> alerts = new ArrayList<>();

        try {
            List<Item> lowStockItems = itemService.getItemsWithLowStock(5);
            for (Item item : lowStockItems) {
                alerts.add(" [상품] '" + item.getItemName() + "'의 재고가 " + item.getStock() + "개 이하입니다.");
            }
        } catch (Exception e) {
            log.warn("[MainController] 알림 생성 중 오류 (재고): {}", e.getMessage());
        }

        try {
            int unansweredQna = totalOrderService.getUnansweredQnaCount();
            if (unansweredQna > 0) {
                alerts.add(" [문의] 미답변 Q&A가 " + unansweredQna + "건 있습니다.");
            }
        } catch (Exception e) {
            log.warn("[MainController] 알림 생성 중 오류 (Q&A): {}", e.getMessage());
        }

        try {
            int flaggedReviews = totalOrderService.getFlaggedReviewCount();
            if (flaggedReviews > 0) {
                alerts.add(" [리뷰] 신고된 리뷰가 " + flaggedReviews + "건 있습니다.");
            }
        } catch (Exception e) {
            log.warn("[MainController] 알림 생성 중 오류 (리뷰): {}", e.getMessage());
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
        try {
            model.addAttribute("todayJoinedList", custService.getTodayJoinedCustomers());
        } catch (Exception e) {
            model.addAttribute("todayJoinedList", null);
        }
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

    @GetMapping("/totalorder/delete/{orderKey}")
    public String deleteOrder(@PathVariable int orderKey,
                              RedirectAttributes redirectAttrs) {
        try {
            totalOrderService.deleteOne(orderKey);
            redirectAttrs.addFlashAttribute("msgSuccess", "주문 " + orderKey + "번이 삭제되었습니다.");
        } catch (Exception e) {
            log.error("[MainController] 주문 삭제 실패: {}", e.getMessage());
            redirectAttrs.addFlashAttribute("msgError", "주문 삭제에 실패했습니다.");
        }
        return "redirect:/totalorder";
    }
}
