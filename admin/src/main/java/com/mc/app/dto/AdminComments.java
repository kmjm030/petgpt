package com.mc.app.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.Date;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdminComments {
    private int adcommentsKey;
    private int boardKey;
    private String adminId;
    private String adcommentsContent;
    private Date adcommentsRdate;
    private Date adcommentsUpdate;
}
