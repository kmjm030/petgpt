"""
PetGPT 챗봇 설정 모듈 테스트
"""
import os
import pytest
from pydantic import ValidationError

# 추후 구현할 config.py에서 Settings 클래스와 get_settings 함수를 임포트
from petgpt_chatbot.config import Settings, get_settings

def test_load_settings_from_env_file():
    """
    테스트용 환경 변수가 Settings 모델에 올바르게 로드되는지 검증
    """
    # 테스트를 위한 환경 변수 설정
    os.environ["GOOGLE_API_KEY"] = "test_api_key"
    os.environ["MYSQL_HOST"] = "localhost"
    os.environ["MYSQL_USER"] = "test_user"
    os.environ["MYSQL_PASSWORD"] = "test_password"
    os.environ["MYSQL_DB_NAME"] = "test_db"
    
    # Settings 인스턴스 생성
    settings = Settings()
    
    # 환경 변수가 올바르게 로드되었는지 검증
    assert settings.GOOGLE_API_KEY == "test_api_key"
    assert settings.MYSQL_HOST == "localhost"
    assert settings.MYSQL_USER == "test_user"
    assert settings.MYSQL_PASSWORD == "test_password"
    assert settings.MYSQL_DB_NAME == "test_db"
    assert settings.MYSQL_PORT == 3306  # 기본값
    assert settings.CHROMA_DB_PATH == "./data/chromadb"  # 기본값
    assert settings.SQLITE_LOG_DB_PATH == "./data/logs.db"  # 기본값

def test_missing_required_env_var_raises_error():
    """
    필수 환경 변수 누락 시 ValidationError가 발생하는지 검증
    """
    # 테스트를 위해 필수 환경 변수 제거
    if "GOOGLE_API_KEY" in os.environ:
        del os.environ["GOOGLE_API_KEY"]
    
    # ValidationError가 발생하는지 검증
    with pytest.raises(ValidationError):
        Settings()

def test_get_settings_returns_settings_instance():
    """
    get_settings 함수가 Settings 인스턴스를 반환하는지 검증
    """
    # 테스트를 위한 환경 변수 설정
    os.environ["GOOGLE_API_KEY"] = "test_api_key"
    os.environ["MYSQL_HOST"] = "localhost"
    os.environ["MYSQL_USER"] = "test_user"
    os.environ["MYSQL_PASSWORD"] = "test_password"
    os.environ["MYSQL_DB_NAME"] = "test_db"
    
    settings = get_settings()
    
    assert isinstance(settings, Settings)
    assert settings.GOOGLE_API_KEY == "test_api_key" 