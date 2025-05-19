"""
PetGPT 챗봇 API 응답 시간 측정 스크립트
"""
import time
import json
import requests
import statistics
from datetime import datetime

# 측정 설정
API_URL = "http://localhost:8000/api/chat"
ITERATIONS = 5  # 측정 횟수
WAIT_BETWEEN_CALLS = 1  # 호출 간 대기 시간(초)

# 측정할 쿼리 목록 (영어와 한글 모두 테스트)
TEST_QUERIES = [
    # QnA 의도 쿼리
    {"query": "How much food should I give to my dog?", "description": "QnA (영어)"},
    {"query": "강아지에게 사료를 얼마나 줘야 하나요?", "description": "QnA (한글)"},
    
    # 상품 추천 의도 쿼리
    {"query": "Can you recommend dog food for a puppy?", "description": "상품 추천 (영어)"},
    {"query": "강아지 사료 추천해주세요", "description": "상품 추천 (한글)"},
    
    # 일반 의도 쿼리
    {"query": "Hello, how are you?", "description": "일반 대화 (영어)"},
    {"query": "안녕하세요", "description": "일반 대화 (한글)"}
]

def measure_response_time(query_data):
    """
    API 응답 시간을 측정하는 함수
    
    Args:
        query_data (dict): 측정할 쿼리 데이터
    
    Returns:
        tuple: (성공 여부, 응답 시간, 응답 데이터/오류 메시지)
    """
    headers = {"Content-Type": "application/json"}
    data = {"query": query_data["query"], "session_id": f"perf-test-{int(time.time())}"}
    
    try:
        start_time = time.time()
        response = requests.post(API_URL, headers=headers, json=data)
        end_time = time.time()
        
        response_time = end_time - start_time
        
        if response.status_code == 200:
            return True, response_time, response.json()
        else:
            return False, response_time, f"오류 응답: {response.status_code} - {response.text}"
    
    except Exception as e:
        return False, -1, f"예외 발생: {str(e)}"

def main():
    """
    메인 측정 함수
    """
    print(f"PetGPT 챗봇 API 응답 시간 측정 시작 ({datetime.now().strftime('%Y-%m-%d %H:%M:%S')})")
    print(f"서버 URL: {API_URL}")
    print(f"각 쿼리당 {ITERATIONS}회 반복 측정")
    print("-" * 80)
    
    results = {}
    
    # 각 쿼리에 대해 반복 측정
    for query_data in TEST_QUERIES:
        query_desc = query_data["description"]
        query_text = query_data["query"]
        
        print(f"\n쿼리: {query_desc} - '{query_text}'")
        print("측정 시작...")
        
        times = []
        success_count = 0
        
        for i in range(ITERATIONS):
            print(f"  측정 {i+1}/{ITERATIONS} 진행 중...", end="", flush=True)
            
            success, response_time, response_data = measure_response_time(query_data)
            
            if success:
                times.append(response_time)
                success_count += 1
                result_type = response_data.get("response_type", "unknown")
                print(f" 성공 ({response_time:.2f}초, 타입: {result_type})")
            else:
                print(f" 실패 - {response_data}")
            
            # 호출 간 대기
            if i < ITERATIONS - 1:
                time.sleep(WAIT_BETWEEN_CALLS)
        
        # 결과 계산 및 저장
        if success_count > 0:
            avg_time = statistics.mean(times)
            min_time = min(times)
            max_time = max(times)
            
            if success_count >= 2:
                std_dev = statistics.stdev(times)
            else:
                std_dev = 0
            
            results[query_desc] = {
                "avg_time": avg_time,
                "min_time": min_time,
                "max_time": max_time,
                "std_dev": std_dev,
                "success_rate": success_count / ITERATIONS
            }
            
            print(f"  결과: 평균 {avg_time:.2f}초 (최소: {min_time:.2f}초, 최대: {max_time:.2f}초)")
            print(f"  성공률: {success_count}/{ITERATIONS} ({(success_count / ITERATIONS) * 100:.0f}%)")
        else:
            print("  모든 요청이 실패했습니다.")
    
    # 최종 결과 요약
    print("\n" + "=" * 80)
    print("성능 측정 결과 요약:")
    print("=" * 80)
    
    for query_desc, result in results.items():
        print(f"{query_desc}:")
        print(f"  평균 응답 시간: {result['avg_time']:.2f}초")
        print(f"  최소/최대: {result['min_time']:.2f}초 / {result['max_time']:.2f}초")
        print(f"  표준 편차: {result['std_dev']:.2f}초")
        print(f"  성공률: {result['success_rate'] * 100:.0f}%")
        
        # 성능 목표 달성 여부 (5초 이내)
        if result['avg_time'] <= 5.0:
            print("  ✅ 성능 목표 달성 (5초 이내)")
        else:
            print("  ❌ 성능 목표 미달 (5초 초과)")
        
        print()

if __name__ == "__main__":
    main() 