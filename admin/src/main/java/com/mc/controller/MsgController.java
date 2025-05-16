package com.mc.controller;

import com.mc.app.msg.Msg;
import com.mc.util.LanguageDetectionUtil;
import com.mc.util.PapagoUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload; 
import org.springframework.messaging.handler.annotation.SendTo; 
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Slf4j
@Controller
public class MsgController {
    @Autowired
    SimpMessagingTemplate template;
    
    @Value("${ncp.papago.id}")
    String papagoId;
    
    @Value("${ncp.papago.key}")
    String papagoKey;

    @MessageMapping("/receiveall")
    public void receiveall(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        System.out.println(msg);
        template.convertAndSend("/send",msg);
    }
    
    @MessageMapping("/receiveme")
    public void receiveme(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        System.out.println(msg);

        String id = msg.getSendid();
        template.convertAndSend("/send/"+id,msg);
    }
    
    @MessageMapping("/receiveto")
    public void receiveto(Msg msg, SimpMessageHeaderAccessor headerAccessor) {
        String id = msg.getSendid();
        String target = msg.getReceiveid();
        log.info("-------------------------");
        log.info(target);

        template.convertAndSend("/send/to/"+target,msg);
    }

    // 실시간 상담 메시지 처리 메소드
    @MessageMapping("/livechat.sendMessage") 
    @SendTo("/livechat/public") 
    public Msg sendLiveChatMessage(@Payload Msg chatMessage) {
        log.info("Live chat message received: {}", chatMessage);

        String detectedLang = LanguageDetectionUtil.detectLanguage(chatMessage.getContent1());
        chatMessage.setLangCode(detectedLang);
        
        if (chatMessage.isTranslationEnabled()) {
            try {
                String targetLang = "en".equals(detectedLang) ? "ko" : "en";
                String translatedText = PapagoUtil.getMsg(papagoId, papagoKey, chatMessage.getContent1(), targetLang);
                chatMessage.setTranslatedContent(translatedText);
            } catch (Exception e) {
                log.error("메시지 번역 중 오류 발생: {}", e.getMessage());
                chatMessage.setTranslatedContent("(번역 실패)");
            }
        }
        
        return chatMessage;
    }
}
