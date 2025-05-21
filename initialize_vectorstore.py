"""
벡터 스토어 초기화 및 데이터 로드 스크립트
"""

import os
import logging
from pathlib import Path
from dotenv import load_dotenv
from langchain_core.documents import Document
import time

# 로깅 설정
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.StreamHandler(),  # 콘솔 출력
        # logging.FileHandler("vectorstore_init.log") # 파일 로깅 (필요시 주석 해제)
    ],
)
logger = logging.getLogger(__name__)

# 환경 변수 로드
load_dotenv()


def create_sample_documents():
    """
    샘플 문서 생성 (E2E 테스트 시나리오 커버하도록 확장)
    """
    logger.info("샘플 문서 생성 중...")

    pet_knowledge = [
        {
            "title": "강아지 초콜릿 위험성 및 응급 대처",  # 시나리오 1.1
            "content": """
            강아지가 초콜릿을 먹으면 위험한 주된 이유는 초콜릿에 함유된 테오브로민과 카페인 성분 때문입니다. 
            이 성분들은 사람에게는 비교적 안전하지만, 강아지는 이를 매우 느리게 대사하여 체내에 독성 수준으로 축적될 수 있습니다.

            주요 증상:
            - 초기: 구토, 설사, 심한 갈증, 불안, 안절부절못함
            - 중기: 과도한 활동성, 배뇨 증가, 근육 떨림, 불규칙하거나 빠른 심장 박동
            - 심각: 발작, 혼수 상태, 심정지로 이어져 사망에 이를 수 있습니다.

            초콜릿 종류별 위험도:
            카카오 함량이 높을수록 테오브로민 농도도 높아져 더 위험합니다. 
            베이킹 초콜릿 > 다크 초콜릿 > 밀크 초콜릿 > 화이트 초콜릿 순으로 위험도가 높습니다.

            응급 대처:
            강아지가 초콜릿을 섭취한 것을 알게 되면 즉시 동물병원에 연락하는 것이 가장 중요합니다. 
            수의사는 섭취량, 초콜릿 종류, 강아지의 체중 등을 고려하여 구토 유도, 활성탄 투여, 수액 치료 등의 적절한 조치를 취할 것입니다. 
            집에서 임의로 구토를 유도하는 것은 위험할 수 있으므로 반드시 수의사의 지시에 따라야 합니다.
            정확한 진단과 치료는 반드시 전문 수의사와 상담하세요. 이 정보는 일반적인 참고자료이며, 의학적 조언을 대체할 수 없습니다.
            """,
            "source": "대한수의사회 긴급진료 가이드라인 (가상)",
            "category": "건강_위험요소",
        },
        {
            "title": "고양이 털 관리 방법",  # 시나리오 1.2
            "content": """
            고양이 털 관리는 고양이의 건강과 청결 유지에 중요합니다. 효과적인 털 관리 방법은 다음과 같습니다:
            
            1. 정기적인 빗질: 단모종은 주 1-2회, 장모종은 거의 매일 빗질을 해주는 것이 좋습니다. 슬리커 브러시, 핀 브러시, 고무 브러시 등 고양이의 털 유형에 맞는 도구를 사용하세요.
            
            2. 그루밍 장갑: 브러시를 거부하는 고양이에게는 그루밍 장갑이 효과적일 수 있습니다. 손으로 쓰다듬듯이 털을 정리할 수 있어 스트레스가 적습니다.
            
            3. 목욕: 대부분의 고양이는 자체 그루밍을 하므로 자주 목욕이 필요하지 않습니다. 특별한 상황(기름이나 오염물질이 묻었을 때)에만 고양이용 샴푸로 목욕을 시키세요.
            
            4. 환절기 특별 관리: 환절기에는 털갈이가 심해지므로 빗질 빈도를 늘리고, 필요하다면 전문 그루머에게 도움을 받는 것도 좋습니다.
            
            5. 영양 관리: 오메가-3와 오메가-6 지방산이 풍부한 사료는 피부와 모질 개선에 도움이 됩니다.
            
            규칙적인 털 관리는 털뭉치를 삼켜서 생기는 헤어볼 문제를 예방하고, 집안의 털 날림을 줄이며, 고양이의 피부 건강을 유지하는 데 도움이 됩니다.
            """,
            "source": "한국반려동물관리사협회 (가상)",
            "category": "케어_그루밍",
        },
        {
            "title": "강아지 사료 선택 가이드",  # E2E 시나리오의 맥락 질문 대응 가능
            "content": """
            강아지 사료 선택 시 고려해야 할 주요 요소들:

            1. 연령에 맞는 사료: 강아지의 성장 단계(퍼피, 어덜트, 시니어/노견)에 따라 필요한 영양소가 다릅니다. 연령별 맞춤 사료를 선택하세요.

            2. 체형과 크기: 소형견, 중형견, 대형견에 따라 적절한 사료가 다릅니다. 특히 대형견은 관절 건강을 위한 특별한 영양소가 필요합니다.

            3. 활동량: 활동량이 많은 강아지는 더 많은 단백질과 칼로리가 필요합니다. 반면 실내에서 주로 생활하는 강아지는 체중 관리용 사료가 적합할 수 있습니다.

            4. 건강 상태: 알레르기, 소화 문제, 피부 질환 등 특별한 건강 이슈가 있는 경우 수의사가 추천하는 처방식 사료를 고려해야 합니다.

            5. 주요 성분 확인: 
               - 단백질: 첫 번째 성분이 고기(닭고기, 소고기, 양고기 등)여야 합니다.
               - 탄수화물: 통곡물이나 고구마, 감자 등 소화하기 좋은 탄수화물이 좋습니다.
               - 지방: 오메가-3, 오메가-6 지방산이 균형있게 포함된 사료가 피부와 모질에 좋습니다.
               - 인공 첨가물: 인공 색소, 향료, 방부제가 없는 제품이 좋습니다.

            사료 변경 시에는 기존 사료와 새 사료를 7-10일에 걸쳐 점진적으로 혼합하여 소화 문제를 방지하세요. 새로운 사료를 주기 시작한 후 강아지의 건강, 피부, 배변 상태를 관찰하는 것이 중요합니다.
            """,
            "source": "한국애견협회 영양 가이드라인 (가상)",
            "category": "영양_사료",
        },
        {
            "title": "대형견 관절 건강 관리",  # 시나리오 2.2 (사료 추천) 및 일반 건강 질문 대응
            "content": """
            대형견은 체중이 관절에 주는 부담 때문에 관절 질환에 취약합니다. 특히 노령 대형견(노견)은 더욱 세심한 관리가 필요합니다.

            관절 건강을 위한 주요 관리 방법:
            1. 체중 관리: 과체중은 관절에 부담을 주므로 적정 체중을 유지하는 것이 가장 중요합니다.
            2. 적절한 운동: 수영이나 짧은 산책 같은 저충격 운동이 좋습니다.
            3. 영양 보충제: 글루코사민, 콘드로이틴, MSM, 오메가-3 지방산 등이 도움이 될 수 있으나, 수의사와 상담 후 결정하세요.
            4. 관절 건강용 사료: 관절 건강에 도움이 되는 성분이 강화된 사료를 고려할 수 있습니다.
            5. 편안한 휴식 공간: 푹신한 침대가 도움이 됩니다.
            6. 미끄럼 방지: 바닥에 매트를 깔아주세요.
            7. 정기적인 수의사 검진: 조기 발견이 중요합니다.

            관절 질환 증상(느린 움직임, 뻣뻣함, 일어서기 어려움, 다리 절음)이 보이면 즉시 수의사와 상담하세요. 이 정보는 일반적인 관리 방법이며, 실제 진단과 치료는 전문가의 도움을 받아야 합니다.
            """,
            "source": "한국수의학회 대형견 건강 관리 지침 (가상)",
            "category": "건강_관절",
        },
        {
            "title": "고양이 행동 이해하기",  # 일반적인 고양이 관련 질문 대응
            "content": """
            고양이의 행동을 이해하는 것은 건강하고 행복한 반려 생활의 기본입니다. 고양이의 주요 행동과 그 의미는 다음과 같습니다:
            - 꼬리: 높이 들면 기분 좋음, 빠르게 흔들면 짜증, 부풀리면 놀람.
            - 소리: 그르렁은 만족감 또는 통증, 미야오는 요구, 낮은 그륵거림은 경고.
            - 눈: 느리게 깜빡이면 신뢰, 커진 동공은 흥분/두려움.
            - 몸짓: 배 보여주기는 신뢰, 등 아치는 위협, 귀 접기는 두려움/공격성.
            - 특이 행동: 머리 비비기는 애정/영역 표시, 꾹꾹이는 편안함.
            평소와 다른 행동이 지속되면 건강 문제를 의심하고 수의사와 상담하세요.
            """,
            "source": "한국고양이행동학회 (가상)",
            "category": "행동_심리",
        },
        {
            "title": "강아지 구토 시 일반적인 대처 및 주의사항",  # 시나리오 3.1 대응
            "content": """
            강아지가 구토를 하는 것은 다양한 원인이 있을 수 있습니다.

            관찰 사항: 구토 횟수, 내용물, 다른 증상 동반 여부.

            일반 대처:
            1. 원인 파악 시도.
            2. 잠시 금식 (수의사 지시 하에).
            3. 점진적인 식사 재개 (소화 잘되는 음식).

            **즉시 병원 진료가 필요한 경우:**
            - 구토 반복, 혈액 섞인 구토, 심한 설사/무기력 동반, 어린/노령견/기저질환견, 이물질 섭취 의심.

            **본 정보는 의학적 진단이나 치료를 대체할 수 없습니다. 반드시 수의사의 전문적인 진료를 받으십시오.**
            """,
            "source": "수의학 정보 포털 (가상)",
            "category": "건강_응급상황",
        },
        {
            "title": "PetGPT 챗봇 사용 가이드 및 한계",  # 시나리오 4.1 관련 없는 질문 처리 시 안내 가능
            "content": """
            안녕하세요! PetGPT 챗봇입니다. 반려동물 관련 지식 Q&A, 상품 추천 등을 제공합니다.
            
            **중요 안내:** 제공되는 건강 관련 정보는 일반적인 참고 자료이며, **절대로 의학적 진단이나 전문적인 수의사의 치료를 대체할 수 없습니다.** 반려동물의 건강에 이상이 있거나 응급 상황 시에는 즉시 동물병원에 문의하시기 바랍니다.
            PetGPT는 반려동물과 직접 관련 없는 질문에는 답변이 어려울 수 있습니다.
            """,
            "source": "PetGPT 운영팀 (가상)",
            "category": "챗봇_가이드",
        },
    ]

    pet_products = [
        {
            "product_id": "DOG001",  # 시나리오 2.2 대응
            "name": "프리미엄 대형견 노견 관절 케어 전문 사료",
            "price": 58000,
            "category": "사료",
            "tags": [
                "대형견",
                "노령견",
                "관절건강",
                "프리미엄사료",
                "처방보조식",
                "시니어",
            ],
            "description": """
            10살 이상 대형견 및 이미 관절 문제가 있는 노령견의 관절 건강 관리를 위해 특별히 설계된 수의사 추천 프리미엄 사료입니다.
            고농축 글루코사민, 콘드로이틴, MSM, EPA & DHA (오메가-3), 녹색입홍합 추출물, L-카르니틴 등이 함유되어 있습니다.
            가수분해 단백질 사용 및 Grain-Free로 소화 흡수율을 높이고 알레르기 가능성을 최소화했습니다.
            기호성이 뛰어나며 인공 첨가물은 사용하지 않았습니다. 수의사 상담 후 급여를 권장합니다.
            """,
            "image_url": "https://example.com/images/premium_joint_formula_senior.jpg",
            "product_url": "https://example.com/shop/products/premium_joint_formula_senior",
        },
        {
            "product_id": "DOG002",  # 시나리오 2.1 대응
            "name": "인터랙티브 삑삑이 공룡 인형 장난감 (중형견용)",
            "price": 18000,
            "category": "장난감",
            "tags": [
                "강아지",
                "장난감",
                "삑삑이",
                "스트레스해소",
                "내구성",
                "중형견",
                "인기상품",
            ],
            "description": """
            강아지의 스트레스 해소와 즐거운 놀이 시간을 위한 인기 인터랙티브 공룡 인형 장난감입니다. (중형견용)
            몸통을 누르면 삑삑 소리가 나 호기심과 사냥 본능을 자극합니다. 강화 원단과 튼튼한 박음질로 내구성을 높였습니다.
            안전한 무독성 소재를 사용했으며, 손세탁이 가능하여 위생적입니다.
            """,
            "image_url": "https://example.com/images/squeaky_dino_toy.jpg",
            "product_url": "https://example.com/shop/products/squeaky_dino_toy_medium",
        },
        {
            "product_id": "DOG004",
            "name": "자동 움직이는 레이저 포인터 장난감 (강아지/고양이 공용)",
            "price": 25000,
            "category": "장난감",
            "tags": [
                "강아지",
                "고양이",
                "장난감",
                "자동",
                "레이저",
                "활동량증가",
                "실내놀이",
            ],
            "description": """
            반려동물이 혼자 있을 때도 심심하지 않도록 놀아주는 자동 레이저 포인터 장난감입니다. 강아지와 고양이 모두 사용 가능합니다.
            다양한 패턴으로 레이저 빛을 투사하여 사냥 본능을 자극하고 활동량을 늘립니다.
            타이머 기능(15분 자동 종료) 및 360도 회전, 각도 조절이 가능합니다. USB 충전식입니다.
            (주의: 레이저 빛을 눈에 직접 조사하지 마세요.)
            """,
            "image_url": "https://example.com/images/auto_laser_pointer.jpg",
            "product_url": "https://example.com/shop/products/auto_laser_pointer",
        },
        {
            "product_id": "CAT002",  # 시나리오 5.2 (고양이 장난감) 대응
            "name": "다층 고양이 스크래치 타워 (캣타워, 놀이공 포함)",
            "price": 92000,
            "category": "가구",
            "tags": [
                "고양이",
                "스크래처",
                "타워",
                "캣타워",
                "휴식공간",
                "놀이터",
                "인기상품",
            ],
            "description": """
            고양이의 스크래치 욕구, 수직 공간 선호, 놀이 활동을 충족시키는 인기 다층 캣타워입니다.
            높이 약 165cm, 여러 플랫폼, 은신처, 전망대, 놀이공으로 구성.
            내구성 높은 천연 황마 로프 기둥과 부드러운 플러시 소재 마감. 안정적인 구조로 조립이 간편합니다.
            """,
            "image_url": "https://example.com/images/cat_tower_deluxe.jpg",
            "product_url": "https://example.com/shop/products/multi_level_cat_tower_deluxe",
        },
    ]

    documents = []
    for item in pet_knowledge:
        doc = Document(
            page_content=item["content"],
            metadata={
                "title": item["title"],
                "source": item["source"],
                "category": item["category"],
                "type": "knowledge",
            },
        )
        documents.append(doc)

    for product in pet_products:
        page_content = f"상품명: {product['name']}\n태그: {','.join(product['tags'])}\n\n{product['description']}"
        metadata = {
            "product_id": product["product_id"],
            "name": product["name"],
            "price": product["price"],
            "category": product["category"],
            "tags": ",".join(product["tags"]),
            "image_url": product["image_url"],
            "product_url": product["product_url"],
            "type": "product",
        }
        doc = Document(page_content=page_content, metadata=metadata)
        documents.append(doc)

    logger.info(f"총 {len(documents)}개의 샘플 문서가 생성되었습니다.")
    return documents


def initialize_vectorstore():
    """
    벡터 스토어 초기화 및 데이터 로드
    """
    try:
        # --- 사용자 프로젝트 의존성 ---
        from petgpt_chatbot.rag import get_or_create_vectorstore, split_documents

        # get_embedding_model은 get_or_create_vectorstore 내부에서 호출되므로 여기서 직접 import 불필요
        from petgpt_chatbot.config import get_settings
        from langchain_chroma import Chroma  # isinstance 검사용

        # --- 사용자 프로젝트 의존성 끝 ---

        logger.info("벡터 스토어 초기화 프로세스 시작...")

        settings = get_settings()
        collection_name = settings.KNOWLEDGE_COLLECTION_NAME
        persist_directory_str = (
            str(settings.CHROMA_DB_PATH) if settings.CHROMA_DB_PATH else None
        )

        if persist_directory_str:
            Path(persist_directory_str).mkdir(parents=True, exist_ok=True)
            logger.info(f"ChromaDB 저장 경로: {persist_directory_str}")
        else:
            logger.warning(
                "ChromaDB 저장 경로가 설정되지 않았습니다. 인메모리로 실행될 수 있습니다."
            )

        # 벡터 스토어 가져오기 또는 생성
        # get_or_create_vectorstore 함수가 내부적으로 임베딩 모델을 처리합니다.
        logger.info(
            f"벡터 스토어 가져오기/생성 시도: collection='{collection_name}', directory='{persist_directory_str}'"
        )
        vectorstore = get_or_create_vectorstore(
            collection_name=collection_name, persist_directory=persist_directory_str
        )

        if not isinstance(
            vectorstore, Chroma
        ):  # 또는 VectorStore (langchain_core.vectorstores.VectorStore)
            logger.error(
                f"get_or_create_vectorstore가 Chroma (또는 VectorStore) 인스턴스를 반환하지 않았습니다 (반환 타입: {type(vectorstore)}). 중단합니다."
            )
            return False

        # get_or_create_vectorstore 함수 내부에서 사용된 임베딩 모델 확인 (디버깅용)
        if (
            hasattr(vectorstore, "embedding_function")
            and vectorstore.embedding_function
        ):
            logger.info(
                f"벡터 스토어에 사용된 임베딩 모델: {type(vectorstore.embedding_function)}"
            )
        elif (
            hasattr(vectorstore, "_embedding_function")
            and vectorstore._embedding_function
        ):  # 일부 래퍼는 _ 언더스코어 사용
            logger.info(
                f"벡터 스토어에 사용된 임베딩 모델 (내부): {type(vectorstore._embedding_function)}"
            )
        else:
            logger.warning(
                "벡터 스토어에서 사용 중인 임베딩 함수 정보를 직접 확인할 수 없습니다 (get_or_create_vectorstore 내부 로직 확인 필요)."
            )

        current_doc_count = 0
        try:
            # 컬렉션이 실제로 존재하는지 확인 후 count 호출
            if vectorstore._collection is not None:
                current_doc_count = vectorstore._collection.count()
                logger.info(f"벡터 스토어 현재 문서 수: {current_doc_count}")
            else:
                logger.info("벡터 스토어 컬렉션이 아직 존재하지 않습니다 (count=0).")
        except Exception as e:
            logger.warning(
                f"기존 문서 수 확인 중 오류: {e}. 컬렉션이 아직 없거나 접근 불가일 수 있습니다."
            )

        # 데이터 삭제 및 추가 로직
        should_load_new_data = True
        if current_doc_count > 0:
            logger.info(f"이미 벡터 스토어에 {current_doc_count}개의 문서가 있습니다.")
            response = input(
                f"기존 데이터({current_doc_count}개)를 삭제하고 새로 로드하시겠습니까? (y/n, 기본값 n): "
            ).lower()

            if response == "y":
                logger.info("기존 컬렉션 데이터를 삭제합니다.")
                try:
                    existing_items = vectorstore.get(include=[])
                    existing_ids = existing_items.get("ids", [])

                    if existing_ids:
                        logger.info(f"삭제할 문서 ID {len(existing_ids)}개 확인.")
                        vectorstore._collection.delete(ids=existing_ids)
                        logger.info(f"{len(existing_ids)}개의 기존 문서 삭제 완료.")
                        time.sleep(0.5)
                        new_count = vectorstore._collection.count()
                        logger.info(f"삭제 후 문서 수: {new_count}")
                        if new_count != 0:
                            logger.warning("삭제 후 문서 수가 0이 아닙니다. 확인 필요.")
                    else:
                        logger.info("컬렉션에 삭제할 문서가 없습니다.")
                except Exception as e_delete:
                    logger.error(
                        f"기존 데이터 삭제 중 오류 발생: {e_delete}", exc_info=True
                    )
                    logger.error("데이터 삭제에 실패했습니다. 스크립트를 중단합니다.")
                    return False
            else:
                logger.info("기존 데이터를 유지합니다. 샘플 데이터 로드를 건너뜁니다.")
                should_load_new_data = False

        if should_load_new_data:
            logger.info("새로운 샘플 문서 로드를 진행합니다.")
            documents_to_load = create_sample_documents()

            if not documents_to_load:
                logger.warning("로드할 샘플 문서가 없습니다.")
                return True

            split_docs = split_documents(
                documents_to_load, chunk_size=1000, chunk_overlap=200
            )
            logger.info(f"분할 후 총 {len(split_docs)}개의 문서 청크가 생성되었습니다.")

            if not split_docs:
                logger.warning("분할된 문서 청크가 없습니다. 로드를 중단합니다.")
                return True

            logger.info("문서 임베딩 및 저장 시작...")
            try:
                vectorstore.add_documents(documents=split_docs)
                logger.info(f"{len(split_docs)}개의 문서 청크 저장 시도 완료.")
            except Exception as e_add_docs:
                logger.error(f"문서 추가 중 오류 발생: {e_add_docs}", exc_info=True)
                return False

            if persist_directory_str:
                try:
                    if hasattr(vectorstore, "persist") and callable(
                        vectorstore.persist
                    ):
                        vectorstore.persist()
                        logger.info(
                            "벡터 스토어 변경사항을 디스크에 저장했습니다 (vectorstore.persist())."
                        )
                    elif hasattr(vectorstore._client, "persist") and callable(
                        vectorstore._client.persist
                    ):
                        vectorstore._client.persist()
                        logger.info(
                            "벡터 스토어 변경사항을 디스크에 저장했습니다 (vectorstore._client.persist())."
                        )
                    else:
                        logger.info(
                            "사용 중인 Chroma 버전에서 persist() 메소드를 찾을 수 없습니다. 자동 저장될 수 있습니다."
                        )
                except Exception as e_persist:
                    logger.error(
                        f"데이터 persist 중 오류 발생: {e_persist}", exc_info=True
                    )

            final_doc_count = vectorstore._collection.count()
            logger.info(f"벡터 스토어 최종 문서 수: {final_doc_count}")

            if final_doc_count < len(split_docs) and (
                current_doc_count == 0 or response == "y"
            ):
                logger.warning(
                    f"주의: 최종 로드된 문서 수({final_doc_count})가 예상된 청크 수({len(split_docs)})보다 적습니다."
                )

        return True

    except ImportError as e:
        logger.error(f"필요한 모듈을 import 하는 중 오류 발생: {e}", exc_info=True)
        logger.error("petgpt_chatbot 관련 모듈 경로 및 설치 상태를 확인해주세요.")
        return False
    except Exception as e:
        logger.error(
            f"벡터 스토어 초기화 중 예측하지 못한 오류 발생: {str(e)}", exc_info=True
        )
        return False


if __name__ == "__main__":
    start_time = time.time()
    logger.info("=" * 50)
    logger.info("PetGPT 벡터 스토어 초기화 및 샘플 데이터 로드 스크립트 시작")
    logger.info("=" * 50)

    success = initialize_vectorstore()

    end_time = time.time()
    duration = end_time - start_time

    if success:
        logger.info(
            f"✅ 벡터 스토어 초기화/데이터 로드 작업 성공적으로 완료! (소요 시간: {duration:.2f}초)"
        )
    else:
        logger.error(
            f"❌ 벡터 스토어 초기화/데이터 로드 작업 실패. (소요 시간: {duration:.2f}초)"
        )
    logger.info("=" * 50)
