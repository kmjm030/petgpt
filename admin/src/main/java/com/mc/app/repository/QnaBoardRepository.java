package com.mc.app.repository;

import com.mc.app.dto.AdminComments;
import com.mc.app.dto.QnaBoard;
import com.mc.app.dto.QnaWithComment;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface QnaBoardRepository extends MCRepository<QnaBoard, Integer> {
    List<QnaBoard> findAllByCust(String custId) throws Exception;
    List<QnaBoard> findAllByItem(Integer itemKey) throws Exception;
    List<QnaWithComment> selectQnaWithCommentsByItemKey(Integer itemKey) throws Exception;
    List<QnaBoard> selectPage(int offset, int limit) throws Exception;
    int count() throws Exception;
}
