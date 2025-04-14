package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.ItemFilterCriteria;
import com.mc.app.dto.SortType;
import com.mc.app.service.LikeService;
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

    @GetMapping("")
    public String shop(
            @RequestParam(name = "categoryKey", required = false) Integer categoryKey,
            @RequestParam(name = "size", required = false) String size,
            @RequestParam(name = "color", required = false) String color,
            @RequestParam(name = "price", required = false) String price,
            @RequestParam(name = "sort", required = false) String sort,
            Model model, 
            HttpSession session) {
        
        model.addAttribute("currentPage", "shop");

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
            
            shopService.getFilteredItemList(filterCriteria, model);
        
        } catch (Exception e) {
            log.error("아이템 목록 또는 필터링 조회 중 오류 발생: {}", e.getMessage());
            model.addAttribute("itemList", new ArrayList<>());
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
    public String shopDetails(@RequestParam("itemKey") int itemKey, Model model, HttpSession session) {
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
            
            model.addAttribute("centerPage", "pages/shop_details.jsp");
        } catch (Exception e) {
            log.error("상품 상세 정보 조회 중 오류 발생 (itemKey: {})", itemKey, e);
            return "redirect:/shop";
        }
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
