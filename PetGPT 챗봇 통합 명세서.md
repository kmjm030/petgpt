이 문서는 "PetGPT 챗봇 프로젝트 개요", "PetGPT 챗봇 기술 명세 및 주요 모듈 설계", "PetGPT 챗봇 비즈니스 로직 및 알고리즘" 문서를 통합하고, 제공해주신 검토 의견을 반영하여 프로젝트의 전체적인 그림을 명확히 제시합니다.

---

### 1. 프로젝트명

-   **펫GPT 챗봇**: Langchain 기반 반려동물 지식 Q&A 및 상품 추천 서비스

---

### 2. 프로젝트 목표

-   Langchain 프레임워크를 활용하여 반려동물 관련 사용자의 질문에 답변하고, PetGPT 쇼핑몰 내 상품을 추천하는 AI 챗봇 개발
-   자연어 이해(NLU) 및 생성(NLG) 능력을 갖춘 에이전트를 통해 사용자에게 유용한 정보를 제공하고, 긍정적인 사용자 경험을 제공
-   포트폴리오를 통해 Langchain 에이전트 개발 및 활용 능력 시연

---

### 3. 주요 기능 (MVP - Minimum Viable Product 중심)

#### 3.1. 반려동물 기본 지식 Q&A (✔︎ MVP 범위 정의)

-   **비즈니스 로직:** 사용자의 반려동물 관련 질문에 대해, 시스템은 내부 데이터(커뮤니티, Q&A)를 검색하여 가장 적절한 답변을 생성하고, 필요시 PetGPT 내 관련 콘텐츠 링크를 제공합니다. 의료적 진단/처방으로 해석될 수 있는 답변은 회피하고 전문가 상담을 권유합니다.
-   **대상 정보:** PetGPT 내 커뮤니티 게시물, Q&A 게시판의 기존 답변.
-   **구현 (Langchain RAG 활용):**
    1.  **입력:** 사용자가 반려동물 종류(개/고양이), 품종, 나이, 간단한 증상(예: "강아지 설사", "고양이 구토")이나 궁금증(예: "강아지 예방접종 시기", "고양이 사료 선택 기준")을 자연어로 질문.
    2.  **질문 분석 및 임베딩:** Langchain 에이전트가 질문의 의도를 파악하고, 사용자 질문을 임베딩 벡터로 변환.
    3.  **Vector Store 검색 (ChromaDB):** 준비된 지식 데이터베이스(Vector Store)에서 사용자 질문 임베딩과 유사도가 높은 문서 조각(chunks) 검색 (Top-K개).
    4.  **프롬프트 구성:** 검색된 문서 조각들을 컨텍스트(context)로 사용, 사용자 질문과 함께 LLM(Gemini)에 전달할 프롬프트 생성. (의료 조언 회피 및 전문가 상담 권유 지침 포함)
    5.  **LLM 답변 생성:** 구성된 프롬프트를 LLM에 전달하여 답변 생성.
    6.  **답변 후처리:** 생성된 답변에서 의료적 진단/처방 성격의 내용 필터링/수정. PetGPT 내부 링크 유효성 검사 및 형식 맞춤. 답변을 간결하고 명확하게 제공.
-   **출력:** 생성된 텍스트 답변, (선택적) PetGPT 내 관련 커뮤니티 게시글/Q&A 링크, (필요시) "자세한 사항은 수의사와 상담하세요."와 같은 안내 문구.
-   **포트폴리오 강조점:** Langchain의 RAG(Retrieval Augmented Generation) 기능 활용, 특정 도메인 지식 학습 및 응용 능력.

#### 3.2. PetGPT 상품 추천 (✔︎ MVP 범위 정의)

-   **비즈니스 로직:** 사용자가 원하는 상품 종류나 반려동물 특성을 언급하면, 시스템은 이를 분석하여 PetGPT 쇼핑몰 상품 DB에서 적합한 상품 1~3개를 추천합니다. 상품명, 주요 특징, 가격, 상세 페이지 링크를 함께 제공합니다.
-   **대상 정보:** PetGPT 쇼핑몰의 상품 데이터 (상품명, 카테고리, 주요 특징, 가격 등 - `Item` 테이블).
-   **구현 (규칙 기반 + LLM 보조 - LCEL 기반):**
    1.  **입력:** 사용자가 원하는 상품의 종류(예: "강아지 사료 추천해줘", "고양이 장난감 찾아줘")나 반려동물의 특성(예: "7살 노견인데 관절에 좋은 영양제 있어?")을 질문.
    2.  **요구사항 분석:**
        *   **1단계 (규칙 기반 파서):** 정규표현식 등을 활용하여 반려동물 종류, 주요 키워드(사료, 장난감, 관절 등) 우선 추출.
        *   **2단계 (LLM 보조):** 규칙으로 명확히 추출되지 않거나, 더 상세한 정보(나이, 특정 증상 등)가 필요할 경우 LLM을 통해 추가 분석. (증상 키워드와 `item_content` 매핑 로직은 `recommend.py` 내부에 구현 또는 `prompts.py`의 구조화된 프롬프트 활용 고려)
    3.  **상품 DB 조회:** 분석 결과를 바탕으로 `Item` 테이블 조회 조건 생성 및 MySQL DB에서 데이터 조회 (예: `is_active=1`, `sales_count DESC`).
    4.  **상품 정보 필터링/선정:** 조회된 상품이 많을 경우, LLM에게 사용자 원문과 함께 제시하여 가장 적합한 1~3개 상품 선택 요청 또는 내부 로직(유사도 등)으로 필터링.
    5.  **추천 메시지 생성:** 선정된 상품 정보(상품명, 간단 특징, 가격, 상세 페이지 링크)를 포함하여 LLM을 통해 자연스러운 추천 메시지 생성 또는 정해진 템플릿에 따라 구성.
-   **출력:** 추천 상품 목록 (각 상품별: 상품명, 간단 특징, 가격, PetGPT 상품 상세 페이지 URL).
-   **포트폴리오 강조점:** Langchain 에이전트와 외부 데이터베이스(상품 DB) 연동, 사용자 의도에 맞는 정보 필터링 및 추천 로직 구현.

#### 3.3. 챗봇 인터페이스 (✔︎ MVP 범위 정의)

-   **구현:**
    -   PetGPT 웹사이트 내 플로팅 버튼 형태로 챗봇 UI 제공.
    -   사용자 질문 입력창 및 챗봇 답변 출력창으로 구성된 간단한 채팅 인터페이스.
-   **포트폴리오 강조점:** 기본적인 웹 UI/UX 구현 능력 (프론트엔드 기술 스택과 연계).

---

### 4. 제외/축소 고려 기능 (포트폴리오용)

-   **고도의 개인화:** 사용자별 과거 대화 이력, 구매 내역, 반려동물 상세 정보(병력 등)를 모두 기억하고 활용하는 복잡한 개인화 기능은 초기 버전에서는 제외하거나 단순화.
-   **실시간 외부 정보 연동:** 날씨, 뉴스 등 실시간으로 변하는 외부 정보를 활용한 답변은 초기 범위에서 제외.
-   **복잡한 멀티턴(Multi-turn) 대화:** 여러 번의 질문과 답변이 이어지며 문맥을 깊이 이해해야 하는 복잡한 대화 시나리오는 기본적인 수준으로 제한.
-   **의료적 진단 및 처방:** 법적 문제 및 정보의 신뢰성 문제로 인해, 의료적 조언이나 진단으로 해석될 수 있는 답변은 명확히 회피하고 전문가 상담을 권유. (**✔︎ 의료정보 면책**)
-   **외부 서비스 연동 (결제, 예약 등):** 챗봇을 통한 직접적인 결제나 병원 예약 등의 기능은 제외.

---

### 5. 기술 아키텍처 및 설계

#### 5.1. 기술 스택 (✔︎ FastAPI + LCEL, ✔︎ DB 구성)

-   **프로그래밍 언어 (백엔드):** Python 3.13
-   **웹 프레임워크 (백엔드):** **FastAPI**
-   **Langchain Core Components (LCEL 중심):**
    -   LLMs: Google Gemini API (`ChatGoogleGenerativeAI`, 모델: `gemini-2.5-flash-preview-04-17`)
    -   Embeddings:
        -   주 사용: Google Gemini Embeddings (`GoogleGenerativeAIEmbeddings`)
        -   **(⚠︎ LLM / Embedding) Fallback Plan:** Gemini 서버 측 임베딩 API의 GA 전환 불확실성 대비, `Sentence-Transformers` (예: `jhgan/ko-sroberta-multitask` 또는 기타 한국어 특화 모델) 로컬 임베딩 사용 고려. `llm_init.py`에서 선택 가능하도록 구성.
    -   VectorStores: ChromaDB (로컬 파일 기반)
    -   Document Loaders: `TextLoader`, 커스텀 DB 로더 또는 DB 직접 접근 후 `Document` 객체 생성
    -   Text Splitters: `RecursiveCharacterTextSplitter`
    -   Retrievers: `VectorStoreRetriever`
    -   PromptTemplates: `PromptTemplate`, `ChatPromptTemplate`
    -   LCEL: `RunnableSequence`, `RunnablePassthrough`, `RunnableBranch`, `RunnableParallel` 등
-   **데이터베이스:**
    -   Vector Store (Q&A용): ChromaDB (로컬 파일 기반, 저장 경로: `data/chromadb/`)
    -   지식 출처 DB (Q&A용): MySQL (기존 PetGPT `communityboard`, `qnaboard` 테이블, 초기에는 동기 접근)
    -   상품 DB: MySQL (기존 PetGPT `Item` 테이블 연동, 초기에는 동기 접근)
    -   대화 로그 DB: **SQLite** (로컬 파일 기반: `data/logs.db`)
-   **프론트엔드:** 기존 PetGPT의 웹 기술 (HTML, CSS, JavaScript) 활용
-   **API 통신:** RESTful API (JSON 형식)
-   **HTTP 클라이언트 (LLM 호출 시):**
    -   **(⚠︎ 동기 vs. 비동기)** 초기에는 `requests` (블로킹) 사용.
    -   성능 및 확장성 필요시 `httpx.AsyncClient` (논블로킹)으로 전환 고려. (전환 시 영향 범위: `api.py`의 API 핸들러, `llm_init.py`의 LLM 호출 래퍼, `db_utils.py`의 DB 연동 함수 등 비동기 처리 필요)

#### 5.2. 주요 모듈 설계 (Python/FastAPI 기준) (✔︎ 폴더·파일 수)

```
petgpt_chatbot/
├── main.py                # FastAPI 애플리케이션 설정, 라우터 등록, 실행
│
├── api.py                 # /chat 엔드포인트 및 핵심 로직 (의도분류, LCEL 그래프 구성)
│
├── rag.py                 # RAG 파이프라인 (문서 로드, 임베딩, 저장, 검색, 답변 생성)
│
├── recommend.py           # 상품 추천 로직 (규칙 기반 파서, LLM 보조 분석, DB 조회, 추천 생성)
│
├── llm_init.py            # LLM, Embedding 모델 초기화 및 선택 함수
│
├── db_utils.py            # DB 연결(MySQL, SQLite) 및 쿼리 유틸리티, FastAPI 의존성 주입
│
├── models.py              # Pydantic 모델 (ChatRequest, ChatResponse, ProductInfo 등)
│
├── prompts.py             # LLM 프롬프트 템플릿 모음
│
├── config.py              # 환경 변수 및 설정 (API 키, DB 정보 등)
│
└── data/                  # 데이터 저장 디렉토리
    └── chromadb/          # ChromaDB 데이터 저장 경로
    └── logs.db            # SQLite 대화 로그 파일

tests/                     # (💡 테스트) FastAPI TestClient 기반 유닛/통합 테스트 디렉토리
    ├── test_api.py
    └── ...

requirements.txt           # 프로젝트 의존성
.env                       # 환경 변수 파일 (API 키 등)
README.md                  # 프로젝트 설명 및 실행 방법
Makefile / run.sh          # (선택) 개발 편의 스크립트 (예: uvicorn 실행, 초기 임베딩 로드 자동화)
```

#### 5.3. 모듈별 상세 설명

1.  **main.py:** FastAPI 앱 인스턴스 생성, `api.py`의 라우터 등록, Uvicorn 실행.
2.  **api.py:**
    -   `/chat` (POST) 엔드포인트 정의.
    -   **의도 분류 로직 (💡 api.py 의도 분기):** LCEL `RunnableBranch`와 정규식 키워드 매칭 또는 간단한 LLM 호출 조합.
        ```python
        # 예시: api.py 내 의도 분류 일부 (RunnableBranch 활용 아이디어)
        # from langchain_core.runnables import RunnableBranch
        # from some_module import is_qna_intent, is_product_intent # 키워드/LLM 기반 분류 함수

        # intent_classifier = RunnableBranch(
        #     (lambda x: is_qna_intent(x["query"]), qna_chain),
        #     (lambda x: is_product_intent(x["query"]), product_chain),
        #     general_fallback_chain
        # )
        ```
    -   분기 처리: 의도에 따라 `rag.py` 또는 `recommend.py`의 해당 파이프라인 호출. 일반 대화는 LLM 직접 호출.
    -   `ChatResponse` 형태로 결과 반환 및 `db_utils.py` 통해 SQLite에 대화 기록.
3.  **rag.py:**
    -   `load_and_embed_knowledge_base()`: MySQL에서 지식 데이터 로드, 전처리 (HTML 태그 제거는 **`BeautifulSoup`** 사용 명시 (⚠︎ 지식 전처리)), 임베딩 후 ChromaDB 저장 (일회성).
    -   `create_rag_pipeline()`: RAG용 LCEL `RunnableSequence` 생성.
    -   `get_qna_answer()`: RAG 파이프라인 실행 및 답변/출처 반환.
4.  **recommend.py:**
    -   `parse_product_request_rules()`: 규칙 기반 사용자 요청 파싱.
    -   `extract_product_details_llm()`: LLM 활용 상세 정보 추출.
    -   **(⚠︎ recommend.py 파서 → DB)** "관절", "피부" 등 증상 키워드와 `item_content` 또는 `item_name` 매핑 로직은 `recommend.py` 내 함수 또는 정규식으로 우선 처리. 복잡한 경우 `prompts.py`의 LLM 프롬프트 엔지니어링으로 보조.
    -   `search_products_in_db()`: 추출 조건으로 MySQL `Item` 테이블 조회.
    -   `select_final_products_llm()`: LLM으로 최종 상품 1~3개 선택.
    -   `generate_recommendation_message_llm()`: 자연스러운 추천 문구 생성.
    -   `get_product_recommendation()`: 상품 추천 전체 파이프라인.
5.  **llm_init.py:** `ChatGoogleGenerativeAI` 및 `GoogleGenerativeAIEmbeddings` (또는 Sentence Transformer) 모델 인스턴스 반환 함수.
6.  **db_utils.py:** MySQL, SQLite 연결 객체 반환 및 관리. 대화 로그 테이블 생성 및 기록 함수. FastAPI 의존성 주입용 세션 관리 함수.
7.  **models.py (Pydantic):**
    -   `ChatRequest`: `query: str`, `session_id: Optional[str]`
    -   `ProductInfo`: `item_key: int`, `name: str`, `description_summary: Optional[str]`, `price: Optional[int]`, `image_url: Optional[str]`, `product_page_url: str`
    -   `ChatResponse`: `answer: str`, `response_type: Literal["qna", "product_recommendation", "error", "general"]`, `products: Optional[List[ProductInfo]]`, `source_links: Optional[List[str]]`
8.  **prompts.py:** `INTENT_CLASSIFICATION_PROMPT`, `QNA_RAG_PROMPT`, `PRODUCT_DETAIL_EXTRACTION_PROMPT_LLM`, `PRODUCT_FINAL_SELECTION_PROMPT_LLM`, `PRODUCT_RECOMMENDATION_MESSAGE_PROMPT_LLM` 등.
9.  **config.py (Pydantic Settings):**
    ```python
    from pydantic_settings import BaseSettings
    from typing import Optional

    class Settings(BaseSettings):
        GOOGLE_API_KEY: str
        MYSQL_HOST: str
        MYSQL_USER: str
        MYSQL_PASSWORD: str
        MYSQL_DB_NAME: str
        MYSQL_PORT: int = 3306
        CHROMA_DB_PATH: str = "./data/chromadb"
        SQLITE_LOG_DB_PATH: str = "./data/logs.db"
        KNOWLEDGE_COLLECTION_NAME: str = "petgpt_knowledge"
        EMBEDDING_MODEL_TYPE: str = "gemini" # "gemini" or "sbert"
        SBERT_MODEL_NAME: Optional[str] = "jhgan/ko-sroberta-multitask"
        MAX_TOKENS_PER_QUERY: Optional[int] = 1024 # (💡 LLM 비용 모니터링)
        MAX_TOKENS_PER_RESPONSE: Optional[int] = 512 # (💡 LLM 비용 모니터링)

        class Config:
            env_file = ".env"
            env_file_encoding = "utf-8"

    def get_settings() -> Settings:
        return Settings()
    ```
    **(💡 ENV 표 예시)** `.env` 파일 예시:
    ```dotenv
    GOOGLE_API_KEY="your_google_api_key"
    MYSQL_HOST="localhost"
    MYSQL_USER="petgpt_user"
    MYSQL_PASSWORD="your_db_password"
    MYSQL_DB_NAME="petgpt_db"
    MYSQL_PORT=3306
    # CHROMA_DB_PATH, SQLITE_LOG_DB_PATH 등은 기본값 사용 또는 필요시 오버라이드
    # EMBEDDING_MODEL_TYPE="sbert" # SBERT 사용 시
    ```

#### 5.4. 데이터베이스 설계 및 수정/추가 사항

1.  **신규: VectorStore (ChromaDB)** (✔︎ VectorStore 컬렉션)
    -   **목적:** Q&A를 위한 지식 저장.
    -   **컬렉션 명:** `config.py`의 `KNOWLEDGE_COLLECTION_NAME` 사용.
    -   **데이터:** 분할된 텍스트 조각, 임베딩 벡터, 메타데이터(`source_type`, `source_url`, `title` 등).
    -   **관리:** 초기 데이터 로드 후, PetGPT 내부 데이터 변경 시 주기적 업데이트는 MVP 범위 외.

2.  **기존: Item 테이블 (PetGPT 쇼핑몰 상품 DB - MySQL)**
    -   **목적:** 상품 추천 시 정보 조회.
    -   **활용 필드:** `item_key`, `category_key`, `item_name`, `item_content` (상품 특징 추출용), `item_price`, `item_sprice`, `item_img1` (대표 이미지), `sales_count` (추천 순위 고려), `is_active` (판매중 상품 필터링).
    -   **(💡 상품 태그 부족 시 대안)** `features`와 같은 명시적 태그 필드가 없을 경우, SQL 쿼리에서 `item_name` 및 `item_content`에 대한 `LIKE` 검색으로 대체. 예: `WHERE ... AND (item_name LIKE '%관절%' OR item_content LIKE '%관절%')`.
    -   **추가 고려 (MVP 이후):** `pet_type` (개/고양이), `target_lifestage` (퍼피/어덜트/시니어), `features` (관절, 피부 등 태그형 특성) 필드가 있다면 추천 정확도 향상에 도움.

3.  **신규: 대화 로그 테이블 (SQLite - `logs.db` 내 `conversations` 테이블)**
    -   **목적:** 사용자-챗봇 간 대화 기록, 추후 분석 및 개선에 활용.
    -   **주요 필드:** `id` (PK), `session_id` (TEXT), `user_query` (TEXT), `bot_response` (TEXT), `intent` (TEXT), `timestamp` (DATETIME).
    -   **(⚠︎ 로그 GDPR/개인정보)** 사용자 입력에 반려동물 이름 등 PII(개인 식별 정보) 포함 가능성 인지. MVP에서는 기본 텍스트로 저장하되, 향후 PII 최소화 (예: 특정 키워드 마스킹) 또는 민감 정보 SHA256 해시 처리 등의 정책 적용 고려.

#### 5.5. 시스템 아키텍처 다이어그램 (Mermaid) (💡 문서화 개선)

```mermaid
graph TD
    User[사용자 웹 브라우저] -- HTTP Request (질문) --> PetGPT_FE[PetGPT 웹 프론트엔드 (JS)]
    PetGPT_FE -- API Call /chat (JSON) --> FastAPI_App[FastAPI 백엔드 (Python)]

    subgraph FastAPI_App [펫GPT 챗봇 API 서버]
        direction LR
        APIRoute[/chat 엔드포인트] -- 의도분류 요청 --> IntentClassifier[의도 분류기 (LCEL RunnableBranch)]
        IntentClassifier -- Q&A 요청 --> RAG_Pipeline[RAG Q&A 파이프라인 (rag.py)]
        IntentClassifier -- 상품추천 요청 --> Reco_Pipeline[상품 추천 파이프라인 (recommend.py)]
        IntentClassifier -- 일반대화 --> LLM_Direct[LLM 직접 호출]

        RAG_Pipeline -- 질문 임베딩/컨텍스트 검색 --> ChromaDB[(ChromaDB VectorStore)]
        RAG_Pipeline -- 프롬프트 구성/답변 생성 --> Gemini_LLM[Google Gemini LLM API]
        ChromaDB -- 초기 데이터 로드 --> MySQL_Knowledge[MySQL (커뮤니티/Q&A)]

        Reco_Pipeline -- 사용자 요구사항 분석 (규칙/LLM) --> Gemini_LLM
        Reco_Pipeline -- 상품정보 조회 --> MySQL_Products[MySQL (상품 Item 테이블)]
        Reco_Pipeline -- 최종 상품 선택/메시지 생성 --> Gemini_LLM

        APIRoute -- 대화 로깅 --> SQLite_Logs[(SQLite logs.db)]
    end

    FastAPI_App -- API Response (JSON) --> PetGPT_FE
    PetGPT_FE -- 챗봇 응답 표시 --> User

    style User fill:#f9f,stroke:#333,stroke-width:2px
    style PetGPT_FE fill:#ccf,stroke:#333,stroke-width:2px
    style FastAPI_App fill:#def,stroke:#333,stroke-width:2px
    style Gemini_LLM fill:#lightgreen,stroke:#333,stroke-width:2px
    style ChromaDB fill:#orange,stroke:#333,stroke-width:2px
    style MySQL_Knowledge fill:#yellow,stroke:#333,stroke-width:2px
    style MySQL_Products fill:#yellow,stroke:#333,stroke-width:2px
    style SQLite_Logs fill:#lightblue,stroke:#333,stroke-width:2px
```

---

### 6. 개발 범위 및 단계 (예시) (✔︎ 4-Step 브레이크다운)

1.  **1단계 (기초 및 환경 설정):**
    -   FastAPI 프로젝트 초기 설정, `.env` 구성.
    -   `llm_init.py` 및 `config.py` 설정, Gemini LLM 및 Embedding 모델 API 호출 테스트.
    -   `db_utils.py`에 SQLite 연결 및 로그 테이블 생성/기록 함수 구현.
    -   **(💡 우선 코드 산출물)** Commit Tag: `v0.1-basic-setup`
2.  **2단계 (RAG Q&A 프로토타입):**
    -   `rag.py`: MySQL `communityboard`, `qnaboard` 데이터 로드, 전처리, 임베딩, ChromaDB 저장 함수 구현 및 실행.
    -   간단한 LCEL 파이프라인으로 Q&A 기능 프로토타입 개발 및 테스트.
    -   `prompts.py`에 Q&A용 프롬프트 정의.
    -   **(💡 우선 코드 산출물)** Commit Tag: `v0.2-rag-poc`
3.  **3단계 (상품 추천 프로토타입):**
    -   `db_utils.py`: MySQL 연결 함수 구현. `Item` 테이블 구조 확인.
    -   `recommend.py`: 규칙 기반 파서로 키워드 추출, `Item` 테이블 조회 및 간단한 추천 로직 구현.
    -   `prompts.py`에 상품 추천 관련 프롬프트 초기 정의.
    -   **(💡 우선 코드 산출물)** Commit Tag: `v0.3-reco-poc`
4.  **4단계 (`/chat` 엔드포인트 통합 및 UI 연동):**
    -   `api.py`: 의도 분류 로직 구현 (초기엔 간단한 키워드 기반 또는 LLM 프롬프트).
    -   Q&A 및 상품 추천 요청에 따라 `rag.py`, `recommend.py` 호출 및 응답 반환.
    -   `models.py`에 Pydantic 모델 정의.
    -   기본적인 챗봇 UI 프론트엔드와 `/chat` API 연동.
    -   사용자 테스트 및 피드백 반영.
    -   **(💡 우선 코드 산출물)** Commit Tag: `v0.4-api-ui-integration`

---

### 7. 기대 효과 (포트폴리오 관점)

-   최신 AI 기술인 Langchain (특히 LCEL, RAG) 활용 능력을 어필.
-   자연어 처리, 정보 검색, 규칙 및 LLM 기반 추천 시스템 구축에 대한 이해도 증명.
-   기존 웹 애플리케이션(PetGPT)에 AI 기능을 FastAPI 기반 API로 통합하는 능력 시연.
-   실제 사용자에게 가치를 제공할 수 있는 서비스 기획 및 구현 능력 제시.
-   **(💡 포트폴리오 강조점) 주요 성과 지표 및 시연:**
    -   **Metrics (예상):** Q&A 정답률 (자체 평가 기준), 상품 추천 CTR (시뮬레이션 또는 내부 테스트), 평균 응답 시간.
    -   **시연 영상 링크:** 프로젝트 완료 후, 주요 기능 시연 영상 제작 및 링크 첨부.

---

### 8. 주요 결정 및 고려 사항 (개발 진행 중 확정)

1.  **Q&A 데이터 소스 상세 범위 및 전처리:**
    -   PetGPT 내부 `communityboard`, `qnaboard` 테이블 전체 활용.
    -   데이터 정제 및 전처리 방식 (HTML 태그 제거는 `BeautifulSoup` 사용, 불필요한 정보 필터링 등) 구체화.
2.  **LLM API 사용량 및 비용 관리:** Google Gemini API의 사용량 제한 및 비용 발생 가능성 인지. `config.py`의 `MAX_TOKENS_PER_QUERY`/`RESPONSE` 설정 등을 활용하여 효율적 사용 방안 고려. (**💡 LLM 비용 모니터링**)
3.  **상품 추천 로직 고도화 수준:** MVP에서는 규칙 기반 + 간단한 LLM 보조. 추후 LLM 기반 필터링, 개인화 요소 추가 등은 고려.
4.  **동기 vs 비동기 처리:**
    -   초기에는 동기 방식(MySQL, LLM 호출)으로 구현.
    -   성능 이슈 발생 시 FastAPI의 비동기 기능 및 `httpx.AsyncClient`, 비동기 DB 드라이버(`aiomysql`, `aiosqlite`) 도입 고려.
    -   **(⚠︎ 동기 vs. 비동기)** 전환 시 주요 변경 대상 파일/함수:
        -   `api.py`: FastAPI 라우트 핸들러 (`async def` 사용).
        -   `db_utils.py`: DB 연결 및 쿼리 함수 (비동기 드라이버용으로 수정).
        -   `llm_init.py` 또는 서비스 레이어: `httpx.AsyncClient`를 사용한 LLM API 호출부.
        -   RAG 및 추천 파이프라인 내 I/O 바운드 작업들.
5.  **오류 처리 및 예외 관리:** 각 모듈 및 API 호출 단계에서의 견고한 오류 처리 방안 수립.
6.  **(⚠︎ 성능 턴어라운드) 성능 목표:** 초기 목표로 주요 Q&A 및 추천 응답 시간 **5초 이내** 설정. LLM Latency(초) 및 QPS(Queries Per Second)는 개발 중 지속적으로 모니터링하며 최적화 진행.
7.  **개발 환경 및 실행 자동화:**
    -   `(선택)` `Makefile` 또는 `run.sh` 스크립트를 통해 `uvicorn main:app --reload` 실행, 초기 데이터 임베딩 로드 등의 반복 작업을 자동화하여 개발 효율성 증대.

---