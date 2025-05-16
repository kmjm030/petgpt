package com.mc.app.service;

import com.mc.app.dto.PostLike;
import com.mc.app.repository.PostLikeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
public class PostLikeService {

    private final PostLikeRepository postLikeRepository;
    private final CommunityBoardService communityBoardService;

    @Transactional
    public void likePost(Integer boardKey, String custId) {
        if (communityBoardService.getBoardDetailWithoutViewCount(boardKey) == null) {
            throw new NoSuchElementException("해당 게시글이 존재하지 않습니다. ID: " + boardKey);
        }
        
        if (isLikedByUser(boardKey, custId)) {
            log.info("이미 좋아요를 누른 게시글입니다: boardKey={}, custId={}", boardKey, custId);
            return;
        }
        
        PostLike postLike = PostLike.builder()
                .boardKey(boardKey)
                .custId(custId)
                .likeDate(LocalDateTime.now())
                .build();
        
        postLikeRepository.insert(postLike);
        log.info("게시글 좋아요 추가: boardKey={}, custId={}", boardKey, custId);
    }
    
    @Transactional
    public void unlikePost(Integer boardKey, String custId) {
        if (communityBoardService.getBoardDetailWithoutViewCount(boardKey) == null) {
            throw new NoSuchElementException("해당 게시글이 존재하지 않습니다. ID: " + boardKey);
        }
        
        if (!isLikedByUser(boardKey, custId)) {
            log.info("좋아요를 누르지 않은 게시글입니다: boardKey={}, custId={}", boardKey, custId);
            return;
        }
        
        int result = postLikeRepository.delete(boardKey, custId);
        log.info("게시글 좋아요 취소: boardKey={}, custId={}, 결과={}", boardKey, custId, result);
    }
    
    public boolean isLikedByUser(Integer boardKey, String custId) {
        if (boardKey == null || custId == null || custId.isEmpty()) {
            return false;
        }
        return postLikeRepository.countByBoardKeyAndCustId(boardKey, custId) > 0;
    }
    
    public int getPostLikeCount(Integer boardKey) {
        if (boardKey == null) {
            return 0;
        }
        return postLikeRepository.countByBoardKey(boardKey);
    }
} 