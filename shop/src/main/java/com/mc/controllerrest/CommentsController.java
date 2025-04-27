package com.mc.controllerrest;

import com.mc.app.dto.Comments;
import com.mc.app.dto.Customer;
import com.mc.app.service.CommentsService;
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
     * @return 생성된 댓글 정보 또는 에러 응답
     */
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
            commentsService.addComment(comment);

            // 등록 후 생성된 댓글 정보 다시 조회 (좋아요 정보 포함된 최신 상태 반환 위해)
            Comments createdComment = commentsService.getCommentById(comment.getCommentsKey(),
                    loggedInUser.getCustId());
            if (createdComment == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 등록 후 정보를 가져오는데 실패했습니다.");
            }
            return ResponseEntity.status(HttpStatus.CREATED).body(createdComment);

        } catch (NoSuchElementException e) {
            // addComment에서 부모 댓글 못찾는 경우
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 등록 중 오류가 발생했습니다.");
        }
    }

    /**
     * 댓글 수정
     *
     * @param commentId 수정할 댓글 ID
     * @param comment   수정할 댓글 내용
     * @param session   현재 세션
     * @return 수정된 댓글 정보 또는 에러 응답
     */
    @PutMapping("/comments/{commentId}")
    public ResponseEntity<?> modifyComment(@PathVariable("commentId") Integer commentId,
            @RequestBody Comments comment, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            Comments commentToModify = new Comments();
            commentToModify.setCommentsKey(commentId);
            commentToModify.setCommentsContent(comment.getCommentsContent());
            commentToModify.setCustId(loggedInUser.getCustId());

            commentsService.modifyComment(commentToModify);

            // 수정 후 최신 댓글 정보 조회
            Comments updatedComment = commentsService.getCommentById(commentId, loggedInUser.getCustId());
            if (updatedComment == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 수정 후 정보를 가져오는데 실패했습니다.");
            }
            return ResponseEntity.ok(updatedComment);

        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 수정 중 오류가 발생했습니다.");
        }
    }

    /**
     * 댓글 삭제
     *
     * @param commentId 삭제할 댓글 ID
     * @param session   현재 세션
     * @return 성공 메시지 또는 에러 응답
     */
    @DeleteMapping("/comments/{commentId}")
    public ResponseEntity<?> removeComment(@PathVariable("commentId") Integer commentId, HttpSession session) {
        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            commentsService.removeComment(commentId, loggedInUser.getCustId());
            return ResponseEntity.ok().body(Map.of("message", "댓글이 삭제 처리되었습니다."));

        } catch (SecurityException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 삭제 처리 중 오류가 발생했습니다.");
        }
    }

    /**
     * 댓글 좋아요 토글 (추가/삭제)
     *
     * @param commentId 좋아요를 토글할 댓글 ID
     * @param session   현재 세션
     * @return 업데이트된 좋아요 상태 및 카운트 또는 에러 응답
     */
    @PostMapping("/comments/{commentId}/like")
    public ResponseEntity<?> toggleLike(@PathVariable("commentId") Integer commentId, HttpSession session) {
        log.info(">>>>> Received like toggle request for commentId: {}", commentId); // 로그 추가

        Customer loggedInUser = (Customer) session.getAttribute("cust");

        if (loggedInUser == null) {
            log.warn(">>>>> Unauthorized like attempt for commentId: {}", commentId); // 로그 추가
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            log.info(">>>>> Calling commentsService.toggleLike for commentId: {}, custId: {}", commentId,
                    loggedInUser.getCustId()); // 로그 추가
            Map<String, Object> result = commentsService.toggleLike(commentId, loggedInUser.getCustId());
            log.info(">>>>> Like toggle successful for commentId: {}", commentId); // 로그 추가
            return ResponseEntity.ok(result);

        } catch (NoSuchElementException e) {
            log.warn(">>>>> Comment not found during like toggle for commentId: {}: {}", commentId, e.getMessage()); // 로그
                                                                                                                     // 추가
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            log.error(">>>>> Error during like toggle for commentId: {}", commentId, e); // 에러 로그 수정 (스택 트레이스 포함)
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("좋아요 처리 중 오류가 발생했습니다.");
        }
    }
}
