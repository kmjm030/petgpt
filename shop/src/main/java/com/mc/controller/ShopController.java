package com.mc.controller;

import com.mc.app.dto.Category;
import com.mc.app.dto.Item;
import com.mc.app.dto.Option;
import com.mc.app.service.CategoryService;
import com.mc.app.service.ItemService;
import com.mc.app.service.OptionService;
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
@RequestMapping("/shop")
public class ShopController {
    private final ItemService itemService;
    private final OptionService optionService;
    private final CategoryService categoryService;

    @GetMapping("")
    public String shop(@RequestParam(name = "categoryKey", required = false) Integer categoryKey, Model model, HttpSession session) {
        model.addAttribute("currentPage", "shop");

        List<Item> itemList = new ArrayList<>();
        try {
            List<Category> categories = categoryService.findAll();
            model.addAttribute("categories", categories);
            
            if (categoryKey != null) {
                itemList = itemService.findByCategory(categoryKey);
                model.addAttribute("selectedCategoryKey", categoryKey);
            } else {
                itemList = itemService.get();
            }
        } catch (Exception e) {
            log.error("아이템 목록 또는 카테고리 조회 중 오류 발생: {}", e.getMessage());
        }

        model.addAttribute("itemList", itemList);
        model.addAttribute("pageTitle", "Shop");
        model.addAttribute("centerPage", "pages/shop.jsp");
        return "index";
    }

    // 상품 상세 페이지 처리 메소드
    @GetMapping("/details")
    public String shopDetails(@RequestParam("itemKey") int itemKey, Model model) {
        try {
            Item item = itemService.get(itemKey);
            if (item == null) {
                log.warn("존재하지 않는 상품입니다. itemKey: {}", itemKey);
                // return "redirect:/error";
                return "redirect:/shop";
            }
            model.addAttribute("item", item);

            List<Option> options = optionService.getOptionsByItem(itemKey);
            model.addAttribute("options", options);

            model.addAttribute("pageTitle", item.getItemName());
            model.addAttribute("centerPage", "pages/shop_details.jsp");

        } catch (Exception e) {
            log.error("상품 상세 정보 조회 중 오류 발생 (itemKey: {})", itemKey, e);
            // return "redirect:/error";
            return "redirect:/shop";
        }
        return "index";
    }
}
