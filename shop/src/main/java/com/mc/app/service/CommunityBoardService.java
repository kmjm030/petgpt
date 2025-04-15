package com.mc.app.service;

import com.mc.app.dto.CommunityBoard;
import com.mc.app.repository.CommunityBoardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CommunityBoardService {

    private final CommunityBoardRepository communityBoardRepository;
    private static final int PAGE_SIZE = 10; // 페이지당 게시글 수

    @Transactional
    public int createBoard(CommunityBoard board) {
        board.onCreate();
        return communityBoardRepository.insertBoard(board);
    }

    @Transactional
    public int updateBoard(CommunityBoard board) {
        board.onUpdate();
        return communityBoardRepository.updateBoard(board);
    }

    @Transactional
    public int deleteBoard(int boardKey) {
        return communityBoardRepository.deleteBoard(boardKey);
    }

    @Transactional
    public CommunityBoard getBoardDetail(int boardKey) {
        communityBoardRepository.increaseViewCount(boardKey);
        return communityBoardRepository.selectBoardByKey(boardKey);
    }

    public CommunityBoard getBoardDetailWithoutViewCount(int boardKey) {
        return communityBoardRepository.selectBoardByKey(boardKey);
    }

    public Map<String, Object> getBoardList(String category, int page, String sort) {
        // 페이지 번호는 1부터 시작하므로 offset 계산 시 -1
        int offset = (page - 1) * PAGE_SIZE;
        
        List<CommunityBoard> posts = communityBoardRepository.selectBoardList(
                category, offset, PAGE_SIZE, sort);
        
        int totalPosts = communityBoardRepository.countBoardsByCategory(category);
        int totalPages = (int) Math.ceil((double) totalPosts / PAGE_SIZE);
        
        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("totalPosts", totalPosts);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);
        
        return result;
    }

    public Map<String, Object> searchBoards(String keyword, int page, String sort) {
        int offset = (page - 1) * PAGE_SIZE;
        
        List<CommunityBoard> posts = communityBoardRepository.searchBoards(
                keyword, offset, PAGE_SIZE, sort);
        
        int totalPosts = communityBoardRepository.countBoardsByKeyword(keyword);
        int totalPages = (int) Math.ceil((double) totalPosts / PAGE_SIZE);
        
        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("totalPosts", totalPosts);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);
        
        return result;
    }

    @Transactional
    public void addLike(int boardKey) {
        communityBoardRepository.increaseLikeCount(boardKey);
    }

    @Transactional
    public void cancelLike(int boardKey) {
        communityBoardRepository.decreaseLikeCount(boardKey);
    }

    @Transactional
    public void increaseCommentCount(int boardKey) {
        communityBoardRepository.increaseCommentCount(boardKey);
    }

    @Transactional
    public void decreaseCommentCount(int boardKey) {
        communityBoardRepository.decreaseCommentCount(boardKey);
    }
} 