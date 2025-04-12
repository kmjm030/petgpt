package com.mc.app.repository;

import com.mc.app.dto.Address;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AddressRepository extends MCRepository<Address, Integer> {
    List<Address> findAllByCustomer(String id) throws Exception;
    Address findById(Integer id) throws Exception;
}
