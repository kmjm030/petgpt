package com.mc.controllerrest;

import com.mc.app.dto.CommunityBoard;
import com.mc.app.dto.Customer;
import com.mc.app.service.CommunityBoardService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import java.io.IOException;
import java.util.HashMap;
import java.util.List; // List 임포트 추가 (필요하다면)
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jsqlparser.util.validation.ValidationException;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/community")
public class CommunityRestController {

    private final CommunityBoardService communityBoardService;

    /**
     * 게시글 작성 처리 (POST 요청 - AJAX)
     */
    @PostMapping("/write/submit")
    public ResponseEntity<?> communityWriteSubmit(
            @ModelAttribute CommunityBoard board,
            @RequestParam(value = "thumbnailImage", required = false) MultipartFile thumbnailImage,
            @SessionAttribute(name = "cust", required = false) Customer customer) {

        log.info("Entered POST /community/write/submit API endpoint");

        if (customer == null || customer.getCustId() == null) {
            log.info("세션에 customer 객체가 없습니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("redirectUrl", "/gologin"));
        }
        String custId = customer.getCustId();

        board.setCustId(custId);
        board.setViewCount(0);
        board.onCreate();

        try {
            if (thumbnailImage != null && !thumbnailImage.isEmpty()) {

                try {
                    String webAccessiblePath = communityBoardService.saveThumbnailFile(thumbnailImage);
                    board.setBoardImg(webAccessiblePath);
                    log.info("썸네일 이미지 저장 성공 (Service): {}", webAccessiblePath);

                } catch (IOException e) {
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                            .body(Map.of("message", "이미지 파일 처리 중 오류가 발생했습니다."));
                }
            }

            log.info("CommunityBoardService.createBoard 호출 (API): custId='{}', title='{}'", custId,
                    board.getBoardTitle());
            communityBoardService.createBoard(board);

            log.info("게시글 등록 성공 (API). redirectUrl: /community 반환");
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(Map.of("redirectUrl", "/community"));

        } catch (Exception e) {
            log.error("게시글 저장 중 오류 발생 (API): custId='{}', title='{}'", custId, board.getBoardTitle(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "게시글 저장 중 오류가 발생했습니다."));
        }
    }

    /**
     * 게시글 수정 처리 (PUT 요청 - AJAX)
     */
    @PutMapping("/post/{boardKey}")
    public ResponseEntity<?> updatePost(
            @PathVariable("boardKey") Integer boardKey,
            @ModelAttribute CommunityBoard board,
            @RequestParam(value = "thumbnailImage", required = false) MultipartFile thumbnailImage,
            @SessionAttribute(name = "cust", required = false) Customer customer) {

        log.info("Entered PUT /community/post/{} API endpoint", boardKey);
        Map<String, Object> response = new HashMap<>();

        if (customer == null || customer.getCustId() == null) {
            log.info("세션에 customer 객체가 없습니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("redirectUrl", "/gologin"));
        }
        String currentUserId = customer.getCustId();
        board.setBoardKey(boardKey);
        try {
            CommunityBoard originalBoard = communityBoardService.getBoardDetail(boardKey);

            if (originalBoard == null) {
                log.warn("존재하지 않는 게시글 ID({}) 수정 요청", boardKey);
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "해당 게시글을 찾을 수 없습니다."));
            }

            if (!originalBoard.getCustId().equals(currentUserId)) {
                log.warn("게시글 ID({}) 수정 권한 없음 - 로그인: {}, 게시글 작성: {}", boardKey, currentUserId,
                        originalBoard.getCustId());
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("message", "수정 권한이 없습니다."));
            }

            if (thumbnailImage != null && !thumbnailImage.isEmpty()) {
                try {
                    String webAccessiblePath = communityBoardService.saveThumbnailFile(thumbnailImage);
                    board.setBoardImg(webAccessiblePath);
                    log.info("새 썸네일 저장 완료 (Service) for boardKey {}: {}", boardKey, webAccessiblePath);
                } catch (IOException e) {
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                            .body(Map.of("message", "이미지 파일 처리 중 오류가 발생했습니다."));
                }
            } else {
                if (board.getBoardImg() != null && !board.getBoardImg().isEmpty()) {
                    board.setBoardImg(null);
                } else if (board.getBoardImg() == null) {
                    board.setBoardImg(originalBoard.getBoardImg());
                }
            }

            log.info("CommunityBoardService.updateBoard 호출 (API): boardKey={}, custId='{}'",
                    boardKey, currentUserId, board.getBoardTitle());
            communityBoardService.updateBoard(boardKey, board, thumbnailImage);

            log.info("게시글 수정 성공 (API, boardKey: {}). redirectUrl 반환", boardKey);
            response.put("message", "게시글이 성공적으로 수정되었습니다.");
            response.put("redirectUrl", "/community/detail?id=" + boardKey);
            return ResponseEntity.ok(response);

        } catch (ValidationException e) {
            log.warn("게시글 수정 유효성 검사 실패 (API, boardKey: {}): {}", boardKey, e.getMessage());
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (IOException e) {
            log.error("게시글 수정 중 파일 처리 오류 (API, boardKey: {})", boardKey, e);
            response.put("message", "파일 처리 중 오류가 발생했습니다.");
            return ResponseEntity.internalServerError().body(response);
        } catch (Exception e) {
            log.error("게시글 수정 중 알 수 없는 오류 발생 (API, boardKey: {})", boardKey, e);
            response.put("message", "게시글 수정 중 오류가 발생했습니다.");
            return ResponseEntity.internalServerError().body(response);
        }
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
     * 게시글 삭제 API
     */
    @DeleteMapping("/post/{boardKey}")
    public ResponseEntity<Map<String, Object>> deletePost(@PathVariable("boardKey") int boardKey) {
        int result = communityBoardService.deleteBoard(boardKey);
        if (result > 0) {
            return ResponseEntity.ok(Map.of("success", true));
        } else {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "게시글 삭제에 실패했습니다."));
        }
    }

    /**
     * 게시글 목록 조회 API
     * 
     */
    @GetMapping("/posts")
    public ResponseEntity<?> getPosts(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort) {

        log.info("Entered GET /community/posts API endpoint with page={} and sort={}", page, sort);

        try {
            Map<String, Object> result = communityBoardService.getBoardList(null, page, sort);
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("게시글 목록 조회 중 오류 발생 (API): page={}, sort={}", page, sort, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "게시글 목록 조회 중 오류가 발생했습니다."));
        }
    }
}
