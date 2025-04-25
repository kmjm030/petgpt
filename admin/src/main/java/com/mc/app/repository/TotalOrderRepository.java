package com.mc.app.repository;

import com.mc.app.dto.TotalOrder;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface TotalOrderRepository extends MCRepository<TotalOrder, Integer> {

    int selectOrderCount() throws Exception;
    int selectTodayRevenue() throws Exception;
    List<Map<String, Object>> selectOrderStatusCount() throws Exception;
    int selectTotalRevenue() throws Exception;

    @Select("""
        SELECT COUNT(*) 
        FROM qna 
        WHERE answer IS NULL OR answer = ''
    """)
    int countUnansweredQna() throws Exception;

    @Select("""
        SELECT COUNT(*) 
        FROM review 
        WHERE report_count > 0
    """)
    int countFlaggedReviews() throws Exception;
}
