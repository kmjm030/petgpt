"""
PetGPT 챗봇 프롬프트 템플릿 모듈
"""
from langchain_core.prompts import PromptTemplate

# RAG 질의응답 프롬프트 템플릿
QNA_RAG_PROMPT = PromptTemplate.from_template("""
당신은 PetGPT, 반려동물 케어 전문가입니다. 
주어진 컨텍스트 정보를 바탕으로 사용자의 질문에 친절하고 정확하게 답변해주세요.
답변할 수 없는 내용이나 확실하지 않은 경우에는 솔직하게 모른다고 말해주세요.
의학적 조언이나 진단은 제공하지 말고, 대신 "전문 수의사와 상담하세요"라고 안내해주세요.

--- 컨텍스트 정보 ---
{context}
------------------------

--- 사용자 질문 ---
{query}
------------------------

답변:
""")

# 의료 관련 키워드 목록 (답변에 경고 추가 용도)
MEDICAL_KEYWORDS = [
    "진단", "질병", "증상", "치료", "처방", "약물", "수술", "부작용",
    "병원", "질환", "통증", "치료법", "수의사", "처방전", "감염",
    "질환", "회복", "약품", "투약", "부상", "염증", "검사"
]

# 의료 관련 경고 문구
MEDICAL_ADVICE_WARNING = """
※ 참고: 위 정보는 일반적인 안내일 뿐이며, 의학적 진단이나 전문적인 수의학 조언을 대체할 수 없습니다. 
반려동물의 건강 상태가 우려된다면, 반드시 수의사와 상담하시기 바랍니다.
"""

# 출처 표시 형식 문자열
CITATION_FORMAT = "\n\n[출처: {sources}]"

# RAG 응답 구성 템플릿
def format_rag_response(answer: str, sources: list = None, has_medical_content: bool = False) -> str:
    """
    RAG 응답을 포맷팅하는 함수
    
    Args:
        answer (str): LLM이 생성한 응답
        sources (list, optional): 출처 목록. 기본값은 None
        has_medical_content (bool, optional): 의료 관련 내용 포함 여부. 기본값은 False
    
    Returns:
        str: 포맷팅된 응답
    """
    formatted_response = answer
    
    # 출처 추가
    if sources and len(sources) > 0:
        unique_sources = list(set(sources))
        sources_text = ", ".join(unique_sources)
        formatted_response += CITATION_FORMAT.format(sources=sources_text)
    
    # 의료 관련 경고 추가
    if has_medical_content:
        formatted_response += "\n\n" + MEDICAL_ADVICE_WARNING
    
    return formatted_response

# 전체 RAG 프롬프트 구성 함수
def format_qna_rag_prompt(query: str, context_docs: list) -> str:
    """
    RAG 질의응답을 위한 최종 프롬프트를 구성하는 함수
    
    Args:
        query (str): 사용자 질문
        context_docs (list): 관련 문서 목록
    
    Returns:
        str: 포맷팅된 프롬프트
    """
    # 컨텍스트 문서 결합
    if context_docs and len(context_docs) > 0:
        context_text = "\n\n".join([f"문서 {i+1}: {doc.page_content}" for i, doc in enumerate(context_docs)])
    else:
        context_text = "관련 정보가 없습니다."
    
    # 프롬프트 포맷팅
    formatted_prompt = QNA_RAG_PROMPT.format(
        context=context_text,
        query=query
    )
    
    return formatted_prompt 