import os
from typing import Any, Dict, List
from dotenv import load_dotenv
from langchain.chains.retrieval import create_retrieval_chain
from langchain_core.messages import BaseMessage, SystemMessage, HumanMessage
from langchain_core.prompts import (
    ChatPromptTemplate,
    MessagesPlaceholder,
    HumanMessagePromptTemplate,
)

load_dotenv()

from langchain import hub
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_pinecone import PineconeVectorStore
from langchain_google_genai import ChatGoogleGenerativeAI, GoogleGenerativeAIEmbeddings
from langchain.chains.history_aware_retriever import create_history_aware_retriever

INDEX_NAME = "petgpt-index"  

AI_SHOPPING_ASSISTANT_SYSTEM_PROMPT = """당신은 사용자의 질문과 **사용자가 현재 보고 있는 화면에 대한 설명 (사용자 질문에 포함되어 전달됨)**, 그리고 검색된 관련 정보를 종합적으로 분석하여, 실용적인 쇼핑 도움을 제공하는 AI 어시스턴트입니다. 당신의 주요 임무는 사용자의 쇼핑 경험을 향상시키는 것입니다. 다음 지침에 따라 분석 결과와 제안을 **매우 친절하고 핵심만 간결하게 (예: 2~3 문장)** 제공해주세요:

사용자의 현재 질문 (`{input}`)에는 **사용자가 보고 있는 화면에 대한 상세한 설명이 포함**되어 있습니다. 이 '화면 설명' 부분을 실제 이미지를 보는 것처럼 적극적으로 참고하고, 다음 검색된 관련 정보 조각들 (`{context}`)을 활용하여 답변을 생성합니다. **모든 정보를 나열하기보다는 가장 중요하고 사용자에게 즉시 도움이 될 만한 내용 1~2가지만 선택하여 요약**해주세요.

만약 '화면 설명'이나 검색된 정보만으로는 답을 알 수 없거나 사용자의 질문과 관련성이 낮다면, "현재 화면 정보로는 특별한 추천을 드리기 어렵네요. 혹시 찾으시는 상품이나 정보가 있으신가요?" 와 같이 짧게 응답해주세요.

1.  **'화면 설명' 기반 핵심 파악 (간단히):**
    *   사용자 질문에 포함된 '화면 설명'을 통해 사용자가 어떤 상품/카테고리에 관심을 보이는지 **가장 중요한 부분만 빠르게 파악**합니다.

2.  **상품 추천 (최대 1개, 꼭 필요할 때만 간결하게):**
    *   '화면 설명'과 컨텍스트 정보를 바탕으로, **정말로 관련성이 높고 유용하다고 판단될 경우에만 딱 1개의 상품을 추천**합니다.
    *   추천 시, 상품 이름과 핵심 이유만 간략히 언급합니다. (예: "혹시 '[추천 상품명]'도 살펴보셨나요? [핵심 이유]로 함께 많이 찾으세요.")
    *   **무리하게 추천할 필요는 없습니다. 상품명을 강조할 필요 없이 자연스럽게 문장에 포함시켜주세요.**

3.  **핵심 정보 제공 (가장 중요한 것 1가지 위주):**
    *   '화면 설명'이나 컨텍스트에 고객 리뷰, 할인, 팁 등이 있다면, **그 중 가장 사용자에게 도움이 될 만한 정보 1가지만** 간략히 언급합니다.
    *   (예: "'화면 설명'에 보이는 [핵심 정보]가 도움이 될 것 같아요.")
    *   **특별한 강조 없이 정보를 전달해주세요.**

4.  **가벼운 상호작용 (짧게):**
    *   친근한 어투는 유지하되, 불필요한 미사여구나 긴 설명은 피해주세요.
    *   필요하다면 '화면 설명'의 특정 요소를 짧게 언급할 수 있습니다. (예: "왼쪽 '할인 쿠폰'도 잊지 마세요!")

**응답 시 유의사항:**
*   제공된 정보(검색된 컨텍스트, 사용자 질문, '화면 설명')에 명확히 나타난 정보만을 기반으로 합니다.
*   **답변은 매우 간결하고 명확하게, 핵심 정보 1~2가지 위주로, 전체적으로 2~4 문장을 넘지 않도록 구성해주세요.**
*   **답변은 반드시 일반 텍스트(Plain Text)로만 작성해주세요. 어떠한 마크다운 형식(볼드체, 기울임, 목록, 헤더 등)도 사용하지 마세요.** 모든 내용은 일반 문장으로 표현해주세요.
"""


def run_llm(query: str, chat_history: List[BaseMessage] = []):
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/embedding-001", google_api_key=os.environ.get("GOOGLE_API_KEY")
    )
    docsearch = PineconeVectorStore(index_name=INDEX_NAME, embedding=embeddings)
    chat = ChatGoogleGenerativeAI(
        model="gemini-2.5-flash-preview-05-20",  
        verbose=True,
        temperature=0.2,  
    )

    answer_generation_prompt = ChatPromptTemplate.from_messages(
        [
            SystemMessage(content=AI_SHOPPING_ASSISTANT_SYSTEM_PROMPT),
            MessagesPlaceholder(variable_name="chat_history", optional=True),
            HumanMessagePromptTemplate.from_template(
                """다음은 사용자의 현재 질문입니다:
              {input}

              그리고 다음은 위 질문과 관련하여 검색된 정보입니다. 이 정보를 바탕으로 답변해주세요:
              <관련 정보 시작>
              {context}
              <관련 정보 끝>
              """
            ),
        ]
    )

    stuff_documents_chain = create_stuff_documents_chain(chat, answer_generation_prompt)

    rephrase_prompt = hub.pull("langchain-ai/chat-langchain-rephrase")

    retriever = docsearch.as_retriever(
        search_kwargs={"k": 3}
    )  

    history_aware_retriever = create_history_aware_retriever(
        llm=chat, retriever=retriever, prompt=rephrase_prompt
    )

    qa_chain = create_retrieval_chain(
        retriever=history_aware_retriever, combine_docs_chain=stuff_documents_chain
    )

    result = qa_chain.invoke(input={"input": query, "chat_history": chat_history})

    print("--- Debug in core.run_llm ---")
    print(
        f"Received query (with screen description): {query[:300]}..."
    )  
    if "context" in result and result["context"]:
        print(f"Number of items in context: {len(result['context'])}")
        for i, item_in_context in enumerate(result["context"]):
            if hasattr(item_in_context, "page_content"):
                print(
                    f"  Context Item {i} page_content (first 50 chars): {item_in_context.page_content[:50]}"
                )
            if hasattr(item_in_context, "metadata"):
                print(f"  Context Item {i} has metadata: {item_in_context.metadata}")
    else:
        print("No 'context' found in result or context is empty.")
    print(f"Generated answer: {result.get('answer', '')[:100]}...")
    print("--- End Debug in core.run_llm ---")

    final_result = {
        "query": result.get("input", query),  
        "result": result.get(
            "answer",
            "죄송합니다, 지금은 답변을 드리기 어렵네요. 다른 도움이 필요하시면 말씀해주세요.",
        ),
        "source_documents": result.get("context", []),
    }

    return final_result
