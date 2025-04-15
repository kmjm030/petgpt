package com.mc.app.repository;

import com.mc.app.dto.Customer;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface CustomerRepository extends MCRepository<Customer, String> {
    int selectCount();
    int selectTodayJoinCount() throws Exception;
}
