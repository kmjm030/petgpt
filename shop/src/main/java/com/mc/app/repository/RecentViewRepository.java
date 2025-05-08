package com.mc.app.repository;

import com.mc.app.dto.Address;
import com.mc.app.dto.RecentView;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface RecentViewRepository extends MCRepository<RecentView, Integer> {
    List<RecentView> findAllByCustomer(String id) throws Exception;
    RecentView findByCustAndItem(Map<String, Object> param) throws Exception;
}
