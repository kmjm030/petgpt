package com.mc.app.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class ChatbotService {

    private final WebClient webClient;

    @Value("${chatbot.api.url}")
    private String chatbotApiUrl;

    public Mono<String> getChatbotReply(String userMessage) {
        log.info("Sending prompt to PetGPT API: {}", userMessage);

        Map<String, String> requestPayload = new HashMap<>();
        requestPayload.put("query", userMessage);
        requestPayload.put("session_id", UUID.randomUUID().toString());
        
        log.info("Request payload: {}", requestPayload);
        log.info("Target URL: {}", chatbotApiUrl);

        return webClient.post()
                .uri(chatbotApiUrl)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestPayload)
                .retrieve()
                .bodyToMono(PetGptResponse.class)
                .doOnNext(response -> log.info("Full PetGPT response: {}", response))
                .map(response -> response.getResponse_text())
                .doOnSuccess(reply -> log.info("Received reply from PetGPT API (first 50 chars): {}",
                        reply != null ? reply.substring(0, Math.min(reply.length(), 50)) : "null"))
                .doOnError(error -> log.error("Error calling PetGPT API: {}", error.getMessage()))
                .onErrorResume(error -> {
                    log.error("PetGPT API call failed, returning default message.", error);
                    return Mono.just("죄송합니다, AI 응답을 가져오는 데 실패했습니다.");
                });
    }

    public static class PetGptResponse {
        private String response_type;
        private String response_text;
        private List<String> sources;
        private List<Map<String, Object>> products;
        private boolean medical_warning;

        public PetGptResponse() {
        }

        public String getResponse_type() {
            return response_type;
        }

        public void setResponse_type(String response_type) {
            this.response_type = response_type;
        }

        public String getResponse_text() {
            return response_text;
        }

        public void setResponse_text(String response_text) {
            this.response_text = response_text;
        }

        public List<String> getSources() {
            return sources;
        }

        public void setSources(List<String> sources) {
            this.sources = sources;
        }

        public List<Map<String, Object>> getProducts() {
            return products;
        }

        public void setProducts(List<Map<String, Object>> products) {
            this.products = products;
        }

        public boolean isMedical_warning() {
            return medical_warning;
        }

        public void setMedical_warning(boolean medical_warning) {
            this.medical_warning = medical_warning;
        }
    }
}
