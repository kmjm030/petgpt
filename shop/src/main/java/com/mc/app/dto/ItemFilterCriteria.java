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
    
    public boolean hasAnyFilter() {
        return categoryKey != null || 
               (size != null && !size.isEmpty()) || 
               (color != null && !color.isEmpty()) || 
               (price != null && !price.isEmpty());
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
    }
} 