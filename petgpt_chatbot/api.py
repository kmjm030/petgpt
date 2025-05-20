"""
PetGPT 챗봇 API 모듈
"""
import json
import logging
import traceback
from typing import Dict, Any, Literal, Union, Optional, List
from datetime import datetime

from fastapi import APIRouter, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from langchain_core.output_parsers import StrOutputParser
from pydantic import BaseModel, Field, HttpUrl

from petgpt_chatbot.models import ChatRequest, ChatResponse, ProductInfo
from petgpt_chatbot.llm_init import get_llm
from petgpt_chatbot.prompts import INTENT_CLASSIFICATION_PROMPT
from petgpt_chatbot.db_utils import log_conversation_async
from petgpt_chatbot.rag import get_qna_answer
from petgpt_chatbot.recommend import get_product_recommendation

# Spring 백엔드와의 호환성을 위한 모델
class SpringChatRequest(BaseModel):
    message: str

class SpringProductInfo(BaseModel):
    """
    Spring 응답용 상품 정보 모델
    """
    id: str = Field(..., description="상품 ID")
    name: str = Field(..., description="상품명")
    price: int = Field(..., description="가격")
    imageUrl: HttpUrl = Field(..., description="이미지 URL")
    productUrl: HttpUrl = Field(..., description="상품 URL")
    description: Optional[str] = Field(None, description="상품 설명")
    rating: Optional[float] = Field(None, description="평점")
    brand: Optional[str] = Field(None, description="브랜드")
    category: Optional[str] = Field(None, description="카테고리")
    discountRate: Optional[int] = Field(None, description="할인율")
    originalPrice: Optional[int] = Field(None, description="원래 가격")

class SpringChatResponse(BaseModel):
    """
    스프링 호환 챗봇 응답 모델
    """
    reply: str = Field(..., description="응답 텍스트")
    responseType: str = Field(..., description="응답 유형 (general, qna, product_recommendation)")
    products: Optional[List[SpringProductInfo]] = Field(None, description="추천 상품 목록")
    sources: Optional[List[str]] = Field(None, description="출처 목록")
    medicalWarning: bool = Field(False, description="의료 관련 경고 표시 여부")

# 로깅 설정
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)  # 로그 레벨을 DEBUG로 설정

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
        logger.debug(f"의도 분류 시작: query='{query}'")
        
        # LLM 인스턴스 가져오기
        llm = get_llm()
        logger.debug(f"LLM 인스턴스 생성 완료: {type(llm).__name__}")
        
        # 프롬프트 구성
        prompt_input = {"query": query}
        
        # LLM 호출 및 결과 파싱
        output_parser = StrOutputParser()
        
        # 체인 구성
        chain = INTENT_CLASSIFICATION_PROMPT | llm | output_parser
        logger.debug("의도 분류 체인 구성 완료")
        
        # 체인 실행
        logger.debug("체인 실행 시작")
        response = await chain.ainvoke(prompt_input)
        logger.debug(f"체인 실행 완료, 원본 응답: {response}")
        
        # 응답에서 의도 추출
        try:
            # JSON 형식인 경우 (예: {"intent": "qna"})
            intent_data = json.loads(response.strip())
            intent = intent_data.get("intent", "general")
            logger.debug(f"JSON 형식 응답에서 의도 추출: {intent}")
        except json.JSONDecodeError:
            # 단순 텍스트인 경우
            intent_line = response.strip().lower()
            if "qna" in intent_line:
                intent = "qna"
            elif "product_recommendation" in intent_line or "recommendation" in intent_line:
                intent = "product_recommendation"
            else:
                intent = "general"
            logger.debug(f"텍스트 형식 응답에서 의도 추출: {intent}")
        
        # 유효성 검사
        if intent not in ["qna", "product_recommendation", "general"]:
            logger.warning(f"예상치 못한 의도 분류: {intent}, 'general'로 기본 설정")
            intent = "general"
        
        logger.debug(f"최종 분류된 의도: {intent}")
        return intent
        
    except Exception as e:
        error_text = traceback.format_exc()
        logger.error(f"의도 분류 중 오류 발생: {str(e)}\n{error_text}")
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
    logger.debug(f"일반 대화 처리: query='{query}'")
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
        logger.debug(f"채팅 API 호출: query='{request.query}', session_id='{request.session_id}'")
        
        # 의도 분류
        intent = await classify_intent(request.query)
        logger.info(f"의도 분류 결과: {intent}")
        
        # 의도에 따른 처리
        if intent == "qna":
            try:
                logger.debug("QnA 파이프라인 실행 시작")
                # RAG Q&A 파이프라인 호출
                answer, sources = get_qna_answer(request.query)
                logger.debug(f"QnA 파이프라인 실행 완료: answer_length={len(answer)}, sources={sources}")
                
                # sources가 없으면 빈 리스트로 설정 (유효성 검증 통과를 위해)
                if not sources:
                    sources = ["PetGPT 지식 데이터베이스"]
                
                response = ChatResponse(
                    response_type="qna",
                    response_text=answer,
                    sources=sources,
                    medical_warning=False  # 기본값 설정
                )
            except Exception as qna_err:
                logger.error(f"QnA 처리 중 오류: {str(qna_err)}")
                # QnA 처리 실패 시 일반 응답으로 폴백
                response = ChatResponse(
                    response_type="general",
                    response_text="죄송합니다. 질문에 답변하는 중 문제가 발생했습니다. 다른 질문을 해보시겠어요?"
                )
        elif intent == "product_recommendation":
            try:
                logger.debug("상품 추천 파이프라인 실행 시작")
                # 상품 추천 파이프라인 호출
                result = await get_product_recommendation(request.query)
                logger.debug(f"상품 추천 파이프라인 실행 완료: message_length={len(result['message'])}, products_count={len(result.get('products', []))}")
                
                # 상품이 없으면 빈 리스트로 설정하고 일반 응답으로 변경
                if not result.get('products'):
                    logger.warning("추천 상품이 없어 일반 응답으로 변경")
                    response = ChatResponse(
                        response_type="general",
                        response_text=result.get("message", "죄송합니다. 요청하신 조건에 맞는 상품을 찾을 수 없습니다. 다른 조건으로 검색해 보시겠어요?")
                    )
                else:
                    response = ChatResponse(
                        response_type="product_recommendation",
                        response_text=result["message"],
                        products=result["products"],
                        medical_warning=result.get("medical_warning", False)
                    )
            except Exception as recommend_err:
                logger.error(f"상품 추천 처리 중 오류: {str(recommend_err)}")
                # 상품 추천 처리 실패 시 일반 응답으로 폴백
                response = ChatResponse(
                    response_type="general",
                    response_text="죄송합니다. 상품 추천 중 문제가 발생했습니다. 잠시 후 다시 시도해 주세요."
                )
        else:
            logger.debug("일반 대화 처리 실행")
            # 일반 대화 처리
            response = await handle_general_conversation(request.query)
        
        # 대화 내용 로깅
        try:
            await log_conversation_async({
                "query": request.query,
                "response": response.model_dump(),
                "session_id": request.session_id
            })
            logger.debug("대화 내용 로깅 완료")
        except Exception as log_err:
            logger.error(f"대화 로깅 중 오류 발생: {str(log_err)}")
        
        logger.debug("채팅 API 응답 반환")
        return response
        
    except Exception as e:
        error_text = traceback.format_exc()
        logger.error(f"채팅 처리 중 오류 발생: {str(e)}\n{error_text}")
        # 오류 발생 시 일반 응답
        return ChatResponse(
            response_type="general",
            response_text="죄송합니다. 요청을 처리하는 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."
        )


def convert_to_spring_product(product: ProductInfo) -> SpringProductInfo:
    """
    내부 상품 모델을 Spring 호환 상품 모델로 변환
    
    Args:
        product (ProductInfo): 내부 상품 정보 모델
        
    Returns:
        SpringProductInfo: Spring 호환 상품 정보 모델
    """
    return SpringProductInfo(
        id=product.product_id,
        name=product.name,
        price=product.price,
        imageUrl=product.image_url,
        productUrl=product.product_url,
        description=product.description,
        rating=product.rating,
        brand=product.brand,
        category=product.category,
        discountRate=product.discount_rate,
        originalPrice=product.original_price
    )


@router.post("/chatbot/ask", response_model=SpringChatResponse)
async def chatbot_ask(request: SpringChatRequest) -> SpringChatResponse:
    """
    Spring 백엔드와 호환되는 챗봇 API 엔드포인트
    
    Args:
        request (SpringChatRequest): Spring 형식의 요청
        
    Returns:
        SpringChatResponse: Spring 형식의 응답
    """
    try:
        logger.debug(f"Spring 호환 API 호출: message='{request.message}'")
        
        # 기존 /chat 엔드포인트와 동일한 처리 로직 사용
        chat_request = ChatRequest(query=request.message, session_id="spring-backend")
        response = await chat(chat_request)
        
        # Spring 응답 형식으로 변환
        spring_products = None
        if response.products:
            spring_products = [convert_to_spring_product(product) for product in response.products]
        
        spring_response = SpringChatResponse(
            reply=response.response_text,
            responseType=response.response_type,
            products=spring_products,
            sources=response.sources,
            medicalWarning=response.medical_warning
        )
        
        logger.debug("Spring 호환 API 응답 반환")
        return spring_response
    except Exception as e:
        error_text = traceback.format_exc()
        logger.error(f"Spring 호환 엔드포인트 처리 중 오류: {str(e)}\n{error_text}")
        
        # 오류 발생 시 일반 응답
        return SpringChatResponse(
            reply="죄송합니다. 요청을 처리하는 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.",
            responseType="general",
            medicalWarning=False
        ) 