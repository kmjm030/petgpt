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
public class Customer {
    private String custId;
    private String custPwd;
    private String custName;
    private String custEmail;
    private String custPhone;
    private LocalDateTime custRdate;
    private int custAuth;
    private int custPoint;
    private String custNick;
    private int pointCharge;
    private String pointReason;
}
