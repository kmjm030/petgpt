package com.mc.app.service;

import com.mc.app.dto.AdminComments;
import com.mc.app.dto.QnaBoard;
import com.mc.app.dto.QnaWithComment;
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

    public List<QnaBoard> findAllByCust(String custId) throws Exception {
        return qnaRepository.findAllByCust(custId);
    }

    public List<QnaBoard> findAllByItem(Integer itemKey) throws Exception {
        return qnaRepository.findAllByItem(itemKey);
    }

    public List<QnaWithComment> selectQnaWithCommentsByItemKey(Integer itemKey) throws Exception{
        return qnaRepository.selectQnaWithCommentsByItemKey(itemKey);
    }




}