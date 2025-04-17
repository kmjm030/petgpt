package com.mc.app.repository;

import com.mc.app.dto.QnaBoard;
import com.mc.app.dto.TotalOrder;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface TotalOrderRepository extends MCRepository<TotalOrder, Integer> {
    List<TotalOrder> findAllByCustomer(String custId) throws Exception;
}
