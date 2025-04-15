package com.mc.app.repository;

import com.mc.app.dto.TotalOrder;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface TotalOrderRepository extends MCRepository<TotalOrder, Integer> {
    int selectOrderCount() throws Exception;
    int selectTodayRevenue() throws Exception;
}


