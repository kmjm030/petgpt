package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.Date;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class QnaBoard {
    private int boardKey;
    private int itemKey;
    private int orderKey;
    private String custId;
    private String boardTitle;
    private Date boardRdate;
    private String boardContent;
    private String boardImg;
    private String boardOption;
    private Date boardUpdate;
    private String boardRe;

}