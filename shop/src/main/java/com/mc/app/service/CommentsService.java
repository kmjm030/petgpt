package com.mc.app.service;

import com.mc.app.dto.Comments;
import com.mc.app.repository.CommentLikeRepository;
import com.mc.app.repository.CommentsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
public class CommentsService {

    private final CommentsRepository commentsRepository;
    private final CommentLikeRepository commentLikeRepository;

    /**
     * 특정 게시글의 댓글 목록 조회
     * 
     * @param pboardKey     게시글 키
     * @param currentCustId 현재 로그인 사용자 ID
     * @return 해당 게시글의 댓글 목록
     */
    public List<Comments> getCommentsByPboardKey(Integer pboardKey, String currentCustId) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("pboardKey", pboardKey);
        params.put("currentCustId", currentCustId);

        List<Comments> commentsList = commentsRepository.findAllByPboard(params);

        return commentsList;
    }

    /**
     * 댓글 단 건 조회
     * 
     * @param commentsKey   조회할 댓글 키
     * @param currentCustId 현재 로그인 사용자 ID
     * @return 댓글 정보
     */
    public Comments getCommentById(Integer commentsKey, String currentCustId) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("commentsKey", commentsKey);
        params.put("currentCustId", currentCustId);
        return commentsRepository.findById(params);
    }

    /**
     * 댓글 등록 (답글 포함)
     * 
     * @param comments 등록할 댓글 정보 (pboardKey, custId, commentsContent 필수,
     *                 parentCommentKey는 답글일 경우 포함)
     * @throws NoSuchElementException 답글 등록 시 부모 댓글을 찾을 수 없는 경우
     */
    @Transactional
    public void addComment(Comments comments) throws Exception {
        // 답글인 경우 depth 설정
        if (comments.getParentCommentKey() != null) {
            // 부모 댓글 조회 시 좋아요 정보는 필요 없으므로 currentCustId는 null 전달 가능
            Comments parentComment = this.getCommentById(comments.getParentCommentKey(), null);
            if (parentComment == null) {
                throw new NoSuchElementException("답글을 작성할 원 댓글을 찾을 수 없습니다. ID: " + comments.getParentCommentKey());
            }

            // 삭제된 댓글에는 답글을 달 수 없도록 검사 (예외는 발생시키지 않고 false 반환하도록 수정)
            if ("deleted".equals(parentComment.getCustId())) {
                // 클라이언트에서 버튼을 숨기므로 여기서는 단순 검증만 수행
                return;
            }

            comments.setDepth(parentComment.getDepth() + 1);
        } else {
            comments.setDepth(0);
        }

        comments.setCommentsRdate(LocalDateTime.now());
        comments.setCommentsUpdate(LocalDateTime.now());

        commentsRepository.insert(comments);
    }

    /**
     * 댓글 수정
     *
     * @param comments 수정할 댓글 정보
     */
    @Transactional
    public void modifyComment(Comments comments) throws SecurityException, NoSuchElementException, Exception {
        // 수정 전 댓글 정보 조회
        Comments existingComment = this.getCommentById(comments.getCommentsKey(), null);
        if (existingComment == null) {
            throw new NoSuchElementException("수정할 댓글을 찾을 수 없습니다. ID: " + comments.getCommentsKey());
        }

        if (!existingComment.getCustId().equals(comments.getCustId())) {
            throw new SecurityException("댓글을 수정할 권한이 없습니다.");
        }

        // 실제 업데이트할 내용 설정
        Comments commentToUpdate = new Comments();
        commentToUpdate.setCommentsKey(comments.getCommentsKey());
        commentToUpdate.setCommentsContent(comments.getCommentsContent());
        commentToUpdate.setCommentsUpdate(LocalDateTime.now());

        int updatedRows = commentsRepository.update(commentToUpdate);

        if (updatedRows == 0) {
            throw new Exception("댓글 업데이트에 실패했습니다. ID: " + comments.getCommentsKey());
        }
    }

    /**
     * 댓글 삭제
     *
     * @param commentsKey 삭제할 댓글 키
     * @param custId      삭제 요청 사용자 ID
     */
    @Transactional
    public void removeComment(Integer commentsKey, String custId) throws Exception {
        // 삭제 전 댓글 정보 조회
        Comments comment = this.getCommentById(commentsKey, null);
        if (comment == null) {
            // 이미 삭제되었거나 존재하지 않는 댓글
            throw new NoSuchElementException("삭제할 댓글이 없습니다. ID: " + commentsKey);
        }

        if (!comment.getCustId().equals(custId)) {
            throw new SecurityException("댓글을 삭제할 권한이 없습니다.");
        }

        // 관련 좋아요 정보 삭제
        commentLikeRepository.deleteByCommentKey(commentsKey);

        // 댓글 내용 및 작성자 정보 업데이트
        Comments commentToUpdate = new Comments();
        commentToUpdate.setCommentsKey(commentsKey);
        commentToUpdate.setCommentsContent("삭제된 댓글입니다.");
        // custId를 null 대신 "deleted"로 설정하여 JOIN 문제 해결
        commentToUpdate.setCustId("deleted");
        // custName도 설정
        commentToUpdate.setCustName("삭제된 사용자");
        commentToUpdate.setCommentsUpdate(LocalDateTime.now());

        int updatedRows = commentsRepository.updateForDeletion(commentToUpdate);

        if (updatedRows == 0) {
            throw new Exception("댓글 상태 업데이트(삭제 처리)에 실패했습니다. ID: " + commentsKey);
        }
    }

    /**
     * 댓글 좋아요 추가 또는 삭제 (토글)
     *
     * @param commentsKey 좋아요를 토글할 댓글 키
     * @param custId      좋아요를 누른 사용자 ID
     * @return 업데이트된 좋아요 상태 및 총 좋아요 수
     * @throws NoSuchElementException 댓글이 존재하지 않는 경우
     */
    @Transactional
    public Map<String, Object> toggleLike(Integer commentsKey, String custId) throws Exception {
        // 1. 댓글 존재 여부 확인
        Comments comment = this.getCommentById(commentsKey, null);
        if (comment == null) {
            throw new NoSuchElementException("좋아요를 누를 댓글을 찾을 수 없습니다. ID: " + commentsKey);
        }

        // 삭제된 댓글에는 좋아요를 누를 수 없음 (예외는 발생시키지 않고 현재 상태 그대로 반환)
        if ("deleted".equals(comment.getCustId())) {
            // 클라이언트에서 버튼을 숨기므로 여기서는 단순 검증만 수행
            Map<String, Object> result = new HashMap<>();
            result.put("liked", false);
            result.put("likeCount", commentsRepository.getLikeCount(commentsKey));
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("commentsKey", commentsKey);
        params.put("custId", custId);

        // 2. 좋아요가 이미 존재하는지 확인
        int likeExistsCount = commentLikeRepository.countByCommentKeyAndCustId(params);
        boolean alreadyLiked = likeExistsCount > 0;

        boolean liked; // 최종 상태를 저장할 변수

        if (alreadyLiked) {
            // 3a. 이미 좋아요 상태면 삭제
            commentLikeRepository.delete(params);
            liked = false; // 삭제 후 상태는 false
        } else {
            // 3b. 좋아요 상태가 아니면 추가
            commentLikeRepository.insert(params);
            liked = true; // 추가 후 상태는 true
        }

        // 4. 최종 좋아요 수 조회
        int likeCount = commentsRepository.getLikeCount(commentsKey);

        // 5. 결과 반환
        Map<String, Object> result = new HashMap<>();
        result.put("liked", liked);
        result.put("likeCount", likeCount);
        return result;
    }
}
