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


def test_chat_response_complex_validation():
    """
    ChatResponse 모델의 복잡한 유효성 검사 테스트
    """
    # 1. QnA 타입에 sources 필드가 없는 경우 오류 검증
    invalid_qna_data = {
        "response_type": "qna",
        "response_text": "반려견에게 좋은 사료는...",
        "sources": None  # QnA 타입에는 sources가 필요함
    }
    with pytest.raises(ValidationError):
        ChatResponse(**invalid_qna_data)
    
    # 2. QnA 타입에 빈 sources 리스트가 있는 경우 오류 검증
    invalid_qna_empty_sources = {
        "response_type": "qna",
        "response_text": "반려견에게 좋은 사료는...",
        "sources": []  # 빈 리스트도 허용하지 않음
    }
    with pytest.raises(ValidationError):
        ChatResponse(**invalid_qna_empty_sources)
    
    # 3. 상품 추천 타입에 products 필드가 없는 경우 오류 검증
    invalid_recommendation_data = {
        "response_type": "product_recommendation",
        "response_text": "다음 상품을 추천드립니다",
        "products": None  # 상품 추천 타입에는 products가 필요함
    }
    with pytest.raises(ValidationError):
        ChatResponse(**invalid_recommendation_data)
    
    # 4. 상품 추천 타입에 빈 products 리스트가 있는 경우 오류 검증
    invalid_recommendation_empty_products = {
        "response_type": "product_recommendation",
        "response_text": "다음 상품을 추천드립니다",
        "products": []  # 빈 리스트도 허용하지 않음
    }
    with pytest.raises(ValidationError):
        ChatResponse(**invalid_recommendation_empty_products)
    
    # 5. 일반 대화 타입에 medical_warning 필드를 True로 설정 가능한지 검증
    general_with_warning_data = {
        "response_type": "general",
        "response_text": "안녕하세요, 어떻게 도와드릴까요?",
        "medical_warning": True
    }
    response = ChatResponse(**general_with_warning_data)
    assert response.response_type == "general"
    assert response.medical_warning is True
    
    # 6. 복합 케이스: 상품 추천 타입에 medical_warning과 products 모두 포함
    complex_recommendation_data = {
        "response_type": "product_recommendation",
        "response_text": "반려동물 영양제를 추천드립니다만, 수의사와 상담하세요.",
        "products": [
            {
                "product_id": "P12345",
                "name": "반려견 종합 영양제",
                "price": 45000,
                "rating": 4.5,
                "image_url": "https://example.com/images/dog-vitamin.jpg",
                "product_url": "https://example.com/products/P12345"
            }
        ],
        "medical_warning": True
    }
    response = ChatResponse(**complex_recommendation_data)
    assert response.response_type == "product_recommendation"
    assert response.medical_warning is True
    assert len(response.products) == 1


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


def test_product_info_all_fields_validation():
    """
    ProductInfo 모델의 모든 필드에 대한 유효성 검사 테스트
    """
    # 모든 필드를 포함한 유효한 데이터
    complete_valid_data = {
        "product_id": "P12345",
        "name": "프리미엄 강아지 사료",
        "price": 35000,
        "rating": 4.7,  # 4.5로 반올림되어야 함
        "image_url": "https://example.com/images/dog-food.jpg",
        "product_url": "https://example.com/products/P12345",
        "description": "건강한 반려견을 위한 고품질 사료",
        "category": "사료",
        "brand": "펫케어",
        "discount_rate": 20,
        "original_price": 45000
    }
    product = ProductInfo(**complete_valid_data)
    assert product.product_id == "P12345"
    assert product.name == "프리미엄 강아지 사료"
    assert product.price == 35000
    assert product.rating == 4.5  # 0.5 단위로 반올림됨
    assert product.description == "건강한 반려견을 위한 고품질 사료"
    assert product.category == "사료"
    assert product.brand == "펫케어"
    assert product.discount_rate == 20
    assert product.original_price == 45000
    
    # 필수 필드만 있는 유효한 데이터
    minimal_valid_data = {
        "product_id": "P12345",
        "name": "프리미엄 강아지 사료",
        "price": 35000,
        "rating": 4.0,
        "image_url": "https://example.com/images/dog-food.jpg",
        "product_url": "https://example.com/products/P12345"
    }
    product = ProductInfo(**minimal_valid_data)
    assert product.description is None
    assert product.category is None
    assert product.brand is None
    assert product.discount_rate is None
    assert product.original_price is None
    
    # 할인율 범위 초과 테스트
    invalid_discount_rate_data = complete_valid_data.copy()
    invalid_discount_rate_data["discount_rate"] = 110  # 0-100 범위 초과
    with pytest.raises(ValidationError):
        ProductInfo(**invalid_discount_rate_data)
    
    # 할인 전 가격이 음수인 경우 테스트
    invalid_original_price_data = complete_valid_data.copy()
    invalid_original_price_data["original_price"] = -1000
    with pytest.raises(ValidationError):
        ProductInfo(**invalid_original_price_data)
    
    # 평점 소수점 반올림 테스트 (0.5 단위로 반올림)
    rating_rounding_test_cases = [
        {"input": 3.0, "expected": 3.0},
        {"input": 3.1, "expected": 3.0},
        {"input": 3.2, "expected": 3.0},
        {"input": 3.3, "expected": 3.5},
        {"input": 3.4, "expected": 3.5},
        {"input": 3.5, "expected": 3.5},
        {"input": 3.6, "expected": 3.5},
        {"input": 3.7, "expected": 3.5},
        {"input": 3.8, "expected": 4.0},
        {"input": 4.9, "expected": 5.0}
    ]
    
    for test_case in rating_rounding_test_cases:
        test_data = minimal_valid_data.copy()
        test_data["rating"] = test_case["input"]
        product = ProductInfo(**test_data)
        assert product.rating == test_case["expected"], f"Rating {test_case['input']} should round to {test_case['expected']}, but got {product.rating}" 