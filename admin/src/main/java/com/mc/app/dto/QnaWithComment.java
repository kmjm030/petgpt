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
public class QnaWithComment {
    private int boardKey;
    private int itemKey;
    private String custId;
    private String boardTitle;
    private String boardContent;
    private Date boardRdate;

    private int adcommentsKey;
    private String adcommentsContent;
    private String adminId;
    private Date adcommentsRdate;

//    private AdminComments adminComments; // 포함된 관리자 답글
}