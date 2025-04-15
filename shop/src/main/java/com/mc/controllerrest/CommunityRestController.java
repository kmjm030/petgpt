package com.mc.controllerrest;

import com.mc.app.dto.CommunityBoard;
import com.mc.app.service.CommunityBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/community")
@RequiredArgsConstructor
public class CommunityRestController {

    private final CommunityBoardService communityBoardService;

    /**
     * 게시글 목록 조회 API
     */
    @GetMapping("/posts")
    public ResponseEntity<Map<String, Object>> getPosts(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false, defaultValue = "newest") String sort) {
        
        Map<String, Object> response = communityBoardService.getBoardList(category, page, sort);
        return ResponseEntity.ok(response);
    }

    /**
     * 게시글 검색 API
     */
    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchPosts(
            @RequestParam(name = "keyword") String keyword,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false, defaultValue = "newest") String sort) {
        
        Map<String, Object> response = communityBoardService.searchBoards(keyword, page, sort);
        return ResponseEntity.ok(response);
    }

    /**
     * 게시글 상세 조회 API
     */
    @GetMapping("/post/{boardKey}")
    public ResponseEntity<CommunityBoard> getPostDetail(@PathVariable int boardKey) {
        CommunityBoard board = communityBoardService.getBoardDetail(boardKey);
        if (board == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(board);
    }

    /**
     * 게시글 등록 API
     */
    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> createPost(@RequestBody CommunityBoard board) {
        int result = communityBoardService.createBoard(board);
        if (result > 0) {
            return ResponseEntity.ok(Map.of("success", true, "boardKey", board.getBoardKey()));
        } else {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "게시글 등록에 실패했습니다."));
        }
    }

    /**
     * 게시글 수정 API
     */
    @PutMapping("/post/{boardKey}")
    public ResponseEntity<Map<String, Object>> updatePost(
            @PathVariable int boardKey,
            @RequestBody CommunityBoard board) {
        
        // boardKey 일치 확인
        if (board.getBoardKey() == null || board.getBoardKey() != boardKey) {
            board.setBoardKey(boardKey);
        }
        
        int result = communityBoardService.updateBoard(board);
        if (result > 0) {
            return ResponseEntity.ok(Map.of("success", true));
        } else {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "게시글 수정에 실패했습니다."));
        }
    }

    /**
     * 게시글 삭제 API
     */
    @DeleteMapping("/post/{boardKey}")
    public ResponseEntity<Map<String, Object>> deletePost(@PathVariable int boardKey) {
        int result = communityBoardService.deleteBoard(boardKey);
        if (result > 0) {
            return ResponseEntity.ok(Map.of("success", true));
        } else {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "게시글 삭제에 실패했습니다."));
        }
    }

    /**
     * 게시글 좋아요 API
     */
    @PostMapping("/post/{boardKey}/like")
    public ResponseEntity<Map<String, Object>> likePost(@PathVariable int boardKey) {
        communityBoardService.addLike(boardKey);
        return ResponseEntity.ok(Map.of("success", true));
    }

    /**
     * 게시글 좋아요 취소 API
     */
    @DeleteMapping("/post/{boardKey}/like")
    public ResponseEntity<Map<String, Object>> unlikePost(@PathVariable int boardKey) {
        communityBoardService.cancelLike(boardKey);
        return ResponseEntity.ok(Map.of("success", true));
    }
} 