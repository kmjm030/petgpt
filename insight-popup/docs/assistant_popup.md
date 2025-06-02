# AI Assistant Popup

화면을 자동으로 분석하여 AI 기반 인사이트를 제공하는 데스크톱 팝업 애플리케이션입니다.

## 주요 기능

- **자동 화면 캡처**: 설정된 주기(기본 60초)마다 화면을 자동으로 캡처
- **AI 기반 분석**: Google Gemini AI를 활용하여 화면 내용을 분석하고 인사이트 제공
- **스마트 팝업**: 분석 결과를 말풍선 형태로 화면에 표시
- **RAG 지원**: 기존 문서와 연계하여 더욱 정확한 정보 제공

## 프로젝트 구조

```
insight-popup/
├── main.py              # 메인 실행 파일
├── display_bubble.py    # 팝업 UI 컴포넌트
├── screen_capture.py    # 화면 캡처 기능
├── ai_processor.py      # AI 분석 처리
├── Pipfile             # Python 의존성 관리
├── assets/             # 리소스 파일
│   └── profile.png     # 프로필 이미지
├── backend/            # 백엔드 핵심 로직
└── docs/               # 문서 및 데이터
```

## 설치 및 실행

### 필요 조건

- Python 3.8 이상
- Google API Key (Gemini AI 사용)

### 설치

1. **의존성 설치**

   ```bash
   cd insight-popup
   pipenv install
   ```

2. **환경 변수 설정**
   ```bash
   export GOOGLE_API_KEY="your_google_api_key_here"
   ```

### 실행

```bash
pipenv run python main.py
```

## 설정

### 캡처 주기 변경

`main.py` 파일에서 `CAPTURE_INTERVAL_SECONDS` 값을 수정하여 화면 캡처 주기를 조정할 수 있습니다.

```python
CAPTURE_INTERVAL_SECONDS = 60  # 초 단위
```

### 팝업 위치 조정

`display_bubble.py` 파일에서 팝업 위치를 조정할 수 있습니다:

```python
# 팝업 위치 설정
margin = 20
bookmark_bar_height = 40  # 북마크 바 높이 고려
```

## 주요 컴포넌트

### main.py

- 애플리케이션의 메인 실행 로직
- 주기적인 화면 캡처 및 AI 분석 스케줄링
- 메시지 큐를 통한 UI 업데이트 관리

### display_bubble.py

- CustomTkinter를 사용한 팝업 UI 구현
- 말풍선 형태의 인터페이스
- 투명 배경 및 위치 조정 기능

### screen_capture.py

- PIL(Pillow)을 사용한 화면 캡처
- 이미지를 바이트 스트림으로 변환

### ai_processor.py

- Google Gemini AI 모델 연동
- 화면 이미지 분석 및 텍스트 추출
- RAG 시스템과의 연계

## UI 특징

- **말풍선 디자인**: 친근한 채팅 인터페이스
- **자동 위치 조정**: 브라우저 북마크 바를 고려한 위치 설정
- **투명 배경**: 자연스러운 화면 오버레이
- **자동 숨김**: 설정된 시간 후 자동으로 팝업 숨김

## 작동 원리

1. **화면 캡처**: 설정된 주기마다 전체 화면을 캡처
2. **AI 분석**: Gemini AI가 캡처된 이미지를 분석하여 텍스트 설명 생성
3. **RAG 처리**: 추출된 정보를 기반으로 관련 문서 검색
4. **인사이트 생성**: AI가 상황에 맞는 유용한 정보나 제안사항 생성
5. **팝업 표시**: 생성된 인사이트를 말풍선 형태로 화면에 표시
