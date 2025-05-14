package com.mc.app.repository;

import com.mc.app.dto.PostLike;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface PostLikeRepository {
    int insert(PostLike postLike);
    int delete(@Param("boardKey") Integer boardKey, @Param("custId") String custId);
    int countByBoardKey(Integer boardKey);
    int countByBoardKeyAndCustId(@Param("boardKey") Integer boardKey, @Param("custId") String custId);
} 