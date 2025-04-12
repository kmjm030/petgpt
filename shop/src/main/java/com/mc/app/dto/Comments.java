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
public class Comments {
    private int commentsKey;
    private int pboardKey;
    private int custKey;
    private String commentsContent;
    private LocalDateTime commentsRdate;
    private LocalDateTime commentsUpdate;
}


