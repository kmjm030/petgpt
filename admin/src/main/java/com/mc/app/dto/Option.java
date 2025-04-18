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
    private String size;
    private String color;
    private int stock;
    private int additionalPrice;
}
