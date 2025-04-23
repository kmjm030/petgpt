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
     * CommentsMapper.xml 의 findAllByPboard id 와 매핑됨
     * 
     * @param params Map containing pboardKey (Integer) and currentCustId (String)
     * @return 댓글 목록 (List<Comments>)
     */
    List<Comments> findAllByPboard(Map<String, Object> params) throws Exception;

    /**
     * 댓글 단 건 조회
     * CommentsMapper.xml 의 findById id 와 매핑됨
     * 
     * @param commentsKey 조회할 댓글 키
     * @return 댓글 정보 (Comments)
     */
    Comments findById(Integer commentsKey) throws Exception;

    /**
     * 댓글 등록
     * CommentsMapper.xml 의 insert id 와 매핑됨
     * 
     * @param comments 등록할 댓글 정보
     */
    void insert(Comments comments) throws Exception;

    /**
     * 댓글 수정
     * CommentsMapper.xml 의 update id 와 매핑됨
     * 
     * @param comments 수정할 댓글 정보
     */
    void update(Comments comments) throws Exception;

    /**
     * 댓글 삭제 (PK 기준)
     * CommentsMapper.xml 의 delete id 와 매핑됨
     * 
     * @param commentsKey 삭제할 댓글 키
     */
    void delete(Integer commentsKey) throws Exception;

}
