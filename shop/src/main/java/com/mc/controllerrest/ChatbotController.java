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

    public static record ChatRequest(String message) {
    }

    public static record ChatResponse(String reply) {
    }

    @PostMapping("/ask")
    public Mono<ChatResponse> handleChatMessage(@RequestBody ChatRequest request) {
        return chatbotService.getChatbotReply(request.message())
                .map(ChatResponse::new);
    }
}
