"""
PetGPT와 Spring 백엔드 통합 테스트 스크립트
"""
import asyncio
import json
import sys
import time
from datetime import datetime
import requests
from pprint import pprint

# 테스트 설정
SPRING_API_URL = "http://127.0.0.1/api/chatbot/ask"
FASTAPI_URL = "http://127.0.0.1:8000/api/chat"
FASTAPI_SPRING_COMPAT_URL = "http://127.0.0.1:8000/api/chatbot/ask" # Spring 호환 엔드포인트
TEST_SCENARIOS = [
    {
        "name": "Q&A 시나리오: 기본 반려동물 지식 질문",
        "query": "강아지가 초콜릿을 먹으면 위험한 이유는 무엇인가요?",
        "expected_type": "qna",
    },
    {
        "name": "Q&A 시나리오: 반려동물 케어 관련 질문",
        "query": "고양이 털 관리는 어떻게 해야 하나요?",
        "expected_type": "qna",
    },
    {
        "name": "상품 추천 시나리오: 일반 상품 추천 요청",
        "query": "강아지 장난감 추천해주세요",
        "expected_type": "product_recommendation",
    },
    {
        "name": "상품 추천 시나리오: 특정 조건의 상품 추천 요청",
        "query": "대형견 노견용 관절에 좋은 사료 추천해주세요",
        "expected_type": "product_recommendation",
    },
    {
        "name": "의료 조언 회피 시나리오: 의료 관련 질문 처리",
        "query": "강아지가 구토를 계속하는데 어떻게 해야 하나요?",
        "expected_type": "qna",
        "medical_warning": True,
    },
    {
        "name": "예외 케이스: 반려동물과 관련 없는 질문 처리",
        "query": "오늘 날씨 어때요?",
        "expected_type": "general",
    },
]

def test_direct_fastapi():
    """FastAPI 엔드포인트 직접 테스트"""
    print("="*80)
    print("FastAPI 엔드포인트 직접 테스트")
    print("="*80)
    session_id = f"test_{int(time.time())}"
    
    for scenario in TEST_SCENARIOS:
        print(f"\n테스트: {scenario['name']}")
        try:
            start_time = time.time()
            response = requests.post(
                FASTAPI_URL,
                json={"query": scenario["query"], "session_id": session_id},
                timeout=10,
            )
            elapsed = time.time() - start_time
            
            if response.status_code == 200:
                result = response.json()
                print(f"응답 시간: {elapsed:.2f}초")
                print(f"응답 타입: {result.get('response_type')}")
                print(f"기대 타입: {scenario.get('expected_type')}")
                print(f"응답 텍스트 일부: {result.get('response_text')[:100]}...")
                
                if result.get("response_type") == scenario.get("expected_type"):
                    if scenario.get("expected_type") == "qna":
                        print(f"출처 포함: {'sources' in result and len(result['sources']) > 0}")
                    elif scenario.get("expected_type") == "product_recommendation":
                        print(f"상품 개수: {len(result.get('products', []))}")
                
                if "medical_warning" in scenario:
                    print(f"의료 경고 설정: {result.get('medical_warning', False)}")
                    print(f"기대 의료 경고: {scenario.get('medical_warning')}")
                
                print("✅ 테스트 성공" if result.get("response_type") == scenario.get("expected_type") else "❌ 테스트 실패")
            else:
                print(f"❌ 오류: HTTP {response.status_code}")
                print(response.text)
        except Exception as e:
            print(f"❌ 예외 발생: {str(e)}")

def test_fastapi_spring_compat():
    """FastAPI의 Spring 호환 엔드포인트 테스트"""
    print("\n"+"="*80)
    print("FastAPI Spring 호환 엔드포인트 테스트")
    print("="*80)
    
    for scenario in TEST_SCENARIOS[:2]:  # 처음 2개 시나리오만 테스트
        print(f"\n테스트: {scenario['name']}")
        try:
            start_time = time.time()
            response = requests.post(
                FASTAPI_SPRING_COMPAT_URL,
                json={"message": scenario["query"]},
                timeout=10,
            )
            elapsed = time.time() - start_time
            
            if response.status_code == 200:
                result = response.json()
                print(f"응답 시간: {elapsed:.2f}초")
                print(f"응답 텍스트 일부: {result.get('reply')[:100]}...")
                print("✅ 테스트 성공" if result.get("reply") else "❌ 테스트 실패")
            else:
                print(f"❌ 오류: HTTP {response.status_code}")
                print(response.text)
        except Exception as e:
            print(f"❌ 예외 발생: {str(e)}")
    
def test_spring_integration():
    """Spring 백엔드 통합 테스트"""
    print("\n"+"="*80)
    print("Spring 백엔드 통합 테스트")
    print("="*80)
    
    for scenario in TEST_SCENARIOS:
        print(f"\n테스트: {scenario['name']}")
        try:
            start_time = time.time()
            response = requests.post(
                SPRING_API_URL,
                json={"message": scenario["query"]},
                timeout=10,
            )
            elapsed = time.time() - start_time
            
            if response.status_code == 200:
                result = response.json()
                print(f"응답 시간: {elapsed:.2f}초")
                print(f"응답 텍스트 일부: {result.get('reply')[:100]}...")
                print("✅ 테스트 성공" if result.get("reply") else "❌ 테스트 실패")
            else:
                print(f"❌ 오류: HTTP {response.status_code}")
                print(response.text)
        except Exception as e:
            print(f"❌ 예외 발생: {str(e)}")

if __name__ == "__main__":
    # FastAPI 엔드포인트 직접 테스트
    test_direct_fastapi()
    
    # FastAPI Spring 호환 엔드포인트 테스트
    test_fastapi_spring_compat()
    
    # Spring 백엔드 통합 테스트
    test_spring_integration()
        
    
    print("\n테스트 완료!") 