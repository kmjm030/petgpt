"""
PetGPT 챗봇 LLM 및 Embedding 모델 초기화 모듈
"""
from typing import Union, Any

from langchain_google_genai import ChatGoogleGenerativeAI, GoogleGenerativeAIEmbeddings
from langchain_community.embeddings import SentenceTransformerEmbeddings

from petgpt_chatbot.config import get_settings

# 모델명 상수
GEMINI_MODEL_NAME = "gemini-2.5-flash-preview-04-17"  # 최신 모델명으로 업데이트 필요
GEMINI_EMBEDDING_MODEL_NAME = "embedding-001"
DEFAULT_SAFETY_SETTINGS = [
    {
        "category": "HARM_CATEGORY_HARASSMENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    },
    {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
    }
]


def get_llm() -> ChatGoogleGenerativeAI:
    """
    Google Gemini 모델 인스턴스를 생성하여 반환

    Returns:
        ChatGoogleGenerativeAI: 구성된 Gemini LLM 인스턴스
    """
    settings = get_settings()
    
    # Gemini 모델 인스턴스 생성
    llm = ChatGoogleGenerativeAI(
        model=GEMINI_MODEL_NAME,
        google_api_key=settings.GOOGLE_API_KEY,
        temperature=0.3,  # 낮은 temperature로 보다 사실적인 답변 유도
        top_p=0.95,
        max_output_tokens=settings.MAX_TOKENS_PER_RESPONSE,
        safety_settings=DEFAULT_SAFETY_SETTINGS
    )
    
    return llm


def get_embedding_model() -> Union[GoogleGenerativeAIEmbeddings, SentenceTransformerEmbeddings]:
    """
    임베딩 모델 인스턴스를 생성하여 반환
    설정에 따라 Google Gemini 임베딩 또는 Sentence-Transformers 임베딩 반환

    Returns:
        Union[GoogleGenerativeAIEmbeddings, SentenceTransformerEmbeddings]: 구성된 임베딩 모델 인스턴스
    """
    settings = get_settings()
    
    if settings.EMBEDDING_MODEL_TYPE.lower() == "gemini":
        # Gemini 임베딩 모델 사용
        embedding_model = GoogleGenerativeAIEmbeddings(
            google_api_key=settings.GOOGLE_API_KEY,
            model=GEMINI_EMBEDDING_MODEL_NAME,
            task_type="retrieval_document",
            title="PetGPT 지식 검색"
        )
    else:
        # Sentence-Transformers 모델 사용 (한국어 지원 모델)
        embedding_model = SentenceTransformerEmbeddings(
            model_name=settings.SBERT_MODEL_NAME
        )
    
    return embedding_model 