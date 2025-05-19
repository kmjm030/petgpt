"""
PetGPT 챗봇 Pydantic 모델 테스트
"""
import pytest
from pydantic import ValidationError

from petgpt_chatbot.models import ChatRequest, ChatResponse, ProductInfo


def test_chat_request_validation():
    """
    ChatRequest 모델이 입력 데이터를 올바르게 검증하는지 테스트
    """
    # 유효한 입력
    valid_data = {"query": "강아지 사료 추천해줘"}
    request = ChatRequest(**valid_data)
    assert request.query == "강아지 사료 추천해줘"
    
    # 무효한 입력 (query 필드 누락)
    invalid_data = {}
    with pytest.raises(ValidationError):
        ChatRequest(**invalid_data)
    
    # 무효한 입력 (query 필드가 빈 문자열)
    invalid_data = {"query": ""}
    with pytest.raises(ValidationError):
        ChatRequest(**invalid_data)


def test_chat_response_validation():
    """
    ChatResponse 모델이 입력 데이터를 올바르게 검증하는지 테스트
    """
    # 유효한 입력 (QnA 응답)
    valid_qna_data = {
        "response_type": "qna",
        "response_text": "반려견에게 좋은 사료는...",
        "sources": ["https://example.com/dog-food-guide", "https://example.com/nutrition-tips"]
    }
    qna_response = ChatResponse(**valid_qna_data)
    assert qna_response.response_type == "qna"
    assert qna_response.response_text == "반려견에게 좋은 사료는..."
    assert len(qna_response.sources) == 2
    
    # 유효한 입력 (상품 추천 응답)
    valid_product_data = {
        "response_type": "product_recommendation",
        "response_text": "다음 상품을 추천드립니다",
        "products": [
            {
                "product_id": "P12345",
                "name": "프리미엄 강아지 사료",
                "price": 35000,
                "rating": 4.5,
                "image_url": "https://example.com/images/dog-food.jpg",
                "product_url": "https://example.com/products/P12345"
            }
        ]
    }
    product_response = ChatResponse(**valid_product_data)
    assert product_response.response_type == "product_recommendation"
    assert len(product_response.products) == 1
    assert product_response.products[0].name == "프리미엄 강아지 사료"
    
    # 무효한 입력 (알 수 없는 응답 타입)
    invalid_type_data = {
        "response_type": "unknown_type",
        "response_text": "테스트"
    }
    with pytest.raises(ValidationError):
        ChatResponse(**invalid_type_data)


def test_product_info_validation():
    """
    ProductInfo 모델이 입력 데이터를 올바르게 검증하는지 테스트
    """
    # 유효한 입력
    valid_data = {
        "product_id": "P12345",
        "name": "프리미엄 강아지 사료",
        "price": 35000,
        "rating": 4.5,
        "image_url": "https://example.com/images/dog-food.jpg",
        "product_url": "https://example.com/products/P12345"
    }
    product = ProductInfo(**valid_data)
    assert product.product_id == "P12345"
    assert product.name == "프리미엄 강아지 사료"
    assert product.price == 35000
    assert product.rating == 4.5
    
    # 무효한 입력 (음수 가격)
    invalid_price_data = valid_data.copy()
    invalid_price_data["price"] = -100
    with pytest.raises(ValidationError):
        ProductInfo(**invalid_price_data)
    
    # 무효한 입력 (범위 밖 평점)
    invalid_rating_data = valid_data.copy()
    invalid_rating_data["rating"] = 6.0
    with pytest.raises(ValidationError):
        ProductInfo(**invalid_rating_data)
    
    # 무효한 입력 (URL 형식 오류)
    invalid_url_data = valid_data.copy()
    invalid_url_data["image_url"] = "not-a-url"
    with pytest.raises(ValidationError):
        ProductInfo(**invalid_url_data) 