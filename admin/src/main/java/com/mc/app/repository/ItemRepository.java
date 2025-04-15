package com.mc.app.repository;

import com.mc.app.dto.Item;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Delete;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface ItemRepository extends MCRepository<Item, Integer> {

    @Select("SELECT COUNT(*) FROM item")
    int count();

    @Select("SELECT * FROM item ORDER BY item_regdate DESC LIMIT 5")
    List<Item> selectRecentItems();

    @Insert("INSERT INTO item (...) VALUES (...) ") // 예시, 실제 컬럼명과 바인딩 필요
    void insert(Item item);

    @Update("UPDATE item SET ... WHERE item_key = #{itemKey}") // 예시
    void update(Item item);

    @Delete("DELETE FROM item WHERE item_key = #{itemKey}")
    void delete(int itemKey);
}




