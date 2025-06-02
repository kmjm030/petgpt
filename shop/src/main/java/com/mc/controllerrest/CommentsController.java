package com.mc.controllerrest;

import com.mc.app.dto.Comments;
import com.mc.app.dto.Customer;
import com.mc.app.service.CommentsService;
import com.mc.app.service.CommunityBoardService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

@Slf4j
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class CommentsController {

    private final CommentsService commentsService;
    private final CommunityBoardService communityBoardService;

    @GetMapping("/posts/{postId}/comments")
    public ResponseEntity<?> getComments(@PathVariable("postId") Integer postId, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");
        String currentCustId = (loggedInUser != null) ? loggedInUser.getCustId() : null;

        try {
            List<Comments> comments = commentsService.getCommentsByPboardKey(postId, currentCustId);
            return ResponseEntity.ok(comments);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 조회 중 오류 발생: " + e.getMessage());
        }
    }

    @PostMapping("/posts/{postId}/comments")
    public ResponseEntity<?> addComment(@PathVariable("postId") Integer postId,
            @RequestBody Comments comment, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            comment.setPboardKey(postId);
            comment.setCustId(loggedInUser.getCustId());
            comment.setCustName(loggedInUser.getCustName());
            commentsService.addComment(comment);
            
            // 게시글의 댓글 수를 정확하게 업데이트
            communityBoardService.updateCommentCount(postId);
            
            Comments createdComment = commentsService.getCommentById(comment.getCommentsKey(),
                    loggedInUser.getCustId());
            if (createdComment == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 등록 후 정보를 가져오는데 실패했습니다.");
            }
            return ResponseEntity.status(HttpStatus.CREATED).body(createdComment);

        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            log.error("댓글 등록 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 등록 중 오류가 발생했습니다.");
        }
    }

    @PutMapping("/comments/{commentId}")
    public ResponseEntity<?> updateComment(@PathVariable("commentId") Integer commentId,
            @RequestBody Comments comment, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            comment.setCommentsKey(commentId);
            comment.setCustId(loggedInUser.getCustId());
            commentsService.modifyComment(comment);
            Comments updatedComment = commentsService.getCommentById(commentId, loggedInUser.getCustId());
            return ResponseEntity.ok(updatedComment);

        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 수정 중 오류가 발생했습니다.");
        }
    }

    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<?> removeComment(@PathVariable("commentId") Integer commentId, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            Comments comment = commentsService.getCommentById(commentId, null);
            if (comment == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("삭제할 댓글을 찾을 수 없습니다.");
            }
            
            commentsService.removeComment(commentId, loggedInUser.getCustId());
            
            // 게시글의 댓글 수를 정확하게 업데이트
            communityBoardService.updateCommentCount(comment.getPboardKey());
            
            return ResponseEntity.ok().body(Map.of("message", "댓글이 삭제 처리되었습니다."));

        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            log.error("댓글 삭제 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 삭제 처리 중 오류가 발생했습니다.");
        }
    }

    @PostMapping("/comments/{commentId}/like")
    public ResponseEntity<?> toggleLike(@PathVariable("commentId") Integer commentId, HttpSession session) {

        Customer loggedInUser = (Customer) session.getAttribute("cust");
        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            Map<String, Object> result = commentsService.toggleLike(commentId, loggedInUser.getCustId());
            return ResponseEntity.ok(result);

        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("좋아요 처리 중 오류가 발생했습니다.");
        }
    }
}
