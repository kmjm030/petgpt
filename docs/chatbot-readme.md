# PetGPT AI 챗봇

**PetGPT**는 사용자 질문을 실시간으로 분석하여
쇼핑몰 DB, 쇼핑몰 정책 등의 문서를 근거로 **맞춤형 답변**을 제공하는 RAG‑기반 AI 챗봇 서비스입니다.

---

## 기술 스택

| Layer            | Tech                        | 역할                   |
| ---------------- | --------------------------- | ---------------------- |
| **Frontend**     | Streamlit                   | UI                     |
| **API**          | FastAPI                     | REST 엔드포인트 / CORS |
| **LLM**          | Google Gemini 2.5 Flash     | 답변 생성              |
| **Vector Store** | Pinecone                    | 임베딩 + 유사도 검색   |
| **Frameworks**   | LangChain & LangChain Hub   | 프롬프트·체인 구성     |
| **Ingestion**    | Firecrawl, MySQL → Markdown | 데이터 수집 & 청크     |

---

## 디렉터리 구조

```text
.
├── .streamlit/          # Streamlit 설정
├── backend/
│   ├── api_server.py    # FastAPI 엔트리
│   └── core.py          # LLM · VectorStore 래퍼
├── docs/                # RAG 지식 소스(markdown)
├── ingestion.py         # HTML · 웹 → Pinecone 업로드
├── mysql-to-docs.py     # MySQL → Markdown 변환
├── main.py              # Streamlit 앱
├── Pipfile              # 패키지/파이썬 버전 지정
```

---

## 빠른 시작

### 1) 환경 변수 설정

`.env` 파일을 생성하고 다음 값을 입력합니다.

```env
GOOGLE_API_KEY=your_google_gen_ai_key
PINECONE_API_KEY=your_pinecone_key
PINECONE_ENV=asia-northeast1-gcp
INDEX_NAME=petgpt-index
MYSQL_URI=mysql+pymysql://user:pass@host:3306/petgpt
```

### 2) 의존성 설치

```bash
# Python 3.11+ 권장
pipenv install --dev
pipenv shell
```

### 3) 문서 벡터화 & 업로드

```bash
# Markdown / Web 크롤링 데이터 벡터화
python ingestion.py

# 또는 MySQL 테이블 → Markdown → Pinecone
python mysql-to-docs.py
```

### 4) 서버 실행

```bash
# 백엔드 (FastAPI)
uvicorn backend.api_server:app --reload

# 프론트엔드 (Streamlit)
streamlit run main.py
```

---

## API 사용 예시

| Method | Endpoint             | 역할             |
| ------ | -------------------- | ---------------- |
| `POST` | `/api/chat-with-rag` | RAG 기반 챗 응답 |
| `POST` | `/api/ingest`        | 신규 문서 벡터화 |

```bash
curl -X POST http://localhost:8000/api/chat-with-rag \
     -H "Content-Type: application/json" \
     -d '{"query": "고양이 사료 추천해줘"}'
```

---

## 주요 스크립트

| 스크립트           | 설명                                              |
| ------------------ | ------------------------------------------------- |
| `ingestion.py`     | 웹/로컬 문서를 크롤링해 Pinecone 인덱스에 업로드  |
| `mysql-to-docs.py` | MySQL 테이블 데이터를 Markdown으로 덤프 후 벡터화 |
| `backend/core.py`  | `run_llm()` ‑ LLM + Retriever + Prompt 체인 구성  |

---
