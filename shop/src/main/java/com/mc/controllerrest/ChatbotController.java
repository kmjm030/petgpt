package com.mc.controllerrest;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.mc.app.service.ChatbotService;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/chatbot")
@RequiredArgsConstructor
public class ChatbotController {

    private final ChatbotService chatbotService;

    // Java API 요청 DTO
    public static record ChatRequest(String message) {
    }

    // Java API 응답 DTO
    public static record ChatResponse(String reply) {
    }

    /**
     * 프론트엔드로부터 채팅 메시지를 받아 AI 서비스에 전달하고 응답을 반환
     */
    @PostMapping("/ask")
    public Mono<ChatResponse> handleChatMessage(@RequestBody ChatRequest request) {
        return chatbotService.getChatbotReply(request.message())
                .map(ChatResponse::new);
    }
}
