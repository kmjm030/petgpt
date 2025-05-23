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
public class TotalOrder {
    private int orderKey;
    private String custId;
    private int itemKey;
    private int couponId;
    private Date orderDate;
    private String recipientName;
    private String recipientPhone;
    private String orderReq;
    private String orderStatus;
    private String orderCard;
    private int orderTotalPrice;
    private String orderShootNum;
    private String orderAddr;
    private String orderAddrRef;
    private String orderAddrDetail;
    private String orderHomecode;
    private int orderPoint;
}
