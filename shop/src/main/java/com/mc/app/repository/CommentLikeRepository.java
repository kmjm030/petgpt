package com.mc.app.repository;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
@Mapper
public interface CommentLikeRepository {

    /**
     * 댓글 좋아요 정보 등록
     * CommentLikeMapper.xml 의 insert id 와 매핑됨
     */
    int insert(Map<String, Object> params) throws Exception;

    /**
     * 댓글 좋아요 정보 삭제 (특정 사용자의 특정 댓글 좋아요 취소)
     * CommentLikeMapper.xml 의 delete id 와 매핑됨
     */
    int delete(Map<String, Object> params) throws Exception;

    /**
     * 특정 댓글에 대한 모든 좋아요 정보 삭제 (댓글 삭제 시 사용)
     * CommentLikeMapper.xml 의 deleteByCommentKey id 와 매핑됨
     */
    int deleteByCommentKey(Integer commentsKey) throws Exception;

    /**
     * 특정 댓글에 대한 특정 사용자의 좋아요 존재 여부 확인 (count)
     * CommentLikeMapper.xml 의 countByCommentKeyAndCustId id 와 매핑됨
     */
    int countByCommentKeyAndCustId(Map<String, Object> params) throws Exception;

}
