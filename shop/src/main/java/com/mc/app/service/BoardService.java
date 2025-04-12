package com.mc.app.service;

import com.mc.app.dto.Board;
import com.mc.app.frame.MCService;
import com.mc.app.repository.BoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BoardService implements MCService<Board, Integer> {

    final BoardRepository boardRepository;

    @Override
    public void add(Board board) throws Exception {
        boardRepository.insert(board);
    }

    @Override
    public void mod(Board board) throws Exception {
        boardRepository.update(board);
    }

    @Override
    public void del(Integer id) throws Exception {
        boardRepository.delete(id);
    }

    @Override
    public Board get(Integer id) throws Exception {
        return boardRepository.selectOne(id);
    }

    @Override
    public List<Board> get() throws Exception {
        return boardRepository.select();
    }


}