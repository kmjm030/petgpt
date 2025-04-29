package com.mc.app.repository;

import com.mc.app.dto.Item;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ItemRepository extends MCRepository<Item, Integer> {
    List<Item> findByCategory(int categoryKey) throws Exception;

    List<Item> findByItemKeys(@Param("itemKeys") List<Integer> itemKeys) throws Exception;

    List<Item> findByPriceRange(@Param("minPrice") int minPrice, @Param("maxPrice") int maxPrice) throws Exception;

    List<Item> findByPriceGreaterThan(@Param("minPrice") int minPrice) throws Exception;

    List<Item> selectWithOrder(@Param("orderBy") String orderBy) throws Exception;

    List<Item> findByCategoryWithOrder(@Param("categoryKey") int categoryKey, @Param("orderBy") String orderBy)
            throws Exception;

    List<Item> findByItemKeysWithOrder(@Param("itemKeys") List<Integer> itemKeys, @Param("orderBy") String orderBy)
            throws Exception;

    List<Item> findByPriceRangeWithOrder(@Param("minPrice") int minPrice, @Param("maxPrice") int maxPrice,
            @Param("orderBy") String orderBy) throws Exception;

    List<Item> findByPriceGreaterThanWithOrder(@Param("minPrice") int minPrice, @Param("orderBy") String orderBy)
            throws Exception;

    List<Item> findByNameContaining(@Param("keyword") String keyword) throws Exception;

    List<Item> findByNameContainingWithOrder(@Param("keyword") String keyword, @Param("orderBy") String orderBy)
            throws Exception;

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
    List<Item> selectWithOrderAndLimit(@Param("orderBy") String orderBy, @Param("limit") int limit) throws Exception;

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
}
