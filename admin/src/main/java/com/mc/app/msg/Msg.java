package com.mc.app.msg;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class Msg {
    private String messageId;     // 메시지 고유 ID
    private String sendid;
    private String receiveid;
    private String content1;
    private String langCode;        // 언어 코드 (ko, en 등)
    private boolean translationEnabled; // 번역 서비스 활성화 여부
    private String translatedContent; // 번역된 메시지 내용
}
