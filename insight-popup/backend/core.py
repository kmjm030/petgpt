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

INDEX_NAME = "petgpt-index"  # 실제 Pinecone 인덱스 이름으로 변경하세요.

# AI 쇼핑 어시스턴트 시스템 프롬프트 (query에 포함된 '화면 설명'을 활용하도록 수정)
AI_SHOPPING_ASSISTANT_SYSTEM_PROMPT = """당신은 사용자의 질문과 **사용자가 현재 보고 있는 화면에 대한 설명 (사용자 질문에 포함되어 전달됨)**, 그리고 검색된 관련 정보를 종합적으로 분석하여, 실용적인 쇼핑 도움을 제공하는 AI 어시스턴트입니다. 당신의 주요 임무는 사용자의 쇼핑 경험을 향상시키는 것입니다. 다음 지침에 따라 분석 결과와 제안을 친절하고 간결하게 제공해주세요:

사용자의 현재 질문 (`{input}`)에는 **사용자가 보고 있는 화면에 대한 상세한 설명이 포함**되어 있습니다. 이 '화면 설명' 부분을 실제 이미지를 보는 것처럼 적극적으로 참고하고, 다음 검색된 관련 정보 조각들 (`{context}`)을 활용하여 답변을 생성합니다.

만약 '화면 설명'이나 검색된 정보만으로는 답을 알 수 없거나 사용자의 질문과 관련성이 낮다면, 아는 것처럼 꾸며내지 말고 솔직하게 "현재 정보로는 답변드리기 어렵지만, 다른 상품을 찾아보시겠어요?" 와 같이 응답하거나 일반적인 쇼핑 조언을 제공하세요.

1.  **'화면 설명' 및 핵심 상품/카테고리/사용자 의도 파악:**
    *   사용자 질문에 포함된 '화면 설명'을 통해 사용자가 어떤 상품, 카테고리에 관심을 보이고 있는지, 어떤 시각적 요소(예: 특정 버튼, 할인 배너)에 주목하고 있는지 파악해주세요.
    *   사용자의 질문에서 어떤 의도가 드러나는지 파악해주세요.

2.  **상품 추천 (상황에 따라 0~2개, '화면 설명' 활용):**
    *   '화면 설명'에서 보이는 상품과 검색된 컨텍스트 정보를 바탕으로, 함께 구매하면 좋거나 관련성이 높은 다른 상품을 추천할 수 있습니다.
    *   추천 시, 상품 이름과 추천 이유를 간략히 언급해주세요. (예: "'화면 설명'에 언급된 [상품명]과 함께 사용하기 좋은 '[추천 상품명]'도 살펴보세요. '화면 설명' 우측 하단에 함께 진열된 것으로 보이네요!")

3.  **관련 정보 제공 ('화면 설명' 및 컨텍스트 활용):**
    *   '화면 설명'에 보이는 고객 리뷰 요약, 별점, 할인 정보, 상품 관련 유용한 팁 등이 있다면, 이를 검색된 컨텍스트와 결합하여 언급해주세요.
    *   (주의: 실제 웹사이트 링크를 생성하거나 클릭할 수는 없습니다.)

4.  **가벼운 말동무 역할 및 '화면 설명' 기반 대화:**
    *   사용자의 쇼핑 상황이나 감정에 공감하며 가볍고 친근한 어투로 대화할 수 있습니다.
    *   "'화면 설명' 좌측 상단에 보이는 '오늘만 특가!' 배너도 확인해보셨나요?" 와 같이 '화면 설명' 내의 특정 요소를 언급하며 대화를 이어갈 수 있습니다.

5.  **탐색 제안 (선택 사항, '화면 설명' 활용):**
    *   '화면 설명'에서 사용자가 관심을 가질 만한 다른 관련 카테고리 링크나 버튼이 보인다면 간략히 언급할 수 있습니다.

**응답 시 유의사항:**
*   제공된 검색된 컨텍스트, 사용자 질문, 그리고 **사용자 질문에 포함된 '화면 설명'**에 명확히 나타난 정보만을 기반으로 답변해주세요.
*   항상 친절하고 사용자에게 도움이 되려는 태도를 유지해주세요.
*   답변은 간결하고 명확하게, 핵심 정보 위주로 구성해주세요.
*   답변은 반드시 마크다운 형식을 사용해주세요. (예: 목록은 `-` 또는 `*` 사용, 강조는 `**단어**`)
"""


def run_llm(query: str, chat_history: List[BaseMessage] = []):
    embeddings = GoogleGenerativeAIEmbeddings(
        model="models/embedding-001", google_api_key=os.environ.get("GOOGLE_API_KEY")
    )
    docsearch = PineconeVectorStore(index_name=INDEX_NAME, embedding=embeddings)
    chat = ChatGoogleGenerativeAI(
        model="gemini-2.5-flash-preview-04-17",  # 기존 모델명 유지 또는 필요시 변경
        verbose=True,
        temperature=0.1,  # 약간의 창의성을 위해 (0~0.3 권장)
    )

    # 답변 생성 단계에서 사용할 프롬프트 (새로운 시스템 프롬프트 적용)
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

    # 대화 기록을 바탕으로 사용자의 현재 질문을 재구성하는 프롬프트 (리트리버용)
    # 이 부분은 사용자의 순수한 질문 의도를 파악하는 데 중점.
    # '화면 설명' 부분은 최종 답변 생성 시에만 활용되도록 하는 것이 일반적이나,
    # 필요하다면 rephrase_prompt에도 '화면 설명'을 간략히 포함시켜 검색어 생성에 도움을 줄 수 있음.
    # 현재는 기존 방식대로 사용.
    rephrase_prompt = hub.pull("langchain-ai/chat-langchain-rephrase")

    retriever = docsearch.as_retriever(
        search_kwargs={"k": 3}
    )  # 컨텍스트로 가져올 문서 수

    history_aware_retriever = create_history_aware_retriever(
        llm=chat, retriever=retriever, prompt=rephrase_prompt
    )

    qa_chain = create_retrieval_chain(
        retriever=history_aware_retriever, combine_docs_chain=stuff_documents_chain
    )

    # query에는 ai_processor.py에서 생성한 "화면 설명이 포함된 사용자 질문"이 전달됨
    result = qa_chain.invoke(input={"input": query, "chat_history": chat_history})

    # 디버깅 로그 (필요에 따라 유지 또는 제거)
    print("--- Debug in core.run_llm ---")
    print(
        f"Received query (with screen description): {query[:300]}..."
    )  # 입력된 query 확인
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
        "query": result.get("input", query),  # 입력으로 들어온 query (화면 설명 포함)
        "result": result.get(
            "answer",
            "죄송합니다, 지금은 답변을 드리기 어렵네요. 다른 도움이 필요하시면 말씀해주세요.",
        ),
        "source_documents": result.get("context", []),
    }

    return final_result
