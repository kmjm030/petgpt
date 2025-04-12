package com.mc.app.repository;

import com.mc.app.dto.Item;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ItemRepository extends MCRepository<Item, Integer> {

}


