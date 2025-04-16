package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TotalOrder {
    private int orderKey;
    private String custId;
    private int itemKey;
    private LocalDateTime orderDate;
    private String recipientName;
    private String recipientPhone;
    private String orderReq;
    private String orderStatus;
    private String orderCard;
    private int orderTotalPrice;
    private String orderShootNum;
    private String orderAddr;
    private String orderAddrdetail;
    private String orderHomecode;
}
