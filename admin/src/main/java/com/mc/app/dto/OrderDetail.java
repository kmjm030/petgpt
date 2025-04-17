package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetail {
    private int orderDetailKey;
    private int itemKey;
    private Integer optionKey;
    private int orderKey;
    private int orderDetailPrice;
    private int orderDetailCount;
}