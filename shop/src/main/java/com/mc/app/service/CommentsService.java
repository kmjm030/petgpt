package com.mc.app.service;

import com.mc.app.dto.Comments;
import com.mc.app.repository.CommentsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class CommentsService {

    private final CommentsRepository commentsRepository;

    /**
     * 특정 게시글의 댓글 목록 조회
     * 
     * @param pboardKey     게시글 키
     * @param currentCustId 현재 로그인 사용자 ID (좋아요 여부 확인용, 비로그인이면 null)
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
     * @param commentsKey 조회할 댓글 키
     * @return 댓글 정보
     */
    public Comments getCommentById(Integer commentsKey) throws Exception {
        return commentsRepository.findById(commentsKey);
    }

    /**
     * 댓글 등록
     * 
     * @param comments 등록할 댓글 정보 (pboardKey, custId, commentsContent 필수)
     */
    @Transactional // 댓글 등록과 게시글 카운트 업데이트를 한 트랜잭션으로 묶음
    public void addComment(Comments comments) throws Exception {
        comments.setCommentsRdate(LocalDateTime.now());
        comments.setCommentsUpdate(LocalDateTime.now());

        // 기본 depth 설정 (원댓글)
        if (comments.getParentCommentKey() == null) {
            comments.setDepth(0);
        } else {
            // 답글의 depth 설정 (부모 댓글 depth + 1)
            Comments parentComment = commentsRepository.findById(comments.getParentCommentKey());
            if (parentComment != null) {
                comments.setDepth(parentComment.getDepth() + 1);
            } else {
                comments.setDepth(0);
            }
        }

        commentsRepository.insert(comments);
    }

    /**
     * 댓글 수정
     * 
     * @param comments 수정할 댓글 정보
     */
    @Transactional
    public void modifyComment(Comments comments) throws SecurityException, NoSuchElementException, Exception {

        Comments existingComment = commentsRepository.findById(comments.getCommentsKey());
        if (existingComment == null) {
            throw new NoSuchElementException("수정할 댓글을 찾을 수 없습니다. ID: " + comments.getCommentsKey());
        }

        if (!existingComment.getCustId().equals(comments.getCustId())) {
            throw new SecurityException("댓글을 수정할 권한이 없습니다.");
        }

        existingComment.setCommentsContent(comments.getCommentsContent());
        existingComment.setCommentsUpdate(LocalDateTime.now());

        int updatedRows = commentsRepository.update(existingComment);

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
        Comments comment = commentsRepository.findById(commentsKey);
        if (comment == null) {
            throw new Exception("삭제할 댓글이 없습니다.");
        }

        if (!comment.getCustId().equals(custId)) {
            throw new Exception("삭제 권한이 없습니다.");
        }

        // TODO: 답글이 있는 경우 어떻게 처리?
        // TODO: 관련 좋아요 정보 삭제

        commentsRepository.delete(commentsKey);

        // TODO: 게시글의 댓글 수 업데이트
    }
}
