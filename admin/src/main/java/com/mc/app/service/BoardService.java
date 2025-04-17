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

//    @Value("${app.dir.uploadimgdir}")
//    String uploadDir;

    @Override
    public void add(Board board) throws Exception {
        boardRepository.insert(board);
    }

    @Override
    public void mod(Board board) throws Exception {
        boardRepository.update(board);
    }

    @Override
    public void del(Integer boardKey) throws Exception {
//        Item item = itemRepository.selectOne(itemKey);
//        Board board = boardRepository.selectOne(boardKey);
//
//        FileUploadUtil.deleteFile(item.getItemImg1(), uploadDir);
//        FileUploadUtil.deleteFile(item.getItemImg2(), uploadDir);
//        FileUploadUtil.deleteFile(item.getItemImg3(), uploadDir);

        boardRepository.delete(boardKey);
//
        }

    @Override
    public Board get(Integer boardKey) throws Exception {
        return boardRepository.selectOne(boardKey);
//        return null;
    }

    @Override
    public List<Board> get() throws Exception {
        return boardRepository.select();
    }
}


