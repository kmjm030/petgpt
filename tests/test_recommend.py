import unittest
from unittest.mock import patch, MagicMock
import os
import sys

# 상위 디렉토리를 PATH에 추가하여 petgpt_chatbot 모듈 import 가능하게 함
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from petgpt_chatbot.recommend import parse_product_request_rules


class TestProductRecommend(unittest.TestCase):
    
    def test_parse_product_request_rules_extracts_entities(self):
        """
        여러 형태의 사용자 입력에서 동물 종류, 카테고리, 키워드가 정확히 추출되는지 테스트
        """
        # 테스트 케이스: 사용자 입력 및 예상 추출 결과
        test_cases = [
            # 간단한 요청, 모든 정보 포함
            {
                "input": "강아지 사료 추천해줘",
                "expected": {
                    "animal_type": "강아지",
                    "category": "사료",
                    "keywords": []
                }
            },
            # 복잡한 요청, 키워드 포함
            {
                "input": "우리 고양이가 털을 많이 빠뜨리는데 털 빠짐 방지에 좋은 고양이 사료 추천해줘",
                "expected": {
                    "animal_type": "고양이",
                    "category": "사료",
                    "keywords": ["털 빠짐", "방지"]
                }
            },
            # 특정 품종 언급
            {
                "input": "말티즈 강아지용 장난감 추천해줘",
                "expected": {
                    "animal_type": "강아지",
                    "category": "장난감",
                    "keywords": ["말티즈"]
                }
            },
            # 연령대 포함
            {
                "input": "노견용 영양제 추천해주세요",
                "expected": {
                    "animal_type": "강아지",
                    "category": "영양제",
                    "keywords": ["노견용"]
                }
            },
            # 복합 카테고리
            {
                "input": "고양이 스크래처 추천 부탁해요",
                "expected": {
                    "animal_type": "고양이",
                    "category": "스크래처",
                    "keywords": []
                }
            },
            # 동물 종류 없이 카테고리만 언급
            {
                "input": "반려동물 간식 추천해주세요",
                "expected": {
                    "animal_type": None,
                    "category": "간식",
                    "keywords": ["반려동물"]
                }
            },
            # 반려동물 -> 애완동물 변형
            {
                "input": "애완동물 장난감 추천해줘",
                "expected": {
                    "animal_type": None,
                    "category": "장난감",
                    "keywords": ["애완동물"]
                }
            },
            # 구체적인 제품 특성 언급
            {
                "input": "저희 강아지가 이빨이 약해서 부드러운 강아지 간식을 찾고 있어요",
                "expected": {
                    "animal_type": "강아지",
                    "category": "간식",
                    "keywords": ["부드러운", "이빨이 약"]
                }
            }
        ]
        
        # 각 테스트 케이스 실행
        for i, test_case in enumerate(test_cases):
            user_input = test_case["input"]
            expected = test_case["expected"]
            
            # 함수 실행
            result = parse_product_request_rules(user_input)
            
            # 검증
            self.assertEqual(result["animal_type"], expected["animal_type"], 
                            f"테스트 케이스 {i+1}: 동물 종류가 다름")
            self.assertEqual(result["category"], expected["category"], 
                            f"테스트 케이스 {i+1}: 카테고리가 다름")
            
            # 키워드는 부분 집합으로 검증 (순서 무관)
            actual_keywords = set(result["keywords"])
            expected_keywords = set(expected["keywords"])
            expected_subset = expected_keywords.issubset(actual_keywords)
            self.assertTrue(expected_subset, 
                            f"테스트 케이스 {i+1}: 기대 키워드가 실제 키워드에 포함되지 않음. 기대: {expected_keywords}, 실제: {actual_keywords}")
    
    def test_parse_product_request_rules_edge_cases(self):
        """
        경계 조건에서 규칙 기반 파서가 적절히 동작하는지 테스트
        """
        # 테스트 케이스: 엣지 케이스
        edge_cases = [
            # 빈 문자열
            {
                "input": "",
                "expected": {
                    "animal_type": None,
                    "category": None,
                    "keywords": []
                }
            },
            # 관련 없는 문장
            {
                "input": "오늘 날씨가 정말 좋네요",
                "expected": {
                    "animal_type": None,
                    "category": None,
                    "keywords": []
                }
            },
            # 동물 없이 제품만 언급한 경우
            {
                "input": "사료 추천해주세요",
                "expected": {
                    "animal_type": None,
                    "category": "사료",
                    "keywords": []
                }
            },
            # 여러 동물이 언급된 경우 (첫 번째 언급 사용)
            {
                "input": "강아지와 고양이 둘 다 먹을 수 있는 간식 추천해주세요",
                "expected": {
                    "animal_type": "강아지",
                    "category": "간식",
                    "keywords": ["고양이", "둘 다"]
                }
            }
        ]
        
        # 각 테스트 케이스 실행
        for i, test_case in enumerate(edge_cases):
            user_input = test_case["input"]
            expected = test_case["expected"]
            
            # 함수 실행
            result = parse_product_request_rules(user_input)
            
            # 검증
            self.assertEqual(result["animal_type"], expected["animal_type"], 
                            f"엣지 케이스 {i+1}: 동물 종류가 다름")
            self.assertEqual(result["category"], expected["category"], 
                            f"엣지 케이스 {i+1}: 카테고리가 다름")
            
            # 키워드는 부분 집합으로 검증 (순서 무관)
            if expected["keywords"]:
                actual_keywords = set(result["keywords"])
                expected_keywords = set(expected["keywords"])
                expected_subset = expected_keywords.issubset(actual_keywords)
                self.assertTrue(expected_subset, 
                                f"엣지 케이스 {i+1}: 기대 키워드가 실제 키워드에 포함되지 않음")

    @patch('petgpt_chatbot.recommend.get_llm')
    def test_extract_product_details_llm(self, mock_get_llm):
        """
        extract_product_details_llm 함수가 LLM을 사용하여 상세 정보를 추출하는지 테스트합니다.
        단순화된 접근 방식을 사용합니다.
        """
        # Mock 설정
        # 실제 추천 모듈에서 체인 대신 직접 함수 호출 방식으로 변경하여 모킹
        from petgpt_chatbot.recommend import extract_product_details_llm
        import json
        
        # LLM이 반환할 데이터 정의
        expected_llm_data = {
            "pet_characteristics": ["민감한 피부", "장모종"],
            "price_range": "3만원 이하",
            "brand_preference": ["오리젠", "로얄캐닌"],
            "priorities": ["성분", "기호성"],
            "additional_info": "알러지 반응 없는 제품 선호"
        }
        
        # extract_product_details_llm 함수 내부에서 사용하는 함수 모킹을 위한 패치 적용
        with patch('petgpt_chatbot.recommend.PRODUCT_DETAIL_EXTRACTION_PROMPT_LLM') as mock_prompt:
            with patch('langchain_core.output_parsers.StrOutputParser') as mock_parser:
                # 함수 내에서 체인을 통해 LLM 응답을 받는 부분 모킹
                mock_chain = MagicMock()
                mock_chain.invoke.return_value = json.dumps(expected_llm_data)
                
                # 체인 구성 모킹
                mock_llm = MagicMock()
                mock_get_llm.return_value = mock_llm
                
                # (prompt | llm | parser) 체인 구성 모킹
                mock_prompt_chain = MagicMock()
                mock_prompt.__or__.return_value = mock_prompt_chain
                mock_prompt_chain.__or__.return_value = mock_chain
                
                # 테스트 1: LLM 호출이 필요한 경우 (키워드가 부족한 경우)
                test_info1 = {
                    "animal_type": "고양이",
                    "category": "사료", 
                    "keywords": []
                }
                
                # 함수 호출
                result1 = extract_product_details_llm("고양이 사료 추천", test_info1.copy())
                
                # 검증
                self.assertIn("llm_extracted", result1)
                self.assertEqual(result1["llm_extracted"]["price_range"], "3만원 이하")
                
                # 테스트 2: LLM 호출이 불필요한 경우 (정보가 충분한 경우)
                mock_chain.reset_mock()
                mock_get_llm.reset_mock()
                
                test_info2 = {
                    "animal_type": "강아지",
                    "category": "장난감",
                    "keywords": ["dummy1", "dummy2", "dummy3"]  # 키워드가 2개 이상이면 충분
                }
                
                # 함수 호출
                result2 = extract_product_details_llm("강아지 장난감 추천", test_info2.copy())
                
                # 검증 - LLM이 호출되지 않았으므로 llm_extracted 필드가 없어야 함
                self.assertNotIn("llm_extracted", result2)
                self.assertEqual(result2["animal_type"], "강아지")
                self.assertEqual(result2["category"], "장난감")
                self.assertEqual(len(result2["keywords"]), 3)

    @patch('petgpt_chatbot.recommend.execute_mysql_query')  # DB 쿼리 실행 함수 Mocking
    def test_search_products_in_db(self, mock_execute_mysql_query):
        """
        search_products_in_db 함수가 파싱된 조건으로 올바른 SQL 쿼리를 생성하고 실행하는지 테스트
        """
        # Mock DB 응답 설정 - 더미 상품 데이터
        mock_products = [
            {
                "item_key": 1001,
                "item_name": "프리미엄 강아지 사료",
                "item_content": "건강한 강아지를 위한 고품질 사료입니다.",
                "item_price": 25000,
                "item_sprice": 20000,
                "item_img1": "dog_food_1.jpg",
                "sales_count": 120,
                "category_key": 1
            },
            {
                "item_key": 1002,
                "item_name": "유기농 강아지 간식",
                "item_content": "100% 유기농 재료로 만든 건강한 간식",
                "item_price": 15000,
                "item_sprice": 12000,
                "item_img1": "dog_treat_1.jpg",
                "sales_count": 85,
                "category_key": 2
            }
        ]
        mock_execute_mysql_query.return_value = mock_products

        from petgpt_chatbot.recommend import search_products_in_db

        # 테스트 케이스
        test_cases = [
            # 기본 검색: 동물 종류와 카테고리만 지정
            {
                "parsed_info": {
                    "animal_type": "강아지",
                    "category": "사료",
                    "keywords": []
                },
                "expected_products_count": 2  # 모의 응답은 2개 상품 반환
            },
            # 키워드 포함 검색
            {
                "parsed_info": {
                    "animal_type": "강아지",
                    "category": "사료",
                    "keywords": ["유기농", "건강"]
                },
                "expected_products_count": 2  # 같은 모의 응답 사용
            },
            # LLM 추출 정보 포함 검색
            {
                "parsed_info": {
                    "animal_type": "강아지",
                    "category": "사료",
                    "keywords": ["유기농"],
                    "llm_extracted": {
                        "price_range": "3만원 이하",
                        "brand_preference": "로얄캐닌"
                    }
                },
                "expected_products_count": 2  # 같은 모의 응답 사용
            },
            # item_name LIKE 검색 테스트
            {
                "parsed_info": {
                    "animal_type": "고양이",
                    "category": None,
                    "keywords": ["간식"]
                },
                "expected_products_count": 2  # 같은 모의 응답 사용
            }
        ]

        for i, tc in enumerate(test_cases):
            # 각 테스트 케이스 실행 전에 mock 리셋
            mock_execute_mysql_query.reset_mock()

            # search_products_in_db 함수 호출
            result_products = search_products_in_db(tc["parsed_info"])

            # 검증 1: DB 쿼리 함수 호출 확인
            mock_execute_mysql_query.assert_called_once()
            
            # 검증 2: 쿼리 문자열 및 파라미터 검증
            args, _ = mock_execute_mysql_query.call_args
            query_str = args[0]
            query_params = args[1]
            
            # 쿼리가 SELECT 문으로 시작하고 FROM Item을 포함하는지 확인
            self.assertTrue(query_str.strip().upper().startswith("SELECT"), f"Test case {i+1}: Query should start with SELECT")
            self.assertIn("FROM", query_str.upper(), f"Test case {i+1}: Query should include FROM clause")
            self.assertIn("Item", query_str, f"Test case {i+1}: Query should query the Item table")
            
            # 검색 조건 확인
            if tc["parsed_info"].get("animal_type"):
                self.assertTrue(
                    "pet_type = %s" in query_str or "item_name LIKE %s" in query_str,
                    f"Test case {i+1}: Query should filter by pet type"
                )
                found = False
                for param in query_params:
                    if isinstance(param, str) and tc["parsed_info"]["animal_type"] in param:
                        found = True
                        break
                self.assertTrue(found, f"Test case {i+1}: Query params should include animal type")
            
            if tc["parsed_info"].get("category"):
                self.assertTrue(
                    "category_name LIKE %s" in query_str or "item_name LIKE %s" in query_str,
                    f"Test case {i+1}: Query should filter by category"
                )
            
            # LIMIT 절 확인
            self.assertIn("LIMIT", query_str.upper(), f"Test case {i+1}: Query should include LIMIT clause")
            
            # 검증 3: 반환된 상품 개수 확인
            self.assertEqual(len(result_products), tc["expected_products_count"], f"Test case {i+1}: Wrong number of products returned")
            
            # 검증 4: 반환된 상품 구조 확인
            for product in result_products:
                self.assertIn("item_key", product, f"Test case {i+1}: Products should have item_key field")
                self.assertIn("item_name", product, f"Test case {i+1}: Products should have item_name field")
                self.assertIn("item_price", product, f"Test case {i+1}: Products should have item_price field")

    @patch('petgpt_chatbot.recommend.get_llm')
    def test_select_final_products_llm(self, mock_get_llm):
        """
        select_final_products_llm 함수가 LLM을 사용하여 상품 목록에서 1~3개의 상품을 선택하는지 테스트합니다.
        """
        # 모의 상품 데이터 설정
        mock_products = [
            {
                "item_key": 1001,
                "item_name": "프리미엄 강아지 사료",
                "item_content": "건강한 강아지를 위한 고품질 사료입니다.",
                "item_price": 25000,
                "item_sprice": 20000,
                "item_img1": "dog_food_1.jpg",
                "sales_count": 120,
                "category_key": 1
            },
            {
                "item_key": 1002,
                "item_name": "유기농 강아지 간식",
                "item_content": "100% 유기농 재료로 만든 건강한 간식",
                "item_price": 15000,
                "item_sprice": 12000,
                "item_img1": "dog_treat_1.jpg",
                "sales_count": 85,
                "category_key": 2
            },
            {
                "item_key": 1003,
                "item_name": "고급 강아지 장난감",
                "item_content": "내구성이 강한 고급 장난감",
                "item_price": 18000,
                "item_sprice": 15000,
                "item_img1": "dog_toy_1.jpg",
                "sales_count": 95,
                "category_key": 3
            },
            {
                "item_key": 1004,
                "item_name": "일반 강아지 사료",
                "item_content": "일반 강아지용 사료",
                "item_price": 10000,
                "item_sprice": 8000,
                "item_img1": "dog_food_2.jpg",
                "sales_count": 50,
                "category_key": 1
            }
        ]
        
        # Mock LLM 응답 설정
        mock_llm_instance = MagicMock()
        mock_get_llm.return_value = mock_llm_instance
        
        # LLM 응답 설정 - 상품 ID 목록 형식 (select_final_products_llm 함수에서 기대하는 응답 형식)
        mock_llm_output = "[1001, 1002, 1003]"
        
        # StrOutputParser mock (체인 연결을 위해)
        with patch('petgpt_chatbot.recommend.StrOutputParser') as mock_parser:
            mock_chain = MagicMock()
            mock_llm_instance.__or__.return_value = mock_chain
            mock_chain.invoke.return_value = mock_llm_output
            
            from petgpt_chatbot.recommend import select_final_products_llm
            
            # 사용자 쿼리
            user_query = "강아지 사료 추천해주세요"
            
            # 함수 실행
            result = select_final_products_llm(user_query, mock_products)
            
            # 검증
            # 1. LLM 호출 확인
            mock_get_llm.assert_called_once()
            mock_chain.invoke.assert_called_once()
            
            # 2. 반환된 결과가 기대한 형식인지 확인
            self.assertEqual(len(result), 3)  # 3개 상품 선택
            self.assertEqual(result[0]['item_key'], 1001)
            self.assertEqual(result[1]['item_key'], 1002)
            self.assertEqual(result[2]['item_key'], 1003)
    
    @patch('petgpt_chatbot.recommend.get_llm')
    def test_generate_recommendation_message_llm(self, mock_get_llm):
        """
        generate_recommendation_message_llm 함수가 상품 정보로 자연스러운 추천 메시지를 생성하는지 테스트합니다.
        """
        # 모의 상품 데이터 설정
        mock_products = [
            {
                "item_key": 1001,
                "item_name": "프리미엄 강아지 사료",
                "item_content": "건강한 강아지를 위한 고품질 사료입니다.",
                "item_price": 25000,
                "item_sprice": 20000,
                "item_img1": "dog_food_1.jpg",
                "sales_count": 120,
                "category_key": 1
            },
            {
                "item_key": 1002,
                "item_name": "유기농 강아지 간식",
                "item_content": "100% 유기농 재료로 만든 건강한 간식",
                "item_price": 15000,
                "item_sprice": 12000,
                "item_img1": "dog_treat_1.jpg",
                "sales_count": 85,
                "category_key": 2
            }
        ]
        
        # Mock LLM 응답 설정
        mock_llm_instance = MagicMock()
        mock_get_llm.return_value = mock_llm_instance
        
        # 생성된 추천 메시지 예시
        expected_message = "강아지에게 좋은 프리미엄 사료와 유기농 간식을 추천해 드립니다. 프리미엄 강아지 사료는 건강에 좋은 고품질 재료로 만들어졌으며, 유기농 강아지 간식은 100% 유기농 재료로 만들어 안심하고 급여할 수 있습니다."
        
        # StrOutputParser mock (체인 연결을 위해)
        with patch('petgpt_chatbot.recommend.StrOutputParser') as mock_parser:
            mock_chain = MagicMock()
            mock_llm_instance.__or__.return_value = mock_chain
            mock_chain.invoke.return_value = expected_message
            
            from petgpt_chatbot.recommend import generate_recommendation_message_llm
            
            # 사용자 쿼리
            user_query = "강아지 사료 추천해주세요"
            
            # 함수 실행
            result = generate_recommendation_message_llm(user_query, mock_products)
            
            # 검증
            # 1. LLM 호출 확인
            mock_get_llm.assert_called_once()
            mock_chain.invoke.assert_called_once()
            
            # 2. 반환된 결과가 기대한 메시지인지 확인
            self.assertEqual(result, expected_message)
    
    @patch('petgpt_chatbot.recommend.select_final_products_llm')
    @patch('petgpt_chatbot.recommend.generate_recommendation_message_llm')
    @patch('petgpt_chatbot.recommend.search_products_in_db')
    @patch('petgpt_chatbot.recommend.extract_product_details_llm')
    @patch('petgpt_chatbot.recommend.parse_product_request_rules')
    def test_get_product_recommendation(self, mock_parse, mock_extract, mock_search, mock_generate, mock_select):
        """
        get_product_recommendation 함수가 전체 파이프라인을 실행하고 올바른 결과를 반환하는지 테스트합니다.
        """
        # 모의 데이터 설정
        mock_parse.return_value = {
            "animal_type": "강아지", 
            "category": "사료", 
            "keywords": ["유기농"]
        }
        
        mock_extract.return_value = {
            "animal_type": "강아지", 
            "category": "사료", 
            "keywords": ["유기농"],
            "llm_extracted": {
                "pet_characteristics": ["중형견"], 
                "price_range": "2만원 이하"
            }
        }
        
        mock_products = [
            {
                "item_key": 1001,
                "item_name": "프리미엄 강아지 사료",
                "item_content": "건강한 강아지를 위한 고품질 사료입니다.",
                "item_price": 25000,
                "item_sprice": 20000,
                "item_img1": "dog_food_1.jpg",
                "sales_count": 120,
                "category_key": 1
            },
            {
                "item_key": 1002,
                "item_name": "유기농 강아지 간식",
                "item_content": "100% 유기농 재료로 만든 건강한 간식",
                "item_price": 15000,
                "item_sprice": 12000,
                "item_img1": "dog_treat_1.jpg",
                "sales_count": 85,
                "category_key": 2
            }
        ]
        
        mock_search.return_value = mock_products
        mock_select.return_value = [mock_products[0]]  # 첫 번째 상품만 선택
        
        expected_message = "프리미엄 강아지 사료를 추천해 드립니다. 건강한 강아지를 위한 고품질 사료로, 영양가가 풍부합니다."
        mock_generate.return_value = expected_message
        
        from petgpt_chatbot.recommend import get_product_recommendation
        
        # 사용자 쿼리
        user_query = "강아지 사료 추천해주세요"
        
        # 함수 실행
        result_message, result_products = get_product_recommendation(user_query)
        
        # 검증
        # 1. 파이프라인의 모든 함수 호출 확인
        mock_parse.assert_called_once_with(user_query)
        mock_extract.assert_called_once()
        mock_search.assert_called_once()
        mock_select.assert_called_once()
        mock_generate.assert_called_once()
        
        # 2. 반환된 결과 확인
        self.assertEqual(result_message, expected_message)
        self.assertEqual(len(result_products), 1)
        self.assertEqual(result_products[0].product_id, "1001")
        self.assertEqual(result_products[0].name, "프리미엄 강아지 사료")
        self.assertEqual(result_products[0].price, 20000)  # item_price가 아닌 item_sprice 값 기대


if __name__ == "__main__":
    unittest.main() 