"""
FastAPI 엔드포인트 디버깅 스크립트
"""

import requests
import logging
import json
import sys

# 로깅 설정
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
logger = logging.getLogger(__name__)

# 테스트할 엔드포인트 URL
API_URL = "http://127.0.0.1:8000/api/chat"


def debug_simple_query():
    """
    단순 쿼리 테스트 및 디버깅
    """
    logger.info("단순 쿼리 테스트 시작")

    # 간단한 쿼리로 API 요청
    query = "강아지 사료 추천해주세요"
    payload = {"query": query, "session_id": "debug-session"}

    logger.info(f"요청: {json.dumps(payload, ensure_ascii=False)}")

    try:
        response = requests.post(API_URL, json=payload, timeout=30)

        logger.info(f"응답 상태: {response.status_code}")

        if response.status_code == 200:
            result = response.json()
            logger.info(f"응답 타입: {result.get('response_type')}")
            logger.info(f"응답 텍스트: {result.get('response_text')[:100]}...")

            if "medical_warning" in result:
                logger.info(f"의료 경고: {result.get('medical_warning')}")

            # 전체 응답 덤프
            logger.info(
                f"전체 응답: {json.dumps(result, ensure_ascii=False, indent=2)}"
            )
        else:
            logger.error(f"오류 응답: {response.text}")

    except Exception as e:
        logger.exception(f"예외 발생: {str(e)}")

    logger.info("테스트 완료")


def check_ping():
    """
    서버 상태 확인
    """
    try:
        response = requests.get("http://127.0.0.1:8000/ping")
        logger.info(f"Ping 응답: {response.status_code} - {response.text}")
    except Exception as e:
        logger.exception(f"Ping 요청 중 오류: {str(e)}")


if __name__ == "__main__":
    # 서버 상태 확인
    check_ping()

    # 단순 쿼리 테스트
    debug_simple_query()
