# ai_processor.py (이미지 설명을 생성하여 RAG 쿼리로 사용)
import google.generativeai as genai
import os
import sys
from typing import List, Dict

# --- core.py의 run_llm 함수를 직접 호출하기 위한 경로 설정 ---
try:
    current_file_dir = os.path.dirname(os.path.abspath(__file__))
    # insight-popup/ai_processor.py 와 insight-popup/backend/core.py 구조 가정
    project_root_path = (
        current_file_dir  # ai_processor.py가 프로젝트 루트(insight-popup)에 있다고 가정
    )
    # 만약 ai_processor.py가 하위 폴더에 있다면:
    # project_root_path = os.path.dirname(current_file_dir) # 예: insight-popup/processors/ai_processor.py

    # backend 폴더가 project_root_path 바로 아래에 있다고 가정
    # sys.path.insert(0, project_root_path) # 이렇게 하면 from backend.core 가능

    # 더 명시적으로 backend 폴더의 부모를 추가 (만약 backend가 project_root 바로 아래라면)
    # sys.path.insert(0, os.path.abspath(os.path.join(project_root_path)))
    # 현재 파일이 있는 디렉토리(project_root_path)를 sys.path에 추가하면
    # 해당 디렉토리 내의 'backend' 패키지를 찾을 수 있습니다.
    if project_root_path not in sys.path:
        sys.path.insert(0, project_root_path)

    from backend.core import run_llm
except ImportError as e:
    print(
        f"CRITICAL: backend.core 모듈을 임포트할 수 없습니다. 경로 설정을 확인하세요. Error: {e}"
    )
    print(f"Current sys.path: {sys.path}")
    print(
        f"Attempted to add: {project_root_path if 'project_root_path' in locals() else 'Path not set'}"
    )
    raise

# Gemini 설정
genai.configure(api_key=os.environ.get("GOOGLE_API_KEY", "YOUR_API_KEY_HERE"))
# 이미지에서 정보 추출을 위한 Gemini 모델 (멀티모달 지원)
image_to_text_model = genai.GenerativeModel("gemini-2.5-flash-preview-05-20")


def get_text_description_from_image(image_bytes):
    """Gemini를 사용하여 화면 이미지에서 RAG 쿼리에 활용할 상세한 텍스트 설명을 추출합니다."""
    if not image_bytes:
        return None
    try:
        print("이미지에서 텍스트 설명 추출 시도 (Gemini)...")
        image_part = {"mime_type": "image/png", "data": image_bytes}
        prompt = """당신은 화면 분석 전문가입니다. 이 이미지는 사용자가 현재 보고 있는 반려동물 쇼핑몰의 한 페이지입니다.
        이 화면에서 사용자의 관심을 끌 만한 **주요 상품명, 카테고리명, 눈에 띄는 가격 정보 (할인 포함), 상품의 핵심 특징이나 설명 문구, 그리고 사용자가 클릭할 만한 주요 버튼이나 링크의 텍스트**를 정확하게 추출하여 자연스러운 문장으로 요약 및 설명해주세요.
        이 설명은 나중에 다른 AI가 사용자에게 쇼핑 조언을 하는 데 사용될 것이므로, 구체적이고 명확해야 합니다.
        만약 중요한 정보가 없다면 "특별히 눈에 띄는 상품 정보는 없습니다." 와 같이 언급해주세요.
        설명은 한두 문단 이내로 간결하게 작성해주세요.
        """
        # 예시 프롬프트 (필요시 추가):
        # "예시: '화면에는 [로얄캐닌 인도어캣 사료 2kg] 상품이 보이며, 가격은 [35,000원]에서 [15% 할인]된 [29,750원]으로 표시되어 있습니다. 상품 설명에는 [실내 생활 고양이의 활동량 저하 및 헤어볼 관리 기능]이 강조되어 있고, [장바구니 담기] 버튼과 [상품평 보기 (58개)] 링크가 보입니다. 상단에는 [고양이 사료 > 건식 사료] 카테고리가 표시되어 있습니다.'"

        response = image_to_text_model.generate_content([prompt, image_part])
        description_text = response.text.strip()  # 앞뒤 공백 제거
        if not description_text:  # 빈 응답 처리
            print("Gemini가 이미지에서 설명을 추출하지 못했습니다 (빈 응답).")
            return "화면에서 특별한 정보를 찾지 못했습니다."
        print(f"이미지에서 추출된 텍스트 설명 (일부): {description_text[:250]}...")
        return description_text
    except Exception as e:
        print(f"이미지 텍스트 설명 추출 오류: {e}")
        try:
            if hasattr(response, "prompt_feedback"):
                print(
                    f"Gemini Prompt Feedback (Text Description): {response.prompt_feedback}"
                )
        except Exception:
            pass
        return "화면 정보를 분석하는 데 문제가 발생했습니다."


# main.py에서 호출될 함수
def get_ai_response_based_on_screen_description(
    image_bytes, chat_history_frontend: List[Dict[str, str]] = []
):
    """
    화면 이미지에서 텍스트 설명을 추출하고, 이를 기반으로 RAG 시스템(core.run_llm)을 호출하여
    AI 어시스턴트의 답변을 생성합니다.
    chat_history_frontend는 [{"role": "user", "content": "..."}, ...] 형태입니다.
    """
    from langchain_core.messages import (
        HumanMessage,
        AIMessage,
        SystemMessage,
        BaseMessage,
    )  # 여기서 임포트

    if not image_bytes:
        return "화면 이미지를 분석할 수 없습니다."

    # 1. 이미지에서 텍스트 설명 추출
    screen_description = get_text_description_from_image(image_bytes)

    if (
        not screen_description
        or "화면 정보를 분석하는 데 문제가 발생했습니다." in screen_description
        or "특별한 정보를 찾지 못했습니다." in screen_description
    ):
        # 이미지 설명 추출 실패 시 사용자에게 알림
        return screen_description  # 오류 메시지 또는 기본 메시지 반환

    # 2. 추출된 이미지 설명을 바탕으로 RAG 시스템에 전달할 최종 사용자 질문(query) 생성
    # 이 질문은 core.py의 AI_SHOPPING_ASSISTANT_SYSTEM_PROMPT와 상호작용합니다.
    user_query_for_rag = f"""안녕하세요! 제가 지금 반려동물 쇼핑몰에서 다음과 같은 내용의 화면을 보고 있어요:
    --- 화면 설명 시작 ---
    {screen_description}
    --- 화면 설명 끝 ---

    이 화면 내용과 관련해서 저에게 유용한 쇼핑 정보나 상품 추천, 또는 관련된 팁을 알려주시겠어요?
    예를 들어, 이 상품과 같이 사면 좋은 다른 상품이나, 비슷한 상품 중 인기 있는 것,
    또는 이 상품/카테고리에 대한 중요한 정보(리뷰 요약, 할인 등)가 있다면 알려주세요.
    가볍게 대화하듯 편하게 이야기해주세요!
    """

    print(f"RAG 시스템에 전달할 최종 Query (일부): {user_query_for_rag[:200]}...")

    # 프론트엔드 형식의 chat_history를 Langchain BaseMessage 리스트로 변환
    langchain_chat_history: List[BaseMessage] = []
    for msg_data in chat_history_frontend:
        role = msg_data.get("role", "").lower()
        content = msg_data.get("content", "")
        if role == "user" or role == "human":
            langchain_chat_history.append(HumanMessage(content=content))
        elif role == "assistant" or role == "ai" or role == "model":
            langchain_chat_history.append(AIMessage(content=content))
        elif (
            role == "system"
        ):  # 시스템 메시지는 보통 히스토리에 직접 추가하지 않지만, 유연성을 위해 포함
            langchain_chat_history.append(SystemMessage(content=content))

    try:
        # core.py의 run_llm 함수 직접 호출
        response_data = run_llm(
            query=user_query_for_rag, chat_history=langchain_chat_history
        )
        rag_answer = response_data.get(
            "result", "죄송합니다. 지금은 답변을 드리기 어렵네요."
        )
        print("RAG 시스템 응답 수신 성공.")
        return rag_answer

    except NameError as ne:
        print(
            f"run_llm 함수를 찾을 수 없습니다. backend.core 임포트 경로를 확인하세요. Error: {ne}"
        )
        return "AI 어시스턴트 초기화에 실패했습니다."
    except Exception as e:
        print(f"RAG 시스템 처리 중 오류 발생: {e.__class__.__name__} - {e}")
        import traceback

        traceback.print_exc()
        return f"죄송합니다, AI 어시스턴트 응답 생성 중 문제가 발생했습니다 ({e.__class__.__name__})."


# --- 테스트용 코드 ---
if __name__ == "__main__":
    print("[테스트 모드 시작 - 이미지 설명 기반 RAG]")
    # 필수 환경 변수: GOOGLE_API_KEY, (Pinecone 관련 변수들)

    test_image_bytes = None
    # --- 실제 이미지 파일로 테스트하는 예시 ---
    try:
        from PIL import Image
        import io

        # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        # 로컬 이미지 파일 경로 (실제 테스트 시 이 경로를 수정하세요)
        test_image_path = "path/to/your/pet_shopping_mall_screenshot.png"
        # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

        # # 아래 코드의 주석을 해제하여 로컬 이미지로 테스트하세요.
        # if os.path.exists(test_image_path):
        #     print(f"테스트 이미지 로드 중: {test_image_path}")
        #     img = Image.open(test_image_path)
        #     img_byte_arr = io.BytesIO()
        #     img.save(img_byte_arr, format='PNG')
        #     test_image_bytes = img_byte_arr.getvalue()
        #     print("테스트 이미지 로드 성공.")
        # else:
        #     print(f"경고: 테스트 이미지 파일을 찾을 수 없습니다 - {test_image_path}")
        pass  # 실제 테스트 시 이 pass 제거

    except ImportError:
        print(
            "Pillow 라이브러리가 없어 이미지 파일을 로드할 수 없습니다. (pip install Pillow)"
        )
    except FileNotFoundError:
        print(f"테스트 이미지 파일을 찾을 수 없습니다")

    if test_image_bytes:
        print("\n화면 이미지 설명 기반 RAG 어시스턴트 응답 생성 테스트 시작...")
        sample_frontend_chat_history = [
            # {"role": "user", "content": "이 사료 괜찮을까요?"},
            # {"role": "assistant", "content": "네, 고객님! 보고 계신 사료는 기호성이 좋다는 평이 많습니다. 혹시 반려견의 나이나 특별히 고려하시는 건강 문제가 있으실까요?"}
        ]
        ai_final_answer = get_ai_response_based_on_screen_description(
            test_image_bytes, chat_history_frontend=sample_frontend_chat_history
        )
        print("\n--- 최종 AI 어시스턴트 답변 ---")
        print(ai_final_answer)
    else:
        print(
            "\n테스트를 위한 이미지 데이터가 없습니다. 스크립트 내 `test_image_path`를 설정하거나 `main.py`를 통해 사용하세요."
        )

    print(
        "\n[테스트 모드 종료]"
    )  # ai_processor.py (이미지 설명을 생성하여 RAG 쿼리로 사용)
import google.generativeai as genai
import os
import sys

# --- core.py의 run_llm 함수를 직접 호출하기 위한 경로 설정 ---
try:
    current_file_dir = os.path.dirname(os.path.abspath(__file__))
    # insight-popup/ai_processor.py 와 insight-popup/backend/core.py 구조 가정
    project_root_path = (
        current_file_dir  # ai_processor.py가 프로젝트 루트(insight-popup)에 있다고 가정
    )
    # 만약 ai_processor.py가 하위 폴더에 있다면:
    # project_root_path = os.path.dirname(current_file_dir) # 예: insight-popup/processors/ai_processor.py

    # backend 폴더가 project_root_path 바로 아래에 있다고 가정
    # sys.path.insert(0, project_root_path) # 이렇게 하면 from backend.core 가능

    # 더 명시적으로 backend 폴더의 부모를 추가 (만약 backend가 project_root 바로 아래라면)
    # sys.path.insert(0, os.path.abspath(os.path.join(project_root_path)))
    # 현재 파일이 있는 디렉토리(project_root_path)를 sys.path에 추가하면
    # 해당 디렉토리 내의 'backend' 패키지를 찾을 수 있습니다.
    if project_root_path not in sys.path:
        sys.path.insert(0, project_root_path)

    from backend.core import run_llm
except ImportError as e:
    print(
        f"CRITICAL: backend.core 모듈을 임포트할 수 없습니다. 경로 설정을 확인하세요. Error: {e}"
    )
    print(f"Current sys.path: {sys.path}")
    print(
        f"Attempted to add: {project_root_path if 'project_root_path' in locals() else 'Path not set'}"
    )
    raise

# Gemini 설정
genai.configure(api_key=os.environ.get("GOOGLE_API_KEY", "YOUR_API_KEY_HERE"))
# 이미지에서 정보 추출을 위한 Gemini 모델 (멀티모달 지원)
image_to_text_model = genai.GenerativeModel("gemini-2.5-flash-preview-05-20")


def get_text_description_from_image(image_bytes):
    """Gemini를 사용하여 화면 이미지에서 RAG 쿼리에 활용할 상세한 텍스트 설명을 추출합니다."""
    if not image_bytes:
        return None
    try:
        print("이미지에서 텍스트 설명 추출 시도 (Gemini)...")
        image_part = {"mime_type": "image/png", "data": image_bytes}
        prompt = """당신은 화면 분석 전문가입니다. 이 이미지는 사용자가 현재 보고 있는 반려동물 쇼핑몰의 한 페이지입니다.
        이 화면에서 사용자의 관심을 끌 만한 **주요 상품명, 카테고리명, 눈에 띄는 가격 정보 (할인 포함), 상품의 핵심 특징이나 설명 문구, 그리고 사용자가 클릭할 만한 주요 버튼이나 링크의 텍스트**를 정확하게 추출하여 자연스러운 문장으로 요약 및 설명해주세요.
        이 설명은 나중에 다른 AI가 사용자에게 쇼핑 조언을 하는 데 사용될 것이므로, 구체적이고 명확해야 합니다.
        만약 중요한 정보가 없다면 "특별히 눈에 띄는 상품 정보는 없습니다." 와 같이 언급해주세요.
        설명은 한두 문단 이내로 간결하게 작성해주세요.
        """
        # 예시 프롬프트 (필요시 추가):
        # "예시: '화면에는 [로얄캐닌 인도어캣 사료 2kg] 상품이 보이며, 가격은 [35,000원]에서 [15% 할인]된 [29,750원]으로 표시되어 있습니다. 상품 설명에는 [실내 생활 고양이의 활동량 저하 및 헤어볼 관리 기능]이 강조되어 있고, [장바구니 담기] 버튼과 [상품평 보기 (58개)] 링크가 보입니다. 상단에는 [고양이 사료 > 건식 사료] 카테고리가 표시되어 있습니다.'"

        response = image_to_text_model.generate_content([prompt, image_part])
        description_text = response.text.strip()  # 앞뒤 공백 제거
        if not description_text:  # 빈 응답 처리
            print("Gemini가 이미지에서 설명을 추출하지 못했습니다 (빈 응답).")
            return "화면에서 특별한 정보를 찾지 못했습니다."
        print(f"이미지에서 추출된 텍스트 설명 (일부): {description_text[:250]}...")
        return description_text
    except Exception as e:
        print(f"이미지 텍스트 설명 추출 오류: {e}")
        try:
            if hasattr(response, "prompt_feedback"):
                print(
                    f"Gemini Prompt Feedback (Text Description): {response.prompt_feedback}"
                )
        except Exception:
            pass
        return "화면 정보를 분석하는 데 문제가 발생했습니다."


# main.py에서 호출될 함수
def get_ai_response_based_on_screen_description(
    image_bytes, chat_history_frontend: List[Dict[str, str]] = []
):
    """
    화면 이미지에서 텍스트 설명을 추출하고, 이를 기반으로 RAG 시스템(core.run_llm)을 호출하여
    AI 어시스턴트의 답변을 생성합니다.
    chat_history_frontend는 [{"role": "user", "content": "..."}, ...] 형태입니다.
    """
    from langchain_core.messages import (
        HumanMessage,
        AIMessage,
        SystemMessage,
        BaseMessage,
    )  # 여기서 임포트

    if not image_bytes:
        return "화면 이미지를 분석할 수 없습니다."

    # 1. 이미지에서 텍스트 설명 추출
    screen_description = get_text_description_from_image(image_bytes)

    if (
        not screen_description
        or "화면 정보를 분석하는 데 문제가 발생했습니다." in screen_description
        or "특별한 정보를 찾지 못했습니다." in screen_description
    ):
        # 이미지 설명 추출 실패 시 사용자에게 알림
        return screen_description  # 오류 메시지 또는 기본 메시지 반환

    # 2. 추출된 이미지 설명을 바탕으로 RAG 시스템에 전달할 최종 사용자 질문(query) 생성
    # 이 질문은 core.py의 AI_SHOPPING_ASSISTANT_SYSTEM_PROMPT와 상호작용합니다.
    user_query_for_rag = f"""안녕하세요! 제가 지금 반려동물 쇼핑몰에서 다음과 같은 내용의 화면을 보고 있어요:
    --- 화면 설명 시작 ---
    {screen_description}
    --- 화면 설명 끝 ---

    이 화면 내용과 관련해서 저에게 유용한 쇼핑 정보나 상품 추천, 또는 관련된 팁을 알려주시겠어요?
    예를 들어, 이 상품과 같이 사면 좋은 다른 상품이나, 비슷한 상품 중 인기 있는 것,
    또는 이 상품/카테고리에 대한 중요한 정보(리뷰 요약, 할인 등)가 있다면 알려주세요.
    가볍게 대화하듯 편하게 이야기해주세요!
    """

    print(f"RAG 시스템에 전달할 최종 Query (일부): {user_query_for_rag[:200]}...")

    # 프론트엔드 형식의 chat_history를 Langchain BaseMessage 리스트로 변환
    langchain_chat_history: List[BaseMessage] = []
    for msg_data in chat_history_frontend:
        role = msg_data.get("role", "").lower()
        content = msg_data.get("content", "")
        if role == "user" or role == "human":
            langchain_chat_history.append(HumanMessage(content=content))
        elif role == "assistant" or role == "ai" or role == "model":
            langchain_chat_history.append(AIMessage(content=content))
        elif (
            role == "system"
        ):  # 시스템 메시지는 보통 히스토리에 직접 추가하지 않지만, 유연성을 위해 포함
            langchain_chat_history.append(SystemMessage(content=content))

    try:
        # core.py의 run_llm 함수 직접 호출
        response_data = run_llm(
            query=user_query_for_rag, chat_history=langchain_chat_history
        )
        rag_answer = response_data.get(
            "result", "죄송합니다. 지금은 답변을 드리기 어렵네요."
        )
        print("RAG 시스템 응답 수신 성공.")
        return rag_answer

    except NameError as ne:
        print(
            f"run_llm 함수를 찾을 수 없습니다. backend.core 임포트 경로를 확인하세요. Error: {ne}"
        )
        return "AI 어시스턴트 초기화에 실패했습니다."
    except Exception as e:
        print(f"RAG 시스템 처리 중 오류 발생: {e.__class__.__name__} - {e}")
        import traceback

        traceback.print_exc()
        return f"죄송합니다, AI 어시스턴트 응답 생성 중 문제가 발생했습니다 ({e.__class__.__name__})."


# --- 테스트용 코드 ---
if __name__ == "__main__":
    print("[테스트 모드 시작 - 이미지 설명 기반 RAG]")
    # 필수 환경 변수: GOOGLE_API_KEY, (Pinecone 관련 변수들)

    test_image_bytes = None
    # --- 실제 이미지 파일로 테스트하는 예시 ---
    try:
        from PIL import Image
        import io

        # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        # 로컬 이미지 파일 경로 (실제 테스트 시 이 경로를 수정하세요)
        test_image_path = "path/to/your/pet_shopping_mall_screenshot.png"
        # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

        # # 아래 코드의 주석을 해제하여 로컬 이미지로 테스트하세요.
        # if os.path.exists(test_image_path):
        #     print(f"테스트 이미지 로드 중: {test_image_path}")
        #     img = Image.open(test_image_path)
        #     img_byte_arr = io.BytesIO()
        #     img.save(img_byte_arr, format='PNG')
        #     test_image_bytes = img_byte_arr.getvalue()
        #     print("테스트 이미지 로드 성공.")
        # else:
        #     print(f"경고: 테스트 이미지 파일을 찾을 수 없습니다 - {test_image_path}")
        pass  # 실제 테스트 시 이 pass 제거

    except ImportError:
        print(
            "Pillow 라이브러리가 없어 이미지 파일을 로드할 수 없습니다. (pip install Pillow)"
        )
    except FileNotFoundError:
        print(f"테스트 이미지 파일을 찾을 수 없습니다: {test_image_path}")

    if test_image_bytes:
        print("\n화면 이미지 설명 기반 RAG 어시스턴트 응답 생성 테스트 시작...")
        sample_frontend_chat_history = [
            # {"role": "user", "content": "이 사료 괜찮을까요?"},
            # {"role": "assistant", "content": "네, 고객님! 보고 계신 사료는 기호성이 좋다는 평이 많습니다. 혹시 반려견의 나이나 특별히 고려하시는 건강 문제가 있으실까요?"}
        ]
        ai_final_answer = get_ai_response_based_on_screen_description(
            test_image_bytes, chat_history_frontend=sample_frontend_chat_history
        )
        print("\n--- 최종 AI 어시스턴트 답변 ---")
        print(ai_final_answer)
    else:
        print(
            "\n테스트를 위한 이미지 데이터가 없습니다. 스크립트 내 `test_image_path`를 설정하거나 `main.py`를 통해 사용하세요."
        )

    print("\n[테스트 모드 종료]")
