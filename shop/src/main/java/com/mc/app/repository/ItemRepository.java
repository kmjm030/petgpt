package com.mc.app.repository;

import com.mc.app.dto.Item;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ItemRepository extends MCRepository<Item, Integer> {
        /**
         * 지정된 카테고리 키에 해당하는 상품 목록 조회
         * 
         * @param categoryKey 카테고리 키
         * @return 해당 카테고리의 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByCategory(int categoryKey) throws Exception;

        /**
         * 주어진 상품 키 목록에 해당하는 상품 목록 조회
         * 
         * @param itemKeys 조회할 상품 키 목록
         * @return 해당 상품 키 목록의 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByItemKeys(@Param("itemKeys") List<Integer> itemKeys) throws Exception;

        /**
         * 지정된 가격 범위 내의 상품 목록 조회
         * 
         * @param minPrice 최소 가격
         * @param maxPrice 최대 가격
         * @return 해당 가격 범위의 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByPriceRange(@Param("minPrice") int minPrice, @Param("maxPrice") int maxPrice) throws Exception;

        /**
         * 지정된 최소 가격 이상의 상품 목록 조회
         * 
         * @param minPrice 최소 가격
         * @return 해당 최소 가격 이상의 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByPriceGreaterThan(@Param("minPrice") int minPrice) throws Exception;

        /**
         * 지정된 순서로 정렬된 모든 상품 목록 조회
         * 
         * @param orderBy 정렬 조건 문자열 (예: "item_price ASC")
         * @return 정렬된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> selectWithOrder(@Param("orderBy") String orderBy) throws Exception;

        /**
         * 지정된 카테고리 키에 해당하는 상품 목록을 지정된 순서로 정렬하여 조회
         * 
         * @param categoryKey 카테고리 키
         * @param orderBy     정렬 조건 문자열
         * @return 해당 카테고리의 정렬된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByCategoryWithOrder(@Param("categoryKey") int categoryKey, @Param("orderBy") String orderBy)
                        throws Exception;

        /**
         * 주어진 상품 키 목록에 해당하는 상품 목록을 지정된 순서로 정렬하여 조회
         * 
         * @param itemKeys 조회할 상품 키 목록
         * @param orderBy  정렬 조건 문자열
         * @return 해당 상품 키 목록의 정렬된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByItemKeysWithOrder(@Param("itemKeys") List<Integer> itemKeys, @Param("orderBy") String orderBy)
                        throws Exception;

        /**
         * 지정된 가격 범위 내의 상품 목록을 지정된 순서로 정렬하여 조회
         * 
         * @param minPrice 최소 가격
         * @param maxPrice 최대 가격
         * @param orderBy  정렬 조건 문자열
         * @return 해당 가격 범위의 정렬된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByPriceRangeWithOrder(@Param("minPrice") int minPrice, @Param("maxPrice") int maxPrice,
                        @Param("orderBy") String orderBy) throws Exception;

        /**
         * 지정된 최소 가격 이상의 상품 목록을 지정된 순서로 정렬하여 조회
         * 
         * @param minPrice 최소 가격
         * @param orderBy  정렬 조건 문자열
         * @return 해당 최소 가격 이상의 정렬된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByPriceGreaterThanWithOrder(@Param("minPrice") int minPrice, @Param("orderBy") String orderBy)
                        throws Exception;

        /**
         * 상품명에 특정 키워드가 포함된 상품 목록 조회
         * 
         * @param keyword 검색할 키워드
         * @return 키워드가 포함된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByNameContaining(@Param("keyword") String keyword) throws Exception;

        /**
         * 상품명에 특정 키워드가 포함된 상품 목록을 지정된 순서로 정렬하여 조회
         * 
         * @param keyword 검색할 키워드
         * @param orderBy 정렬 조건 문자열
         * @return 키워드가 포함된 정렬된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> findByNameContainingWithOrder(@Param("keyword") String keyword, @Param("orderBy") String orderBy)
                        throws Exception;

        /**
         * 전체 상품 개수 조회
         * 
         * @return 전체 상품 개수
         */
        @Select("SELECT COUNT(*) FROM item")
        int getTotalCount();

        /**
         * 지정된 순서로 정렬하고 개수를 제한하여 상품 목록 조회
         * 
         * @param orderBy 정렬 조건 문자열 (예: "sales_count DESC")
         * @param limit   조회할 개수
         * @return 정렬 및 제한된 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> selectWithOrderAndLimit(@Param("orderBy") String orderBy, @Param("limit") int limit)
                        throws Exception;

        // --- 베스트셀러 조회를 위한 새로운 메서드 추가 ---
        /**
         * 완료된 주문을 기준으로 판매량 상위 상품 목록 조회
         * 
         * @param orderStatus 집계할 주문 상태 (예: "COMPLETED")
         * @param limit       조회할 개수
         * @return 판매량 순 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> selectBestSellingItemsFromOrders(@Param("orderStatus") String orderStatus, @Param("limit") int limit)
                        throws Exception;

        /**
         * 리뷰 수를 기준으로 상위 상품 목록 조회
         * 
         * @param limit 조회할 개수
         * @return 리뷰 수 순 상품 목록
         * @throws Exception DB 조회 오류 발생 시
         */
        List<Item> selectItemsByReviewCount(@Param("limit") int limit) throws Exception;

        /**
         * 상품 키로 상품 기본 정보와 상세 설명을 함께 조회
         * 
         * @param itemKey 상품 키
         * @return 상품 정보 (상세 설명 포함)
         * @throws Exception DB 조회 오류 발생 시
         */
        Item findItemWithDetailByKey(int itemKey) throws Exception; // 상세 정보 포함 조회 메서드

        /**
         * 상품 상세 설명 추가 또는 수정 (UPSERT)
         * 
         * @param item 상세 설명이 포함된 Item 객체 (itemKey, itemDetail 필요)
         * @return 영향을 받은 행 수
         * @throws Exception DB 오류 발생 시
         */
        int upsertItemDetail(Item item) throws Exception;

        /**
         * 상품 상세 설명 삭제
         * 
         * @param itemKey 삭제할 상품 키
         * @return 영향을 받은 행 수
         * @throws Exception DB 오류 발생 시
         */
        int deleteItemDetail(int itemKey) throws Exception;

        /**
         * 모든 상품의 기본 키 목록을 조회
         * 
         * @return 모든 상품의 itemKey 리스트
         */
        List<Integer> selectAllItemKeys();

}
