# PetGPT 챗봇 프로젝트: AI 코딩 도구 활용 가이드 (사용자 참고용)

이 문서는 `TODO.md` 파일과 함께 PetGPT 챗봇 프로젝트를 AI 코딩 도구(예: Cursor)를 사용하여 TDD 방식으로 개발하기 위한 가이드입니다.

## 1. 개발 프로세스 개요

1.  **계획 숙지:** `TODO.md`의 전체 Phase 및 Task를 숙지합니다.
2.  **단계별 진행:** AI에게 현재 진행할 Phase와 Task 번호, 그리고 TDD 사이클(RED, GREEN, REFACTOR)을 명확히 지시합니다.
3.  **AI와 협업:**
    - **테스트 우선 작성 (RED):** AI에게 먼저 실패하는 테스트 코드를 작성하도록 요청합니다.
    - **기능 구현 (GREEN):** 작성된 테스트를 통과하도록 AI에게 기능 코드를 구현하도록 요청합니다.
    - **리팩토링 (REFACTOR):** 테스트 통과 후, AI에게 코드 개선(가독성, 효율성 등)을 요청하거나 직접 수정합니다.
4.  **지속적인 소통:** AI가 한번에 완벽한 코드를 생성하지 못할 수 있습니다. 명확하고 구체적인 피드백을 통해 원하는 결과물을 얻어냅니다.
5.  **임시 메모 활용:** 코딩 중 떠오르는 아이디어나 LLM과의 중요한 대화 내용은 `session.md` 또는 `scratchpad.md`와 같은 별도 파일에 기록하도록 AI에게 요청하거나 직접 기록하여 작업 컨텍스트를 유지합니다.
6.  **셀프 검증:** 각 Phase가 끝나면 `TODO.md`에 명시된 대로 Test Coverage 확인 및 Linter를 실행합니다. 목표 미달 시 AI에게 개선 작업을 명확히 지시합니다.

## 2. AI 코딩 도구(예: Cursor)에 작업 지시하는 방법

**핵심 원칙:** AI가 현재 "무엇을", "왜", "어떻게" 해야 하는지 명확히 알도록 구체적으로 지시합니다.

**프롬프트 예시:**

- **새로운 Task 시작 시:**

  ```
  좋아, PetGPT 챗봇 프로젝트 Phase 1, Task 1.1을 시작하자.
  목표는 환경 변수 로드 기능을 구현하는 것이고, `config.py` 와 `tests/test_config.py` 파일을 주로 다룰 거야.
  TDD 사이클에 따라 RED 단계부터 시작할게.
  `tests/test_config.py` 파일을 열고, 테스트용 `.env.test` 파일 (내용은 GOOGLE_API_KEY_TEST="test_key_from_env")을 참조해서,
  `Settings` Pydantic 모델이 이 환경 변수를 정상적으로 로드하는지 검증하는 `test_load_settings_from_env_file` 테스트 함수를 작성해줘.
  `petgpt_chatbot/config.py`의 `Settings` 모델은 아직 구현 전이므로, 이 테스트는 실패해야 정상이야.
  ```

- **테스트 실행 및 결과 확인 요청:**

  ```
  좋아, 테스트 코드 작성이 끝났으면 터미널에서 `pytest tests/test_config.py` 명령을 실행하고 그 결과를 보여줘.
  예상대로 테스트가 실패했는지 확인하자.
  ```

- **기능 코드 구현 요청 (GREEN 단계):**

  ```
  예상대로 테스트가 실패했네. 아주 좋아.
  이제 `petgpt_chatbot/config.py` 파일을 열어서, 방금 작성한 `test_load_settings_from_env_file` 테스트를 통과할 수 있도록
  Pydantic을 사용한 `Settings` 모델과 `get_settings` 함수를 구현해줘.
  구현이 끝나면 다시 `pytest tests/test_config.py`를 실행하고 결과를 알려줘.
  ```

- **리팩토링 요청:**

  ```
  테스트 통과 확인! 이제 `petgpt_chatbot/config.py` 코드에 대해 리팩토링할 부분이 있는지 검토해보고,
  가독성이나 효율성을 높일 수 있는 개선안이 있다면 적용해줘. 변경 후에도 테스트는 계속 통과해야 해.
  ```

- **다음 Task로 이동 시:**

  ```
  좋아, Phase 1, Task 1.1은 완료된 것 같아. 체크리스트에 표시해줘.
  이제 Phase 1, Task 1.2 'LLM 및 Embedding 모델 초기화 (`llm_init.py`)'로 넘어가자.
  `tests/test_llm_init.py` 파일부터 만들고, RED 단계 테스트인 `test_get_llm_returns_gemini_instance` 함수부터 작성할 거야.
  이 함수는 `get_llm()`이 (Mocking된) `ChatGoogleGenerativeAI` 인스턴스를 반환하는지 검증해야 해.
  ```

- **임시 메모/스크래치패드 활용 지시:**

  ```
  잠깐, `llm_init.py`에서 SBERT 모델을 fallback으로 고려하는 아이디어가 떠올랐어.
  `session.md` 파일에 "LLM 초기화 개선 아이디어: SBERT 모델 fallback 옵션 추가 고려" 라고 기록해줘.
  ```

- **Phase 종료 및 검증 지시:**
  ```
  Phase 1의 모든 Task가 완료되었어.
  이제 Phase 1 셀프 검증 및 마무리를 진행하자. (Task 1.5)
  먼저, 터미널에서 `pytest --cov=petgpt_chatbot --cov-report=term-missing`를 실행하고 Test Coverage 결과를 보여줘.
  목표는 80% 이상이야.
  ```
  **(Coverage 결과 확인 후, 미달 시)**
  ```
  Test Coverage가 70%로 목표 미달이네. `htmlcov/index.html` (또는 터미널 결과)를 참고해서
  `tests/test_db_utils.py`에 누락된 테스트 케이스를 추가하고, 관련 기능 코드도 보강해줘.
  수정 후 다시 Coverage를 확인해줘.
  ```
  **(Linter 실행 지시)**
  ```
  Coverage 목표 달성했어! 이제 `flake8 petgpt_chatbot tests`를 실행하고 Linter 오류가 있는지 확인해줘.
  오류가 있다면 수정해줘.
  ```

## 3. 팁 및 권장 사항

- **AI의 한계 인지:** AI는 강력한 도구지만 만능은 아닙니다. 복잡한 로직이나 도메인 특화 지식은 사용자가 직접 가이드하거나 수정해야 할 수 있습니다.
- **작은 단위로 작업:** AI에게 너무 크거나 모호한 작업을 한 번에 요청하기보다는, `TODO.md`의 Task 단위로 잘게 나누어 명확히 지시하는 것이 효과적입니다.
- **결과 검토:** AI가 생성한 코드는 반드시 사용자가 직접 검토하고 테스트해야 합니다.
- **Git 활용:** 각 Task 또는 Phase 완료 시점에 Git으로 커밋하여 변경 사항을 체계적으로 관리합니다.
- **유연성:** 계획은 가이드일 뿐, 개발 과정에서 더 좋은 아이디어나 방법이 떠오르면 AI와 논의하여 계획을 수정할 수 있습니다.

이 가이드라인을 통해 AI 코딩 도구를 효과적으로 활용하여 PetGPT 챗봇 프로젝트를 성공적으로 개발하시기를 바랍니다!
