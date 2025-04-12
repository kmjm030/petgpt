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
public class PetBoard {
    private int pboardKey;
    private int custKey;
    private int itemKey;
    private String pboardTitle;
    private LocalDateTime pboardRdate;
    private String pboardContent;
    private String pboardOption;
    private int pboardRate;
    private LocalDateTime pboardUpdate;
    private int pboardHit;
    private String pboardType;
    private String pboardImg1;
    private String pboardImg2;
    private String pboardImg3;
}
