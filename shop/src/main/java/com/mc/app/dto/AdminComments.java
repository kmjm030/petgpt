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
public class AdminComments {
    private int adcommentsKey;
    private int boardKey;
    private int itemKey;
    private String adminId;
    private String adcommentsContent;
    private Date adcommentsRdate;
    private Date adcommentsUpdate;
}
