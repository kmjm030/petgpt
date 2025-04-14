package com.mc.app.repository;

import com.mc.app.dto.Item;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ItemRepository extends MCRepository<Item, Integer> {
    List<Item> findByCategory(int categoryKey) throws Exception;
    List<Item> findByItemKeys(@Param("itemKeys") List<Integer> itemKeys) throws Exception;
    List<Item> findByPriceRange(@Param("minPrice") int minPrice, @Param("maxPrice") int maxPrice) throws Exception;
    List<Item> findByPriceGreaterThan(@Param("minPrice") int minPrice) throws Exception;
    
    // 정렬 관련 메서드
    List<Item> selectWithOrder(@Param("orderBy") String orderBy) throws Exception;
    List<Item> findByCategoryWithOrder(@Param("categoryKey") int categoryKey, @Param("orderBy") String orderBy) throws Exception;
    List<Item> findByItemKeysWithOrder(@Param("itemKeys") List<Integer> itemKeys, @Param("orderBy") String orderBy) throws Exception;
    List<Item> findByPriceRangeWithOrder(@Param("minPrice") int minPrice, @Param("maxPrice") int maxPrice, @Param("orderBy") String orderBy) throws Exception;
    List<Item> findByPriceGreaterThanWithOrder(@Param("minPrice") int minPrice, @Param("orderBy") String orderBy) throws Exception;
}
