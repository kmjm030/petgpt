"""
PetGPT 챗봇 데이터베이스 유틸리티 테스트
"""
import sqlite3
from sqlite3 import Connection
from unittest.mock import patch, MagicMock

import pytest

from petgpt_chatbot.db_utils import (
    get_sqlite_connection,
    create_log_table_if_not_exists,
    log_conversation
)


def test_get_sqlite_connection():
    """
    get_sqlite_connection 함수가 유효한 sqlite3.Connection 객체를 반환하는지 테스트
    """
    # 인메모리 SQLite DB 사용
    conn = get_sqlite_connection(":memory:")
    
    # 반환된 객체가 Connection 타입인지 확인
    assert isinstance(conn, Connection)
    
    # 연결이 정상적으로 동작하는지 확인
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT)")
    cursor.execute("INSERT INTO test (name) VALUES (?)", ("test_name",))
    cursor.execute("SELECT name FROM test WHERE id = 1")
    result = cursor.fetchone()
    
    assert result[0] == "test_name"
    
    # 테스트 후 연결 종료
    conn.close()


def test_create_log_table():
    """
    create_log_table_if_not_exists 함수 실행 후 로그 테이블(conversations)이 생성되는지 검증
    """
    # 인메모리 SQLite DB 사용
    conn = get_sqlite_connection(":memory:")
    
    # 테이블 생성
    create_log_table_if_not_exists(conn)
    
    # 테이블이 존재하는지 확인
    cursor = conn.cursor()
    cursor.execute("""
        SELECT name 
        FROM sqlite_master 
        WHERE type='table' AND name='conversations'
    """)
    table_exists = cursor.fetchone() is not None
    
    assert table_exists is True
    
    # 테이블 스키마 검증
    cursor.execute("PRAGMA table_info(conversations)")
    columns = cursor.fetchall()
    column_names = [col[1] for col in columns]
    
    assert "id" in column_names
    assert "session_id" in column_names
    assert "user_query" in column_names
    assert "bot_response" in column_names
    assert "intent" in column_names
    assert "timestamp" in column_names
    
    # 테스트 후 연결 종료
    conn.close()


def test_log_conversation():
    """
    log_conversation 함수 실행 후 대화 내용이 DB에 정상적으로 기록되고 조회되는지 검증
    """
    # 인메모리 SQLite DB 사용
    conn = get_sqlite_connection(":memory:")
    create_log_table_if_not_exists(conn)
    
    # 테스트 데이터
    session_id = "test_session_123"
    user_query = "강아지 사료 추천해줘"
    bot_response = "좋은 강아지 사료를 몇 가지 추천해드릴게요..."
    intent = "product_recommendation"
    
    # 대화 로깅
    log_conversation(
        conn=conn,
        session_id=session_id,
        user_query=user_query,
        bot_response=bot_response,
        intent=intent
    )
    
    # 기록된 내용 조회
    cursor = conn.cursor()
    cursor.execute("""
        SELECT session_id, user_query, bot_response, intent
        FROM conversations
        ORDER BY id DESC LIMIT 1
    """)
    result = cursor.fetchone()
    
    # 결과 검증
    assert result[0] == session_id
    assert result[1] == user_query
    assert result[2] == bot_response
    assert result[3] == intent
    
    # 테스트 후 연결 종료
    conn.close()


@patch("petgpt_chatbot.config.Settings")
@patch("petgpt_chatbot.db_utils.get_settings")
def test_get_sqlite_connection_uses_settings(mock_get_settings, mock_settings):
    """
    get_sqlite_connection 함수가 Settings에서 기본 DB 경로를 가져오는지 테스트
    """
    # Arrange
    mock_settings.SQLITE_LOG_DB_PATH = "./data/test_logs.db"
    mock_get_settings.return_value = mock_settings
    
    with patch("sqlite3.connect") as mock_connect:
        mock_connect.return_value = MagicMock(spec=Connection)
        
        # Act
        conn = get_sqlite_connection()  # 경로 파라미터 없이 호출
        
        # Assert
        mock_get_settings.assert_called_once()
        mock_connect.assert_called_once_with("./data/test_logs.db")
        assert conn == mock_connect.return_value 