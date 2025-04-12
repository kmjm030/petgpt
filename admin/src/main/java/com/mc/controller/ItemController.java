package com.mc.controller;

import com.mc.app.dto.Item;
import com.mc.app.dto.Option;
import com.mc.app.service.ItemService;
import com.mc.app.service.OptionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/item")
public class ItemController {

    private final ItemService itemService;
    private final OptionService optionService;
    private final String dir = "item/";

    // 전체 목록 조회
    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        List<Item> list = itemService.get();
        model.addAttribute("itemlist", list);
        model.addAttribute("center", dir + "get");
        return "index";
    }

    // 등록 폼
    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("center", dir + "add");
        return "index";
    }

    // 등록 처리
    @RequestMapping("/addimpl")
    public String addimpl(Model model, Item item,
                          @RequestParam("size") String size,
                          @RequestParam("color") String color,
                          @RequestParam("stock") int stock,
                          @RequestParam("additionalPrice") int additionalPrice) throws Exception {
        itemService.add(item);

        Option option = Option.builder()
                .itemKey(item.getItemKey())
                .size(size)
                .color(color)
                .stock(stock)
                .additionalPrice(additionalPrice)
                .build();

        optionService.addOption(option);

        return "redirect:/item/detail?item_key=" + item.getItemKey();
    }

    // 상세 보기
    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("item_key") int itemKey) throws Exception {
        Item item = itemService.get(itemKey);

        Option option = optionService.getOptionsByItem(itemKey).get(0);

        model.addAttribute("item", item);
        model.addAttribute("option", option);
        model.addAttribute("center", dir + "detail");
        return "index";
    }

    // 삭제
    @RequestMapping("/del")
    public String del(Model model, @RequestParam("item_key") int itemKey) throws Exception {
        itemService.del(itemKey);
        return "redirect:/item/get";
    }

    // 수정
    @RequestMapping("/update")
    public String update(Model model, Item item) throws Exception {
        itemService.mod(item);
        return "redirect:/item/detail?item_key=" + item.getItemKey();
    }
}



