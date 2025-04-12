package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Option {
    private int optionKey;
    private int itemKey;
    // private String optionName; 
    private String size;           // 사이즈 필드 추가
    private String color;          // 색상 필드 추가
    private int stock;             // 재고 필드 추가
    private int additionalPrice;   // 추가 가격 필드 추가
}
