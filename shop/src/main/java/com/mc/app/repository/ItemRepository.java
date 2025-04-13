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
}
