"""
PetGPT 챗봇 LLM 및 Embedding 모델 초기화 모듈
"""

from typing import Union, Any, Dict
import traceback
import logging
import os

from langchain_core.language_models.chat_models import BaseChatModel
from langchain_core.prompts import (
    ChatPromptTemplate,
    PromptTemplate,
    HumanMessagePromptTemplate,
)
from langchain_core.messages import SystemMessage, HumanMessage, AIMessage
import google.generativeai as genai
from langchain_google_genai import ChatGoogleGenerativeAI, GoogleGenerativeAIEmbeddings
from langchain_community.embeddings import SentenceTransformerEmbeddings

from petgpt_chatbot.config import get_settings

# 로깅 설정
logger = logging.getLogger(__name__)

# 모델명 상수
GEMINI_MODEL_NAME = "gemini-2.5-flash-preview-04-17"  # 최신 모델명으로 업데이트
GEMINI_EMBEDDING_MODEL_NAME = "models/text-embedding-004"

# 안전 설정
DEFAULT_SAFETY_SETTINGS = {
    "HARM_CATEGORY_HARASSMENT": "BLOCK_MEDIUM_AND_ABOVE",
    "HARM_CATEGORY_HATE_SPEECH": "BLOCK_MEDIUM_AND_ABOVE",
    "HARM_CATEGORY_SEXUALLY_EXPLICIT": "BLOCK_MEDIUM_AND_ABOVE",
    "HARM_CATEGORY_DANGEROUS_CONTENT": "BLOCK_MEDIUM_AND_ABOVE",
}


class MockChatModel(BaseChatModel):
    """
    LLM 초기화 실패시 사용할 수 있는 간단한 Mock 모델
    """

    def _call(self, messages, stop=None, run_manager=None, **kwargs):
        """간단한 응답 생성"""
        logger.warning("MockChatModel을 사용하여 응답을 생성합니다.")
        return AIMessage(
            content="죄송합니다. 현재 시스템 점검 중입니다. 잠시 후 다시 시도해 주세요."
        )

    async def _agenerate(self, messages, stop=None, run_manager=None, **kwargs):
        """간단한 응답 생성 (비동기)"""
        from langchain_core.outputs import (
            ChatGenerationChunk,
            ChatGeneration,
            ChatResult,
        )

        logger.warning("MockChatModel을 사용하여 비동기 응답을 생성합니다.")
        response = ChatResult(
            generations=[
                ChatGeneration(
                    message=AIMessage(
                        content="죄송합니다. 현재 시스템 점검 중입니다. 잠시 후 다시 시도해 주세요."
                    )
                )
            ]
        )
        return response

    @property
    def _llm_type(self):
        """모델 타입 반환"""
        return "mock-chat-model"


def test_google_api_key(api_key: str) -> bool:
    """
    Google API 키 유효성 테스트

    Args:
        api_key (str): 테스트할 Google API 키

    Returns:
        bool: API 키 유효성 여부
    """
    try:
        # Google Generative AI 초기화
        genai.configure(api_key=api_key)

        # 가장 간단한 쿼리 테스트
        model = genai.GenerativeModel(GEMINI_MODEL_NAME)
        response = model.generate_content("안녕하세요")

        return True
    except Exception as e:
        logger.error(f"Google API 키 테스트 실패: {str(e)}")
        return False


def get_llm() -> BaseChatModel:
    """
    Google Gemini 모델 인스턴스를 생성하여 반환
    실패 시 MockChatModel 반환

    Returns:
        BaseChatModel: 구성된 LLM 인스턴스
    """
    settings = get_settings()

    try:
        # 설정에서 Mock LLM 사용 여부 확인
        if settings.USE_MOCK_LLM and settings.USE_MOCK_LLM.lower() == "true":
            logger.info("설정에 따라 MockChatModel을 사용합니다.")
            return MockChatModel()

        # API 키 확인
        api_key = settings.GOOGLE_API_KEY
        if not api_key:
            logger.error("GOOGLE_API_KEY가 설정되지 않았습니다.")
            return MockChatModel()

        # API 키 테스트
        if not test_google_api_key(api_key):
            logger.error("Google API 키가 유효하지 않습니다.")
            return MockChatModel()

        # 모델명 확인 및 설정
        model_name = (
            settings.GEMINI_MODEL_NAME
            if settings.GEMINI_MODEL_NAME
            else GEMINI_MODEL_NAME
        )
        logger.debug(f"LLM 초기화 시작: 모델={model_name}")

        # 최대 토큰 설정
        max_output_tokens = (
            int(settings.MAX_TOKENS_PER_RESPONSE)
            if settings.MAX_TOKENS_PER_RESPONSE
            else 512
        )

        # Gemini 모델 직접 초기화 테스트
        try:
            genai.configure(api_key=api_key)
            temp_model = genai.GenerativeModel(model_name)
            logger.debug("Google GenerativeAI 직접 초기화 성공")
        except Exception as genai_err:
            logger.error(f"Google GenerativeAI 직접 초기화 실패: {str(genai_err)}")
            return MockChatModel()

        # LangChain GoogleGenerativeAI 초기화
        llm = ChatGoogleGenerativeAI(
            model=model_name,
            google_api_key=api_key,
            temperature=0.3,
            top_p=0.95,
            max_output_tokens=max_output_tokens,
        )

        # 간단한 테스트
        test_response = llm.invoke("테스트 메시지입니다.")
        logger.debug(f"테스트 응답 생성 성공: {test_response.content[:30]}...")

        logger.debug(f"LLM 초기화 완료: {type(llm).__name__}")
        return llm
    except Exception as e:
        error_text = traceback.format_exc()
        logger.error(f"LLM 초기화 중 오류 발생: {str(e)}\n{error_text}")
        logger.warning("LLM 초기화 실패로 MockChatModel을 대신 사용합니다.")
        return MockChatModel()


def get_embedding_model() -> (
    Union[GoogleGenerativeAIEmbeddings, SentenceTransformerEmbeddings]
):
    """
    임베딩 모델 인스턴스를 생성하여 반환
    설정에 따라 Google Gemini 임베딩 또는 Sentence-Transformers 임베딩 반환

    Returns:
        Union[GoogleGenerativeAIEmbeddings, SentenceTransformerEmbeddings]: 구성된 임베딩 모델 인스턴스
    """
    settings = get_settings()

    try:
        # 사용자 지정 임베딩 모델 타입 확인
        embedding_model_type = (
            settings.EMBEDDING_MODEL_TYPE.lower()
            if settings.EMBEDDING_MODEL_TYPE
            else "sbert"
        )

        if embedding_model_type == "gemini":
            logger.debug(
                f"Gemini 임베딩 모델 초기화 시작: 모델={GEMINI_EMBEDDING_MODEL_NAME}"
            )

            # API 키 확인
            api_key = settings.GOOGLE_API_KEY
            if not api_key:
                logger.error("GOOGLE_API_KEY가 설정되지 않았습니다.")
                raise ValueError("GOOGLE_API_KEY가 필요합니다")

            # Gemini 임베딩 모델 사용
            embedding_model = GoogleGenerativeAIEmbeddings(
                google_api_key=api_key,
                model=GEMINI_EMBEDDING_MODEL_NAME,
                task_type="retrieval_document",
                title="PetGPT 지식 검색",
            )

            # 테스트 임베딩 생성
            test_embedding = embedding_model.embed_query("임베딩 테스트")
            logger.debug(
                f"Gemini 임베딩 모델 테스트 성공: 벡터 차원={len(test_embedding)}"
            )
            logger.debug("Gemini 임베딩 모델 초기화 완료")
        else:
            logger.debug(
                f"SentenceTransformer 임베딩 모델 초기화 시작: 모델={settings.SBERT_MODEL_NAME}"
            )
            # Sentence-Transformers 모델 사용 (한국어 지원 모델)
            model_name = (
                settings.SBERT_MODEL_NAME
                if settings.SBERT_MODEL_NAME
                else "jhgan/ko-sroberta-multitask"
            )
            embedding_model = SentenceTransformerEmbeddings(model_name=model_name)
            logger.debug("SentenceTransformer 임베딩 모델 초기화 완료")

        return embedding_model
    except Exception as e:
        error_text = traceback.format_exc()
        logger.error(f"임베딩 모델 초기화 중 오류 발생: {str(e)}\n{error_text}")

        # 기본 Sentence-Transformers 모델로 대체
        logger.warning(
            "임베딩 모델 초기화 실패로 기본 SentenceTransformer 모델을 사용합니다."
        )
        return SentenceTransformerEmbeddings(model_name="jhgan/ko-sroberta-multitask")
