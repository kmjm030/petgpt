package com.mc.app.repository;

import com.mc.app.dto.AdminComments;
import com.mc.app.dto.QnaBoard;
import com.mc.app.dto.QnaWithComment;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface QnaBoardRepository extends MCRepository<QnaBoard, Integer> {

    List<QnaBoard> findAllByCust(String custId) throws Exception;
    List<QnaBoard> findAllByItem(Integer itemKey) throws Exception;
    List<QnaWithComment> selectQnaWithCommentsByItemKey(Integer itemKey) throws Exception;

    List<QnaBoard> selectPage(@Param("offset") int offset, @Param("limit") int limit) throws Exception;
    int count() throws Exception;

    // ✅ 검색 + 페이징
    List<QnaBoard> searchPage(@Param("field") String field,
                              @Param("keyword") String keyword,
                              @Param("offset") int offset,
                              @Param("limit") int limit) throws Exception;

    int searchCount(@Param("field") String field,
                    @Param("keyword") String keyword) throws Exception;
}
