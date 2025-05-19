"""
PetGPT 챗봇 API 모듈
"""
import json
import logging
from typing import Dict, Any, Literal, Union, Optional
from datetime import datetime

from fastapi import APIRouter, HTTPException, Depends
from langchain_core.output_parsers import StrOutputParser
from pydantic import BaseModel

from petgpt_chatbot.models import ChatRequest, ChatResponse, ProductInfo
from petgpt_chatbot.llm_init import get_llm
from petgpt_chatbot.prompts import INTENT_CLASSIFICATION_PROMPT
from petgpt_chatbot.db_utils import log_conversation_async
from petgpt_chatbot.rag import get_qna_answer
from petgpt_chatbot.recommend import get_product_recommendation

# 로깅 설정
logger = logging.getLogger(__name__)

# 의도 타입 정의
IntentType = Literal["qna", "product_recommendation", "general"]

# API 라우터 정의
router = APIRouter(prefix="/api", tags=["chat"])


# 의도 분류 함수
async def classify_intent(query: str) -> IntentType:
    """
    사용자 질문의 의도를 분류하는 함수
    
    Args:
        query (str): 사용자 질문
        
    Returns:
        IntentType: 분류된 의도 ("qna", "product_recommendation", "general" 중 하나)
    """
    try:
        # LLM 인스턴스 가져오기
        llm = get_llm()
        
        # 프롬프트 구성
        prompt_input = {"query": query}
        
        # LLM 호출 및 결과 파싱
        output_parser = StrOutputParser()
        
        # 체인 구성
        chain = INTENT_CLASSIFICATION_PROMPT | llm | output_parser
        
        # 체인 실행
        response = await chain.ainvoke(prompt_input)
        
        # 응답에서 의도 추출
        try:
            # JSON 형식인 경우 (예: {"intent": "qna"})
            intent_data = json.loads(response.strip())
            intent = intent_data.get("intent", "general")
        except json.JSONDecodeError:
            # 단순 텍스트인 경우
            intent_line = response.strip().lower()
            if "qna" in intent_line:
                intent = "qna"
            elif "product_recommendation" in intent_line or "recommendation" in intent_line:
                intent = "product_recommendation"
            else:
                intent = "general"
        
        # 유효성 검사
        if intent not in ["qna", "product_recommendation", "general"]:
            logger.warning(f"예상치 못한 의도 분류: {intent}, 'general'로 기본 설정")
            intent = "general"
        
        return intent
        
    except Exception as e:
        logger.error(f"의도 분류 중 오류 발생: {str(e)}")
        # 오류 발생 시 기본값
        return "general"


class IntentResponse(BaseModel):
    """
    의도 분류 응답 모델 (테스트용)
    """
    intent: IntentType


# 일반 대화 처리 함수
async def handle_general_conversation(query: str) -> ChatResponse:
    """
    일반 대화를 처리하는 함수
    
    Args:
        query (str): 사용자 질문
        
    Returns:
        ChatResponse: 챗봇 응답
    """
    # 일반 응답으로 기본 메시지 반환
    return ChatResponse(
        response_type="general",
        response_text="안녕하세요, PetGPT입니다. 반려동물에 관한 질문이나 상품 추천을 요청해 주세요."
    )


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    """
    채팅 API 엔드포인트
    
    Args:
        request (ChatRequest): 사용자 요청
        
    Returns:
        ChatResponse: 챗봇 응답
    """
    try:
        # 의도 분류
        intent = await classify_intent(request.query)
        logger.info(f"의도 분류 결과: {intent}")
        
        # 의도에 따른 처리
        if intent == "qna":
            # RAG Q&A 파이프라인 호출
            result = await get_qna_answer(request.query)
            response = ChatResponse(
                response_type="qna",
                response_text=result["answer"],
                sources=result["sources"],
                medical_warning=result["medical_warning"]
            )
        elif intent == "product_recommendation":
            # 상품 추천 파이프라인 호출
            result = await get_product_recommendation(request.query)
            response = ChatResponse(
                response_type="product_recommendation",
                response_text=result["message"],
                products=result["products"],
                medical_warning=result.get("medical_warning", False)
            )
        else:
            # 일반 대화 처리
            response = await handle_general_conversation(request.query)
        
        # 대화 내용 로깅
        await log_conversation_async({
            "query": request.query,
            "response": response.model_dump(),
            "session_id": request.session_id
        })
        
        return response
        
    except Exception as e:
        logger.error(f"채팅 처리 중 오류 발생: {str(e)}")
        # 오류 발생 시 일반 응답
        return ChatResponse(
            response_type="general",
            response_text="죄송합니다. 요청을 처리하는 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        ) 