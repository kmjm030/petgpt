"""
PetGPT 챗봇 메인 애플리케이션
"""
from fastapi import FastAPI
from petgpt_chatbot.api import router as api_router

app = FastAPI(
    title="PetGPT 챗봇",
    description="Langchain 기반 반려동물 지식 Q&A 및 상품 추천 서비스",
    version="0.1.0"
)

# API 라우터 등록
app.include_router(api_router)

@app.get("/ping")
async def ping():
    """
    상태 확인용 엔드포인트
    """
    return {"message": "pong"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 