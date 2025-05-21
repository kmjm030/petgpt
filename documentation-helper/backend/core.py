## File: backend/core.py (원본 제공 코드)
import os
from typing import Any, Dict, List
from dotenv import load_dotenv
from langchain.chains.retrieval import create_retrieval_chain
from langchain_core.messages import BaseMessage
from langchain_core.prompts import (
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
    AIMessagePromptTemplate,
    ChatPromptTemplate,
)

load_dotenv()

from langchain import hub
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_pinecone import PineconeVectorStore
from langchain_google_genai import ChatGoogleGenerativeAI, GoogleGenerativeAIEmbeddings
from langchain.chains.history_aware_retriever import create_history_aware_retriever

INDEX_NAME = "petgpt-index"


def run_llm(query: str, chat_history: List[BaseMessage] = []):
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/embedding-001", google_api_key=os.environ.get("GOOGLE_API_KEY")
    )
    docsearch = PineconeVectorStore(index_name=INDEX_NAME, embedding=embeddings)
    chat = ChatGoogleGenerativeAI(
        model="gemini-2.5-flash-preview-04-17", verbose=True, temperature=0
    )

    retrieval_qa_chat_prompt_original = hub.pull("langchain-ai/retrieval-qa-chat")
    new_messages = []
    markdown_instruction_added = False
    if hasattr(
        retrieval_qa_chat_prompt_original, "messages"
    ): 
        for msg_template in retrieval_qa_chat_prompt_original.messages:
            if isinstance(msg_template, SystemMessagePromptTemplate):
                original_system_template = msg_template.prompt.template
                if (
                    "Format your answer in Markdown" not in original_system_template
                ): 
                    new_system_content = (
                        original_system_template
                        + "\n\nIMPORTANT: Format your answer in Markdown. Use lists for multiple items and bold for emphasis."
                    )
                    new_messages.append(
                        SystemMessagePromptTemplate.from_template(new_system_content)
                    )
                    markdown_instruction_added = True
                else:
                    new_messages.append(msg_template)
            else:
                new_messages.append(msg_template)

        if (
            not markdown_instruction_added and new_messages
        ):  
            pass 

        if new_messages: 
            retrieval_qa_chat_prompt_markdown = ChatPromptTemplate.from_messages(
                new_messages
            )
        else: 
            retrieval_qa_chat_prompt_markdown = retrieval_qa_chat_prompt_original
            print(
                "Warning: Could not modify the hub prompt to include Markdown instructions. Using original or fallback prompt."
            )
    else:  
        if hasattr(retrieval_qa_chat_prompt_original, "template"):
            original_template = retrieval_qa_chat_prompt_original.template
            if (
                "마크다운 형식" not in original_template
                and "Format your answer in Markdown" not in original_template
            ):
                new_template_content = (
                    original_template
                    + "\n\n답변은 반드시 마크다운 형식을 사용해주세요. (예: 목록은 -, 강조는 **단어**)"
                )
                from langchain_core.prompts import PromptTemplate

                retrieval_qa_chat_prompt_markdown = PromptTemplate.from_template(
                    new_template_content
                )
                markdown_instruction_added = True
            else:
                retrieval_qa_chat_prompt_markdown = retrieval_qa_chat_prompt_original
        else:  
            retrieval_qa_chat_prompt_markdown = retrieval_qa_chat_prompt_original
            print(
                "Warning: Prompt from hub is not a ChatPromptTemplate or PromptTemplate. Markdown instruction might not be applied."
            )

    stuff_documents_chain = create_stuff_documents_chain(
        chat, retrieval_qa_chat_prompt_markdown
    )  

    rephrase_prompt = hub.pull("langchain-ai/chat-langchain-rephrase")

    retriever = docsearch.as_retriever(search_kwargs={"k": 5})

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
            if hasattr(item_in_context, "metadata"):
                print(f"  Item {i} has metadata: {item_in_context.metadata}")
            else:
                print(f"  Item {i} does NOT have metadata attribute.")
    else:
        print("No 'context' found in result or context is empty in run_llm.")
    print("--- End Debug in run_llm ---")

    # new_result 구성 직전에 result["context"]의 타입을 다시 한번 로깅
    if "context" in result and result["context"]:
        print(
            "--- Debug: Checking type of result['context'] items JUST BEFORE new_result creation ---"
        )
        for i, doc_check in enumerate(result["context"]):
            print(f"Doc {i} type before new_result: {type(doc_check)}")
    else:
        print("No context in result before new_result creation.")

    new_result = {
        "query": result.get("input", query),
        "result": result.get("answer", "죄송합니다, 답변을 생성하지 못했습니다."),
        "source_documents": result.get("context", []),  # 이 할당이 문제인지 확인
    }

    # new_result["source_documents"]의 타입도 확인
    if new_result["source_documents"]:
        print(
            "--- Debug: Checking type of new_result['source_documents'] items AFTER creation ---"
        )
        for i, doc_final_check in enumerate(new_result["source_documents"]):
            print(f"Doc {i} type in new_result: {type(doc_final_check)}")
    else:
        print("No source_documents in new_result.")

    return new_result


def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)
