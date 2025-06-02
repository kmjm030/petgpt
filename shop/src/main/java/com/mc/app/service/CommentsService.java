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
    private final CommunityBoardService communityBoardService;

    public List<Comments> getCommentsByPboardKey(Integer pboardKey, String currentCustId) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("pboardKey", pboardKey);
        params.put("currentCustId", currentCustId);

        List<Comments> commentsList = commentsRepository.findAllByPboard(params);

        return commentsList;
    }

    public Comments getCommentById(Integer commentsKey, String currentCustId) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("commentsKey", commentsKey);
        params.put("currentCustId", currentCustId);
        return commentsRepository.findById(params);
    }

    @Transactional
    public void addComment(Comments comments) throws Exception {
        if (comments.getParentCommentKey() != null) {
            Comments parentComment = this.getCommentById(comments.getParentCommentKey(), null);
            if (parentComment == null) {
                throw new NoSuchElementException("답글을 작성할 원 댓글을 찾을 수 없습니다. ID: " + comments.getParentCommentKey());
            }

            if ("deleted".equals(parentComment.getCustId())) {
                return;
            }

            comments.setDepth(parentComment.getDepth() + 1);
        } else {
            comments.setDepth(0);
        }

        comments.setCommentsRdate(LocalDateTime.now());
        comments.setCommentsUpdate(LocalDateTime.now());

        commentsRepository.insert(comments);
        // 컨트롤러에서 updateCommentCount를 호출하므로 increaseCommentCount는 주석 처리
        // communityBoardService.increaseCommentCount(comments.getPboardKey());
    }

    @Transactional
    public void modifyComment(Comments comments) throws SecurityException, NoSuchElementException, Exception {
        Comments existingComment = this.getCommentById(comments.getCommentsKey(), null);
        if (existingComment == null) {
            throw new NoSuchElementException("수정할 댓글을 찾을 수 없습니다. ID: " + comments.getCommentsKey());
        }

        if (!existingComment.getCustId().equals(comments.getCustId())) {
            throw new SecurityException("댓글을 수정할 권한이 없습니다.");
        }

        Comments commentToUpdate = new Comments();
        commentToUpdate.setCommentsKey(comments.getCommentsKey());
        commentToUpdate.setCommentsContent(comments.getCommentsContent());
        commentToUpdate.setCommentsUpdate(LocalDateTime.now());

        int updatedRows = commentsRepository.update(commentToUpdate);

        if (updatedRows == 0) {
            throw new Exception("댓글 업데이트에 실패했습니다. ID: " + comments.getCommentsKey());
        }
    }

    @Transactional
    public void removeComment(Integer commentsKey, String custId) throws Exception {
        Comments comment = this.getCommentById(commentsKey, null);
        if (comment == null) {
            throw new NoSuchElementException("삭제할 댓글이 없습니다. ID: " + commentsKey);
        }

        if (!comment.getCustId().equals(custId)) {
            throw new SecurityException("댓글을 삭제할 권한이 없습니다.");
        }

        commentLikeRepository.deleteByCommentKey(commentsKey);

        Comments commentToUpdate = new Comments();
        commentToUpdate.setCommentsKey(commentsKey);
        commentToUpdate.setCommentsContent("삭제된 댓글입니다.");
        commentToUpdate.setCustId("deleted");
        commentToUpdate.setCustName("삭제된 사용자");
        commentToUpdate.setCommentsUpdate(LocalDateTime.now());

        int updatedRows = commentsRepository.updateForDeletion(commentToUpdate);

        if (updatedRows == 0) {
            throw new Exception("댓글 상태 업데이트(삭제 처리)에 실패했습니다. ID: " + commentsKey);
        }
        
        // 컨트롤러에서 updateCommentCount를 호출하므로 decreaseCommentCount는 주석 처리
        // communityBoardService.decreaseCommentCount(comment.getPboardKey());
    }

    @Transactional
    public Map<String, Object> toggleLike(Integer commentsKey, String custId) throws Exception {
        Comments comment = this.getCommentById(commentsKey, null);
        if (comment == null) {
            throw new NoSuchElementException("좋아요를 누를 댓글을 찾을 수 없습니다. ID: " + commentsKey);
        }

        if ("deleted".equals(comment.getCustId())) {
            Map<String, Object> result = new HashMap<>();
            result.put("liked", false);
            result.put("likeCount", commentsRepository.getLikeCount(commentsKey));
            return result;
        }

        Map<String, Object> params = new HashMap<>();
        params.put("commentsKey", commentsKey);
        params.put("custId", custId);

        int likeExistsCount = commentLikeRepository.countByCommentKeyAndCustId(params);
        boolean alreadyLiked = likeExistsCount > 0;

        boolean liked;

        if (alreadyLiked) {
            commentLikeRepository.delete(params);
            liked = false; 
        } else {
            commentLikeRepository.insert(params);
            liked = true; 
        }

        int likeCount = commentsRepository.getLikeCount(commentsKey);

        Map<String, Object> result = new HashMap<>();
        result.put("liked", liked);
        result.put("likeCount", likeCount);
        return result;
    }
}
