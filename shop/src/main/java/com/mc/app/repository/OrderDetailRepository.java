package com.mc.app.repository;

import com.mc.app.dto.OrderDetail;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface OrderDetailRepository extends MCRepository<OrderDetail, Integer> {
    List<OrderDetail> findAllByOrder(int orderKey) throws Exception;
    List<OrderDetail> findAllByCustomer(String custId) throws Exception;
    List<OrderDetail> findNoReview(String custId) throws Exception;
    void deleteByOrderKey(int orderKey) throws Exception;
}
