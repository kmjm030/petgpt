"""
PetGPT 챗봇 상품 추천 모듈 테스트
"""
import pytest
from unittest.mock import patch, MagicMock

from petgpt_chatbot.recommend import (
    parse_product_request_rules,
    extract_product_details_llm,
    search_products_in_db,
    select_final_products_llm,
    generate_recommendation_message_llm,
    get_product_recommendation
)


class TestProductParser:
    """상품 요청 파서 테스트 클래스"""
    
    def test_parse_product_request_rules_pet_type(self):
        """반려동물 종류 파싱 테스트"""
        # 강아지 키워드 테스트
        result = parse_product_request_rules("우리 강아지 사료 추천해줘")
        assert result['pet_type'] == "강아지"
        
        result = parse_product_request_rules("댕댕이 간식 추천")
        assert result['pet_type'] == "강아지"
        
        # 고양이 키워드 테스트
        result = parse_product_request_rules("고양이 장난감 찾고 있어요")
        assert result['pet_type'] == "고양이"
        
        result = parse_product_request_rules("우리 냥이 간식 뭐가 좋을까요?")
        assert result['pet_type'] == "고양이"
        
        # 동물 종류가 없는 경우
        result = parse_product_request_rules("반려동물 사료 추천해주세요")
        assert result['pet_type'] is None
    
    def test_parse_product_request_rules_categories(self):
        """상품 카테고리 파싱 테스트"""
        # 사료 카테고리 테스트
        result = parse_product_request_rules("강아지 사료 추천해줘")
        assert "사료" in result['categories']
        
        # 여러 카테고리 함께 언급된 경우
        result = parse_product_request_rules("강아지 사료랑 간식 모두 추천해주세요")
        assert "사료" in result['categories']
        assert "간식" in result['categories']
        assert len(result['categories']) == 2
        
        # 장난감 카테고리 테스트
        result = parse_product_request_rules("고양이 장난감 찾아줘")
        assert "장난감" in result['categories']
        
        # 카테고리가 없는 경우
        result = parse_product_request_rules("강아지 좋은 물건 추천해줘")
        assert len(result['categories']) == 0
    
    def test_parse_product_request_rules_symptoms(self):
        """문제/증상 키워드 파싱 테스트"""
        # 관절 문제 테스트
        result = parse_product_request_rules("강아지 관절에 좋은 영양제 추천해줘")
        assert "관절" in result['symptoms']
        
        # 피부 문제 테스트
        result = parse_product_request_rules("고양이 피부가 건조한데 좋은 제품 있을까요?")
        assert "피부" in result['symptoms']
        
        # 여러 증상이 함께 언급된 경우
        result = parse_product_request_rules("강아지 피부랑 관절에 모두 좋은 제품")
        assert "피부" in result['symptoms']
        assert "관절" in result['symptoms']
        assert len(result['symptoms']) == 2
        
        # 증상이 없는 경우
        result = parse_product_request_rules("강아지 장난감 추천해줘")
        assert len(result['symptoms']) == 0
    
    def test_parse_product_request_rules_life_stage(self):
        """생애주기 파싱 테스트"""
        # 퍼피/키튼 테스트
        result = parse_product_request_rules("새끼 강아지 사료 추천")
        assert result['life_stage'] == "퍼피/키튼"
        
        result = parse_product_request_rules("키튼 사료 추천해줘")
        assert result['life_stage'] == "퍼피/키튼"
        
        # 어덜트 테스트
        result = parse_product_request_rules("성묘 사료 추천")
        assert result['life_stage'] == "어덜트"
        
        # 시니어 테스트
        result = parse_product_request_rules("노령 고양이 영양제 추천")
        assert result['life_stage'] == "시니어"
        
        # 생애주기가 없는 경우
        result = parse_product_request_rules("강아지 사료 추천")
        assert result['life_stage'] is None
    
    def test_parse_product_request_rules_age_patterns(self):
        """나이 패턴 기반 생애주기 추론 테스트"""
        # 개월 수 기반 퍼피/키튼 테스트
        result = parse_product_request_rules("3개월 강아지 사료 추천")
        assert result['life_stage'] == "퍼피/키튼"
        
        # 살 기반 시니어 강아지 테스트
        result = parse_product_request_rules("우리 강아지가 8살인데 관절에 좋은 제품 추천해줘")
        assert result['life_stage'] == "시니어"
        
        # 살 기반 어덜트 고양이 테스트
        result = parse_product_request_rules("5살 고양이 간식 추천")
        assert result['life_stage'] == "어덜트"
        
        # 살 기반 시니어 고양이 테스트
        result = parse_product_request_rules("12살 고양이 영양제 추천")
        assert result['life_stage'] == "시니어"
    
    def test_parse_product_request_rules_complex_query(self):
        """복잡한 질문 파싱 테스트"""
        result = parse_product_request_rules("우리 7살 노견인데 관절이 안좋아서 관절에 좋은 사료랑 영양제 추천해주세요")
        assert result['pet_type'] == "강아지"
        assert "사료" in result['categories']
        assert "건강관리" in result['categories']
        assert "관절" in result['symptoms']
        assert result['life_stage'] == "시니어"
        
        result = parse_product_request_rules("2개월된 고양이 키튼인데 좋은 사료와 장난감 추천해주세요")
        assert result['pet_type'] == "고양이"
        assert "사료" in result['categories']
        assert "장난감" in result['categories']
        assert result['life_stage'] == "퍼피/키튼"


class TestLLMExtraction:
    """LLM 기반 정보 추출 테스트 클래스"""
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_extract_product_details_llm_no_enhancement_needed(self, mock_get_llm):
        """정보가 충분할 때 LLM 호출이 필요하지 않은 경우 테스트"""
        # 파싱 정보가 충분한 경우
        parsed_info = {
            'pet_type': '강아지', 
            'categories': ['사료'], 
            'symptoms': ['관절'], 
            'life_stage': '시니어',
            'original_query': '강아지 관절에 좋은 사료 추천해주세요'
        }
        
        # LLM 호출이 필요하지 않으므로 mocking할 필요 없음
        result = extract_product_details_llm('강아지 관절에 좋은 사료 추천해주세요', parsed_info)
        
        # LLM이 호출되지 않았는지 확인
        mock_get_llm.assert_not_called()
        
        # 원본 정보가 유지되는지 확인
        assert result['pet_type'] == '강아지'
        assert result['categories'] == ['사료']
        assert result['symptoms'] == ['관절']
        assert result['life_stage'] == '시니어'
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_extract_product_details_llm_missing_pet_type(self, mock_get_llm):
        """반려동물 종류가 없을 때 LLM 추출 테스트"""
        # 파싱 정보 중 pet_type이 없는 경우
        parsed_info = {
            'pet_type': None, 
            'categories': ['사료'], 
            'symptoms': ['관절'], 
            'life_stage': None,
            'original_query': '반려동물 사료 추천해주세요'
        }
        
        # LLM 모킹
        mock_llm = MagicMock()
        mock_chain = MagicMock()
        mock_llm.__or__.return_value = mock_chain
        mock_chain.invoke.return_value = '{"pet_type": "강아지", "pet_characteristics": "중형견, 활동적", "price_range": "가격 제한 없음"}'
        mock_get_llm.return_value = mock_llm
        
        result = extract_product_details_llm('반려동물 사료 추천해주세요', parsed_info)
        
        # LLM이 호출되었는지 확인
        mock_get_llm.assert_called_once()
        
        # LLM 추출 정보가 보강되었는지 확인
        assert result['pet_type'] == '강아지'
        assert 'llm_extracted' in result
        assert 'pet_characteristics' in result['llm_extracted']
        assert 'price_range' in result['llm_extracted']
        
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_extract_product_details_llm_missing_categories(self, mock_get_llm):
        """카테고리가 없을 때 LLM 추출 테스트"""
        # 파싱 정보 중 categories가 없는 경우
        parsed_info = {
            'pet_type': '고양이', 
            'categories': [], 
            'symptoms': [], 
            'life_stage': '어덜트',
            'original_query': '고양이가 가지고 놀만한 좋은 물건 추천해줘'
        }
        
        # LLM 모킹
        mock_llm = MagicMock()
        mock_chain = MagicMock()
        mock_llm.__or__.return_value = mock_chain
        mock_chain.invoke.return_value = '{"categories": ["장난감", "스크래처"], "pet_characteristics": "집에서 주로 지내는 고양이", "priorities": "내구성 중요"}'
        mock_get_llm.return_value = mock_llm
        
        result = extract_product_details_llm('고양이가 가지고 놀만한 좋은 물건 추천해줘', parsed_info)
        
        # LLM이 호출되었는지 확인
        mock_get_llm.assert_called_once()
        
        # LLM 추출 정보가 보강되었는지 확인
        assert '장난감' in result['categories']
        assert 'llm_extracted' in result
        assert 'pet_characteristics' in result['llm_extracted']
        assert 'priorities' in result['llm_extracted']
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_extract_product_details_llm_error_handling(self, mock_get_llm):
        """LLM 호출 에러 처리 테스트"""
        # 파싱 정보 중 증상과 생애주기가 없는 경우
        parsed_info = {
            'pet_type': '강아지', 
            'categories': ['간식'], 
            'symptoms': [], 
            'life_stage': None,
            'original_query': '강아지 간식 추천해주세요'
        }
        
        # LLM 호출 오류 모킹
        mock_get_llm.side_effect = Exception("API 오류")
        
        result = extract_product_details_llm('강아지 간식 추천해주세요', parsed_info)
        
        # 오류가 발생했지만 원본 정보는 유지
        assert result['pet_type'] == '강아지'
        assert result['categories'] == ['간식']
        assert 'llm_error' in result
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_extract_product_details_llm_json_parsing_error(self, mock_get_llm):
        """LLM 응답 JSON 파싱 에러 처리 테스트"""
        # 파싱 정보 중 증상과 생애주기가 없는 경우
        parsed_info = {
            'pet_type': '강아지', 
            'categories': ['간식'], 
            'symptoms': [], 
            'life_stage': None,
            'original_query': '강아지 간식 추천해주세요'
        }
        
        # 유효하지 않은 JSON 응답 모킹
        mock_llm = MagicMock()
        mock_chain = MagicMock()
        mock_llm.__or__.return_value = mock_chain
        mock_chain.invoke.return_value = '유효하지 않은 JSON 응답'
        mock_get_llm.return_value = mock_llm
        
        result = extract_product_details_llm('강아지 간식 추천해주세요', parsed_info)
        
        # JSON 파싱 오류가 발생했지만 원본 정보는 유지
        assert result['pet_type'] == '강아지'
        assert result['categories'] == ['간식']
        assert 'llm_error' in result


class TestDBSearch:
    """상품 DB 검색 테스트 클래스"""
    
    @patch('petgpt_chatbot.recommend.execute_mysql_query')
    def test_search_products_in_db_with_pet_type(self, mock_execute_query):
        """반려동물 종류를 기준으로 DB 검색 테스트"""
        # 목업 데이터 설정
        mock_products = [
            {
                'item_key': 1, 
                'item_name': '프리미엄 강아지 사료', 
                'item_content': '성장기 강아지를 위한 영양 만점 사료', 
                'item_price': 30000,
                'item_sprice': 25000,
                'item_img1': 'https://example.com/dog_food.jpg',
                'sales_count': 100,
                'category_key': 1
            }
        ]
        mock_execute_query.return_value = mock_products
        
        # 테스트 파싱 정보
        parsed_info = {
            'pet_type': '강아지',
            'categories': ['사료'],
            'symptoms': [],
            'life_stage': None,
            'original_query': '강아지 사료 추천해줘'
        }
        
        # 함수 호출
        results = search_products_in_db(parsed_info)
        
        # 검증
        assert mock_execute_query.called
        assert len(results) == 1
        assert results[0]['item_key'] == 1
        assert results[0]['item_name'] == '프리미엄 강아지 사료'
    
    @patch('petgpt_chatbot.recommend.execute_mysql_query')
    def test_search_products_in_db_with_symptoms(self, mock_execute_query):
        """증상 키워드를 기준으로 DB 검색 테스트"""
        # 목업 데이터 설정
        mock_products = [
            {
                'item_key': 2, 
                'item_name': '관절 건강 영양제', 
                'item_content': '노령견의 관절 건강을 위한 특별 영양제', 
                'item_price': 45000,
                'item_sprice': 40000,
                'item_img1': 'https://example.com/joint_supplement.jpg',
                'sales_count': 80,
                'category_key': 5
            }
        ]
        mock_execute_query.return_value = mock_products
        
        # 테스트 파싱 정보
        parsed_info = {
            'pet_type': '강아지',
            'categories': ['건강관리'],
            'symptoms': ['관절'],
            'life_stage': '시니어',
            'original_query': '노령견 관절에 좋은 영양제'
        }
        
        # 함수 호출
        results = search_products_in_db(parsed_info)
        
        # 검증
        assert mock_execute_query.called
        assert len(results) == 1
        assert results[0]['item_key'] == 2
        assert '관절' in results[0]['item_name']
        assert '노령견' in results[0]['item_content']
    
    @patch('petgpt_chatbot.recommend.execute_mysql_query')
    def test_search_products_in_db_with_life_stage(self, mock_execute_query):
        """생애주기를 기준으로 DB 검색 테스트"""
        # 목업 데이터 설정
        mock_products = [
            {
                'item_key': 3, 
                'item_name': '키튼 전용 사료', 
                'item_content': '성장기 고양이를 위한 영양가 높은 키튼 사료', 
                'item_price': 35000,
                'item_sprice': 32000,
                'item_img1': 'https://example.com/kitten_food.jpg',
                'sales_count': 90,
                'category_key': 2
            }
        ]
        mock_execute_query.return_value = mock_products
        
        # 테스트 파싱 정보
        parsed_info = {
            'pet_type': '고양이',
            'categories': ['사료'],
            'symptoms': [],
            'life_stage': '퍼피/키튼',
            'original_query': '새끼 고양이 사료 추천'
        }
        
        # 함수 호출
        results = search_products_in_db(parsed_info)
        
        # 검증
        assert mock_execute_query.called
        assert len(results) == 1
        assert results[0]['item_key'] == 3
        assert '키튼' in results[0]['item_name']
    
    @patch('petgpt_chatbot.recommend.execute_mysql_query')
    def test_search_products_in_db_with_price_range(self, mock_execute_query):
        """가격대를 기준으로 DB 검색 테스트"""
        # 목업 데이터 설정
        mock_products = [
            {
                'item_key': 4, 
                'item_name': '저자극 강아지 샴푸', 
                'item_content': '피부가 민감한 강아지를 위한 저자극 샴푸', 
                'item_price': 15000,
                'item_sprice': 12000,
                'item_img1': 'https://example.com/dog_shampoo.jpg',
                'sales_count': 70,
                'category_key': 4
            }
        ]
        mock_execute_query.return_value = mock_products
        
        # 테스트 파싱 정보 (LLM 추출 정보 포함)
        parsed_info = {
            'pet_type': '강아지',
            'categories': ['위생용품'],
            'symptoms': ['피부'],
            'life_stage': None,
            'original_query': '2만원 이하의 강아지 피부에 좋은 샴푸 추천',
            'llm_extracted': {
                'price_range': '2만원 이하',
                'pet_characteristics': '피부 민감한 강아지'
            }
        }
        
        # 함수 호출
        results = search_products_in_db(parsed_info)
        
        # 검증
        assert mock_execute_query.called
        assert len(results) == 1
        assert results[0]['item_key'] == 4
        assert results[0]['item_price'] <= 20000  # 2만원 이하
    
    @patch('petgpt_chatbot.recommend.execute_mysql_query')
    def test_search_products_in_db_error_handling(self, mock_execute_query):
        """DB 검색 오류 처리 테스트"""
        # DB 쿼리 오류 모킹
        mock_execute_query.side_effect = Exception("DB 연결 오류")
        
        # 테스트 파싱 정보
        parsed_info = {
            'pet_type': '강아지',
            'categories': ['사료'],
            'symptoms': [],
            'life_stage': None,
            'original_query': '강아지 사료 추천'
        }
        
        # 함수 호출 - 예외가 발생해도 빈 리스트 반환
        results = search_products_in_db(parsed_info)
        
        # 검증
        assert mock_execute_query.called
        assert isinstance(results, list)
        assert len(results) == 0


class TestProductSelection:
    """상품 선택 테스트 클래스"""
    
    def test_select_final_products_llm_empty_list(self):
        """빈 상품 목록 처리 테스트"""
        products = []
        result = select_final_products_llm("강아지 사료 추천", products)
        assert result == []
    
    def test_select_final_products_llm_single_item(self):
        """단일 상품 목록 처리 테스트"""
        products = [{'item_key': 1, 'item_name': '테스트 상품'}]
        result = select_final_products_llm("강아지 사료 추천", products)
        assert result == products
    
    def test_select_final_products_llm_below_limit(self):
        """최대 개수 이하의 상품 목록 처리 테스트"""
        products = [
            {'item_key': 1, 'item_name': '테스트 상품 1'}, 
            {'item_key': 2, 'item_name': '테스트 상품 2'}
        ]
        result = select_final_products_llm("강아지 사료 추천", products, max_products=3)
        assert len(result) == 2
        assert result == products
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_select_final_products_llm_with_llm_selection(self, mock_get_llm):
        """LLM을 통한 상품 선택 테스트"""
        # 테스트 상품 목록
        products = [
            {'item_key': 1, 'item_name': '상품 1', 'item_content': '설명 1', 'item_price': 10000, 'sales_count': 10},
            {'item_key': 2, 'item_name': '상품 2', 'item_content': '설명 2', 'item_price': 20000, 'sales_count': 20},
            {'item_key': 3, 'item_name': '상품 3', 'item_content': '설명 3', 'item_price': 30000, 'sales_count': 30},
            {'item_key': 4, 'item_name': '상품 4', 'item_content': '설명 4', 'item_price': 40000, 'sales_count': 40},
            {'item_key': 5, 'item_name': '상품 5', 'item_content': '설명 5', 'item_price': 50000, 'sales_count': 50}
        ]
        
        # LLM 응답 모킹 (ID 2와 4를 선택)
        mock_llm = MagicMock()
        mock_chain = MagicMock()
        mock_llm.__or__.return_value = mock_chain
        mock_chain.invoke.return_value = "[2, 4]"
        mock_get_llm.return_value = mock_llm
        
        # 함수 호출
        result = select_final_products_llm("강아지 사료 추천", products, max_products=3)
        
        # 검증
        mock_get_llm.assert_called_once()
        assert len(result) == 2
        assert result[0]['item_key'] == 2
        assert result[1]['item_key'] == 4
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_select_final_products_llm_parsing_error(self, mock_get_llm):
        """LLM 응답 파싱 오류 처리 테스트"""
        # 테스트 상품 목록
        products = [
            {'item_key': 1, 'item_name': '상품 1', 'sales_count': 10},
            {'item_key': 2, 'item_name': '상품 2', 'sales_count': 20},
            {'item_key': 3, 'item_name': '상품 3', 'sales_count': 30},
            {'item_key': 4, 'item_name': '상품 4', 'sales_count': 40},
            {'item_key': 5, 'item_name': '상품 5', 'sales_count': 50}
        ]
        
        # 잘못된 형식의 LLM 응답 모킹
        mock_llm = MagicMock()
        mock_chain = MagicMock()
        mock_llm.__or__.return_value = mock_chain
        mock_chain.invoke.return_value = "잘못된 형식의 응답"
        mock_get_llm.return_value = mock_llm
        
        # 함수 호출 - 판매량 기준 상위 3개 상품 반환 예상
        result = select_final_products_llm("강아지 사료 추천", products, max_products=3)
        
        # 검증
        mock_get_llm.assert_called_once()
        assert len(result) == 3
        assert result[0]['item_key'] == 5  # 판매량 50
        assert result[1]['item_key'] == 4  # 판매량 40
        assert result[2]['item_key'] == 3  # 판매량 30
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_select_final_products_llm_exception(self, mock_get_llm):
        """LLM 호출 예외 처리 테스트"""
        # 테스트 상품 목록
        products = [
            {'item_key': 1, 'item_name': '상품 1', 'sales_count': 10},
            {'item_key': 2, 'item_name': '상품 2', 'sales_count': 20},
            {'item_key': 3, 'item_name': '상품 3', 'sales_count': 30},
            {'item_key': 4, 'item_name': '상품 4', 'sales_count': 40},
            {'item_key': 5, 'item_name': '상품 5', 'sales_count': 50}
        ]
        
        # LLM 호출 예외 모킹
        mock_get_llm.side_effect = Exception("LLM API 오류")
        
        # 함수 호출 - 판매량 기준 상위 3개 상품 반환 예상
        result = select_final_products_llm("강아지 사료 추천", products, max_products=3)
        
        # 검증
        mock_get_llm.assert_called_once()
        assert len(result) == 3
        assert result[0]['item_key'] == 5  # 판매량 50
        assert result[1]['item_key'] == 4  # 판매량 40
        assert result[2]['item_key'] == 3  # 판매량 30 