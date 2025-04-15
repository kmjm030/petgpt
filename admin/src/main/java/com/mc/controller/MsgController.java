package com.mc.controller;

import com.mc.app.msg.Msg;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Slf4j
@Controller
public class MsgController {
    @Autowired
    SimpMessagingTemplate template;

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
}
