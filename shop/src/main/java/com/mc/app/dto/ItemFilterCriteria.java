package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.ui.Model;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ItemFilterCriteria {
    private Integer categoryKey;
    private String size;
    private String color;
    private String price;
    private String sort;
    
    public SortType getSortType() {
        return SortType.fromKey(sort);
    }
    
    public boolean hasAnyFilter() {
        return categoryKey != null || 
               (size != null && !size.isEmpty()) || 
               (color != null && !color.isEmpty()) || 
               (price != null && !price.isEmpty()) ||
               (sort != null && !sort.isEmpty());
    }
    
    public boolean hasSizeFilter() {
        return size != null && !size.isEmpty();
    }
    
    public boolean hasColorFilter() {
        return color != null && !color.isEmpty();
    }

    public boolean hasPriceFilter() {
        return price != null && !price.isEmpty();
    }
    
    public boolean hasCategoryFilter() {
        return categoryKey != null;
    }
    
    public boolean hasSortFilter() {
        return sort != null && !sort.isEmpty();
    }
    
    public void addAttributesToModel(Model model) {
        if (hasSizeFilter()) {
            model.addAttribute("selectedSize", size);
        }
        if (hasColorFilter()) {
            model.addAttribute("selectedColor", color);
        }
        if (hasPriceFilter()) {
            model.addAttribute("selectedPrice", price);
        }
        if (hasCategoryFilter()) {
            model.addAttribute("selectedCategoryKey", categoryKey);
        }
        if (hasSortFilter()) {
            model.addAttribute("selectedSort", sort);
        }
    }
} 