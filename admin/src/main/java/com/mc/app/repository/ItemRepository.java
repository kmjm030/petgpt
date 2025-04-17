package com.mc.app.repository;

import com.mc.app.dto.Item;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@Mapper
public interface ItemRepository extends MCRepository<Item, Integer> {

    @Select("SELECT COUNT(*) FROM item")
    int count();
    List<Item> selectTopSellingItems(@Param("limit") int limit);
}