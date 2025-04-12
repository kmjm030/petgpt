package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Coupon {
    private int couponId;
    private int custKey;
    private Integer couponPrice;
    private Integer couponRate;
    private Integer couponMaxPrice;
    private String couponType;
    private LocalDate couponIssue;
    private LocalDate couponExpire;
    private String couponUse;
}
