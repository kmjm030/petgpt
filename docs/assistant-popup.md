# AI 어시스턴트 팝업

> **AI 어시스턴트 팝업**은 데스크톱 화면을 실시간으로 분석해 Gemini Vision + RAG로 이해하고, 사용자를 위해 간결한 쇼핑 팁을 **말풍선 UI**로 띄워 주는 서비스입니다.

## 디렉터리 구조

```
├── ai_processor.py      # Vision → 텍스트 → RAG
├── display_bubble.py    # GUI 컴포넌트(CustomTkinter)
├── screen_capture.py    # Pillow ImageGrab 헬퍼
├── main.py              # 엔트리 포인트 / 스레딩
├── backend/
│   └── core.py          # LangChain 파이프라인
├── assets/
│   └── profile.png      # 아바타(없으면 기본)
├── tests/
│   ├── test_bubble.py   # 단위 테스트(pytest)
│   └── ...
└── Pipfile / Pipfile.lock
```

## 주요 기능

| 모듈                | 설명                                                                            |
| ------------------- | ------------------------------------------------------------------------------- |
| `screen_capture.py` | **Pillow ImageGrab**으로 _CAPTURE_INTERVAL_SECONDS_ 간격으로 기본 모니터를 캡처 |
| `ai_processor.py`   | 이미지 → **Gemini Vision** → 키워드 추출 → **LangChain RAG**로 질문             |
| `display_bubble.py` | **CustomTkinter** 말풍선 카드 렌더링                                            |
| `main.py`           | GUI 루프와 캡처 루프 스레드 관리, 우아한 종료 처리                              |

## 아키텍처

```
┌────────────┐    PNG 바이트   ┌──────────────┐   프롬프트    ┌──────────┐
│screen_capture│ ───────────▶ │ ai_processor │ ───────────▶ │Gemini/RAG│
└────────────┘                 └──────────────┘               └──────────┘
       ▲                                │  조언 텍스트             │
       │                                └──────────────┐          │
       │                                               ▼          │
       └─────── Tkinter 말풍선 ◀──────────── display_bubble ◀────┘
```

## 시작하기

### 환경 변수

| 변수                                | 용도                     |
| ----------------------------------- | ------------------------ |
| `GOOGLE_API_KEY`                    | Gemini llm model         |
| `PINECONE_API_KEY` / `PINECONE_ENV` | 벡터 스토어              |
| `CAPTURE_INTERVAL_SECONDS`          | 기본 60 초 간격 덮어쓰기 |

`.env` 파일에 저장하세요.

## 실행 방법

```bash
$ pipenv run python main.py
```

첫 인터벌 후 말풍선이 표시됩니다. **Esc** 키나 ✕ 아이콘으로 조기 종료할 수 있습니다.
