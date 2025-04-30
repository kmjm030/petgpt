package com.mc.app.repository;

import com.mc.app.dto.Customer;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
// d
@Repository
@Mapper
public interface CustomerRepository extends MCRepository<Customer, String> {
    int selectCount();
    int selectTodayJoinCount() throws Exception;
    List<Customer> selectTodayJoinedCustomers() throws Exception;
    List<Map<String, Object>> selectWeeklyJoinStats() throws Exception;
}
