package com.mc.app.repository;

import com.mc.app.dto.TotalOrder;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface TotalOrderRepository extends MCRepository<TotalOrder, Integer> {

    @Select("SELECT COUNT(*) FROM total_order")
    int selectOrderCount() throws Exception;

    @Select("SELECT SUM(order_totalprice) FROM total_order WHERE DATE(order_date) = CURDATE()")
    int selectTodayRevenue() throws Exception;

    @Select("SELECT * FROM total_order ORDER BY order_date DESC LIMIT 5")
    List<TotalOrder> selectRecentOrders();

    @Select("SELECT * FROM total_order ORDER BY order_date DESC LIMIT 10")
    List<TotalOrder> selectActivityLog();
}




