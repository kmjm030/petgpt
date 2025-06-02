package com.mc.controllerrest;

import com.mc.app.dto.CommunityBoard;
import com.mc.app.dto.Customer;
import com.mc.app.dto.PostLike;
import com.mc.app.service.CommunityBoardService;
import com.mc.app.service.PostLikeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;

@Slf4j
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class PostLikeController {

    private final PostLikeService postLikeService;
    private final CommunityBoardService communityBoardService;

    @PostMapping("/posts/{postId}/like")
    public ResponseEntity<?> toggleLike(@PathVariable("postId") Integer postId, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");
        
        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            boolean isLiked = postLikeService.isLikedByUser(postId, loggedInUser.getCustId());
            Map<String, Object> result = new HashMap<>();
            
            if (isLiked) {
                postLikeService.unlikePost(postId, loggedInUser.getCustId());
                communityBoardService.cancelLike(postId);
                result.put("liked", false);
            } else {
                postLikeService.likePost(postId, loggedInUser.getCustId());
                communityBoardService.addLike(postId);
                result.put("liked", true);
            }
            
            // 좋아요 수를 안전하게 조회
            int likeCount = 0;
            try {
                CommunityBoard board = communityBoardService.getBoardDetailWithoutViewCount(postId);
                if (board != null && board.getLikeCount() != null) {
                    likeCount = board.getLikeCount();
                } else {
                    // DB에서 직접 좋아요 수 조회
                    likeCount = postLikeService.getPostLikeCount(postId);
                }
            } catch (Exception e) {
                log.warn("좋아요 수 조회 중 오류 발생, 기본값 사용: {}", e.getMessage());
                // 좋아요 수를 직접 조회
                likeCount = postLikeService.getPostLikeCount(postId);
            }
            
            result.put("likeCount", likeCount);
            return ResponseEntity.ok(result);
            
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            log.error("게시글 좋아요 처리 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                   .body("좋아요 처리 중 오류가 발생했습니다.");
        }
    }

    @GetMapping("/posts/{postId}/like")
    public ResponseEntity<?> getLikeStatus(@PathVariable("postId") Integer postId, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");
        
        try {
            boolean isLiked = false;
            
            if (loggedInUser != null) {
                isLiked = postLikeService.isLikedByUser(postId, loggedInUser.getCustId());
            }
            
            // 좋아요 수를 안전하게 조회
            int likeCount = 0;
            try {
                CommunityBoard board = communityBoardService.getBoardDetailWithoutViewCount(postId);
                if (board != null && board.getLikeCount() != null) {
                    likeCount = board.getLikeCount();
                } else {
                    // DB에서 직접 좋아요 수 조회
                    likeCount = postLikeService.getPostLikeCount(postId);
                }
            } catch (Exception e) {
                log.warn("좋아요 수 조회 중 오류 발생, 기본값 사용: {}", e.getMessage());
                // 좋아요 수를 직접 조회
                likeCount = postLikeService.getPostLikeCount(postId);
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("liked", isLiked);
            result.put("likeCount", likeCount);
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("게시글 좋아요 상태 조회 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                   .body("좋아요 상태 조회 중 오류가 발생했습니다.");
        }
    }
} 