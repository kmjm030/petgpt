package com.mc.app.service;

import com.mc.app.dto.Coupon;
import com.mc.app.frame.MCService;
import com.mc.app.repository.CouponRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CouponService implements MCService<Coupon, Integer> {

    final CouponRepository couponRepository;


    @Override
    public void add(Coupon coupon) throws Exception {
        couponRepository.insert(coupon);
    }

    @Override
    public void mod(Coupon coupon) throws Exception {
        couponRepository.update(coupon);
    }

    @Override
    public void del(Integer integer) throws Exception {
        couponRepository.delete(integer);
    }

    @Override
    public Coupon get(Integer integer) throws Exception {
        return couponRepository.selectOne(integer);
    }

    @Override
    public List<Coupon> get() throws Exception {
        return couponRepository.select();
    }

    public List<Coupon> findByCustId(String custId) throws Exception {
        return couponRepository.findByCustId(custId);
    }
}