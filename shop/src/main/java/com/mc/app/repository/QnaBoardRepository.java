package com.mc.app.repository;

import com.mc.app.dto.QnaBoard;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface QnaBoardRepository extends MCRepository<QnaBoard, Integer> {
    List<QnaBoard> findQnaByCust(String custId) throws Exception;
    List<QnaBoard> findQnaByItem(Integer itemKey) throws Exception;
    List<QnaBoard> findReviewByCust(String custId) throws Exception;
    List<QnaBoard> findReviewByItem(Integer itemKey) throws Exception;
}
