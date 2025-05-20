"""
PetGPT 챗봇 RAG(Retrieval-Augmented Generation) 시스템 모듈
"""
from typing import List, Optional, Dict, Any, Tuple
import re
import os
from bs4 import BeautifulSoup
from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_chroma import Chroma
from langchain_core.vectorstores import VectorStore
from langchain_core.runnables import RunnablePassthrough, RunnableLambda, RunnableParallel
from langchain_core.output_parsers import StrOutputParser

from petgpt_chatbot.db_utils import get_mysql_connection
from petgpt_chatbot.config import get_settings
from petgpt_chatbot.llm_init import get_embedding_model, get_llm
from petgpt_chatbot.prompts import (
    format_qna_rag_prompt, 
    format_rag_response, 
    MEDICAL_KEYWORDS,
    QNA_RAG_PROMPT
)

def load_documents_from_db(table_name: str) -> List[Document]:
    """
    MySQL 데이터베이스에서 문서를 가져와 Document 객체 리스트로 변환
    
    Args:
        table_name (str): 데이터를 가져올 테이블 이름
    
    Returns:
        List[Document]: Document 객체 리스트
    """
    conn = get_mysql_connection()
    cursor = conn.cursor()
    
    try:
        # 테이블에서 모든 데이터 가져오기
        query = f"SELECT * FROM {table_name}"
        cursor.execute(query)
        
        rows = cursor.fetchall()
        field_names = [i[0] for i in cursor.description]
        
        documents = []
        for row in rows:
            # 행을 필드명:값 쌍의 딕셔너리로 변환
            row_dict = {field_names[i]: row[i] for i in range(len(field_names))}
            
            # content 필드가 페이지 내용으로 사용됨
            content_field = "content"
            page_content = row_dict.get(content_field, "")
            
            # content 필드를 제외한 나머지는 메타데이터로 사용
            metadata = {k: v for k, v in row_dict.items() if k != content_field}
            
            # Document 객체 생성 및 리스트에 추가
            document = Document(page_content=page_content, metadata=metadata)
            documents.append(document)
        
        return documents
    finally:
        cursor.close()
        conn.close()


def preprocess_text(text: str) -> str:
    """
    텍스트에서 HTML 태그 제거 등 전처리 작업 수행
    
    Args:
        text (str): 전처리할 텍스트
    
    Returns:
        str: 전처리된 텍스트
    """
    # BeautifulSoup으로 HTML 태그 제거
    soup = BeautifulSoup(text, "html.parser")
    clean_text = soup.get_text(separator=" ", strip=True)
    
    # 추가적인 전처리 작업이 필요하면 여기에 추가
    # 예: 중복 공백 제거
    clean_text = re.sub(r'\s+', ' ', clean_text).strip()
    
    return clean_text


def split_documents(
    documents: List[Document],
    chunk_size: int = 1000,
    chunk_overlap: int = 200
) -> List[Document]:
    """
    문서를 청크로 분할
    
    Args:
        documents (List[Document]): 분할할 Document 객체 리스트
        chunk_size (int, optional): 청크 크기. 기본값은 1000.
        chunk_overlap (int, optional): 청크 간 중복 크기. 기본값은 200.
    
    Returns:
        List[Document]: 분할된 Document 객체 리스트
    """
    # RecursiveCharacterTextSplitter 인스턴스 생성
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
        length_function=len,
        separators=["\n\n", "\n", " ", ""]
    )
    
    # 문서 분할
    split_docs = text_splitter.split_documents(documents)
    
    return split_docs


def embed_and_store_documents(
    documents: List[Document],
    collection_name: Optional[str] = None,
    persist_directory: Optional[str] = None
) -> VectorStore:
    """
    문서를 임베딩하고 ChromaDB에 저장
    
    Args:
        documents (List[Document]): 임베딩할 Document 객체 리스트
        collection_name (Optional[str], optional): ChromaDB 컬렉션 이름. 기본값은 None.
        persist_directory (Optional[str], optional): ChromaDB 저장 디렉토리. 기본값은 None.
    
    Returns:
        VectorStore: ChromaDB 인스턴스
    """
    # 설정에서 기본값 가져오기
    settings = get_settings()
    if collection_name is None:
        collection_name = settings.KNOWLEDGE_COLLECTION_NAME
    
    if persist_directory is None:
        persist_directory = settings.CHROMA_DB_PATH
    
    # 디렉토리가 존재하는지 확인하고 없으면 생성
    if persist_directory and not os.path.exists(persist_directory):
        os.makedirs(persist_directory)
    
    # 임베딩 모델 가져오기
    embedding_model = get_embedding_model()
    
    # ChromaDB에 문서 저장
    vectorstore = Chroma.from_documents(
        documents=documents,
        embedding=embedding_model,
        collection_name=collection_name,
        persist_directory=persist_directory
    )
    
    # 디스크에 저장
    if persist_directory:
        vectorstore.persist()
    
    return vectorstore


def retrieve_relevant_documents(
    query: str,
    vectorstore: VectorStore,
    k: int = 4
) -> List[Document]:
    """
    쿼리와 관련성 높은 문서를 검색
    
    Args:
        query (str): 검색 쿼리
        vectorstore (VectorStore): 벡터 스토어 인스턴스
        k (int, optional): 검색할 문서 수. 기본값은 4.
    
    Returns:
        List[Document]: 관련성 높은 문서 리스트
    """
    # 임베딩 모델 가져오기 (임베딩 일관성을 위해)
    embedding_model = get_embedding_model()
    
    # 쿼리를 임베딩 벡터로 변환 (명시적으로 호출)
    embedding_model.embed_query(query)
    
    # similarity_search를 사용하여 관련 문서 검색
    documents = vectorstore.similarity_search(query, k=k)
    
    return documents


def get_or_create_vectorstore(
    collection_name: Optional[str] = None,
    persist_directory: Optional[str] = None
) -> VectorStore:
    """
    기존 ChromaDB 인스턴스를 가져오거나 없으면 새로 생성
    
    Args:
        collection_name (Optional[str], optional): ChromaDB 컬렉션 이름. 기본값은 None.
        persist_directory (Optional[str], optional): ChromaDB 저장 디렉토리. 기본값은 None.
    
    Returns:
        VectorStore: ChromaDB 인스턴스
    """
    # 설정에서 기본값 가져오기
    settings = get_settings()
    if collection_name is None:
        collection_name = settings.KNOWLEDGE_COLLECTION_NAME
    
    if persist_directory is None:
        persist_directory = settings.CHROMA_DB_PATH
    
    # 임베딩 모델 가져오기
    embedding_model = get_embedding_model()
    
    # 디렉토리가 존재하는지 확인
    if persist_directory and os.path.exists(persist_directory):
        # 기존 ChromaDB 로드
        vectorstore = Chroma(
            collection_name=collection_name,
            embedding_function=embedding_model,
            persist_directory=persist_directory
        )
    else:
        # 디렉토리 생성
        if persist_directory and not os.path.exists(persist_directory):
            os.makedirs(persist_directory)
        
        # 빈 ChromaDB 생성
        vectorstore = Chroma(
            collection_name=collection_name,
            embedding_function=embedding_model,
            persist_directory=persist_directory
        )
        vectorstore.persist()
    
    return vectorstore


def check_medical_content(text: str) -> bool:
    """
    텍스트에 의료 관련 키워드가 포함되어 있는지 확인
    
    Args:
        text (str): 확인할 텍스트
    
    Returns:
        bool: 의료 관련 키워드 포함 여부
    """
    text_lower = text.lower()
    for keyword in MEDICAL_KEYWORDS:
        if keyword in text_lower:
            return True
    return False


def create_rag_pipeline(vectorstore: Optional[VectorStore] = None):
    """
    LCEL 기반 RAG 파이프라인 생성
    
    Args:
        vectorstore (Optional[VectorStore], optional): 벡터 스토어 인스턴스. 기본값은 None.
    
    Returns:
        langchain_core.runnables.Runnable: RAG 파이프라인
    """
    # VectorStore가 없으면 기존 것 로드 또는 생성
    if vectorstore is None:
        vectorstore = get_or_create_vectorstore()
    
    # LLM 가져오기
    llm = get_llm()
    print(f"DEBUG RAG: LLM object type: {type(llm)}")
    
    # 검색기 생성 (Retriever)
    retriever = vectorstore.as_retriever(search_kwargs={"k": 10})
    print(f"DEBUG RAG: Retriever object type: {type(retriever)}")
    
    # 컨텍스트와 질문을 포맷팅하는 함수
    def format_docs(docs):
        return "\n\n".join([f"문서 {i+1}: {doc.page_content}" for i, doc in enumerate(docs)])
    
    # 소스 추출 함수
    def extract_sources(docs):
        sources = []
        for doc in docs:
            if "title" in doc.metadata:
                sources.append(doc.metadata["title"])
        return list(set(sources))  # 중복 제거
    
    # 의료 관련 내용 확인 함수
    def check_medical_content_in_chain(input_dict):
        print(f"DEBUG RAG: input_dict in CMCIC value: {input_dict}")
        print(f"DEBUG RAG: type of input_dict in CMCIC: {type(input_dict)}")
        query = input_dict.get("query", "")
        docs = input_dict.get("docs", [])
        content = query + " " + " ".join([doc.page_content for doc in docs])
        return check_medical_content(content)

    # retriever 결과를 로깅하는 함수
    def log_and_retrieve_docs(query_input): # retriever는 이 함수 스코프 외부에서 정의됨
        actual_query = query_input
        # RunnablePassthrough()가 전체 입력을 그대로 넘기므로, 실제 사용자 쿼리는 query_input 자체가 됨
        print(f"DEBUG RAG: Retrieving documents for query: {actual_query}")
        retrieved_docs = retriever.get_relevant_documents(actual_query) 
        print(f"DEBUG RAG: Retrieved {len(retrieved_docs)} documents.")
        for i, doc_retrieved in enumerate(retrieved_docs):
            print(f"DEBUG RAG: Doc {i+1} Title: {doc_retrieved.metadata.get('title', 'N/A')}, Source: {doc_retrieved.metadata.get('source', 'N/A')}, Type: {doc_retrieved.metadata.get('type', 'N/A')}")
            # print(f"DEBUG RAG: Doc {i+1} Content Snippet: {doc_retrieved.page_content[:100]}...") # 필요시 내용 일부 출력
        return retrieved_docs
    
    # RAG 파이프라인 구성 (LCEL)
    rag_chain = (
        RunnableParallel(
            query=RunnablePassthrough(), # 사용자 질문(str)을 "query" 키로 전달
            docs=RunnablePassthrough() | RunnableLambda(log_and_retrieve_docs) # 사용자 질문(str)을 받아 문서 검색 및 로깅
        )
        | RunnableParallel(
            query=lambda x: x["query"],
            docs=lambda x: x["docs"],
            has_medical_content=RunnableLambda(check_medical_content_in_chain) 
        )
        | RunnableParallel(
            context = RunnableLambda(lambda x: format_docs(x["docs"])),
            query = RunnableLambda(lambda x: x["query"]),
            sources = RunnableLambda(lambda x: extract_sources(x["docs"])),
            has_medical_content = RunnableLambda(lambda x: x["has_medical_content"] or check_medical_content(x["query"]))
        )
        | RunnableParallel(
            raw_answer = RunnableLambda(lambda x: {"context": x["context"], "query": x["query"]}) | QNA_RAG_PROMPT | llm | StrOutputParser(),
            sources = RunnableLambda(lambda x: x["sources"]),
            has_medical_content = RunnableLambda(lambda x: x["has_medical_content"])
        )
        | RunnableParallel(
            answer = RunnableLambda(lambda x: format_rag_response(x["raw_answer"], x["sources"], x["has_medical_content"])),
            sources = RunnableLambda(lambda x: x["sources"])
        )
    )
    
    return rag_chain


def get_qna_answer(query: str, vectorstore: Optional[VectorStore] = None) -> Tuple[str, List[str]]:
    """
    RAG를 사용하여 사용자 질문에 답변 생성
    
    Args:
        query (str): 사용자 질문
        vectorstore (Optional[VectorStore], optional): 벡터 스토어 인스턴스. 기본값은 None.
    
    Returns:
        Tuple[str, List[str]]: (생성된 답변, 출처 목록)
    """
    # LCEL 기반 RAG 파이프라인 생성
    rag_pipeline = create_rag_pipeline(vectorstore)
    
    # 파이프라인 실행
    result = rag_pipeline.invoke(query)
    
    # 만약 응답에 출처 정보가 포함되어 있다면 제거
    answer = result["answer"]
    if "[출처:" in answer:
        answer = answer.split("[출처:")[0].strip()
    
    # 영어 또는 영어-한국어 혼합 질문인지 확인
    is_english_query = bool(re.search(r'[a-zA-Z]{3,}', query))
    
    # 의료 관련 질문인지 판단 (음식/사료 관련 질문은 제외)
    is_food_related = bool(re.search(r'food|feed|사료|먹이|식사|식품|간식|영양|nutrition|diet|dietary', query.lower()))
    
    # 의료 관련 경고 문구가 별도로 포함되어 있고, 음식 관련 질문이 아닌 경우에만 유지
    medical_warning = "※ 참고: 위 정보는 일반적인 안내일 뿐이며, 의학적 진단이나 전문적인 수의학 조언을 대체할 수 없습니다."
    if medical_warning in answer and not is_food_related:
        medical_warning_pos = answer.find(medical_warning)
        if medical_warning_pos > 0:
            answer = answer[:medical_warning_pos].strip() + "\n\n" + medical_warning
    else:
        # 음식 관련 질문이면 의료 경고 문구 제거
        if medical_warning in answer:
            answer = answer.replace(medical_warning, "").strip()

    # 결과가 비어있거나 너무 짧은 경우 기본 메시지
    if not answer or len(answer.strip()) < 5:
        if is_english_query:
            # 영어 질문에는 영어로 된 기본 메시지 제공
            answer = "강아지에게 가장 좋은 사료는 개별 강아지의 나이, 크기, 활동 수준, 건강 상태에 따라 달라집니다. 고품질의 단백질이 풍부하고 적절한 양의 탄수화물과 건강한 지방이 함유된 균형 잡힌 사료가 좋습니다. 특별한 건강 상태가 있는 경우에는 전문 수의사와 상담하는 것이 좋습니다."
        else:
            answer = "죄송합니다. 질문에 대한 정확한 답변을 찾지 못했습니다. 다른 질문을 해주시겠어요?"
    
    return answer, result["sources"] 