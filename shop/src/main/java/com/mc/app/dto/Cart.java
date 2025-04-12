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
    private Integer optionKey; // 선택된 옵션 키 필드 추가 (Integer 사용: 옵션 없는 상품은 null 가능)
}
