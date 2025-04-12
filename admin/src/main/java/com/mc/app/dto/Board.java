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
public class Board {
    private int boardKey;
    private int itemKey;
    private int custKey;
    private String boardTitle;
    private LocalDateTime boardRdate;
    private String boardContent;
    private String boardImg;
    private String boardOption;
    private LocalDateTime boardUpdate;
}