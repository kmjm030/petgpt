package com.mc.app.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class ChatbotService {

    private final WebClient webClient;

    @Value("${chatbot.api.url}")
    private String chatbotApiUrl;

    // Python API 요청 본문 DTO
    private static class AiApiRequest {
        public String prompt;

        public AiApiRequest(String prompt) {
            this.prompt = prompt;
        }

        public String getPrompt() {
            return prompt;
        }
    }

    // Python API 응답 본문 DTO
    private static class AiApiResponse {
        public String generated_text;

        public AiApiResponse() {
        }

        public String getGenerated_text() {
            return generated_text;
        }

        public void setGenerated_text(String generated_text) {
            this.generated_text = generated_text;
        }
    }

    /**
     * Python AI 서비스 API를 호출하여 챗봇 응답을 가져옴
     * 
     * @param userMessage
     * @return AI 모델의 응답 문자열을 포함하는 Mono
     */
    public Mono<String> getChatbotReply(String userMessage) {
        log.info("Sending prompt to AI API: {}", userMessage);
        AiApiRequest requestPayload = new AiApiRequest(userMessage);

        return webClient.post()
                .uri(chatbotApiUrl)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestPayload)
                .retrieve()
                .bodyToMono(AiApiResponse.class)
                .map(AiApiResponse::getGenerated_text)
                .doOnSuccess(reply -> log.info("Received reply from AI API (first 50 chars): {}",
                        reply != null ? reply.substring(0, Math.min(reply.length(), 50)) : "null"))
                .doOnError(error -> log.error("Error calling AI API: {}", error.getMessage()))
                .onErrorResume(error -> {
                    log.error("AI API call failed, returning default message.", error);
                    return Mono.just("죄송합니다, AI 응답을 가져오는 데 실패했습니다.");
                });
    }
}
