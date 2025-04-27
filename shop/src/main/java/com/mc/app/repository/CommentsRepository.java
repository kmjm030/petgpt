package com.mc.app.repository;

import com.mc.app.dto.Comments;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface CommentsRepository {

    /**
     * 특정 게시글(pboardKey)의 모든 댓글 목록 조회 (작성자 정보, 좋아요 수 포함)
     * commentsmapper.xml 의 findAllByPboard id 와 매핑됨됨
     */
    List<Comments> findAllByPboard(Map<String, Object> params) throws Exception;

    /**
     * 댓글 단 건 조회
     * commentsmapper.xml 의 findById id 와 매핑됨
     */
    Comments findById(Map<String, Object> params) throws Exception;

    /**
     * 댓글 등록
     * commentsmapper.xml 의 insert id 와 매핑됨
     */
    int insert(Comments comments) throws Exception;

    /**
     * 댓글 수정
     * commentsmapper.xml 의 update id 와 매핑됨
     */
    int update(Comments comments) throws Exception;

    /**
     * 댓글 삭제 (PK 기준)
     * commentsmapper.xml 의 delete id 와 매핑됨
     */
    int delete(Integer commentsKey) throws Exception;

    /**
     * 특정 댓글의 좋아요 수 조회
     * commentsmapper.xml의 getLikeCount id와 매핑됨
     */
    int getLikeCount(Integer commentsKey) throws Exception;

    /**
     * 댓글 삭제 상태로 업데이트
     * commentsmapper.xml 의 updateForDeletion id 와 매핑됨
     */
    int updateForDeletion(Comments comment) throws Exception;

}
