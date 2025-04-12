package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Admin {
    private int adminKey;
    private String adminId;
    private String adminPwd;
    private String adminName;
    private int adminAuth;
}