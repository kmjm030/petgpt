package com.mc.app.repository;

import com.mc.app.dto.Cart;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface CartRepository extends MCRepository<Cart, String> {
    List<Map<String, Object>> selectCartWithItems(String custId) throws Exception;
    void delete(Cart cart) throws Exception;
    void update(Cart cart) throws Exception;
}