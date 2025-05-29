package com.mc.app.service;

import com.theokanning.openai.completion.CompletionRequest;
import com.theokanning.openai.service.OpenAiService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class GptService {

    private final OpenAiService openAiService;

    public GptService(@Value("${openai.api.key}") String apiKey) {
        this.openAiService = new OpenAiService(apiKey);
    }

    public String generateReply(String question) {
        CompletionRequest request = CompletionRequest.builder()
                .model("gpt-3.5-turbo-instruct")
                .prompt("고객 문의: \"" + question + "\"\n\n관리자 응답:")
                .maxTokens(500)
                .temperature(0.7)
                .build();

        return openAiService.createCompletion(request)
                .getChoices()
                .get(0)
                .getText()
                .trim();
    }
}
