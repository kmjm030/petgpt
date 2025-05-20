"""
SentenceTransformer 임베딩 모델 테스트 스크립트
"""
from dotenv import load_dotenv
from langchain_community.embeddings import SentenceTransformerEmbeddings
from petgpt_chatbot.config import get_settings

# 환경 변수 로드
load_dotenv()

def test_sentence_transformer():
    """
    SentenceTransformer 임베딩 테스트
    """
    print("\nSentenceTransformerEmbeddings 테스트")
    print("=" * 50)
    
    try:
        # 설정 불러오기
        settings = get_settings()
        model_name = settings.SBERT_MODEL_NAME
        
        print(f"사용할 모델명: {model_name}")
        
        # 임베딩 모델 초기화
        embedding_model = SentenceTransformerEmbeddings(
            model_name=model_name
        )
        
        # 테스트 쿼리 임베딩
        query = "강아지 사료 추천"
        print(f"테스트 쿼리: '{query}'")
        
        # 시간 측정
        import time
        start_time = time.time()
        
        # 임베딩 실행
        embedding = embedding_model.embed_query(query)
        
        end_time = time.time()
        execution_time = end_time - start_time
        
        print(f"임베딩 생성 시간: {execution_time:.4f}초")
        print(f"임베딩 벡터 차원: {len(embedding)}")
        print(f"임베딩 벡터 처음 3개 값: {embedding[:3]}")
        print("✅ SentenceTransformerEmbeddings 테스트 성공")
    except Exception as e:
        print(f"❌ SentenceTransformerEmbeddings 테스트 실패: {str(e)}")

if __name__ == "__main__":
    print("임베딩 모델 테스트 시작")
    
    # SentenceTransformer 임베딩 테스트
    test_sentence_transformer()
    
    print("\n테스트 완료!") 