package com.mc.app.service;

import com.mc.app.dto.Category;
import com.mc.app.dto.Item;
import com.mc.app.dto.ItemFilterCriteria;
import com.mc.app.dto.Option;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ShopService {
    
    private final CategoryService categoryService;
    private final OptionService optionService;
    private final ItemService itemService;
    
    public void addFilterOptionsToModel(Model model) throws Exception {
        List<Category> categories = categoryService.findAll();
        List<String> sizes = optionService.getAllSizes();
        List<String> colors = optionService.getAllColors();
        
        model.addAttribute("categories", categories);
        model.addAttribute("sizes", sizes);
        model.addAttribute("colors", colors);
    }
    
    public boolean addItemDetailsToModel(int itemKey, Model model) throws Exception {
        Item item = itemService.get(itemKey);
        if (item == null) {
            return false;
        }
        
        List<Option> options = optionService.getOptionsByItem(itemKey);
        
        model.addAttribute("item", item);
        model.addAttribute("options", options);
        model.addAttribute("pageTitle", item.getItemName());
        
        return true;
    }
    
    public void getFilteredItemList(ItemFilterCriteria filterCriteria, Model model) throws Exception {
        filterCriteria.addAttributesToModel(model);
        
        List<Item> itemList = itemService.findItemsByFilter(filterCriteria);
        model.addAttribute("itemList", itemList);
    }
} 