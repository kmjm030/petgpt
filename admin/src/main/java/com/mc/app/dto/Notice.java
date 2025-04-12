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
public class Notice {
    private int noticeKey;
    private int adminKey;
    private String noticeTitle;
    private String noticeWriter;
    private String noticeImg;
    private int noticeHit;
    private LocalDateTime noticeRdate;
}
