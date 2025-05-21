import os
from typing import List, Dict, Any, Tuple
import json
import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv

from langchain_core.documents import Document
from langchain_core.messages import HumanMessage, AIMessage, SystemMessage, BaseMessage
from langchain_google_genai import ChatGoogleGenerativeAI
import google.generativeai as genai
from core import run_llm, INDEX_NAME

load_dotenv()

app = FastAPI(
    title="PetGPT API",
    description="API for PetGPT, a RAG-powered chatbot for pet information.",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:80", "http://localhost:80"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class MessagePart(BaseModel):
    text: str


class ChatMessage(BaseModel):
    role: str
    parts: List[MessagePart]


class ChatQuery(BaseModel):
    query: str
    chat_history: List[ChatMessage] = []


class SummarizeRequest(BaseModel):
    conversation_text: str


class SuggestRepliesRequest(BaseModel):
    context_message: str


class DocumentModel(BaseModel):
    page_content: str
    metadata: Dict[str, Any]


class ChatResponse(BaseModel):
    query: str
    result: str
    source_documents: List[DocumentModel]


# --- Helper Functions ---
def convert_frontend_history_to_langchain_messages(
    frontend_history: List[ChatMessage],
) -> List[BaseMessage]:
    messages: List[BaseMessage] = []
    for msg_data in frontend_history:
        role = msg_data.role.lower()
        content = msg_data.parts[0].text if msg_data.parts else ""
        if role == "user" or role == "human":
            messages.append(HumanMessage(content=content))
        elif role == "model" or role == "ai":
            messages.append(AIMessage(content=content))
        elif role == "system":
            messages.append(SystemMessage(content=content))
    return messages


def serialize_documents(documents: List[Document]) -> List[Dict[str, Any]]:
    serialized = []
    if documents:
        for doc in documents:
            serialized.append(
                {
                    "page_content": doc.page_content,
                    "metadata": doc.metadata if hasattr(doc, "metadata") else {},
                }
            )
    return serialized


# --- API 엔드포인트 ---
@app.post("/api/chat-with-rag", response_model=ChatResponse)
async def chat_with_rag_endpoint(request: ChatQuery):
    print(f"Received query: {request.query}")
    print(f"Received chat_history (raw from frontend): {request.chat_history}")

    # 프론트엔드의 chatHistory (user/model role)를 Langchain 메시지 형식으로 변환
    langchain_chat_history: List[BaseMessage] = (
        convert_frontend_history_to_langchain_messages(request.chat_history)
    )
    print(f"Converted langchain_chat_history for run_llm: {langchain_chat_history}")

    # core.py의 run_llm 호출
    # run_llm의 chat_history 파라미터는 List[Dict[str, Any]] 이지만, 내부적으로 Langchain Message 객체를 기대
    response_data = run_llm(query=request.query, chat_history=langchain_chat_history)

    # source_documents를 직렬화 가능한 형태로 변환
    serialized_sources = serialize_documents(response_data.get("source_documents", []))

    return ChatResponse(
        query=response_data.get("query", request.query),
        result=response_data.get("result", "죄송합니다. 답변을 생성하지 못했습니다."),
        source_documents=serialized_sources,
    )


@app.post("/api/summarize")
async def summarize_endpoint(request: SummarizeRequest):
    try:
        from langchain_google_genai import ChatGoogleGenerativeAI

        chat = ChatGoogleGenerativeAI(
            model="gemini-2.5-flash-preview-05-20",
            google_api_key=os.environ.get("GOOGLE_API_KEY"),
        )
        prompt_template = f"다음 대화 내용을 한국어로 간결하게 요약해 주세요:\n\n---\n{request.conversation_text}\n---"
        summary_result = chat.invoke(prompt_template)
        summary_text = summary_result.content
        return {"summary": summary_text}
    except Exception as e:
        print(f"Summarization error: {e}")
        return {"summary": f"요약 중 오류 발생: {e}"}


@app.post("/api/suggest-replies")
async def suggest_replies_endpoint(
    request: SuggestRepliesRequest,
) -> Dict[str, List[str]]:
    google_api_key = os.environ.get("GOOGLE_API_KEY")

    try:
        genai.configure(api_key=google_api_key)

        schema = {
            "type": "OBJECT",
            "properties": {"replies": {"type": "ARRAY", "items": {"type": "STRING"}}},
            "required": ["replies"],
        }

        model_name = (
            "gemini-2.5-flash-preview-05-20"
        )

        model = genai.GenerativeModel(
            model_name=model_name, 
            generation_config=genai.types.GenerationConfig(
                response_mime_type="application/json",  
                response_schema=schema, 
            ),
        )

        prompt = (
            f'이전 대화 메시지: "{request.context_message}"\n\n'
            "위 메시지에 대한 응답으로 사용될 수 있는 짧고 자연스러운 한국어 빠른 답변 3가지를 제안해 주세요. "
            "각 답변은 1-5단어 사이로 간결해야 합니다."
        )

        response = await model.generate_content_async(prompt) 

        try:
            response_text = ""
            if (
                response.candidates
                and response.candidates[0].content
                and response.candidates[0].content.parts
            ):
                response_text = response.candidates[0].content.parts[0].text
            else: 
                response_text = response.text

            if not response_text:
                print("Error: Model returned an empty response text.")
                return {"suggestions": ["모델 응답 없음"]}

            parsed_json = json.loads(response_text)
            suggestions = parsed_json.get("replies", [])
            if (
                not suggestions and "replies" not in parsed_json
            ):  
                print(f"Warning: 'replies' key not found in parsed JSON: {parsed_json}")
                suggestions = ["응답 형식에서 'replies' 키를 찾을 수 없음"]

        except json.JSONDecodeError:
            print(f"JSON decode error for suggestions. Raw response: {response_text}")
            suggestions = ["제안 파싱 오류 (JSON 형식 아님)"]
        except AttributeError:
            print(
                f"AttributeError: Could not extract text from response. Full response: {response}"
            )
            suggestions = ["모델 응답 구조 오류"]
        except Exception as e_parse:
            print(
                f"Unexpected error during response parsing: {e_parse}. Raw response: {response_text if 'response_text' in locals() else 'N/A'}"
            )
            suggestions = ["응답 처리 중 알 수 없는 오류"]

        return {"suggestions": suggestions}

    except genai.types.generation_types.BlockedPromptException as bpe:
        print(f"Suggest replies error: Prompt blocked - {bpe}")
        return {
            "suggestions": [f"요청 내용에 부적절한 내용이 포함되어 처리할 수 없습니다."]
        }
    except Exception as e:
        print(f"Suggest replies error: {type(e).__name__} - {e}")
        return {"suggestions": [f"제안 생성 중 오류 발생: {type(e).__name__}"]}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
