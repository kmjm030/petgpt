package com.mc.app.dto;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum SortType {
    NEWEST("newest", "최신순", "item_rdate DESC"),
    OLDEST("oldest", "오래된순", "item_rdate ASC"),
    PRICE_HIGH("price_high", "가격 높은순", "item_price DESC"),
    PRICE_LOW("price_low", "가격 낮은순", "item_price ASC"),
    DEFAULT("default", "상품번호순", null),
    BEST_SELLING("best_selling", "판매량순", "sales_count DESC"),
    HIGHEST_DISCOUNT("highest_discount", "할인율순", "discount_rate DESC");

    private final String key;
    private final String description;
    private final String sqlOrderBy;

    public static SortType fromKey(String key) {
        if (key == null || key.trim().isEmpty()) {
            return DEFAULT;
        }

        for (SortType sortType : SortType.values()) {
            if (sortType.getKey().equalsIgnoreCase(key)) {
                return sortType;
            }
        }

        return DEFAULT;
    }
}