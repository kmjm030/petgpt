package com.mc.app.repository;

import com.mc.app.dto.Coupon;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface CouponRepository extends MCRepository<Coupon, Integer>{
    List<Coupon> findByCustId(String custId) throws Exception;
    List<Coupon> findUsableByCustId(String custId) throws Exception;
}
