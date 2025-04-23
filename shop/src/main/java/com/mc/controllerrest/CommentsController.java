package com.mc.controllerrest;

import com.mc.app.dto.Comments;
import com.mc.app.dto.Customer;
import com.mc.app.service.CommentsService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class CommentsController {

    private final CommentsService commentsService;

    /**
     * 특정 게시글의 댓글 목록 조회
     * 
     * @param postId  게시글 ID (pboardKey)
     * @param session 현재 세션
     * @return 댓글 목록 또는 에러 응답
     */
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

    /**
     * 댓글 등록
     * 
     * @param postId  게시글 ID (pboardKey)
     * @param comment 등록할 댓글 정보
     * @param session 현재 세션
     * @return 성공 또는 에러 응답
     */
    @PostMapping("/posts/{postId}/comments")
    public ResponseEntity<?> addComment(@PathVariable("postId") Integer postId,
            @RequestBody Comments comment, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        String custId = loggedInUser.getCustId();

        try {
            comment.setPboardKey(postId);
            comment.setCustId(custId);
            commentsService.addComment(comment);

            return ResponseEntity.status(HttpStatus.CREATED).body(comment);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 등록 중 오류 발생: " + e.getMessage());
        }
    }

    /**
     * 댓글 수정
     * 
     * @param commentId 수정할 댓글 ID
     * @param comment   수정할 댓글 내용
     * @param session   현재 세션
     * @return 성공 또는 에러 응답
     */
    @PutMapping("/comments/{commentId}")
    public ResponseEntity<?> modifyComment(@PathVariable("commentId") Integer commentId,
            @RequestBody Comments comment, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        String custId = loggedInUser.getCustId();

        try {
            comment.setCommentsKey(commentId);

            commentsService.modifyComment(comment);
            return ResponseEntity.ok("댓글이 성공적으로 수정되었습니다.");

        } catch (Exception e) {
            if (e.getMessage().contains("권한이 없습니다")) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
            }

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 수정 중 오류 발생: " + e.getMessage());
        }
    }

    /**
     * 댓글 삭제
     * 
     * @param commentId 삭제할 댓글 ID
     * @param session   현재 세션
     * @return 성공 또는 에러 응답
     */
    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<?> removeComment(@PathVariable("commentId") Integer commentId, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        String custId = loggedInUser.getCustId();

        try {
            commentsService.removeComment(commentId, custId);
            return ResponseEntity.ok("댓글이 성공적으로 삭제되었습니다.");

        } catch (Exception e) {
            if (e.getMessage().contains("권한이 없습니다")) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
            }

            if (e.getMessage().contains("댓글이 없습니다")) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
            }

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 삭제 중 오류 발생: " + e.getMessage());
        }
    }

    // TODO: 댓글 좋아요 추가/삭제 API 엔드포인트 추가
}
