package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.sql.Date;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/item")
public class ItemController {

    private final ItemService itemService;
    private final OptionService optionService;
    private final QnaBoardService qnaBoardService;
    private final AdminCommentsService adminCommentsService;

    private final String dir = "item/";

    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        List<Item> list = itemService.get();
        model.addAttribute("itemlist", list);
        model.addAttribute("center", dir + "get");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model) {
        model.addAttribute("center", dir + "add");
        return "index";
    }

    @RequestMapping("/addimpl")
    public String addimpl(Model model, Item item,
                          @RequestParam("size") String size,
                          @RequestParam("color") String color,
                          @RequestParam("stock") int stock,
                          @RequestParam("additionalPrice") int additionalPrice,
                          @RequestParam("img1") MultipartFile img1,
                          @RequestParam("img2") MultipartFile img2,
                          @RequestParam("img3") MultipartFile img3) throws Exception {

        String uploadPath = new File("src/main/resources/static/img/item").getAbsolutePath();

        if (!img1.isEmpty()) {
            String imgName1 = img1.getOriginalFilename();
            img1.transferTo(new File(uploadPath, imgName1));
            item.setItemImg1(imgName1);
        }

        if (!img2.isEmpty()) {
            String imgName2 = img2.getOriginalFilename();
            img2.transferTo(new File(uploadPath, imgName2));
            item.setItemImg2(imgName2);
        }

        if (!img3.isEmpty()) {
            String imgName3 = img3.getOriginalFilename();
            img3.transferTo(new File(uploadPath, imgName3));
            item.setItemImg3(imgName3);
        }

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

    @RequestMapping("/del")
    public String del(Model model, @RequestParam("item_key") int itemKey) throws Exception {
        List<Option> options = optionService.getOptionsByItem(itemKey);
        for (Option opt : options) {
            optionService.removeOption(opt.getOptionKey());
        }
        itemService.del(itemKey);
        return "redirect:/item/get";
    }

  @RequestMapping("/update")
  public String update(Model model, Item item,
                       @RequestParam("size") String size,
                       @RequestParam("color") String color,
                       @RequestParam("stock") int stock,
                       @RequestParam("additionalPrice") int additionalPrice,
                       @RequestParam("img1") MultipartFile img1,
                       @RequestParam("img2") MultipartFile img2,
                       @RequestParam("img3") MultipartFile img3) throws Exception {

    String uploadPath = new File("src/main/resources/static/img/item").getAbsolutePath();

    if (!img1.isEmpty()) {
      String name1 = img1.getOriginalFilename();
      img1.transferTo(new File(uploadPath, name1));
      item.setItemImg1(name1);
    }

    if (!img2.isEmpty()) {
      String name2 = img2.getOriginalFilename();
      img2.transferTo(new File(uploadPath, name2));
      item.setItemImg2(name2);
    }

    if (!img3.isEmpty()) {
      String name3 = img3.getOriginalFilename();
      img3.transferTo(new File(uploadPath, name3));
      item.setItemImg3(name3);
    }

    itemService.mod(item);
    Option option = Option.builder()
      .itemKey(item.getItemKey())
      .size(size)
      .color(color)
      .stock(stock)
      .additionalPrice(additionalPrice)
      .build();
    optionService.updateOption(option);

    return "redirect:/item/detail?item_key=" + item.getItemKey();
  }


  @RequestMapping("/detail")
  public String detail(Model model, @RequestParam("item_key") int itemKey) throws Exception {
    Item item = itemService.get(itemKey);
    Option option = optionService.getOptionsByItem(itemKey).get(0);
    List<QnaWithComment> qnaList = qnaBoardService.selectQnaWithCommentsByItemKey(itemKey);

    log.info("=qnaList============================={}", qnaList);

    if (item.getItemRdate() != null) {
      model.addAttribute("itemRdateDate", Date.valueOf(item.getItemRdate()));
    }
    if (item.getItemUdate() != null) {
      model.addAttribute("itemUdateDate", Date.valueOf(item.getItemUdate()));
    }

    model.addAttribute("item", item);
    model.addAttribute("option", option);
    model.addAttribute("qnaList", qnaList);
    model.addAttribute("center", dir + "detail");
    return "index";
  }

    @RequestMapping("/top10")
    public String topSellingItems(Model model) {
        try {
            List<Item> topItemList = itemService.getTopSellingItems(10);
            model.addAttribute("topItemList", topItemList);
        } catch (Exception e) {
            log.error("Top 10 상품 불러오기 실패: {}", e.getMessage());
            model.addAttribute("topItemList", new ArrayList<>());
        }
        model.addAttribute("center", "item/top10");
        return "index";
    }

  @RequestMapping("/toggleStatus")
  public String toggleStatus(@RequestParam("item_key") int itemKey) throws Exception {
    Item item = itemService.get(itemKey);
    item.setIsActive(item.getIsActive() == 1 ? 0 : 1);
    itemService.updateStatus(item);
    return "redirect:/item/detail?item_key=" + itemKey;
  }

}
