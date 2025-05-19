이 문서는 PetGPT 챗봇 프로젝트의 최종 통합 명세서를 기반으로, 각 개발 단계(Phase)별 목표, 주요 작업 내용 및 테스트 대상 파일을 명시한 TDD(Test-Driven Development) 마스터 플랜입니다. 모든 기능 구현에 앞서 테스트 코드를 먼저 작성하거나, 최소한 기능 명세와 함께 테스트 케이스를 정의하는 것을 목표로 합니다.

---

### 사전 준비 (Phase 0): 프로젝트 및 테스트 환경 설정

-   **목표:** TDD를 수행할 수 있는 기본적인 프로젝트 구조와 테스트 환경을 구축합니다.
-   **주요 작업 내용:**
    1.  **프로젝트 초기화 및 가상환경 설정:**
        -   작업: Python 가상환경 생성 및 활성화, Git 저장소 초기화.
        -   테스트: (N/A - 환경 설정)
    2.  **기본 의존성 설치:** FastAPI, Uvicorn, Pydantic, `python-dotenv` 등 기본 라이브러리 설치.
        -   작업: `requirements.txt` 초기화 및 패키지 추가.
        -   테스트: (N/A - 환경 설정)
    3.  **테스트 프레임워크 설치:** `pytest`, `pytest-cov` (커버리지 측정용), `httpx` (FastAPI `TestClient` 의존성) 설치.
        -   작업: `requirements.txt`에 테스트 관련 패키지 추가.
        -   테스트: (N/A - 환경 설정)
    4.  **기본 폴더 구조 생성:** `petgpt_chatbot/`, `tests/` 디렉토리 생성.
        -   작업: 프로젝트 폴더 구조 생성.
        -   테스트: (N/A - 환경 설정)
    5.  **간단한 "Hello World" API 및 테스트 작성:**
        -   작업: `main.py`에 `/` 또는 `/ping` 엔드포인트 생성. `tests/test_main.py`에 해당 엔드포인트에 대한 기본 성공 테스트 작성.
        -   테스트: `pytest` 실행 시 해당 테스트 통과 확인.
-   **작업할 파일 (구현 & 테스트):**
    -   `main.py`
    -   `tests/test_main.py`
    -   `requirements.txt`
    -   `.gitignore`

---

### Phase 1: 핵심 설정 및 기본 유틸리티 구현 (Commit Tag: `v0.1-basic-setup`)

-   **목표:** 환경 변수 로드, LLM/Embedding 모델 초기화, DB 유틸리티(SQLite 우선) 등 핵심 설정 및 기본 유틸리티 모듈을 테스트 주도 하에 개발합니다.
-   **주요 작업 내용:**
    1.  **환경 변수 로드 (`config.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_config.py`): `.env` 파일 (테스트용)을 사용하여 `Settings` 모델이 정상적으로 환경 변수를 로드하는지 검증. 필수 값이 누락된 경우 오류 발생하는지 검증.
        -   작업: `config.py`에 `Settings` Pydantic 모델 및 `get_settings` 함수 구현. 테스트용 `.env.example` 또는 `.env.test` 파일 준비.
    2.  **LLM 및 Embedding 모델 초기화 (`llm_init.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_llm_init.py`): `get_llm()` 및 `get_embedding_model()` 함수가 설정에 따라 올바른 타입의 클라이언트 인스턴스(Gemini 또는 SBERT)를 반환하는지 검증 (실제 API 호출은 Mocking). API 키가 없을 때 예외 처리 검증.
        -   작업: `llm_init.py`에 LLM 및 Embedding 모델 초기화 함수 구현.
    3.  **SQLite DB 유틸리티 (`db_utils.py`) 테스트 및 구현 (로그용):**
        -   테스트 (`tests/test_db_utils.py`):
            -   SQLite 연결/해제 기능 검증 (인메모리 DB 사용 가능).
            -   `create_log_table_if_not_exists()` 함수 실행 시 로그 테이블 생성 여부 검증.
            -   `log_conversation()` 함수 실행 시 대화 내용이 정상적으로 DB에 기록되고 조회되는지 검증.
        -   작업: `db_utils.py`에 SQLite 연결, 테이블 생성, 로그 기록 함수 구현.
    4.  **Pydantic 모델 (`models.py`) 기본 정의 및 테스트:**
        -   테스트 (`tests/test_models.py`): `ChatRequest` 등 간단한 모델의 유효성 검사(필수 필드, 타입) 테스트.
        -   작업: `models.py`에 초기 Pydantic 모델 정의.
-   **작업할 파일 (구현 & 테스트):**
    -   `petgpt_chatbot/config.py`, `tests/test_config.py`
    -   `petgpt_chatbot/llm_init.py`, `tests/test_llm_init.py`
    -   `petgpt_chatbot/db_utils.py`, `tests/test_db_utils.py`
    -   `petgpt_chatbot/models.py`, `tests/test_models.py`
    -   `.env` (실제 키), `.env.example`

---

### Phase 2: RAG Q&A 파이프라인 프로토타입 (Commit Tag: `v0.2-rag-poc`)

-   **목표:** 반려동물 지식 Q&A를 위한 RAG 파이프라인의 핵심 로직을 테스트 주도 하에 개발합니다. (LLM, Embedding, DB 호출은 Mocking 또는 테스트용 경량 데이터 사용)
-   **주요 작업 내용:**
    1.  **지식 데이터 로드 및 전처리 (`rag.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_rag.py`):
            -   (Mocking) MySQL DB에서 테스트용 데이터(간단한 텍스트 목록)를 로드하는 함수 검증.
            -   HTML 태그가 포함된 텍스트 입력 시 `BeautifulSoup`을 통해 태그가 제거되는지 검증.
            -   `RecursiveCharacterTextSplitter`를 사용한 텍스트 분할 기능 검증 (청크 수, 내용 등).
        -   작업: `rag.py`에 데이터 로드, HTML 제거, 텍스트 분할 함수 구현. `db_utils.py`에 MySQL 연결 함수 기초 구현 (테스트 시에는 Mocking).
    2.  **임베딩 및 Vector Store 저장/검색 (`rag.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_rag.py`):
            -   (Mocking) 분할된 텍스트 청크들이 임베딩 모델(Mock)을 거쳐 Vector Store(테스트용 인메모리 ChromaDB)에 메타데이터와 함께 저장되는지 검증.
            -   주어진 쿼리 임베딩(Mock)으로 Vector Store에서 유사도 높은 문서가 정상적으로 검색되는지 검증.
        -   작업: `rag.py`에 임베딩 생성 및 ChromaDB 저장/검색 관련 함수 구현. `llm_init.py`의 임베딩 모델 활용.
    3.  **프롬프트 템플릿 (`prompts.py`) 정의 및 RAG 프롬프트 구성 테스트:**
        -   테스트 (`tests/test_rag.py`): `QNA_RAG_PROMPT` 템플릿에 검색된 컨텍스트와 사용자 질문이 올바르게 삽입되어 최종 프롬프트가 생성되는지 검증.
        -   작업: `prompts.py`에 `QNA_RAG_PROMPT` 정의. `rag.py`에 프롬프트 구성 로직 추가.
    4.  **RAG 답변 생성 로직 (`rag.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_rag.py`): (Mocking) 구성된 프롬프트로 LLM(Mock)을 호출하고, 반환된 (Mock) 답변 및 출처 정보가 예상대로 포맷팅되는지 검증. 의료 조언 회피 로직(간단한 키워드 기반 또는 LLM 프롬프트 지침 확인) 테스트.
        -   작업: `rag.py`에 `get_qna_answer()` 함수와 LCEL 기반 `RunnableSequence` (RAG 체인) 구현.
-   **작업할 파일 (구현 & 테스트):**
    -   `petgpt_chatbot/rag.py`, `tests/test_rag.py`
    -   `petgpt_chatbot/prompts.py` (Q&A 관련 프롬프트 추가)
    -   `petgpt_chatbot/db_utils.py` (MySQL 연결부 추가)
    -   `petgpt_chatbot/llm_init.py` (필요시 수정)

---

### Phase 3: 상품 추천 파이프라인 프로토타입 (Commit Tag: `v0.3-reco-poc`)

-   **목표:** PetGPT 상품 추천 파이프라인의 핵심 로직(규칙 기반 파서, DB 조회, LLM 보조)을 테스트 주도 하에 개발합니다.
-   **주요 작업 내용:**
    1.  **규칙 기반 사용자 요청 파서 (`recommend.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_recommend.py`): 다양한 사용자 질문 입력(예: "강아지 사료 추천", "7살 노견 관절 영양제")에 대해 `parse_product_request_rules()` 함수가 반려동물 종류, 상품 카테고리, 주요 키워드 등을 정확히 추출하는지 정규식 기반으로 검증.
        -   작업: `recommend.py`에 규칙 기반 파서 함수 구현.
    2.  **LLM 보조 상세 정보 추출 (`recommend.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_recommend.py`): (Mocking) 규칙으로 잡기 어려운 정보(예: 특정 증상, 나이대 미묘한 표현)에 대해 `extract_product_details_llm()` 함수가 적절한 프롬프트(`PRODUCT_DETAIL_EXTRACTION_PROMPT_LLM`)를 생성하고 (Mock) LLM 응답을 파싱하는지 검증.
        -   작업: `recommend.py`에 LLM 보조 정보 추출 함수 구현. `prompts.py`에 관련 프롬프트 추가.
    3.  **상품 DB 조회 로직 (`recommend.py`, `db_utils.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_recommend.py`): (Mocking) 파싱된 조건(동물 종류, 카테고리, 키워드 등)으로 `search_products_in_db()` 함수가 올바른 SQL 쿼리(문자열 비교 또는 Mock DB 객체 메소드 호출)를 생성하고, (Mock) DB 결과를 반환하는지 검증. `Item` 테이블의 `features` 필드가 없을 경우 `item_name`이나 `item_content` LIKE 검색 로직 검증.
        -   작업: `recommend.py`에 상품 DB 조회 함수 구현. `db_utils.py`의 MySQL 연동 부분 실제 구현 (또는 테스트용 Mock DB 클래스).
    4.  **LLM 기반 최종 상품 선택 및 추천 메시지 생성 (`recommend.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_recommend.py`):
            -   (Mocking) 조회된 상품 목록과 사용자 원문을 바탕으로 `select_final_products_llm()` 함수가 적절한 프롬프트(`PRODUCT_FINAL_SELECTION_PROMPT_LLM`)를 생성하고 (Mock) LLM 응답을 통해 1~3개 상품을 선택하는지 검증.
            -   (Mocking) 선택된 상품 정보로 `generate_recommendation_message_llm()` 함수가 자연스러운 추천 메시지(`PRODUCT_RECOMMENDATION_MESSAGE_PROMPT_LLM`)를 생성하는지 검증.
        -   작업: `recommend.py`에 LLM 기반 최종 선택 및 메시지 생성 함수, 그리고 `get_product_recommendation()` 전체 파이프라인 함수 구현. `prompts.py`에 관련 프롬프트 추가.
-   **작업할 파일 (구현 & 테스트):**
    -   `petgpt_chatbot/recommend.py`, `tests/test_recommend.py`
    -   `petgpt_chatbot/prompts.py` (상품 추천 관련 프롬프트 추가)
    -   `petgpt_chatbot/db_utils.py` (MySQL 연동부 상세 구현)

---

### Phase 4: API 엔드포인트 통합 및 UI 연동 준비 (Commit Tag: `v0.4-api-ui-integration`)

-   **목표:** 개발된 Q&A 및 상품 추천 파이프라인을 FastAPI 엔드포인트로 통합하고, Pydantic 모델을 이용한 요청/응답 처리를 테스트 주도 하에 개발합니다. (UI 연동 자체는 이 단계의 테스트 범위에 포함되지 않음)
-   **주요 작업 내용:**
    1.  **Pydantic 모델 (`models.py`) 최종 정의 및 테스트:**
        -   테스트 (`tests/test_models.py`): `ChatRequest`, `ChatResponse`, `ProductInfo` 등 API 통신에 사용될 모든 Pydantic 모델의 유효성 검사(필수 필드, 타입, 제약조건 등)를 철저히 테스트.
        -   작업: `models.py`의 Pydantic 모델 최종 확정.
    2.  **의도 분류 로직 (`api.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_api.py`): 다양한 사용자 질문 입력에 대해 의도 분류기(LCEL `RunnableBranch` 또는 간단한 LLM 호출)가 "Q&A", "상품 추천", "일반 대화" 중 올바른 의도로 분류하는지 검증 (하위 체인은 Mocking).
        -   작업: `api.py`에 의도 분류 로직 및 관련 프롬프트(`INTENT_CLASSIFICATION_PROMPT` in `prompts.py`) 구현.
    3.  **`/chat` API 엔드포인트 (`api.py`, `main.py`) 테스트 및 구현:**
        -   테스트 (`tests/test_api.py`): FastAPI의 `TestClient` 사용.
            -   정상적인 `ChatRequest` 전송 시, 의도에 따라 적절한 (Mocked) RAG 또는 추천 파이프라인이 호출되고, 예상되는 `ChatResponse` (상태 코드 200, 올바른 `response_type`, 내용)를 반환하는지 검증.
            -   잘못된 요청(예: 필수 필드 누락) 시 422 Unprocessable Entity 응답 검증.
            -   대화 내용이 (Mocked) SQLite에 정상적으로 로그되는지 검증.
        -   작업: `api.py`에 `/chat` 엔드포인트 및 핵심 분기 로직 구현. `main.py`에 라우터 등록.
    4.  **성능 목표치(응답 5초 이내) 검토:**
        -   테스트: (개별 기능 테스트 시 시간 측정, 통합 후 부하 테스트는 MVP 이후) 주요 로직의 응답 시간 측정.
        -   작업: 병목 지점 발견 시 최적화 고려 (비동기 전환 등).
-   **작업할 파일 (구현 & 테스트):**
    -   `petgpt_chatbot/api.py`, `tests/test_api.py`
    -   `petgpt_chatbot/main.py` (라우터 등록)
    -   `petgpt_chatbot/models.py` (최종 검토)
    -   `petgpt_chatbot/prompts.py` (의도 분류 프롬프트 추가)

---

### 최종 단계: 실제 UI 연동 및 전체 시스템 테스트

-   **목표:** 개발된 챗봇 API를 실제 PetGPT 웹사이트의 프론트엔드 UI와 연동하고, 사용 시나리오 기반의 E2E(End-to-End) 테스트를 수행합니다.
-   **주요 작업 내용:** (이 단계는 전통적인 TDD보다는 BDD 또는 수동 테스트의 비중이 커질 수 있습니다)
    1.  **프론트엔드와 `/chat` API 연동 작업.**
    2.  **주요 사용 시나리오 기반 E2E 테스트:**
        -   Q&A 시나리오 (예: "강아지 설사", "고양이 예방접종")
        -   상품 추천 시나리오 (예: "7살 시츄 사료 추천", "활동적인 고양이 장난감")
        -   의료 조언 회피 및 전문가 상담 권유 메시지 확인.
    3.  **사용성 테스트 및 피드백 반영.**
-   **테스트:** 실제 UI를 통한 기능 검증, 브라우저 개발자 도구를 이용한 API 호출/응답 확인.

---

이 TDD 마스터 플랜은 개발 과정에서 발견되는 문제나 새로운 요구사항에 따라 유연하게 조정될 수 있습니다. 각 단계별로 `pytest --cov=petgpt_chatbot`를 실행하여 코드 커버리지를 지속적으로 확인하고 높여나가는 것을 권장합니다.