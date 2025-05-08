package com.mc.app.repository;

import com.mc.app.dto.Like;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Mapper
public interface LikeRepository extends MCRepository<Like, Integer> {
    List<Like> findAllByCustomer(String custId) throws Exception;
    void insert(Like like) throws Exception;
    void deleteByCustAndItem(Like like) throws Exception;
    Like findByCustIdAndItemKey(@Param("custId") String custId, @Param("itemKey") int itemKey) throws Exception;
    int countByCustId(String custId) throws Exception;
    void deleteForMypage(String custId, int itemKey) throws Exception;
    void deleteOlderThan(Date date) throws Exception;
} 