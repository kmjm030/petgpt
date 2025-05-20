"""
PetGPT 챗봇 LLM 및 Embedding 모델 초기화 테스트
"""
import os
from unittest.mock import patch, MagicMock

import pytest
from langchain_google_genai import ChatGoogleGenerativeAI, GoogleGenerativeAIEmbeddings

# 추후 구현할 llm_init.py에서 함수를 임포트
from petgpt_chatbot.llm_init import get_llm, get_embedding_model


@patch("petgpt_chatbot.llm_init.get_settings")
@patch("petgpt_chatbot.llm_init.ChatGoogleGenerativeAI")
def test_get_llm_returns_gemini_instance(mock_chat_gemini, mock_get_settings):
    """
    get_llm() 함수가 ChatGoogleGenerativeAI 인스턴스를 반환하는지 테스트
    """
    # Arrange
    mock_settings = MagicMock()
    mock_settings.GOOGLE_API_KEY = "test_api_key"
    mock_settings.MAX_TOKENS_PER_RESPONSE = 512
    mock_get_settings.return_value = mock_settings
    
    mock_chat_gemini.return_value = MagicMock(spec=ChatGoogleGenerativeAI)
    
    # Act
    llm = get_llm()
    
    # Assert
    mock_chat_gemini.assert_called_once()
    assert isinstance(llm, MagicMock)
    assert llm == mock_chat_gemini.return_value


@patch("petgpt_chatbot.llm_init.get_settings")
@patch("petgpt_chatbot.llm_init.GoogleGenerativeAIEmbeddings")
def test_get_embedding_model_returns_gemini_embedding_instance(mock_gemini_embeddings, mock_get_settings):
    """
    get_embedding_model() 함수가 GoogleGenerativeAIEmbeddings 인스턴스를 반환하는지 테스트
    (EMBEDDING_MODEL_TYPE=gemini 경우)
    """
    # Arrange
    mock_settings = MagicMock()
    mock_settings.GOOGLE_API_KEY = "test_api_key"
    mock_settings.EMBEDDING_MODEL_TYPE = "gemini"
    mock_get_settings.return_value = mock_settings
    
    mock_gemini_embeddings.return_value = MagicMock(spec=GoogleGenerativeAIEmbeddings)
    
    # Act
    embedding_model = get_embedding_model()
    
    # Assert
    mock_gemini_embeddings.assert_called_once()
    assert isinstance(embedding_model, MagicMock)
    assert embedding_model == mock_gemini_embeddings.return_value


@patch("petgpt_chatbot.llm_init.get_settings")
@patch("petgpt_chatbot.llm_init.SentenceTransformerEmbeddings")
def test_get_embedding_model_returns_sbert_instance(mock_sbert_embeddings, mock_get_settings):
    """
    get_embedding_model() 함수가 SentenceTransformerEmbeddings 인스턴스를 반환하는지 테스트
    (EMBEDDING_MODEL_TYPE=sbert 경우)
    """
    # Arrange
    mock_settings = MagicMock()
    mock_settings.EMBEDDING_MODEL_TYPE = "sbert"
    mock_settings.SBERT_MODEL_NAME = "jhgan/ko-sroberta-multitask"
    mock_get_settings.return_value = mock_settings
    
    mock_sbert_embeddings.return_value = MagicMock()
    
    # Act
    embedding_model = get_embedding_model()
    
    # Assert
    mock_sbert_embeddings.assert_called_once()
    assert embedding_model == mock_sbert_embeddings.return_value


@patch("petgpt_chatbot.llm_init.get_settings")
def test_llm_uses_settings_for_configuration(mock_get_settings):
    """
    get_llm() 함수가 Settings에서 설정 정보를 가져오는지 테스트
    """
    # Arrange
    mock_settings = MagicMock()
    mock_settings.GOOGLE_API_KEY = "test_api_key"
    mock_settings.MAX_TOKENS_PER_RESPONSE = 512
    mock_get_settings.return_value = mock_settings
    
    with patch("petgpt_chatbot.llm_init.ChatGoogleGenerativeAI") as mock_chat_gemini:
        # Act
        get_llm()
        
        # Assert
        mock_get_settings.assert_called_once()
        call_kwargs = mock_chat_gemini.call_args.kwargs
        assert call_kwargs["google_api_key"] == "test_api_key"
        assert call_kwargs["max_output_tokens"] == 512 