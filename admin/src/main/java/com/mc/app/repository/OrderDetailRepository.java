package com.mc.app.repository;

import com.mc.app.dto.OrderDetail;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Mapper
@Repository
public interface OrderDetailRepository {
    List<OrderDetail> findAll();
    OrderDetail findById(int id);
    int count();
    void deleteById(@Param("id") int id);
}
