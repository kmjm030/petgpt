package com.mc.app.repository;

import com.mc.app.dto.TotalOrder;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface TotalOrderRepository {

    int selectTotalRevenue() throws Exception;
    List<Map<String, Object>> selectTop10Items() throws Exception;
    int selectOrderCount() throws Exception;
    List<Map<String, Object>> selectOrderStatusCount() throws Exception;
    int countUnansweredQna() throws Exception;
    int countFlaggedReviews() throws Exception;
    List<TotalOrder> selectAll() throws Exception;
    TotalOrder selectOne(Integer orderKey) throws Exception;
    List<TotalOrder> selectRecentOrders() throws Exception;
    int deleteOne(Integer orderKey) throws Exception;
}
