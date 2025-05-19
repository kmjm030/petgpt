"""
Spring 호환 API 엔드포인트 테스트 스크립트
"""
import requests
import json
import time

# Spring 형식 API 엔드포인트 URL
API_URL = "http://localhost:8000/api/chatbot/ask"

def test_spring_api():
    """Spring 형식 API 엔드포인트 테스트"""
    print(f"Spring 형식 API 엔드포인트 테스트: {API_URL}")
    
    # 테스트할 메시지 목록
    test_messages = [
        "안녕하세요",
        "강아지 사료 추천해주세요",
        "고양이 건강에 좋은 음식은 무엇인가요?"
    ]
    
    for message in test_messages:
        print(f"\n테스트 메시지: '{message}'")
        
        # API 요청
        headers = {"Content-Type": "application/json"}
        data = {"message": message}
        
        try:
            start_time = time.time()
            response = requests.post(API_URL, headers=headers, json=data)
            end_time = time.time()
            
            response_time = end_time - start_time
            
            # 응답 처리
            if response.status_code == 200:
                print(f"성공! (응답 시간: {response_time:.2f}초)")
                
                response_data = response.json()
                print(f"응답: '{response_data['reply']}'")
            else:
                print(f"오류 응답: {response.status_code}")
                print(response.text)
        
        except Exception as e:
            print(f"예외 발생: {str(e)}")
        
        # 잠시 대기
        time.sleep(1)

if __name__ == "__main__":
    test_spring_api() 