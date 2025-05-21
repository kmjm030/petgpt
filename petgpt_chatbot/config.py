"""
PetGPT 챗봇 설정 모듈
"""

from typing import Optional
from pydantic import ConfigDict
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """
    애플리케이션 설정을 위한 Pydantic 모델
    """

    # Google Gemini API 관련 설정
    GOOGLE_API_KEY: str

    # MySQL 데이터베이스 설정
    MYSQL_HOST: str
    MYSQL_USER: str
    MYSQL_PASSWORD: str
    MYSQL_DB_NAME: str
    MYSQL_PORT: int = 3306

    # 데이터 저장 경로
    CHROMA_DB_PATH: str = "./data/chromadb"
    SQLITE_LOG_DB_PATH: str = "./data/logs.db"
    KNOWLEDGE_COLLECTION_NAME: str = "petgpt_knowledge"

    # 임베딩 모델 설정
    EMBEDDING_MODEL_TYPE: str = "gemini"  # "gemini" 또는 "sbert"
    SBERT_MODEL_NAME: Optional[str] = "jhgan/ko-sroberta-multitask"

    # LLM 및 Embedding 모델 이름 (환경 변수에서 직접 로드)
    GEMINI_MODEL_NAME: Optional[str] = None  # .env 우선
    EMBEDDING_MODEL_NAME: Optional[str] = None  # .env 우선

    # LLM 토큰 제한 (비용 모니터링용)
    MAX_TOKENS_PER_QUERY: Optional[int] = 1024
    MAX_TOKENS_PER_RESPONSE: Optional[int] = 512

    # Mock LLM 사용 여부 (환경 변수에서 직접 로드)
    USE_MOCK_LLM: bool = False  # .env 우선

    # 내부 클래스 대신 ConfigDict 사용
    model_config = ConfigDict(
        env_file=".env", env_file_encoding="utf-8", case_sensitive=True, extra="ignore"
    )


def get_settings() -> Settings:
    """
    애플리케이션 설정 인스턴스를 반환

    Returns:
        Settings: 설정 인스턴스
    """
    return Settings()
