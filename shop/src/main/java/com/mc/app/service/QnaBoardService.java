package com.mc.app.service;

import com.mc.app.dto.QnaBoard;
import com.mc.app.frame.MCService;
import com.mc.app.repository.QnaBoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class QnaBoardService implements MCService<QnaBoard, Integer> {

    final QnaBoardRepository qnaRepository;

    @Override
    public void add(QnaBoard board) throws Exception {
        qnaRepository.insert(board);
    }

    @Override
    public void mod(QnaBoard board) throws Exception {
        qnaRepository.update(board);
    }

    @Override
    public void del(Integer id) throws Exception {
        qnaRepository.delete(id);
    }

    @Override
    public QnaBoard get(Integer id) throws Exception {
        return qnaRepository.selectOne(id);
    }

    @Override
    public List<QnaBoard> get() throws Exception {
        return qnaRepository.select();
    }

    public List<QnaBoard> findQnaByCust(String custId) throws Exception {
        return qnaRepository.findQnaByCust(custId);
    }

    public List<QnaBoard> findQnaByItem(Integer itemKey) throws Exception {
        return qnaRepository.findQnaByItem(itemKey);
    }

    public List<QnaBoard> findReviewByCust(String custId) throws Exception {
        return qnaRepository.findReviewByCust(custId);
    }

    public List<QnaBoard> findReviewByItem(Integer itemKey) throws Exception {
        return qnaRepository.findReviewByItem(itemKey);
    }




}