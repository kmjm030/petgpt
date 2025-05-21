## File: backend/core.py (원본 제공 코드)
import os
from typing import Any, Dict, List
from dotenv import load_dotenv
from langchain.chains.retrieval import create_retrieval_chain
from langchain_core.documents import Document

load_dotenv()

from langchain import hub
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_pinecone import PineconeVectorStore
from langchain_google_genai import ChatGoogleGenerativeAI, GoogleGenerativeAIEmbeddings
from langchain.chains.history_aware_retriever import create_history_aware_retriever

INDEX_NAME = "petgpt-index"


def run_llm(query: str, chat_history: List[Dict[str, Any]] = []):
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/embedding-001", google_api_key=os.environ.get("GOOGLE_API_KEY")
    )
    docsearch = PineconeVectorStore(index_name=INDEX_NAME, embedding=embeddings)
    chat = ChatGoogleGenerativeAI(
        model="gemini-2.5-flash-preview-04-17", verbose=True, temperature=0
    )

    retrieval_qa_chat_prompt = hub.pull("langchain-ai/retrieval-qa-chat")
    stuff_documents_chain = create_stuff_documents_chain(chat, retrieval_qa_chat_prompt)

    rephrase_prompt = hub.pull("langchain-ai/chat-langchain-rephrase")

    retriever = docsearch.as_retriever(search_kwargs={"k": 10})

    history_aware_retriever = create_history_aware_retriever(
        llm=chat, retriever=retriever, prompt=rephrase_prompt
    )

    qa = create_retrieval_chain(
        retriever=history_aware_retriever, combine_docs_chain=stuff_documents_chain
    )

    result = qa.invoke(input={"input": query, "chat_history": chat_history})

    print("--- Debug in run_llm: Checking result['context'] before returning ---")
    if "context" in result and result["context"]:
        print(f"Type of result['context'] in run_llm: {type(result['context'])}")
        print(f"Number of items in context: {len(result['context'])}")
        for i, item_in_context in enumerate(result["context"]):
            print(f"Item {i} in context - Type: {type(item_in_context)}")
            if hasattr(item_in_context, 'metadata'):
                print(f"  Item {i} has metadata: {item_in_context.metadata}")
            else:
                print(f"  Item {i} does NOT have metadata attribute.")
    else:
        print("No 'context' found in result or context is empty in run_llm.")
    print("--- End Debug in run_llm ---")

    # new_result 구성 직전에 result["context"]의 타입을 다시 한번 로깅
    if "context" in result and result["context"]:
        print("--- Debug: Checking type of result['context'] items JUST BEFORE new_result creation ---")
        for i, doc_check in enumerate(result["context"]):
            print(f"Doc {i} type before new_result: {type(doc_check)}")
    else:
        print("No context in result before new_result creation.")


    new_result = {
        "query": result.get("input", query),
        "result": result.get("answer", "죄송합니다, 답변을 생성하지 못했습니다."),
        "source_documents": result.get("context", []) # 이 할당이 문제인지 확인
    }

    # new_result["source_documents"]의 타입도 확인
    if new_result["source_documents"]:
        print("--- Debug: Checking type of new_result['source_documents'] items AFTER creation ---")
        for i, doc_final_check in enumerate(new_result["source_documents"]):
            print(f"Doc {i} type in new_result: {type(doc_final_check)}")
    else:
        print("No source_documents in new_result.")


    return new_result


def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)


# def run_llm2(query: str, chat_history: List[Dict[str, Any]] = []):
#     embeddings = GoogleGenerativeAIEmbeddings(
#         model="models/embedding-001", google_api_key=os.environ.get("GOOGLE_API_KEY")
#     )
#     docsearch = PineconeVectorStore(index_name=INDEX_NAME, embedding=embeddings)
#     chat = ChatGoogleGenerativeAI(
#         model="gemini-2.5-flash-preview-04-17", verbose=True, temperature=0
#     )

#     rephrase_prompt = hub.pull(
#         "langchain-ai/chat-langchain-rephrase"
#     )  # 참고: run_llm의 변수명과 동일

#     retrieval_qa_chat_prompt = hub.pull(
#         "langchain-ai/retrieval-qa-chat"
#     )  # 참고: run_llm의 변수명과 동일

#     rag_chain = (
#         {
#             "context": docsearch.as_retriever() | format_docs,
#             "input": RunnablePassthrough(),
#         }
#         | retrieval_qa_chat_prompt
#         | chat
#         | StrOutputParser()
#     )

#     retrieve_docs_chain = (lambda x: x["input"]) | docsearch.as_retriever()

#     chain = RunnablePassthrough.assign(context=retrieve_docs_chain).assign(
#         answer=rag_chain
#     )

#     result = chain.invoke({"input": query, "chat_history": chat_history})
#     return result
