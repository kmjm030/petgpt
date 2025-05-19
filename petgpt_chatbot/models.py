"""
PetGPT 챗봇 Pydantic 모델 정의
"""
from typing import List, Literal, Optional, Union
from pydantic import BaseModel, Field, HttpUrl, field_validator


class ChatRequest(BaseModel):
    """
    사용자 채팅 요청 모델
    """
    query: str = Field(..., min_length=1, description="사용자 질문/요청 내용")
    session_id: Optional[str] = Field(None, description="세션 ID (선택 사항)")


class ProductInfo(BaseModel):
    """
    상품 정보 모델
    """
    product_id: str = Field(..., description="상품 고유 ID")
    name: str = Field(..., min_length=1, description="상품명")
    price: int = Field(..., gt=0, description="상품 가격 (원)")
    rating: float = Field(..., ge=0, le=5, description="상품 평점 (0-5)")
    image_url: HttpUrl = Field(..., description="상품 이미지 URL")
    product_url: HttpUrl = Field(..., description="상품 상세 페이지 URL")
    description: Optional[str] = Field(None, description="상품 설명 (선택 사항)")
    category: Optional[str] = Field(None, description="상품 카테고리 (선택 사항)")
    brand: Optional[str] = Field(None, description="상품 브랜드 (선택 사항)")
    discount_rate: Optional[int] = Field(None, ge=0, le=100, description="할인률 (0-100%)")
    original_price: Optional[int] = Field(None, gt=0, description="원래 가격 (할인 전)")

    @field_validator('rating')
    @classmethod
    def validate_rating(cls, value: float) -> float:
        """평점을 소수점 한 자리까지 반올림"""
        return round(value * 2) / 2  # 0.5 단위로 반올림


class ChatResponse(BaseModel):
    """
    챗봇 응답 모델
    """
    response_type: Literal["qna", "product_recommendation", "general"] = Field(
        ..., description="응답 유형 (질의응답, 상품 추천, 일반 대화)"
    )
    response_text: str = Field(..., min_length=1, description="응답 텍스트")
    sources: Optional[List[str]] = Field(None, description="QnA 응답의 출처/참고 링크")
    products: Optional[List[ProductInfo]] = Field(None, description="추천 상품 목록")
    medical_warning: Optional[bool] = Field(
        False, description="의료 관련 응답 여부 (경고 표시 필요 시 True)"
    )

    @field_validator('sources')
    @classmethod
    def validate_sources_for_qna(cls, sources: Optional[List[str]], info):
        """QnA 응답 타입인 경우 sources 필드 필수 검증"""
        values = info.data
        if values.get('response_type') == 'qna' and not sources:
            raise ValueError("QnA 응답에는 sources 필드가 필요합니다")
        return sources

    @field_validator('products')
    @classmethod
    def validate_products_for_recommendation(cls, products: Optional[List[ProductInfo]], info):
        """상품 추천 응답 타입인 경우 products 필드 필수 검증"""
        values = info.data
        if values.get('response_type') == 'product_recommendation' and not products:
            raise ValueError("상품 추천 응답에는 products 필드가 필요합니다")
        return products 