import os
from typing import Any, Dict, List
from dotenv import load_dotenv
from langchain.chains.retrieval import create_retrieval_chain
from langchain_core.messages import BaseMessage, SystemMessage
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
        model="gemini-2.5-flash-preview-05-20",
        verbose=True,
        temperature=0,
        convert_system_message_to_human=True,
    )

    custom_system_prompt_template = """당신은 펫GPT 쇼핑몰의 상품 및 고객 정보 전문가입니다.
    제공된 펫GPT 관련 Markdown 문서(상품, 고객, 카테고리, 커뮤니티, Q&A 정보 포함)를 기반으로 다음 질문에 답변해주세요.
    외부 지식을 사용하지 말고, 제공된 문서 내용만을 활용하여 답변해야 합니다.
    문서에서 검색된 내용을 바탕으로, 질문에 대해 명확하고 간결하게 답변해주세요.
    답변은 반드시 마크다운 형식을 사용해주세요. (예: 목록은 '-', 강조는 **단어**)
    만약 문서에 해당 정보가 없다면, "제공된 문서에서는 해당 정보를 찾을 수 없습니다."라고 명확히 답변해주세요.

    검색된 문서 내용:
    {context}"""

    prompt_for_answer_generation = hub.pull("langchain-ai/retrieval-qa-chat")
    new_messages_for_answer_gen = []

    if hasattr(prompt_for_answer_generation, "messages"):
        system_message_exists_in_hub_prompt = False
        for msg_template in prompt_for_answer_generation.messages:
            if isinstance(msg_template, SystemMessagePromptTemplate):
                new_messages_for_answer_gen.append(
                    SystemMessagePromptTemplate.from_template(
                        custom_system_prompt_template
                    )
                )
                system_message_exists_in_hub_prompt = True
            else:
                new_messages_for_answer_gen.append(msg_template)

        if not system_message_exists_in_hub_prompt:
            new_messages_for_answer_gen.insert(
                0,
                SystemMessagePromptTemplate.from_template(
                    custom_system_prompt_template
                ),
            )

        combine_docs_chat_prompt = ChatPromptTemplate.from_messages(
            new_messages_for_answer_gen
        )
    else:
        print(
            "Warning: Prompt from hub for answer generation is not a ChatPromptTemplate. Attempting to create a new one."
        )
        combine_docs_chat_prompt = ChatPromptTemplate.from_messages(
            [
                SystemMessagePromptTemplate.from_template(
                    custom_system_prompt_template
                ),
                HumanMessagePromptTemplate.from_template("{input}"),
            ]
        )

    stuff_documents_chain = create_stuff_documents_chain(chat, combine_docs_chat_prompt)

    rephrase_prompt = hub.pull("langchain-ai/chat-langchain-rephrase")

    retriever = docsearch.as_retriever(
        search_type="mmr",
        search_kwargs={"k": 5, "fetch_k": 50, "lambda_mult": 0.6},
    )

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
        "source_documents": result.get("context", []),
    }

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
