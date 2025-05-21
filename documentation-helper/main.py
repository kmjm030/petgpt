from dotenv import load_dotenv

load_dotenv()
from typing import Set, List, Dict, Any
from langchain_core.documents import Document
import streamlit as st
import datetime
import re

from backend.core import run_llm

st.set_page_config(
    page_title="PetGPT 상품 및 정보 검색",
    page_icon="🐾",
    layout="wide",
    initial_sidebar_state="expanded",
)

st.markdown(
    """
<style>
    /* 전체 배경 스타일 */
    .main {
        background-color: #ffffff;
    }
    
    /* 사이드바 스타일링 */
    .css-1d391kg, .css-1e5imcs { /* Streamlit 버전에 따라 클래스명이 다를 수 있음 */
        background-color: #202123 !important; /* !important 추가 */
    }
    
    /* 사이드바 텍스트 색상 */
    .css-1d391kg .css-1kqfqy2, .css-1d391kg label, .css-1d391kg p, 
    .css-1e5imcs .css-1kqfqy2, .css-1e5imcs label, .css-1e5imcs p {
        color: #ffffff;
    }
    
    /* 사이드바 버튼 스타일 */
    .css-1d391kg .stButton>button, .css-1e5imcs .stButton>button {
        width: 100%;
        border-radius: 5px;
        margin-bottom: 5px;
        background-color: #343541; /* 버튼 배경색 변경 */
        color: #ffffff; /* 버튼 텍스트색 변경 */
        border: 1px solid #4a4a4a; /* 버튼 테두리 추가 */
    }
    .css-1d391kg .stButton>button:hover, .css-1e5imcs .stButton>button:hover {
        background-color: #4a4a4a; /* 호버 시 배경색 변경 */
    }


    /* 채팅 메시지 스타일링 */
    .user-message-container {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 10px;
    }
    .user-message {
        background-color: #10a37f; /* ChatGPT의 메인 녹색 */
        color: white;
        padding: 10px 15px;
        border-radius: 15px 15px 0 15px;
        max-width: 70%;
        word-wrap: break-word;
    }
    
    .bot-message-container {
        display: flex;
        justify-content: flex-start;
        margin-bottom: 10px;
    }
    .bot-message {
        background-color: #f7f7f8;
        color: #343541;
        padding: 10px 15px;
        border-radius: 15px 15px 15px 0;
        max-width: 70%;
        word-wrap: break-word;
        border: 1px solid #e0e0e0; /* 봇 메시지 테두리 */
    }
    
    /* 헤더 스타일 */
    h1, h2, h3 {
        color: #343541;
    }
    
    /* 입력 필드 스타일링 */
    .stTextInput > div > div > input {
        border-radius: 6px !important;
        border: 1px solid #d9d9e3 !important;
        padding: 10px 14px !important;
        height: 44px !important;
    }
    
    /* 전송 버튼 스타일링 */
    .stButton > button[kind="primary"] { /* st.form_submit_button을 사용하거나, 특정 버튼에 클래스 부여 필요 */
        background-color: #10a37f;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 8px 16px;
        font-weight: 500;
    }
    
    /* 채팅 컨테이너 */
    .chat-container {
        max-width: 900px; /* 너비 조정 */
        margin: 0 auto;
        padding: 20px;
    }
    
    /* 구분선 스타일링 */
    hr {
        border-top: 1px solid #d9d9e3;
        margin: 1.5rem 0;
    }
    
    /* 입력 영역 고정 스타일 */
    .input-area-container {
        position: fixed;
        bottom: 0;
        left: 0; /* 사이드바 너비 고려 */
        right: 0;
        background-color: #ffffff;
        padding: 15px 0px; /* 패딩 조정 */
        border-top: 1px solid #d9d9e3;
        z-index: 99;
    }
    .input-area {
        max-width: 850px; /* 채팅 컨테이너와 유사하게 */
        margin: 0 auto; /* 중앙 정렬 */
        display: flex;
        align-items: center;
    }
    .input-area .stTextInput {
        flex-grow: 1;
        margin-right: 10px;
    }
    
    /* 채팅 기록 컨테이너 */
    .chat-history {
        padding-bottom: 120px; /* 입력 영역을 위한 공간 확보 */
    }

    /* 저장된 채팅 목록 스타일 */
    .chat-list-item {
        padding: 8px 10px;
        border-radius: 5px;
        cursor: pointer;
        color: #ececf1;
        margin: 5px 0;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    
    .chat-list-item:hover {
        background-color: #343541;
    }

    /* 사이드바 사용자 프로필 사진 */
    .sidebar-profile-pic img {
        border-radius: 50%;
        border: 2px solid #10a37f; /* 테두리 추가 */
    }
</style>
""",
    unsafe_allow_html=True,
)

# --- 세션 상태 초기화 ---
if "chat_history_list" not in st.session_state:
    st.session_state.chat_history_list = []

if "current_chat_id" not in st.session_state:
    st.session_state.current_chat_id = None

# 각 채팅별 대화 기록을 저장하기 위한 구조
if "chats" not in st.session_state:
    st.session_state.chats = {}


def create_new_chat():
    now = datetime.datetime.now()
    chat_id = f"petgpt_chat_{now.strftime('%Y%m%d_%H%M%S_%f')}"

    new_chat_info = {
        "id": chat_id,
        "title": "새 PetGPT 채팅",
        "date": now.strftime("%Y-%m-%d %H:%M"),
        "created_at": now,
    }

    st.session_state.chat_history_list.insert(0, new_chat_info)
    st.session_state.chats[chat_id] = {"messages": [], "history_for_llm": []}
    st.session_state.current_chat_id = chat_id


def switch_chat(chat_id: str):
    st.session_state.current_chat_id = chat_id


# --- 사이드바 UI ---
with st.sidebar:
    st.button(
        "➕ 새 PetGPT 채팅",
        key="new_petgpt_chat_button",
        on_click=create_new_chat,
        use_container_width=True,
    )

    st.markdown("---")  # 구분선

    # 지난 채팅 목록 (최신순 정렬을 위해 chat_history_list를 그대로 사용)
    if not st.session_state.chat_history_list:
        st.caption("지난 채팅이 없습니다.")
    else:
        st.markdown("##### 지난 채팅")
        for chat_info in st.session_state.chat_history_list:
            if st.button(
                f"{chat_info['title']} ({chat_info['date']})",
                key=f"chat_button_{chat_info['id']}",
                on_click=switch_chat,
                args=(chat_info["id"],),
                use_container_width=True,
            ):
                pass  # on_click에서 처리

    st.markdown("---")  # 구분선
    st.markdown("##### 사용자 프로필")

    # Gravatar URL 생성 (기본 이미지 사용)
    gravatar_url = "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y&s=100"
    st.markdown(
        f'<div class="sidebar-profile-pic"><img src="{gravatar_url}" alt="User Profile"></div>',
        unsafe_allow_html=True,
    )

    # 사용자 이름 (예시, 실제 인증 로직 필요 시 확장)
    if "user_name" not in st.session_state:
        st.session_state.user_name = "사용자"
    st.write(f"안녕하세요, {st.session_state.user_name}님!")

    st.markdown("---")
    st.caption("© 2025 PetGPT Style Assistant")


def clean_response_text(text: str) -> str:
    text = re.sub(r"</?div[^>]*>", "", text)
    text = re.sub(r"<br\s*/?>", "\n", text)
    patterns_to_remove = [
        r"^(제공된\s*문맥에\s*따르면|주어진\s*정보에\s*따르면|문서에\s*따르면|DB 정보에 따르면)\s*[,:]?\s*",
    ]
    for pattern in patterns_to_remove:
        text = re.sub(pattern, "", text, flags=re.IGNORECASE | re.MULTILINE)
    return text.strip()


def created_sources_string(source_docs: List[Document]) -> str:
    if not source_docs:
        return ""
    sources_list = list(source_docs)
    sources_list.sort()
    sources_string = "sources:\n"
    for i, source in enumerate(sources_list):
        sources_string += f"{i+1}. {source}\n"
    return sources_string


# --- 메인 채팅 인터페이스 ---
st.markdown('<div class="chat-container">', unsafe_allow_html=True)

if st.session_state.current_chat_id is None:
    if not st.session_state.chat_history_list:
        st.markdown(
            '<h2 style="text-align: center; margin-top: 100px;">PetGPT 검색 시작하기</h2>',  # 문구 변경
            unsafe_allow_html=True,
        )
        st.markdown(
            '<p style="text-align: center; color: #6e6e80;">왼쪽 사이드바에서 "새 PetGPT 채팅" 버튼을 눌러 대화를 시작하세요.<br>예: "고양이 겨울 옷 찾아줘", "강아지 피부에 좋은 사료는?", "최근 올라온 커뮤니티 인기글 알려줘"</p>',  # 예시 질문 추가
            unsafe_allow_html=True,
        )
else:
    current_chat_id = st.session_state.current_chat_id
    # 현재 채팅 ID가 chat_history_list에 있는지 확인
    chat_exists_in_list = any(
        c["id"] == current_chat_id for c in st.session_state.chat_history_list
    )
    current_chat_data = st.session_state.chats.get(current_chat_id)

    if current_chat_data and chat_exists_in_list:
        # 채팅 제목 가져오기
        chat_title = "채팅"  # 기본값
        for chat_info_item in st.session_state.chat_history_list:
            if chat_info_item["id"] == current_chat_id:
                chat_title = chat_info_item["title"]
                break
        st.markdown(f"### {chat_title}")  # 채팅 제목 표시

        st.markdown('<div class="chat-history">', unsafe_allow_html=True)
        for msg_data in current_chat_data["messages"]:
            is_user = msg_data["role"] == "user"

            if is_user:
                st.markdown(
                    f"""
                <div class="user-message-container">
                    <div class="user-message">
                        {msg_data["content"]}
                    </div>
                </div>
                """,
                    unsafe_allow_html=True,
                )
            else:  # AI 메시지
                # AI 응답 내용을 표시할 때 st.markdown 사용 (HTML 직접 삽입보다는 markdown 선호)
                # unsafe_allow_html=True는 링크 등을 위해 필요
                st.markdown(
                    f"""
                <div class="bot-message-container">
                    <div class="bot-message">
                        {msg_data["content"]}
                    </div>
                </div>
                """,
                    unsafe_allow_html=True,
                )

        st.markdown("</div>", unsafe_allow_html=True)
    elif not chat_exists_in_list and current_chat_id:
        st.warning(
            f"선택된 채팅 ID '{current_chat_id}'가 채팅 목록에 없습니다. 새 채팅을 시작해주세요."
        )
        # st.session_state.current_chat_id = None # 선택된 채팅 ID 초기화
        # st.experimental_rerun()
    elif not current_chat_data and current_chat_id:
        st.error(
            f"채팅 ID '{current_chat_id}'에 대한 데이터를 찾을 수 없습니다. 문제가 지속되면 새 채팅을 시도해주세요."
        )
        # st.session_state.current_chat_id = None
        # st.experimental_rerun()


st.markdown("</div>", unsafe_allow_html=True)


# --- 입력 영역 (하단 고정) ---
st.markdown('<div class="input-area-container">', unsafe_allow_html=True)
st.markdown('<div class="input-area">', unsafe_allow_html=True)

with st.form(key="chat_input_form", clear_on_submit=True):
    prompt_key = (
        f"prompt_input_{st.session_state.current_chat_id or 'default_chat_prompt'}"
    )
    prompt = st.text_input(
        "PetGPT에게 무엇이든 물어보세요...",
        key=prompt_key,
        label_visibility="collapsed",
        disabled=(st.session_state.current_chat_id is None),
    )
    submit_button = st.form_submit_button(label="전송")

st.markdown("</div>", unsafe_allow_html=True)
st.markdown("</div>", unsafe_allow_html=True)


# --- 프롬프트 처리 로직 ---
if submit_button and prompt and st.session_state.current_chat_id:
    current_chat_id = st.session_state.current_chat_id

    # current_chat_id가 st.session_state.chats에 존재하는지 다시 한번 확인
    if current_chat_id not in st.session_state.chats:
        st.error("오류: 현재 채팅 세션을 찾을 수 없습니다. 새 채팅을 시작해 주세요.")
        st.stop()  # 더 이상 진행하지 않음

    current_chat_data = st.session_state.chats[current_chat_id]

    current_chat_data["messages"].append({"role": "user", "content": prompt})
    history_for_llm = current_chat_data["history_for_llm"]

    # 스피너를 채팅창 대신 사이드바나 특정 영역에 표시할 수도 있음
    with st.spinner("PetGPT가 답변을 준비하고 있어요... 🐾"):
        try:
            llm_response = run_llm(query=prompt, chat_history=history_for_llm)

            # --- !!! main.py에서 타입 확인 !!! ---
            print("--- Debug in main.py: Checking llm_response['source_documents'] ---")
            if "source_documents" in llm_response and llm_response["source_documents"]:
                print(f"Type of llm_response['source_documents'] in main.py: {type(llm_response['source_documents'])}")
                print(f"Number of items in source_documents: {len(llm_response['source_documents'])}")
                for i, doc_main_check in enumerate(llm_response["source_documents"]):
                    print(f"Doc {i} type in main.py: {type(doc_main_check)}")
                    if hasattr(doc_main_check, 'metadata'):
                         print(f"  Doc {i} has metadata in main.py: {doc_main_check.metadata}")
                    else:
                         print(f"  Doc {i} does NOT have metadata attribute in main.py.")
            else:
                print("No source_documents in llm_response or it's empty in main.py.")
            print("--- End Debug in main.py ---")
            # --- !!! 디버깅 코드 끝 !!! ---

            raw_ai_answer = llm_response["result"]
            # AI 답변 정제
            cleaned_ai_answer = clean_response_text(raw_ai_answer)

            sources = set()
            if llm_response.get(
                "source_documents"
            ):  # source_documents가 없을 수도 있음
                sources = set(
                    [doc.metadata["source"] for doc in llm_response["source_documents"]]
                )



            source_documents_from_llm = llm_response.get("source_documents", [])

            # --- !!! created_sources_string 호출 직전 타입 확인 !!! ---
            print("--- Debug in main.py: Types JUST BEFORE calling created_sources_string ---")
            if source_documents_from_llm:
                for i, doc_before_call in enumerate(source_documents_from_llm):
                    print(f"Doc {i} type before call: {type(doc_before_call)}")
            else:
                print("source_documents_from_llm is empty before call.")
            print("--- End Debug ---")

            # 출처 문자열 생성 (클릭 가능한 링크 포함)
            sources_html = created_sources_string(sources)

            # 최종 AI 응답 컨텐츠 (HTML 형식으로 조합)
            # Markdown을 사용하여 줄바꿈 등을 처리하고, st.markdown(unsafe_allow_html=True)로 렌더링
            formatted_response_content_for_display = (
                f"{cleaned_ai_answer}<br><br>{sources_html}"
            )

            current_chat_data["messages"].append(
                {"role": "ai", "content": formatted_response_content_for_display}
            )

            history_for_llm.append(("human", prompt))
            history_for_llm.append(
                ("ai", raw_ai_answer)
            )  # LLM 히스토리에는 정제되지 않은 원본 답변 저장

            if len(current_chat_data["messages"]) == 2:  # 사용자 질문 1개, AI 답변 1개
                chat_idx_in_list = -1
                for i, chat_item in enumerate(st.session_state.chat_history_list):
                    if chat_item["id"] == current_chat_id:
                        chat_idx_in_list = i
                        break
                if chat_idx_in_list != -1:
                    new_title_prefix = "질문: "  # 접두사 추가
                    # 사용자 질문(prompt)을 기반으로 제목 생성, 길이 제한
                    title_content = prompt[:25]  # 제목으로 사용할 내용 길이 (예: 25자)
                    new_title = (
                        new_title_prefix
                        + title_content
                        + ("..." if len(prompt) > 25 else "")
                    )
                    st.session_state.chat_history_list[chat_idx_in_list][
                        "title"
                    ] = new_title

        except Exception as e:
            st.error(f"죄송합니다, 응답을 생성하는 중 오류가 발생했습니다: {e}")
            current_chat_data["messages"].append(
                {"role": "ai", "content": f"오류: {e}"}
            )

    st.rerun()
