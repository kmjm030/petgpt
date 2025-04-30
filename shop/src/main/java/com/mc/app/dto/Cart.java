package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cart {
    private int itemKey;
    private String custId;
    private int cartCnt;
    private Date cartRdate;
    private Integer optionKey;
    private boolean isHotDeal;
}
