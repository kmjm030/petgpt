package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.*;
import com.mc.app.service.*;
import com.fasterxml.jackson.databind.ObjectMapper; 
import com.mc.app.service.OptionService;
import com.mc.app.service.ShopService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/shop")
public class ShopController {
    private final ShopService shopService;
    private final LikeService likeService;
    private final OptionService optionService;
    private final QnaBoardService qnaService;

    @GetMapping("")
    public String shop(
            @RequestParam(name = "categoryKey", required = false) Integer categoryKey,
            @RequestParam(name = "size", required = false) String size,
            @RequestParam(name = "color", required = false) String color,
            @RequestParam(name = "price", required = false) String price,
            @RequestParam(name = "sort", required = false) String sort,
            @RequestParam(name = "page", defaultValue = "1") int page,
            Model model, 
            HttpSession session) {
        
        model.addAttribute("currentPage", "shop");
        int itemsPerPage = 12; // 한 페이지당 상품 수

        try {
            Customer customer = (Customer) session.getAttribute("cust");
            if (customer != null) {
                model.addAttribute("isLoggedIn", true);
                model.addAttribute("custId", customer.getCustId());
            } else {
                model.addAttribute("isLoggedIn", false);
            }
            
            shopService.addFilterOptionsToModel(model);
            
            addSortOptionsToModel(model, sort);
            
            ItemFilterCriteria filterCriteria = ItemFilterCriteria.builder()
                    .categoryKey(categoryKey)
                    .size(size)
                    .color(color)
                    .price(price)
                    .sort(sort)
                    .build();
            
            int totalItems = shopService.getTotalItemsCount(filterCriteria);
            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
            
            // 페이지 범위 검증
            page = Math.max(1, Math.min(page, totalPages));
            
            List<Item> items = shopService.findItemsByFilterWithPagination(filterCriteria, page, itemsPerPage);
            
            model.addAttribute("itemList", items);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("totalItems", totalItems);
            model.addAttribute("itemsPerPage", itemsPerPage);
        
        } catch (Exception e) {
            log.error("아이템 목록 또는 필터링 조회 중 오류 발생: {}", e.getMessage());
            model.addAttribute("itemList", new ArrayList<>());
            model.addAttribute("currentPage", 1);
            model.addAttribute("totalPages", 1);
            model.addAttribute("totalItems", 0);
            model.addAttribute("itemsPerPage", itemsPerPage);
        }

        model.addAttribute("pageTitle", "Shop");
        model.addAttribute("centerPage", "pages/shop.jsp");
        return "index";
    }

    private void addSortOptionsToModel(Model model, String selectedSort) {
        List<SortType> sortOptions = Arrays.asList(
            SortType.DEFAULT,
            SortType.NEWEST,
            SortType.OLDEST,
            SortType.PRICE_HIGH,
            SortType.PRICE_LOW
        );
        
        model.addAttribute("sortOptions", sortOptions);
        
        if (selectedSort != null && !selectedSort.isEmpty()) {
            model.addAttribute("selectedSort", selectedSort);
        }
    }

    @GetMapping("/details")
    public String shopDetails(@RequestParam("itemKey") int itemKey, Model model, HttpSession session) throws Exception {
        try {

            Customer customer = (Customer) session.getAttribute("cust");

            if (customer != null) {
                model.addAttribute("isLoggedIn", true);
                model.addAttribute("custId", customer.getCustId());
                
                boolean isLiked = likeService.isLiked(customer.getCustId(), itemKey);
                model.addAttribute("isLiked", isLiked);
                
            } else {
                model.addAttribute("isLoggedIn", false);
                model.addAttribute("isLiked", false);
            }
            
            if (!shopService.addItemDetailsToModel(itemKey, model)) {
                log.warn("존재하지 않는 상품입니다. itemKey: {}", itemKey);
                return "redirect:/shop";
            }

            List<String> availableSizes = optionService.getAvailableSizesByItem(itemKey);
            List<String> availableColors = optionService.getAvailableColorsByItem(itemKey);
            model.addAttribute("availableSizes", availableSizes);
            model.addAttribute("availableColors", availableColors);

            @SuppressWarnings("unchecked")
            List<Option> options = (List<Option>) model.getAttribute("options");

            if (options != null) {
                ObjectMapper objectMapper = new ObjectMapper();
                String optionsJson = objectMapper.writeValueAsString(options);

                 optionsJson = optionsJson.replace("\\", "\\\\")
                                          .replace("'", "\\'")
                                          .replace("<", "\\u003C")
                                          .replace(">", "\\u003E");
                                          
                model.addAttribute("optionsJson", optionsJson);
            } else {
                 model.addAttribute("optionsJson", "[]"); 
            }
            
            model.addAttribute("centerPage", "pages/shop_details.jsp");
        } catch (Exception e) {
            log.error("상품 상세 정보 조회 중 오류 발생 (itemKey: {})", itemKey, e);
            return "redirect:/shop";
        }
        List<QnaBoard> qnaBoards = qnaService.findQnaByItem(itemKey);
        List<QnaBoard> reviews = qnaService.findReviewByItem(itemKey);

        model.addAttribute("qnaBoards", qnaBoards);
        model.addAttribute("reviews", reviews);
        return "index";
    }
    
    @PostMapping("/like/toggle")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleLike(
            @RequestParam("itemKey") int itemKey, 
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        Customer customer = (Customer) session.getAttribute("cust");
        if (customer == null) {
            response.put("success", false);
            response.put("redirectUrl", "/customer/login");
            response.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.ok(response);
        }
        
        Map<String, Object> result = likeService.toggleLike(customer.getCustId(), itemKey);
        
        return ResponseEntity.ok(result);
    }
    
    @GetMapping("/like/check")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkLiked(
            @RequestParam("itemKey") int itemKey, 
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        Customer customer = (Customer) session.getAttribute("cust");
        if (customer == null) {
            response.put("success", false);
            response.put("isLoggedIn", false);
            response.put("message", "로그인이 필요한 서비스입니다.");
            return ResponseEntity.ok(response);
        }
        
        boolean isLiked = likeService.isLiked(customer.getCustId(), itemKey);
        
        response.put("success", true);
        response.put("isLoggedIn", true);
        response.put("isLiked", isLiked);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/search")
    public String search(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "sort", required = false) String sort,
            Model model, 
            HttpSession session) {
        
        model.addAttribute("currentPage", "shop");
        model.addAttribute("pageTitle", "검색 결과: " + (keyword != null ? keyword : ""));

        try {
            Customer customer = (Customer) session.getAttribute("cust");
            if (customer != null) {
                model.addAttribute("isLoggedIn", true);
                model.addAttribute("custId", customer.getCustId());
            } else {
                model.addAttribute("isLoggedIn", false);
            }
            
            shopService.addFilterOptionsToModel(model);
            addSortOptionsToModel(model, sort);
            shopService.searchItems(keyword, sort, model);
            
        } catch (Exception e) {
            log.error("검색 중 오류 발생: {}", e.getMessage());
            model.addAttribute("itemList", new ArrayList<>());
            model.addAttribute("error", "검색 중 오류가 발생했습니다.");
        }

        model.addAttribute("centerPage", "pages/shop.jsp");
        return "index";
    }
}
