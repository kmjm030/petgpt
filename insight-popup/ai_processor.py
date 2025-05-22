import google.generativeai as genai
import os
import sys
from typing import List, Dict

try:
    current_file_dir = os.path.dirname(os.path.abspath(__file__))
    project_root_path = (
        current_file_dir  
    )

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

genai.configure(api_key=os.environ.get("GOOGLE_API_KEY", "YOUR_API_KEY_HERE"))
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

        response = image_to_text_model.generate_content([prompt, image_part])
        description_text = response.text.strip()  
        if not description_text:  
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
    ) 

    if not image_bytes:
        return "화면 이미지를 분석할 수 없습니다."

    screen_description = get_text_description_from_image(image_bytes)

    if (
        not screen_description
        or "화면 정보를 분석하는 데 문제가 발생했습니다." in screen_description
        or "특별한 정보를 찾지 못했습니다." in screen_description
    ):
        return screen_description  

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
        ): 
            langchain_chat_history.append(SystemMessage(content=content))

    try:
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
