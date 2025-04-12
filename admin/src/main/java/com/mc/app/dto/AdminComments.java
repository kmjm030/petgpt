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
public class AdminComments {
    private int adCommentsKey;
    private int boardKey;
    private int adminKey;
    private String adCommentsContent;
    private LocalDateTime adCommentsRdate;
    private LocalDateTime adCommentsUpdate;
}
