# PetGPT API 통합 가이드

이 문서는 Spring 백엔드와 FastAPI 기반 PetGPT 챗봇 서비스의 통합 방법을 설명합니다.

## 1. 아키텍처 개요

현재 시스템은 다음과 같은 구성요소로 이루어져 있습니다:

- **프론트엔드**: JSP 기반 웹 애플리케이션 (chat.js에서 챗봇 기능 구현)
- **Java 백엔드**: Spring Boot 기반 백엔드 서비스 (ChatbotController, ChatbotService)
- **Python 백엔드**: FastAPI 기반 챗봇 서비스 (PetGPT)

## 2. API 엔드포인트

### Spring 백엔드 (현재)

- **요청 URL**: `/api/chatbot/ask`
- **메소드**: POST
- **요청 본문**: `{ "message": "사용자 메시지" }`
- **응답 본문**: `{ "reply": "챗봇 응답 메시지" }`

### FastAPI 백엔드 (PetGPT)

- **요청 URL**: `/api/chat`
- **메소드**: POST
- **요청 본문**: `{ "query": "사용자 메시지", "session_id": "세션 ID" }`
- **응답 본문**:
  ```json
  {
    "response_type": "qna|product_recommendation|general",
    "response_text": "챗봇 응답 메시지",
    "sources": ["출처1", "출처2"], // QnA 타입인 경우
    "products": [{ ... }], // 상품 추천 타입인 경우
    "medical_warning": false // 의료 관련 경고 여부
  }
  ```

## 3. 통합 방법

### 방법 1: Spring 백엔드에서 FastAPI 호출 (권장)

Spring의 `ChatbotService`를 수정하여 FastAPI의 `/api/chat` 엔드포인트를 호출하도록 합니다:

```java
// ChatbotService.java 수정
public Mono<String> getChatbotReply(String userMessage) {
    log.info("Sending prompt to PetGPT API: {}", userMessage);

    Map<String, String> requestPayload = new HashMap<>();
    requestPayload.put("query", userMessage);
    requestPayload.put("session_id", UUID.randomUUID().toString());

    return webClient.post()
            .uri(chatbotApiUrl) // application.properties에서 설정
            .contentType(MediaType.APPLICATION_JSON)
            .bodyValue(requestPayload)
            .retrieve()
            .bodyToMono(PetGptResponse.class)
            .map(response -> response.getResponse_text())
            .doOnSuccess(reply -> log.info("Received reply from PetGPT API"))
            .doOnError(error -> log.error("Error calling PetGPT API: {}", error.getMessage()))
            .onErrorResume(error -> {
                log.error("PetGPT API call failed, returning default message.", error);
                return Mono.just("죄송합니다, AI 응답을 가져오는 데 실패했습니다.");
            });
}

// PetGptResponse 클래스 추가
public static class PetGptResponse {
    private String response_type;
    private String response_text;
    private List<String> sources;
    private List<Map<String, Object>> products;
    private boolean medical_warning;

    // getter/setter 생략
}
```

### 방법 2: FastAPI에서 Spring 호환 엔드포인트 제공

FastAPI에 Spring 호환 엔드포인트를 추가합니다:

```python
# petgpt_chatbot/api.py에 추가
@router.post("/chatbot/ask", response_model=SpringChatResponse)
async def chatbot_ask(request: SpringChatRequest):
    """
    Spring 백엔드와 호환되는 챗봇 API 엔드포인트
    """
    try:
        # 기존 /chat 엔드포인트와 동일한 처리 로직 사용
        chat_request = ChatRequest(query=request.message, session_id="spring-backend")
        response = await chat(chat_request)

        # Spring 응답 형식으로 변환
        return SpringChatResponse(reply=response.response_text)
    except Exception as e:
        logger.error(f"Spring 호환 엔드포인트 처리 중 오류: {str(e)}")
        raise HTTPException(status_code=500, detail="내부 서버 오류")

# 모델 추가
class SpringChatRequest(BaseModel):
    message: str

class SpringChatResponse(BaseModel):
    reply: str
```

## 4. 배포 구성

### 옵션 1: 프록시 서버 사용

Nginx와 같은 프록시 서버를 사용하여 `/api/chatbot/ask` 요청을 FastAPI 서버로 리다이렉션

### 옵션 2: 직접 FastAPI 서버 호출

Spring 서버에서 FastAPI 서버를 직접 호출하는 방식

## 5. 환경 설정

### Spring 백엔드 (application.properties)

```
chatbot.api.url=http://localhost:8000/api/chat
```

### FastAPI 백엔드 (config.py)

```python
# CORS 설정으로 Spring 백엔드의 요청 허용
```

## 6. 권장 통합 방법

1. Spring의 `ChatbotService`를 수정하여 FastAPI 서버 호출 (방법 1)
2. 응답 형식 변환 처리 추가
3. 성능 모니터링 구현

이 방식은 기존 프론트엔드 코드를 수정하지 않아도 되며, Spring 백엔드와 FastAPI 백엔드를 효과적으로 통합할 수 있습니다.
