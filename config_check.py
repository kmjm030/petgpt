"""
환경 설정 및 환경 변수 확인 스크립트
"""

import sys
import os
from dotenv import load_dotenv
from pathlib import Path


def check_env():
    """
    .env 파일과 환경변수 확인
    """
    print("=" * 80)
    print("환경 설정 확인")
    print("=" * 80)

    # 현재 디렉토리와 .env 파일 경로
    current_dir = Path.cwd()
    env_file = current_dir / ".env"

    print(f"현재 디렉토리: {current_dir}")
    print(f".env 파일 존재 여부: {env_file.exists()}")

    # .env 파일 로드
    load_dotenv()

    # 필수 환경 변수 목록
    required_vars = [
        "GOOGLE_API_KEY",
        "MYSQL_HOST",
        "MYSQL_USER",
        "MYSQL_PASSWORD",
        "MYSQL_DB_NAME",
    ]

    # 선택적 환경 변수 목록
    optional_vars = [
        "CHROMA_DB_PATH",
        "SQLITE_LOG_DB_PATH",
        "KNOWLEDGE_COLLECTION_NAME",
        "EMBEDDING_MODEL_TYPE",
        "SBERT_MODEL_NAME",
        "GEMINI_MODEL_NAME",
        "EMBEDDING_MODEL_NAME",
        "MAX_TOKENS_PER_QUERY",
        "MAX_TOKENS_PER_RESPONSE",
        "USE_MOCK_LLM",
    ]

    # 필수 환경 변수 확인
    print("\n필수 환경 변수 확인:")
    missing_required = []
    for var in required_vars:
        value = os.getenv(var)
        if value:
            masked_value = (
                value[:3] + "*" * (len(value) - 6) + value[-3:]
                if len(value) > 6
                else "***"
            )
            print(f"  ✅ {var}: {masked_value}")
        else:
            missing_required.append(var)
            print(f"  ❌ {var}: 설정되지 않음")

    # 선택적 환경 변수 확인
    print("\n선택적 환경 변수 확인:")
    for var in optional_vars:
        value = os.getenv(var)
        if value:
            print(f"  ✅ {var}: {value}")
        else:
            print(f"  ⚠️ {var}: 설정되지 않음 (기본값 사용)")

    # 종합 결과
    print("\n종합 결과:")
    if missing_required:
        print(f"  ❌ 필수 환경 변수 {len(missing_required)}개가 설정되지 않았습니다.")
        print(f"     Missing: {', '.join(missing_required)}")
        return False
    else:
        print(f"  ✅ 모든 필수 환경 변수가 설정되어 있습니다.")
        return True


def check_database():
    """
    데이터베이스 연결 확인
    """
    print("\n" + "=" * 80)
    print("데이터베이스 연결 확인")
    print("=" * 80)

    try:
        from petgpt_chatbot.db_utils import get_mysql_connection

        conn = get_mysql_connection()
        cursor = conn.cursor()

        # 간단한 쿼리 실행
        cursor.execute("SELECT VERSION()")
        version = cursor.fetchone()

        print(f"MySQL 연결 성공: 버전 {version[0]}")

        # 사용 가능한 테이블 확인
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()

        if tables:
            print("\n사용 가능한 테이블:")
            for table in tables:
                print(f"  - {table[0]}")
        else:
            print("\n사용 가능한 테이블이 없습니다.")

        cursor.close()
        conn.close()
        return True

    except Exception as e:
        print(f"❌ 데이터베이스 연결 오류: {str(e)}")
        return False


def check_vectorstore():
    """
    벡터 스토어 확인
    """
    print("\n" + "=" * 80)
    print("벡터 스토어 확인")
    print("=" * 80)

    try:
        from petgpt_chatbot.rag import get_or_create_vectorstore

        vectorstore = get_or_create_vectorstore()

        # 벡터 스토어 정보
        collection_info = vectorstore._collection.count()

        print(f"ChromaDB 연결 성공")
        print(f"문서 수: {collection_info}")

        if collection_info == 0:
            print("⚠️ 벡터 스토어에 문서가 없습니다. 데이터를 추가해야 합니다.")
            return False

        return True

    except Exception as e:
        print(f"❌ 벡터 스토어 연결 오류: {str(e)}")
        return False


if __name__ == "__main__":
    # 환경 변수 확인
    env_ok = check_env()

    if env_ok:
        # 데이터베이스 확인
        db_ok = check_database()

        # 벡터 스토어 확인
        vs_ok = check_vectorstore()

        # 종합 결과
        print("\n" + "=" * 80)
        print("종합 진단 결과")
        print("=" * 80)
        print(f"환경 변수: {'✅ 정상' if env_ok else '❌ 오류'}")
        print(f"데이터베이스: {'✅ 정상' if db_ok else '❌ 오류'}")
        print(f"벡터 스토어: {'✅ 정상' if vs_ok else '❌ 오류 또는 데이터 없음'}")

        if env_ok and db_ok and vs_ok:
            print("\n✅ 모든 구성요소가 정상입니다.")
        else:
            print("\n❌ 일부 구성요소에 문제가 있습니다. 위 내용을 확인하세요.")
    else:
        print("\n❌ 환경 변수 설정을 완료한 후 다시 실행하세요.")
