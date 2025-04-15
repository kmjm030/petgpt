package com.mc.app.repository;

import com.mc.app.dto.Customer;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface CustomerRepository extends MCRepository<Customer, String> {

    @Select("SELECT COUNT(*) FROM customer")
    int selectCount();

    @Select("SELECT COUNT(*) FROM customer WHERE DATE(cust_rdate) = CURDATE()")
    int selectTodayJoinCount() throws Exception;

    // 최근 가입/수정/삭제 활동을 나타내기 위한 최신 가입 순서
    @Select("SELECT * FROM customer ORDER BY cust_rdate DESC LIMIT 10")
    List<Customer> selectRecentActivities() throws Exception;
}

