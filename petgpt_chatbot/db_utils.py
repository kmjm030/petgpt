"""
PetGPT 챗봇 데이터베이스 유틸리티 모듈
"""
import os
import sqlite3
from datetime import datetime
from pathlib import Path
from sqlite3 import Connection
from typing import Optional, Any, Dict, List, Tuple

from petgpt_chatbot.config import get_settings

# MySQL 지원을 위한 import 추가
try:
    import mysql.connector
    from mysql.connector import MySQLConnection
    MYSQL_AVAILABLE = True
except ImportError:
    MYSQL_AVAILABLE = False


def get_sqlite_connection(db_path: Optional[str] = None) -> Connection:
    """
    SQLite 데이터베이스 연결 객체를 생성하여 반환
    
    Args:
        db_path (Optional[str], optional): 데이터베이스 파일 경로. 기본값은 None으로, 설정에서 가져옴.
    
    Returns:
        Connection: SQLite 연결 객체
    """
    if db_path is None:
        settings = get_settings()
        db_path = settings.SQLITE_LOG_DB_PATH
    
    # 데이터베이스 파일이 저장될 디렉토리가 존재하는지 확인하고 없으면 생성
    if db_path != ":memory:":
        db_dir = os.path.dirname(db_path)
        if db_dir and not os.path.exists(db_dir):
            os.makedirs(db_dir)
    
    # SQLite 데이터베이스 연결
    conn = sqlite3.connect(db_path)
    
    return conn


def get_mysql_connection():
    """
    MySQL 데이터베이스 연결 객체를 생성하여 반환
    
    Returns:
        MySQLConnection: MySQL 연결 객체
    
    Raises:
        ImportError: mysql.connector 패키지가 설치되어 있지 않을 경우
        Exception: MySQL 연결에 실패한 경우
    """
    if not MYSQL_AVAILABLE:
        raise ImportError("mysql.connector 패키지가 설치되어 있지 않습니다. 'pip install mysql-connector-python'을 실행하세요.")
    
    settings = get_settings()
    
    try:
        conn = mysql.connector.connect(
            host=settings.MYSQL_HOST,
            user=settings.MYSQL_USER,
            password=settings.MYSQL_PASSWORD,
            database=settings.MYSQL_DB_NAME,
            port=settings.MYSQL_PORT
        )
        return conn
    except Exception as e:
        raise Exception(f"MySQL 연결에 실패했습니다: {str(e)}")


def execute_mysql_query(query: str, params: Tuple = None, fetch: bool = True) -> List[Dict[str, Any]]:
    """
    MySQL 쿼리를 실행하고 결과를 반환하는 함수
    
    Args:
        query (str): 실행할 SQL 쿼리
        params (Tuple, optional): 쿼리 파라미터. 기본값은 None.
        fetch (bool, optional): 결과를 가져올지 여부. 기본값은 True.
    
    Returns:
        List[Dict[str, Any]]: 쿼리 결과를 딕셔너리 리스트로 반환
    """
    conn = get_mysql_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        
        if fetch:
            result = cursor.fetchall()
            return result
        else:
            conn.commit()
            return [{"affected_rows": cursor.rowcount}]
    finally:
        cursor.close()
        conn.close()


def create_log_table_if_not_exists(conn: Connection) -> None:
    """
    대화 로그를 저장할 테이블이 존재하지 않으면 생성
    
    Args:
        conn (Connection): SQLite 연결 객체
    """
    cursor = conn.cursor()
    
    # conversations 테이블 생성 (존재하지 않을 경우)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS conversations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id TEXT NOT NULL,
            user_query TEXT NOT NULL,
            bot_response TEXT NOT NULL,
            intent TEXT NOT NULL,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    conn.commit()


def log_conversation(
    conn: Connection,
    session_id: str,
    user_query: str,
    bot_response: str,
    intent: str
) -> None:
    """
    사용자와 챗봇의 대화 내용을 로그 테이블에 기록
    
    Args:
        conn (Connection): SQLite 연결 객체
        session_id (str): 세션 ID
        user_query (str): 사용자 질문
        bot_response (str): 챗봇 응답
        intent (str): 의도 분류 결과
    """
    cursor = conn.cursor()
    
    # 현재 시간
    timestamp = datetime.now().isoformat()
    
    # 데이터 삽입
    cursor.execute(
        """
        INSERT INTO conversations 
        (session_id, user_query, bot_response, intent, timestamp) 
        VALUES (?, ?, ?, ?, ?)
        """,
        (session_id, user_query, bot_response, intent, timestamp)
    )
    
    conn.commit()


def get_connection_and_ensure_table():
    """
    SQLite 연결을 생성하고 로그 테이블이 존재하는지 확인하는 유틸리티 함수
    
    Returns:
        Connection: 준비된 SQLite 연결 객체
    """
    conn = get_sqlite_connection()
    create_log_table_if_not_exists(conn)
    return conn 