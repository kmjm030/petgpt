import unittest
from unittest.mock import patch, MagicMock
import pytest
from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
import os
import sys
import tempfile
import shutil
import numpy as np

# 상위 디렉토리를 PATH에 추가하여 petgpt_chatbot 모듈 import 가능하게 함
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from petgpt_chatbot.rag import (
    load_documents_from_db,
    preprocess_text,
    split_documents,
    embed_and_store_documents,
    retrieve_relevant_documents,
    get_qna_answer,
    check_medical_content,
    create_rag_pipeline
)
from petgpt_chatbot.prompts import format_qna_rag_prompt, format_rag_response


class TestRAG(unittest.TestCase):
    
    @patch('petgpt_chatbot.rag.get_mysql_connection')
    def test_load_documents_from_db(self, mock_get_connection):
        # 가짜 커서와 연결 객체 설정
        mock_cursor = MagicMock()
        mock_connection = MagicMock()
        mock_connection.cursor.return_value = mock_cursor
        mock_get_connection.return_value = mock_connection
        
        # MySQL에서 반환될 가짜 데이터 설정
        mock_cursor.fetchall.return_value = [
            (1, "강아지 사료", "강아지 사료에 관한 <b>상세 정보</b>입니다.", "사료"),
            (2, "고양이 장난감", "고양이 장난감에 관한 <i>제품 설명</i>입니다.", "장난감")
        ]
        
        # 필드명 설정
        mock_cursor.description = [
            ("id", None, None, None, None, None, None),
            ("title", None, None, None, None, None, None),
            ("content", None, None, None, None, None, None),
            ("category", None, None, None, None, None, None)
        ]
        
        # 함수 호출
        documents = load_documents_from_db("pet_knowledge")
        
        # 검증
        assert len(documents) == 2
        assert isinstance(documents[0], Document)
        assert documents[0].page_content == "강아지 사료에 관한 <b>상세 정보</b>입니다."
        assert documents[0].metadata["title"] == "강아지 사료"
        assert documents[0].metadata["category"] == "사료"
        assert documents[1].metadata["title"] == "고양이 장난감"
    
    def test_preprocess_text_removes_html(self):
        # HTML 태그가 포함된 테스트 텍스트
        html_text = "<p>이것은 <b>굵은</b> 텍스트와 <i>기울임꼴</i> 텍스트입니다.</p>"
        
        # 함수 호출
        cleaned_text = preprocess_text(html_text)
        
        # 검증
        assert "<p>" not in cleaned_text
        assert "<b>" not in cleaned_text
        assert "<i>" not in cleaned_text
        assert "이것은 굵은 텍스트와 기울임꼴 텍스트입니다." == cleaned_text
    
    def test_split_documents(self):
        # 테스트용 문서 생성
        docs = [
            Document(
                page_content="이것은 첫 번째 문서입니다. " * 20,  # 긴 내용
                metadata={"source": "doc1", "title": "문서1"}
            ),
            Document(
                page_content="이것은 두 번째 문서입니다. " * 20,  # 긴 내용
                metadata={"source": "doc2", "title": "문서2"}
            )
        ]
        
        # 함수 호출
        split_docs = split_documents(docs, chunk_size=100, chunk_overlap=20)
        
        # 검증
        assert len(split_docs) > len(docs)  # 더 많은 청크로 분할되었는지 확인
        for doc in split_docs:
            assert isinstance(doc, Document)
            assert len(doc.page_content) <= 100 + 20  # chunk_size + 최대 overlap
            # 메타데이터 유지 확인
            assert "source" in doc.metadata
            assert "title" in doc.metadata

    @patch('petgpt_chatbot.rag.get_settings')
    @patch('petgpt_chatbot.rag.get_embedding_model')
    @patch('petgpt_chatbot.rag.Chroma')
    def test_embed_and_store_documents(self, mock_chroma_class, mock_get_embedding_model, mock_get_settings):
        # 임시 디렉토리 생성
        temp_dir = tempfile.mkdtemp()
        try:
            # 가짜 설정 객체 설정
            mock_settings = MagicMock()
            mock_settings.KNOWLEDGE_COLLECTION_NAME = "test_collection"
            mock_settings.CHROMA_DB_PATH = temp_dir
            mock_get_settings.return_value = mock_settings
            
            # 가짜 임베딩 모델 설정
            mock_embedding_model = MagicMock()
            mock_get_embedding_model.return_value = mock_embedding_model
            
            # 가짜 임베딩 결과 설정 (2차원 리스트 형태)
            mock_embedding_model.embed_documents.return_value = [
                [0.1, 0.2, 0.3],  # 첫 번째 문서의 임베딩
                [0.4, 0.5, 0.6]   # 두 번째 문서의 임베딩
            ]
            
            # 가짜 ChromaDB 설정
            mock_chroma_instance = MagicMock()
            mock_chroma_class.from_documents.return_value = mock_chroma_instance
            
            # 테스트용 문서 생성
            docs = [
                Document(page_content="강아지 사료에 관한 정보", metadata={"source": "doc1", "title": "강아지 사료"}),
                Document(page_content="고양이 장난감에 관한 정보", metadata={"source": "doc2", "title": "고양이 장난감"})
            ]
            
            # 함수 호출
            vectorstore = embed_and_store_documents(
                docs, 
                collection_name="test_collection",
                persist_directory=temp_dir
            )
            
            # 검증
            assert vectorstore is mock_chroma_instance
            mock_get_embedding_model.assert_called_once()
            
            # ChromaDB가 올바른 파라미터로 호출되었는지 확인
            mock_chroma_class.from_documents.assert_called_once()
            
            # 호출 인자 확인 - kwargs만 검증 (전체 args는 생략)
            kwargs = mock_chroma_class.from_documents.call_args.kwargs
            assert kwargs["collection_name"] == "test_collection"
            assert kwargs["persist_directory"] == temp_dir
        
        finally:
            # 임시 디렉토리 정리
            shutil.rmtree(temp_dir)
    
    @patch('petgpt_chatbot.rag.get_embedding_model')
    def test_retrieve_relevant_documents(self, mock_get_embedding_model):
        # 가짜 임베딩 모델 설정
        mock_embedding_model = MagicMock()
        mock_get_embedding_model.return_value = mock_embedding_model
        
        # 가짜 임베딩 결과 설정 (쿼리에 대한 임베딩)
        mock_embedding_model.embed_query.return_value = [0.7, 0.8, 0.9]
        
        # 가짜 ChromaDB 설정
        mock_vectorstore = MagicMock()
        
        # 가짜 검색 결과 설정
        mock_retrieved_docs = [
            Document(page_content="강아지 사료에 관한 정보", metadata={"source": "doc1", "title": "강아지 사료"}),
            Document(page_content="강아지 간식에 관한 정보", metadata={"source": "doc3", "title": "강아지 간식"})
        ]
        mock_vectorstore.similarity_search.return_value = mock_retrieved_docs
        
        # 함수 호출
        query = "강아지 식품 추천해주세요"
        retrieved_docs = retrieve_relevant_documents(query, mock_vectorstore, k=2)
        
        # 검증
        assert retrieved_docs == mock_retrieved_docs
        mock_get_embedding_model.assert_called_once()
        mock_embedding_model.embed_query.assert_called_once_with(query)
        mock_vectorstore.similarity_search.assert_called_once()
        
        # similarity_search가 올바른 파라미터로 호출되었는지 확인
        call_args = mock_vectorstore.similarity_search.call_args
        assert call_args[0][0] == query  # 첫 번째 인자는 쿼리
        assert call_args[1]["k"] == 2  # k 값이 올바른지 확인
    
    def test_format_qna_rag_prompt(self):
        # 테스트용 쿼리와 문서 생성
        query = "강아지 사료 추천해주세요"
        context_docs = [
            Document(page_content="강아지 사료는 연령과 크기에 맞게 선택해야 합니다.", 
                     metadata={"title": "강아지 사료 선택 가이드", "source": "doc1"}),
            Document(page_content="고품질 단백질이 풍부한 사료가 강아지 건강에 좋습니다.", 
                     metadata={"title": "강아지 영양 정보", "source": "doc2"})
        ]
        
        # 함수 호출
        prompt = format_qna_rag_prompt(query, context_docs)
        
        # 검증
        assert isinstance(prompt, str)
        assert "당신은 PetGPT, 반려동물 케어 전문가입니다" in prompt
        assert "--- 컨텍스트 정보 ---" in prompt
        assert "문서 1: 강아지 사료는 연령과 크기에 맞게 선택해야 합니다." in prompt
        assert "문서 2: 고품질 단백질이 풍부한 사료가 강아지 건강에 좋습니다." in prompt
        assert "--- 사용자 질문 ---" in prompt
        assert query in prompt
    
    def test_format_rag_response(self):
        # 테스트용 응답 생성
        answer = "강아지 사료는 연령에 맞게 선택하는 것이 중요합니다."
        sources = ["강아지 사료 선택 가이드", "강아지 영양 정보"]
        
        # 함수 호출 - 일반 응답
        response = format_rag_response(answer, sources, has_medical_content=False)
        
        # 검증 - 일반 응답
        assert answer in response
        assert "[출처: " in response
        for source in sources:
            assert source in response
        assert "수의사와 상담하시기 바랍니다" not in response
        
        # 함수 호출 - 의료 관련 응답
        medical_response = format_rag_response(answer, sources, has_medical_content=True)
        
        # 검증 - 의료 관련 응답
        assert answer in medical_response
        assert "[출처: " in medical_response
        assert "수의사와 상담하시기 바랍니다" in medical_response
    
    def test_check_medical_content(self):
        # 의료 관련 텍스트
        medical_text = "강아지가 기침 증상을 보이면 수의사에게 진단을 받아보세요."
        assert check_medical_content(medical_text) == True
        
        # 일반 텍스트
        normal_text = "강아지 사료는 영양 균형이 중요합니다."
        assert check_medical_content(normal_text) == False
    
    @patch('petgpt_chatbot.rag.create_rag_pipeline')
    def test_get_qna_answer(self, mock_create_pipeline):
        # 가짜 파이프라인 생성
        mock_pipeline = MagicMock()
        mock_result = {
            "answer": "강아지 사료는 연령, 크기, 활동량에 맞게 선택해야 합니다.\n\n[출처: 강아지 사료 선택 가이드, 강아지 영양 정보]",
            "sources": ["강아지 사료 선택 가이드", "강아지 영양 정보"]
        }
        mock_pipeline.invoke.return_value = mock_result
        mock_create_pipeline.return_value = mock_pipeline
        
        # 함수 호출
        query = "강아지 사료 추천해주세요"
        answer, sources = get_qna_answer(query)
        
        # 검증
        assert isinstance(answer, str)
        assert "강아지 사료는 연령, 크기, 활동량에 맞게 선택해야 합니다." in answer
        assert "[출처: " in answer
        assert sources == ["강아지 사료 선택 가이드", "강아지 영양 정보"]
        
        # 함수 호출이 올바르게 이루어졌는지 확인
        mock_create_pipeline.assert_called_once()
        mock_pipeline.invoke.assert_called_once_with(query)
    
    @patch('petgpt_chatbot.rag.get_llm')
    @patch('petgpt_chatbot.rag.get_or_create_vectorstore')
    def test_create_rag_pipeline(self, mock_get_vectorstore, mock_get_llm):
        # 가짜 LLM 설정
        mock_llm_instance = MagicMock()
        mock_get_llm.return_value = mock_llm_instance
        
        # 가짜 벡터스토어 설정
        mock_vectorstore = MagicMock()
        mock_retriever = MagicMock()
        mock_vectorstore.as_retriever.return_value = mock_retriever
        mock_get_vectorstore.return_value = mock_vectorstore
        
        # 함수 호출
        rag_pipeline = create_rag_pipeline()
        
        # 검증
        assert rag_pipeline is not None
        mock_get_vectorstore.assert_called_once()
        mock_get_llm.assert_called_once()
        mock_vectorstore.as_retriever.assert_called_once()
        
        # LCEL 파이프라인은 dictionary 형태일 수 있으므로 형식보다는 핵심 요소 확인
        assert isinstance(rag_pipeline, dict) or callable(rag_pipeline)
            
if __name__ == "__main__":
    unittest.main() 