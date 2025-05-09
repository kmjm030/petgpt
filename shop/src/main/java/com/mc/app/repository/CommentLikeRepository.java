package com.mc.app.repository;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
@Mapper
public interface CommentLikeRepository {
    int insert(Map<String, Object> params) throws Exception;
    int delete(Map<String, Object> params) throws Exception;
    int deleteByCommentKey(Integer commentsKey) throws Exception;
    int countByCommentKeyAndCustId(Map<String, Object> params) throws Exception;

}
