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
public class PostLike {
    private Integer likeKey;
    private Integer boardKey;
    private String custId;
    private LocalDateTime likeDate;
} 