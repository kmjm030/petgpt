package com.mc.app.repository;

import com.mc.app.dto.Comments;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface CommentsRepository {
    List<Comments> findAllByPboard(Map<String, Object> params) throws Exception;
    Comments findById(Map<String, Object> params) throws Exception;
    int insert(Comments comments) throws Exception;
    int update(Comments comments) throws Exception;
    int delete(Integer commentsKey) throws Exception;
    int getLikeCount(Integer commentsKey) throws Exception;
    int updateForDeletion(Comments comment) throws Exception;

}
