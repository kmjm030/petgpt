"""
PetGPT 챗봇 메인 애플리케이션 테스트
"""
from fastapi.testclient import TestClient
from main import app  # main.py에 있는 FastAPI app 인스턴스 임포트

client = TestClient(app)

def test_ping_returns_pong():
    """
    /ping 엔드포인트가 {"message": "pong"} 응답을 반환하는지 테스트
    """
    response = client.get("/ping")
    assert response.status_code == 200
    assert response.json() == {"message": "pong"} 