package com.mc.controller;

import lombok.RequiredArgsConstructor; // 생성자 주입을 위해 추가
import lombok.extern.slf4j.Slf4j; // 로깅을 위해 추가
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.Map;

@Slf4j 
@Controller
@RequiredArgsConstructor 
public class PetGPTController {

    private final RestTemplate restTemplate; 

    @Value("${python.api.baseurl:http://localhost:8000}")
    private String pythonApiBaseUrl;

    @GetMapping("/ai")
    public String petGptPage() {
        return "petgpt";
    }

    // --- Python API 프록시 엔드포인트 ---

    @PostMapping("/api/chat-with-rag")
    @ResponseBody
    public ResponseEntity<String> handleChatWithRag(@RequestBody Map<String, Object> payload) {
        String apiUrl = pythonApiBaseUrl + "/api/chat-with-rag";
        log.info("Forwarding RAG request to [{}], payload: {}", apiUrl, payload);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(payload, headers);

        try {
            ResponseEntity<String> responseFromPython = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    requestEntity,
                    String.class
            );
            log.info("Received RAG response (String) from [{}]: {}", apiUrl, responseFromPython.getBody());
            return ResponseEntity.status(responseFromPython.getStatusCode())
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(responseFromPython.getBody());
        } catch (HttpClientErrorException | HttpServerErrorException e) {
            log.error("Error from Python RAG API [{}] ({}): {} - Response Body: {}", apiUrl, e.getStatusCode(), e.getMessage(), e.getResponseBodyAsString(), e);
            return ResponseEntity.status(e.getStatusCode())
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(e.getResponseBodyAsString());
        } catch (RestClientException e) {
            log.error("Error connecting to Python RAG API [{}]: {}", apiUrl, e.getMessage(), e);
            String errorJson = "{\"error\":\"RAG 서비스에 접속할 수 없습니다: " + escapeJson(e.getMessage()) + "\"}";
            return ResponseEntity.status(503)
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(errorJson);
        } catch (Exception e) {
            log.error("Unexpected error in handleChatWithRag for [{}]: {}", apiUrl, e.getMessage(), e);
            String errorJson = "{\"error\":\"예상치 못한 오류가 발생했습니다.\"}";
            return ResponseEntity.status(500)
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(errorJson);
        }
    }

    @PostMapping("/api/summarize")
    @ResponseBody
    public ResponseEntity<String> handleSummarize(@RequestBody Map<String, Object> payload) {
        String apiUrl = pythonApiBaseUrl + "/api/summarize";
        log.info("Forwarding Summarize request to [{}], payload: {}", apiUrl, payload);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(payload, headers);

        try {
            ResponseEntity<String> responseFromPython = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    requestEntity,
                    String.class
            );
            log.info("Received Summarize response (String) from [{}]: {}", apiUrl, responseFromPython.getBody());
            return ResponseEntity.status(responseFromPython.getStatusCode())
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(responseFromPython.getBody());
        } catch (HttpClientErrorException | HttpServerErrorException e) {
            log.error("Error from Python Summarize API [{}] ({}): {} - Response Body: {}", apiUrl, e.getStatusCode(), e.getMessage(), e.getResponseBodyAsString(), e);
            return ResponseEntity.status(e.getStatusCode())
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(e.getResponseBodyAsString());
        } catch (RestClientException e) {
            log.error("Error connecting to Python Summarize API [{}]: {}", apiUrl, e.getMessage(), e);
            String errorJson = "{\"error\":\"요약 서비스에 접속할 수 없습니다: " + escapeJson(e.getMessage()) + "\"}";
            return ResponseEntity.status(503)
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(errorJson);
        } catch (Exception e) {
            log.error("Unexpected error in handleSummarize for [{}]: {}", apiUrl, e.getMessage(), e);
            String errorJson = "{\"error\":\"예상치 못한 오류가 발생했습니다.\"}";
            return ResponseEntity.status(500)
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(errorJson);
        }
    }

    @PostMapping("/api/suggest-replies")
    @ResponseBody
    public ResponseEntity<String> handleSuggestReplies(@RequestBody Map<String, Object> payload) {
        String apiUrl = pythonApiBaseUrl + "/api/suggest-replies";
        log.info("Forwarding Suggest Replies request to [{}], payload: {}", apiUrl, payload);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(payload, headers);

        try {
            ResponseEntity<String> responseFromPython = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    requestEntity,
                    String.class
            );
            log.info("Received Suggest Replies response (String) from [{}]: {}", apiUrl, responseFromPython.getBody());
            return ResponseEntity.status(responseFromPython.getStatusCode())
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(responseFromPython.getBody());
        } catch (HttpClientErrorException | HttpServerErrorException e) {
            log.error("Error from Python Suggest Replies API [{}] ({}): {} - Response Body: {}", apiUrl, e.getStatusCode(), e.getMessage(), e.getResponseBodyAsString(), e);
            return ResponseEntity.status(e.getStatusCode())
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(e.getResponseBodyAsString());
        } catch (RestClientException e) {
            log.error("Error connecting to Python Suggest Replies API [{}]: {}", apiUrl, e.getMessage(), e);
            String errorJson = "{\"error\":\"답변 제안 서비스에 접속할 수 없습니다: " + escapeJson(e.getMessage()) + "\"}";
            return ResponseEntity.status(503)
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(errorJson);
        } catch (Exception e) {
            log.error("Unexpected error in handleSuggestReplies for [{}]: {}", apiUrl, e.getMessage(), e);
            String errorJson = "{\"error\":\"예상치 못한 오류가 발생했습니다.\"}";
            return ResponseEntity.status(500)
                                 .contentType(MediaType.APPLICATION_JSON)
                                 .body(errorJson);
        }
    }

    // JSON 문자열 내 특수문자를 이스케이프하는 헬퍼 메소드
    private String escapeJson(String str) {
        if (str == null) return null;
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}