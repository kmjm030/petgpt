# PetGPT - 반려동물 지식 Q&A 및 상품 추천 챗봇

<p align="center">
  <img src="assets/petgpt_logo.png" alt="PetGPT Logo" width="200"/>
</p>

PetGPT는 Langchain, FastAPI, Google Gemini를 활용한 반려동물 특화 챗봇 서비스입니다. 반려동물 관련 지식 Q&A와 맞춤형 상품 추천 기능을 제공합니다.

## 주요 기능

- **반려동물 지식 Q&A**: 반려동물 케어, 건강, 행동 등에 관한 질문에 답변
- **맞춤형 상품 추천**: 사용자의 요청에 기반한 반려동물 용품 추천
- **의료 조언 회피**: 전문적인 수의학 영역에서는 전문가 상담을 권유

## 기술 스택

- **백엔드**: FastAPI, Python 3.13
- **AI 모델**: Google Gemini Pro (LLM), Gemini Embedding
- **RAG 구현**: Langchain, ChromaDB
- **인프라**: Docker, Git
- **테스트**: Pytest, Coverage
- **API 문서화**: Swagger UI (FastAPI 내장)

## 시작하기

### 필수 조건

- Python 3.10 이상
- Google API 키 (Gemini Pro/Embedding 사용)

### 설치 방법

1. 저장소 복제

   ```bash
   git clone https://github.com/yourusername/petgpt.git
   cd petgpt
   ```

2. 가상환경 생성 및 활성화

   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Windows: .venv\Scripts\activate
   ```

3. 의존성 설치

   ```bash
   pip install -r requirements.txt
   ```

4. 환경 변수 설정
   `.env` 파일을 프로젝트 루트에 생성하고 다음 내용을 추가:
   ```
   GOOGLE_API_KEY=your_google_api_key
   SQLITE_LOG_DB_PATH=./data/chat_logs.db
   MAX_TOKENS_PER_RESPONSE=1000
   GEMINI_MODEL_NAME=gemini-pro
   EMBEDDING_MODEL_NAME=gemini-embed
   ```

### 실행 방법

1. FastAPI 서버 실행

   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

2. 브라우저에서 Swagger UI 접속
   ```
   http://localhost:8000/docs
   ```

## API 엔드포인트

- **GET /ping**: 서버 상태 확인
- **POST /api/chat**: 챗봇 대화 API (메인 엔드포인트)
- **POST /api/chatbot/ask**: Spring 호환 챗봇 API

## 프로젝트 구조

```
petgpt/
├── assets/                # 로고 등의 이미지 자산
├── petgpt_chatbot/        # 메인 패키지
│   ├── __init__.py
│   ├── api.py             # API 엔드포인트 구현
│   ├── config.py          # 설정 관리
│   ├── db_utils.py        # 데이터베이스 유틸리티
│   ├── llm_init.py        # LLM/임베딩 모델 초기화
│   ├── models.py          # Pydantic 모델
│   ├── prompts.py         # 프롬프트 템플릿
│   ├── rag.py             # RAG Q&A 구현
│   └── recommend.py       # 상품 추천 구현
├── tests/                 # 테스트 코드
├── .env                   # 환경 변수
├── .gitignore
├── main.py                # FastAPI 앱 메인 파일
├── README.md
└── requirements.txt       # 의존성 목록
```

## TDD 개발 과정

이 프로젝트는 TDD(Test-Driven Development) 방법론을 사용하여 개발되었습니다:

1. **Phase 0**: 프로젝트 및 테스트 환경 설정
2. **Phase 1**: 핵심 설정 및 기본 유틸리티 구현
3. **Phase 2**: RAG Q&A 파이프라인 프로토타입
4. **Phase 3**: 상품 추천 파이프라인 프로토타입
5. **Phase 4**: API 엔드포인트 통합 및 UI 연동 준비
6. **Phase 5**: 실제 UI 연동 및 전체 시스템 테스트

자세한 개발 단계와 TDD 과정은 [TODO.md](TODO.md) 파일을 참고하세요.

## 성능 지표

- **API 응답 시간**: 평균 2.0~2.2초 (목표: 5초 이내)
- **성공률**: 100%
- **테스트 커버리지**: 74%

## Spring 백엔드 통합

Spring 백엔드와의 통합에 관한 상세 정보는 [api_integration_guide.md](api_integration_guide.md) 파일을 참고하세요.

## 테스트

테스트 실행:

```bash
pytest
```

커버리지 보고서 생성:

```bash
pytest --cov=petgpt_chatbot --cov-report=term-missing
```

E2E 테스트 시나리오에 대한 자세한 정보는 [e2e_test_scenarios.md](e2e_test_scenarios.md)를 참고하세요.

## 라이선스

이 프로젝트는 MIT 라이선스 하에 제공됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

## 연락처

- 개발자: [개발자 이름]
- 이메일: [이메일 주소]
- 프로젝트 저장소: [GitHub 저장소 URL]
