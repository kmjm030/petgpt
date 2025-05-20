"""
Google API 키 및 임베딩 모델 테스트 스크립트
"""
import os
from dotenv import load_dotenv
import google.generativeai as genai
from langchain_google_genai import ChatGoogleGenerativeAI, GoogleGenerativeAIEmbeddings
from langchain_core.output_parsers import StrOutputParser

# 환경 변수 로드
load_dotenv()

# API 키 확인
api_key = os.getenv("GOOGLE_API_KEY")
if not api_key:
    print("❌ GOOGLE_API_KEY가 설정되지 않았습니다.")
    exit(1)
    
print(f"Google API 키: {api_key[:5]}...{api_key[-5:]}")

# Gemini API 초기화
genai.configure(api_key=api_key)

def test_genai_direct():
    """
    Google GenerativeAI API 직접 호출 테스트
    """
    print("\n1. Google GenerativeAI 직접 호출 테스트")
    print("=" * 50)
    
    try:
        model = genai.GenerativeModel('gemini-2.5-flash-preview-04-17')
        response = model.generate_content("안녕하세요, 반려동물 케어에 대해 알려주세요.")
        
        print(f"응답: {response.text[:100]}...")
        print("✅ Google GenerativeAI 직접 호출 성공")
    except Exception as e:
        print(f"❌ Google GenerativeAI 직접 호출 실패: {str(e)}")

def test_langchain_genai():
    """
    LangChain GoogleGenerativeAI 래퍼 테스트
    """
    print("\n2. LangChain GoogleGenerativeAI 테스트")
    print("=" * 50)
    
    try:
        llm = ChatGoogleGenerativeAI(
            model="gemini-2.5-flash-preview-04-17",
            google_api_key=api_key,
            temperature=0.7,
            top_p=0.95,
            max_output_tokens=512
        )
        
        chain = llm | StrOutputParser()
        response = chain.invoke("고양이가 헤어볼을 자주 토해내는데 어떻게 관리해야 하나요?")
        
        print(f"응답: {response[:100]}...")
        print("✅ LangChain GoogleGenerativeAI 테스트 성공")
    except Exception as e:
        print(f"❌ LangChain GoogleGenerativeAI 테스트 실패: {str(e)}")

def test_genai_embedding():
    """
    GoogleGenerativeAIEmbeddings 테스트
    """
    print("\n3. GoogleGenerativeAIEmbeddings 테스트")
    print("=" * 50)
    
    try:
        embedding_model = GoogleGenerativeAIEmbeddings(
            google_api_key=api_key,
            model="models/embedding-001",
            task_type="retrieval_document",
            title="테스트 임베딩"
        )
        
        embedding = embedding_model.embed_query("강아지 사료 추천")
        
        print(f"임베딩 벡터 차원: {len(embedding)}")
        print(f"임베딩 벡터 처음 3개 값: {embedding[:3]}")
        print("✅ GoogleGenerativeAIEmbeddings 테스트 성공")
    except Exception as e:
        print(f"❌ GoogleGenerativeAIEmbeddings 테스트 실패: {str(e)}")

if __name__ == "__main__":
    print("Google API 키 테스트 시작")
    
    # 직접 genai 호출 테스트
    test_genai_direct()
    
    # LangChain 래퍼 테스트
    test_langchain_genai()
    
    # 임베딩 테스트
    test_genai_embedding()
    
    print("\n테스트 완료!") 