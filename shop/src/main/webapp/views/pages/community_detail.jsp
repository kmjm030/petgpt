<%@ page pageEncoding="UTF-8" %>
    <%@ page contentType="text/html; charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <style>
                    .community-detail-container {
                        max-width: 800px;
                        margin: 0 auto;
                        padding: 30px 20px;
                    }

                    .post-header-actions-wrapper {
                        display: flex;
                        justify-content: space-between;
                        align-items: flex-end;
                        padding-bottom: 20px;
                        margin-bottom: 30px;
                    }

                    .post-title {
                        font-size: 36px;
                        font-weight: 600;
                        margin-bottom: 15px;
                    }

                    .post-meta {
                        font-size: 14px;
                        color: #888;
                    }

                    .post-meta span {
                        margin-right: 15px;
                        vertical-align: middle;
                    }

                    .post-meta i {
                        width: 20px;
                        text-align: center;
                        margin-right: 5px;
                        display: inline-block;
                        vertical-align: middle;
                        margin-right: 5px;
                    }

                    .post-content {
                        line-height: 1.7;
                        font-size: 16px;
                    }

                    .post-content img {
                        max-width: 100%;
                        height: auto;
                        margin-top: 10px;
                        margin-bottom: 10px;
                    }

                    .site-btn-outline {
                        margin: 0 5px;
                        padding: 8px 20px;
                        border: 1px solid #888888;
                        background-color: transparent;
                        color: #888888;
                        border-radius: 4px;
                    }

                    .site-btn-outline:hover {
                        background-color: #888888;
                        color: #ffffff;
                        border-color: #888888;
                    }

                    .thumbnail-image {
                        max-width: 100%;
                        height: auto;
                        margin-bottom: 20px;
                        border-radius: 5px;
                    }

                    .post-feedback {
                        margin-top: 30px;
                        padding-top: 20px;
                        display: flex;
                        gap: 20px;
                        color: #555;
                        font-size: 14px;
                    }

                    .post-feedback .feedback-item {
                        display: flex;
                        align-items: center;
                        cursor: pointer;
                    }

                    .post-feedback i {
                        margin-right: 5px;
                        font-size: 16px;
                    }

                    .post-feedback .count {
                        margin-left: 5px;
                        font-weight: 600;
                    }

                    .post-feedback .like-button i {
                        color: #e53637;
                    }

                    .post-feedback .like-button.liked i {
                        color: #e53637;
                        font-weight: bold;
                    }

                    .post-feedback .comment-section-link i {
                        color: #555;
                    }

                    .comment-form {
                        display: flex;
                        align-items: flex-start;
                        margin-top: 40px;
                        border: 1px solid #e0e0e0;
                        border-radius: 8px;
                        padding: 20px 20px 20px 15px;
                        background-color: #f9f9f9;
                        width: 100%;
                        box-sizing: border-box;
                    }

                    .comment-form .author-img {
                        width: 45px;
                        height: 45px;
                        border-radius: 50%;
                        overflow: hidden;
                        margin-right: 15px;
                        flex-shrink: 0;
                    }

                    .comment-form .author-img img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .comment-form .form-content {
                        flex-grow: 1;
                        display: flex;
                        flex-direction: column;
                    }

                    .comment-form textarea {
                        width: 100%;
                        min-height: 100px;
                        padding: 10px 15px;
                        border: 1px solid #eee;
                        border-radius: 4px;
                        resize: vertical;
                        margin-bottom: 10px;
                        font-size: 15px;
                    }

                    .comment-form .submit-btn {
                        align-self: flex-end;
                        padding: 8px 25px;
                        border-radius: 4px;
                    }

                    .comment-section {
                        padding-top: 30px;
                    }

                    .comment-item {
                        display: flex;
                        margin-bottom: 15px;
                        padding-bottom: 15px;
                    }

                    .comment-item:last-child {
                        margin-bottom: 0;
                        padding-bottom: 0;
                        border-bottom: none;
                    }

                    .comment-author-img {
                        width: 45px;
                        height: 45px;
                        border-radius: 50%;
                        overflow: hidden;
                        margin-right: 15px;
                        flex-shrink: 0;
                    }

                    .comment-author-img img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .comment-content-wrap {
                        flex-grow: 1;
                    }

                    .comment-author-name {
                        font-weight: 600;
                        margin-bottom: 5px;
                        color: #333;
                    }

                    .comment-text {
                        line-height: 1.6;
                        margin-bottom: 10px;
                        color: #555;
                        font-size: 15px;
                    }

                    .comment-meta {
                        font-size: 13px;
                        color: #999;
                        display: flex;
                        align-items: center;
                        gap: 15px;
                    }

                    .comment-meta .reply-link,
                    .comment-meta .comment-like-button,
                    .comment-meta .edit-comment-btn,
                    .comment-meta .delete-comment-btn {
                        cursor: pointer;
                        color: #888;
                    }

                    .comment-meta .reply-link:hover,
                    .comment-meta .edit-comment-btn:hover,
                    /* Add edit button hover selector */
                    .comment-meta .delete-comment-btn:hover {
                        text-decoration: underline;
                    }

                    .comment-meta .comment-like-button i {
                        font-size: 14px;
                        margin-right: 3px;
                        color: #e53637;
                    }

                    .comment-meta .comment-like-button.liked i {
                        color: #e53637;
                        font-weight: bold;
                    }

                    /* 댓글 들여쓰기 */
                    .comment-item.depth-1 {
                        margin-left: 40px;
                        border-left: 2px solid #eee;
                        padding-left: 10px;
                        margin-bottom: 30px;
                    }

                    /* 답글 입력 폼 스타일 */
                    .reply-form {
                        margin-top: 15px;
                        padding: 15px;
                        background-color: #f8f8f8;
                        border-radius: 4px;
                        border: 1px solid #eee;
                    }

                    .reply-form textarea {
                        width: 100%;
                        min-height: 60px;
                        margin-bottom: 10px;
                        padding: 10px;
                        border: 1px solid #ddd;
                        border-radius: 4px;
                        font-size: 14px;
                    }

                    .reply-form .reply-actions {
                        text-align: right;
                    }

                    .reply-form .reply-actions button {
                        margin-left: 5px;
                        padding: 6px 15px;
                        font-size: 13px;
                    }

                    .author-badge {
                        display: inline-block;
                        margin-left: 8px;
                        padding: 2px 6px;
                        font-size: 11px;
                        font-weight: bold;
                        color: #007bff;
                        background-color: #e7f3ff;
                        border: 1px solid #b8daff;
                        border-radius: 4px;
                        vertical-align: middle;
                    }
                </style>

                <!-- Breadcrumb Section Begin -->
                <section class="breadcrumb-option">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="breadcrumb__text">
                                    <h4>
                                        <c:out value="${board.boardTitle}" />
                                    </h4>
                                    <div class="breadcrumb__links">
                                        <a href="<c:url value='/'/>">Home</a>
                                        <a href="<c:url value='/community'/>">커뮤니티</a>
                                        <span>
                                            <c:out value="${board.boardTitle}" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- Breadcrumb Section End -->

                <!-- Community Detail Section Begin -->
                <section class="community-detail spad">
                    <div class="container">
                        <div class="community-detail-container">
                            <c:choose>
                                <c:when test="${not empty board}">
                                    <div class="post-header-actions-wrapper">
                                        <div class="post-header">
                                            <h2 class="post-title">
                                                <c:out value="${board.boardTitle}" />
                                            </h2>
                                            <div class="post-meta">
                                                <span><i class="fa fa-user"></i>
                                                    <c:out value="${board.custId}" />
                                                </span>
                                                <span><i class="fa fa-calendar"></i>
                                                    <c:out value="${formattedRegDate}" />
                                                </span>
                                                <span><i class="fa fa-eye"></i> 조회&nbsp;
                                                    <c:out value="${board.viewCount}" />
                                                </span>
                                            </div>
                                        </div>

                                        <div class="post-actions">
                                            <a href="<c:url value='/community'/>"
                                                class="site-btn site-btn-outline">목록</a>

                                            <c:if
                                                test="${not empty sessionScope.cust && sessionScope.cust.custId eq board.custId}">
                                                <a href="#" data-board-key="${board.boardKey}"
                                                    onclick="modifyPost(this); return false;"
                                                    class="site-btn site-btn-outline">수정</a>
                                                <a href="#" data-board-key="${board.boardKey}"
                                                    onclick="deletePost(this); return false;"
                                                    class="site-btn site-btn-outline">삭제</a>
                                            </c:if>
                                        </div>
                                    </div>

                                    <c:if test="${not empty board.boardImg}">
                                        <img src="<c:url value='${board.boardImg}'/>" alt="대표 이미지"
                                            class="thumbnail-image">
                                    </c:if>

                                    <div class="post-content">

                                        <c:out value="${board.boardContent}" escapeXml="false" />
                                    </div>

                                    <!-- 좋아요/댓글 피드백 영역 -->
                                    <div class="post-feedback">
                                        <div class="feedback-item like-button">
                                            <i class="fa fa-heart-o"></i>
                                            <span>좋아요</span>
                                            <span class="count like-count">0</span>
                                        </div>
                                        <div class="feedback-item comment-section-link">
                                            <i class="fa fa-comment-o"></i>
                                            <span>댓글</span>
                                            <span class="count comment-count">${commentCount}</span>
                                        </div>
                                    </div>

                                    <!-- 댓글 섹션 -->
                                    <div class="comment-section">
                                        <c:forEach var="comment" items="${comments}">
                                            <c:set var="depthClass"
                                                value="${comment.depth >= 1 ? 'depth-1' : 'depth-0'}" />
                                            <div class="comment-item ${depthClass}"
                                                data-comment-key="${comment.commentsKey}">
                                                <div class="comment-author-img">
                                                    <c:set var="profileImageUrl">
                                                        <c:choose>
                                                            <c:when test="${not empty comment.custProfileImgUrl}">
                                                                ${comment.custProfileImgUrl}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:url value="/img/default-profile.png" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:set>
                                                    <img src="${profileImageUrl}" alt="프로필 이미지">
                                                </div>
                                                <div class="comment-content-wrap">
                                                    <div class="comment-author-name">
                                                        <c:out value="${comment.custId}" />
                                                        <c:if test="${comment.isAuthorComment}">
                                                            <span class="author-badge">작성자</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="comment-text">
                                                        <c:if
                                                            test="${comment.depth >= 1 and not empty comment.parentCustId}">
                                                            <strong style="color: blue; margin-right: 5px;">@
                                                                <c:out value="${comment.parentCustId}" />
                                                            </strong>
                                                        </c:if>
                                                        <c:out value="${comment.commentsContent}" />
                                                    </div>
                                                    <div class="comment-meta">
                                                        <span class="comment-timestamp">
                                                            ${comment.formattedCommentsRdate}
                                                        </span>
                                                        <a href="#" class="reply-link"
                                                            data-comment-key="${comment.commentsKey}">답글쓰기</a>
                                                        <c:if
                                                            test="${not empty loggedInUser && loggedInUser.custId eq comment.custId}">
                                                            <a href="#" class="edit-comment-btn"
                                                                data-comment-key="${comment.commentsKey}">수정</a>
                                                            <a href="#" class="delete-comment-btn"
                                                                data-comment-key="${comment.commentsKey}">삭제</a>
                                                        </c:if>
                                                        <span
                                                            class="comment-like-button ${comment.likedByCurrentUser ? 'liked' : ''}"
                                                            data-comment-key="${comment.commentsKey}">
                                                            <i
                                                                class="fa ${comment.likedByCurrentUser ? 'fa-heart' : 'fa-heart-o'}"></i>
                                                            <span class="count">${comment.likeCount}</span>
                                                        </span>
                                                    </div>
                                                    <!-- 답글 폼이 삽입될 위치 -->
                                                    <div class="reply-form-container"></div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${empty comments && empty commentErrorMessage}">
                                            <p>아직 댓글이 없습니다.</p>
                                        </c:if>
                                        <c:if test="${not empty commentErrorMessage}">
                                            <p style="color: red;">${commentErrorMessage}</p>
                                        </c:if>
                                    </div>

                                    <!-- 댓글 입력 폼 -->
                                    <div class="comment-form">
                                        <div class="author-img">
                                            <%-- 프로필 이미지 (항상 기본 이미지 표시) --%>
                                                <img src="<c:url value='/img/default-profile.png'/>" alt="프로필">
                                        </div>
                                        <div class="form-content">
                                            <textarea placeholder="댓글을 남겨보세요..."></textarea>
                                            <button type="button" class="site-btn submit-btn">등록</button> <%-- 실제 등록 기능은
                                                JS/서버 연동 필요 --%>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p>${errorMessage}</p>
                                    <div class="post-actions">
                                        <a href="<c:url value='/community'/>" class="site-btn site-btn-outline">목록으로</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </section>
                <!-- Community Detail Section End -->

                <script>
                    function formatDateTime(dateTimeString) {
                        if (!dateTimeString) return "방금 전";
                        try {
                            const date = new Date(dateTimeString);
                            const year = date.getFullYear();
                            const month = String(date.getMonth() + 1).padStart(2, '0');
                            const day = String(date.getDate()).padStart(2, '0');
                            const hours = String(date.getHours()).padStart(2, '0');
                            const minutes = String(date.getMinutes()).padStart(2, '0');
                            return year + "." + month + "." + day + " " + hours + ":" + minutes;
                        } catch (e) {
                            console.error("날짜 포맷 오류:", e);
                            return dateTimeString;
                        }
                    }

                    function deletePost(element) {
                        const boardKey = element.dataset.boardKey;
                        if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
                            fetch('/community/post/' + boardKey, {
                                method: 'DELETE'
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        return response.json().then(err => {
                                            throw new Error(err.message || '삭제 처리 중 오류가 발생했습니다다.');
                                        });
                                    }
                                    return response.json();
                                })
                                .then(data => {
                                    if (data.success) {
                                        alert('게시글이 삭제되었습니다');
                                        window.location.href = '<c:url value="/community" />';
                                    } else {
                                        alert('게시글 삭제에 실패했습니다.');
                                        log.info(data.message);
                                    }
                                })
                                .catch(error => {
                                    alert('게시글 삭제 중 오류가 발생했습니다.');
                                    log.info(error.message);
                                })
                        }
                    }

                    function modifyPost(element) {
                        const boardKey = element.dataset.boardKey;
                        const editUrl = '/community/edit/' + boardKey;
                        window.location.href = editUrl;
                    }

                    const likeButton = document.querySelector('.like-button');
                    const likeIcon = likeButton?.querySelector('i');
                    const likeCountSpan = likeButton?.querySelector('.like-count');

                    if (likeButton && likeIcon && likeCountSpan) {
                        likeButton.addEventListener('click', () => {
                            const isLiked = likeButton.classList.toggle('liked');
                            let currentCount = parseInt(likeCountSpan.textContent || '0', 10);

                            if (isLiked) {
                                likeIcon.classList.remove('fa-heart-o');
                                likeIcon.classList.add('fa-heart');
                                currentCount++;
                            } else {
                                likeIcon.classList.remove('fa-heart');
                                likeIcon.classList.add('fa-heart-o');
                                currentCount--;
                            }
                            likeCountSpan.textContent = currentCount;
                        });
                    }

                    function appendComment(comment) {
                        const commentSection = document.querySelector('.comment-section');
                        if (!commentSection) return;

                        const profileImgUrl = comment.custProfileImgUrl || '<c:url value="/img/default-profile.png"/>';
                        const formattedDate = formatDateTime(comment.commentsRdate);
                        const commentId = comment.commentsKey || '';
                        const commentAuthorId = comment.custId || '';
                        const isAuthor = postAuthorId && postAuthorId === commentAuthorId;

                        let deleteButtonHTML = '';
                        if (loggedInCustId && loggedInCustId === commentAuthorId) {
                            editButtonHTML = ' <a href="#" class="edit-comment-btn" data-comment-key="' + commentId + '">수정</a>';
                            deleteButtonHTML = ' <a href="#" class="delete-comment-btn" data-comment-key="' + commentId + '">삭제</a>';
                        }

                        const commentItemHTML =
                            '<div class="comment-item" data-comment-key="' + commentId + '">' +
                            '<div class="comment-author-img">' +
                            '<img src="' + profileImgUrl + '" alt="프로필 이미지">' +
                            '</div>' +
                            '<div class="comment-content-wrap">' +
                            '<div class="comment-author-name">' + (comment.custId || '익명') + (isAuthor ? ' <span class="author-badge">작성자</span>' : '') + '</div>' +
                            '<div class="comment-text">' + (comment.commentsContent || '') + '</div>' +
                            '<div class="comment-meta">' +
                            '<span class="comment-timestamp">' + formattedDate + '</span>' +
                            ' <a href="#" class="reply-link" data-comment-key="' + commentId + '">답글쓰기</a> ' +
                            editButtonHTML +
                            deleteButtonHTML +
                            ' <span class="comment-like-button" data-comment-key="' + commentId + '">' +
                            ' <i class="fa fa-heart-o"></i>' +
                            ' <span class="count">' + (comment.likeCount || 0) + '</span>' +
                            '</span>' +
                            '</div>' +
                            '<div class="reply-form-container"></div>' +
                            '</div>' +
                            '</div>';

                        const noCommentMsg = commentSection.querySelector('p');
                        if (noCommentMsg && noCommentMsg.textContent.includes('댓글이 없습니다')) {
                            noCommentMsg.remove();
                        }

                        commentSection.insertAdjacentHTML('beforeend', commentItemHTML);
                    }

                    function showEditForm(commentItem) {
                        if (commentItem.querySelector('.edit-form')) {
                            return;
                        }

                        const commentContentWrap = commentItem.querySelector('.comment-content-wrap');
                        const commentTextDiv = commentContentWrap.querySelector('.comment-text');
                        const commentMetaDiv = commentContentWrap.querySelector('.comment-meta');

                        let currentContent = '';
                        const mentionStrongTag = commentTextDiv.querySelector('strong');

                        if (mentionStrongTag) {
                            let nextNode = mentionStrongTag.nextSibling;
                            while (nextNode) {
                                if (nextNode.nodeType === Node.TEXT_NODE) {
                                    currentContent += nextNode.textContent;
                                }
                                nextNode = nextNode.nextSibling;
                            }
                            currentContent = currentContent.trim();
                        } else {
                            currentContent = commentTextDiv.textContent.trim();
                        }

                        commentTextDiv.style.display = 'none';
                        commentMetaDiv.style.display = 'none';

                        const editFormHTML =
                            '<div class="edit-form" style="margin-top: 10px;">' +
                            '<textarea class="edit-textarea" style="width: 100%; min-height: 80px; margin-bottom: 10px; padding: 10px; border: 1px solid #eee; border-radius: 4px; font-size: 15px;">' +
                            currentContent +
                            '</textarea>' +
                            '<div class="edit-actions" style="text-align: right;">' +
                            '<button type="button" class="site-btn save-edit-btn" style="margin-left: 5px; padding: 8px 25px; border-radius: 4px;">저장</button>' +
                            '<button type="button" class="site-btn site-btn-outline cancel-edit-btn" style="margin-left: 5px; padding: 8px 25px;">취소</button>' +
                            '</div>' +
                            '</div>';

                        const authorNameDiv = commentContentWrap.querySelector('.comment-author-name');
                        commentTextDiv.insertAdjacentHTML('afterend', editFormHTML);
                    }

                    function removeEditForm(commentItem) {
                        const editForm = commentItem.querySelector('.edit-form');
                        if (editForm) {
                            editForm.remove();
                        }

                        const commentTextDiv = commentItem.querySelector('.comment-text');
                        const commentMetaDiv = commentItem.querySelector('.comment-meta');
                        if (commentTextDiv) commentTextDiv.style.display = 'block';
                        if (commentMetaDiv) commentMetaDiv.style.display = 'flex';
                    }

                    function cancelCommentEdit(commentItem) {
                        removeEditForm(commentItem);
                    }

                    function saveCommentEdit(commentId, newContent, commentItem) {
                        const trimmedContent = newContent.trim();
                        if (!trimmedContent) {
                            alert('댓글 내용을 입력해주세요.');
                            commentItem.querySelector('.edit-textarea').focus();
                            return;
                        }

                        fetch('/api/comments/' + commentId, {
                            method: 'PUT',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({ commentsContent: trimmedContent }),
                        })
                            .then(async (response) => {
                                if (!response.ok) {
                                    const errorText = await response.text();
                                    throw new Error(errorText || "댓글 수정 처리 중 오류 발생 (HTTP " + response.status + ")");
                                }
                                return response.json();

                            })
                            .then(updatedComment => {
                                const commentTextDiv = commentItem.querySelector('.comment-text');
                                if (commentTextDiv) {
                                    commentTextDiv.textContent = updatedComment.commentsContent;
                                    // TODO: 수정 시간도 업데이트하려면 해당 요소 찾아서 updatedComment.commentsUpdate 값으로 업데이트
                                }
                                removeEditForm(commentItem);
                            })
                            .catch(error => {
                                console.error('댓글 수정 중 오류:', error);
                                alert('댓글 수정 중 오류가 발생했습니다. \n' + error.message);
                            });
                    }

                    function deleteComment(commentId, buttonElement) {
                        fetch('/api/comments/' + commentId, {
                            method: 'DELETE',
                        })
                            .then(async response => {
                                const responseText = await response.text();
                                if (!response.ok) {
                                    throw new Error(responseText || "댓글 삭제 처리 중 오류 발생 (HTTP " + response.status + ")");

                                }
                                return responseText;
                            })
                            .then(successMessage => {

                                const commentItem = buttonElement.closest('.comment-item');
                                if (commentItem) {
                                    commentItem.remove();
                                }

                                const commentCountSpan = document.querySelector('.comment-count');
                                if (commentCountSpan) {
                                    let currentCount = parseInt(commentCountSpan.textContent || '0', 10);
                                    commentCountSpan.textContent = Math.max(0, currentCount - 1);
                                }
                            })
                            .catch(error => {
                                console.error('댓글 삭제 중 오류:', error);
                                alert('댓글 삭제 중 오류가 발생했습니다. \n' + error.message);
                            });
                    }

                    /**
                     * 답글 입력 폼을 표시하는 함수
                     */
                    function showReplyForm(parentCommentItem, parentCommentKey) {
                        closeAllForms();

                        const replyFormContainer = parentCommentItem.querySelector('.reply-form-container');
                        if (!replyFormContainer || replyFormContainer.querySelector('.reply-form')) {
                            return;
                        }

                        const replyFormHTML =
                            '<div class="reply-form" data-parent-key="' + parentCommentKey + '">' +
                            '<textarea placeholder="답글을 남겨보세요..."></textarea>' +
                            '<div class="reply-actions">' +
                            '<button type="button" class="site-btn save-reply-btn">등록</button>' +
                            '<button type="button" class="site-btn site-btn-outline cancel-reply-btn">취소</button>' +
                            '</div>' +
                            '</div>';

                        replyFormContainer.innerHTML = replyFormHTML;
                        replyFormContainer.querySelector('textarea').focus();
                    }

                    /**
                     * 답글 입력 폼을 제거하는 함수
                     */
                    function removeReplyForm(containerElement) {
                        const replyForm = containerElement.querySelector('.reply-form');
                        if (replyForm) {
                            replyForm.remove();
                        }
                    }

                    /**
                     * 모든 답글 폼과 수정 폼을 닫는 함수
                     */
                    function closeAllForms() {
                        document.querySelectorAll('.reply-form').forEach(form => form.remove());
                        document.querySelectorAll('.edit-form').forEach(form => {
                            const commentItem = form.closest('comment-item');
                            if (commentItem) {
                                removeEditForm(commentItem);
                            }
                        })
                    }

                    // --- 답글 저장 함수 ---
                    function saveReply(parentCommentKey, content, parentCommentItem, replyForm) {
                        const trimmedContent = content.trim();
                        if (!trimmedContent) {
                            alert('답글 내용을 입력해주세요.');
                            replyForm.querySelector('textarea').focus();
                            return;
                        }

                        if (!boardKey) {
                            console.error("답글 저장 오류: 게시글 ID를 찾을 수 없습니다.");
                            alert('게시글 정보를 찾을 수 없어 답글을 등록할 수 없습니다.');
                            return;
                        }

                        const replyData = {
                            commentsContent: trimmedContent,
                            parentCommentKey: parseInt(parentCommentKey, 10)
                        };

                        fetch('/api/posts/' + boardKey + '/comments', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify(replyData),
                        })
                            .then(async (response) => {
                                if (!response.ok) {
                                    const errorText = await response.text();
                                    throw new Error(errorText || "답글 등록 처리 중 오류 발생 (HTTP " + response.status + ")");
                                }

                                return response.json();
                            })
                            .then(newReplyComment => {
                                appendReplyComment(newReplyComment, parentCommentItem);
                                removeReplyForm(replyForm.parentElement);

                                const commentCountSpan = document.querySelector('.comment-count');
                                if (commentCountSpan) {
                                    let currentCount = parseInt(commentCountSpan.textContent || '0', 10);
                                    commentCountSpan.textContent = currentCount + 1;
                                }
                            })
                            .catch(error => {
                                console.error('답글 등록 중 오류:', error);
                                alert('답글 등록 중 오류가 발생했습니다. \n' + error.message);
                            });
                    }

                    // --- 답글 화면 추가 함수 ---
                    function appendReplyComment(replyData, parentCommentItem) {
                        const profileImgUrl = replyData.custProfileImgUrl || '<c:url value="/img/default-profile.png"/>';
                        const formattedDate = formatDateTime(replyData.commentsRdate);
                        const commentId = replyData.commentsKey || '';
                        const commentAuthorId = replyData.custId || '';
                        const isAuthor = postAuthorId && postAuthorId === commentAuthorId;
                        const depth = replyData.depth || 0;
                        // depth가 1 이상이면 항상 'depth-1', 0이면 'depth-0'
                        const depthClass = depth >= 1 ? 'depth-1' : 'depth-0';

                        const parentAuthorNameElement = parentCommentItem.querySelector('.comment-author-name');
                        let parentCustId = '';
                        if (parentAuthorNameElement) {
                            for (let node of parentAuthorNameElement.childNodes) {
                                if (node.nodeType === Node.TEXT_NODE && node.textContent.trim()) {
                                    parentCustId = node.textContent.trim();
                                    break;
                                }
                            }
                        }

                        let editButtonHTML = '';
                        let deleteButtonHTML = '';

                        if (loggedInCustId && loggedInCustId === commentAuthorId) {
                            editButtonHTML = ' <a href="#" class="edit-comment-btn" data-comment-key="' + commentId + '">수정</a>';
                            deleteButtonHTML = ' <a href="#" class="delete-comment-btn" data-comment-key="' + commentId + '">삭제</a>';
                        }

                        const replyHTML =
                            '<div class="comment-item ' + depthClass + '" data-comment-key="' + commentId + '">' +
                            '<div class="comment-author-img">' +
                            '<img src="' + profileImgUrl + '" alt="프로필 이미지">' +
                            '</div>' +
                            '<div class="comment-content-wrap">' +
                            '<div class="comment-author-name">' + (commentAuthorId || '익명') + (isAuthor ? ' <span class="author-badge">작성자</span>' : '') + '</div>' +
                            '<div class="comment-text">' +
                            ((depth >= 1 && parentCustId) ?
                                '<strong style="color: blue; margin-right: 5px;">@' + parentCustId + '</strong>'
                                : '') +
                            (replyData.commentsContent || '') +
                            '</div>' +
                            '<div class="comment-meta">' +
                            '<!-- ... meta content ... -->' +
                            '</div>' +
                            '<div class="reply-form-container"></div>' +
                            '</div>' +
                            '</div>';


                        let insertAfterElement = parentCommentItem;
                        let nextSibling = parentCommentItem.nextElementSibling;
                        const parentDepth = parseInt(parentCommentItem.classList.value.match(/depth-(\d+)/)?.[1] || '0', 10);

                        while (nextSibling && nextSibling.classList.contains('comment-item')) {
                            const siblingDepth = parseInt(nextSibling.classList.value.match(/depth-(\d+)/)?.[1] || '0', 10);

                            if (siblingDepth > parentDepth) {
                                insertAfterElement = nextSibling;
                                nextSibling = nextSibling.nextElementSibling;
                            } else {
                                break;
                            }
                        }

                        insertAfterElement.insertAdjacentHTML('afterend', replyHTML);

                    }

                    const commentLikeButtons = document.querySelectorAll('.comment-like-button');

                    commentLikeButtons.forEach(button => {
                        const icon = button.querySelector('i');
                        const countSpan = button.querySelector('.count');

                        if (icon && countSpan) {
                            button.addEventListener('click', () => {
                                const isLiked = button.classList.toggle('liked');
                                let currentCount = parseInt(countSpan.textContent || '0', 10);

                                if (isLiked) {
                                    icon.classList.remove('fa-heart-o');
                                    icon.classList.add('fa-heart');
                                    currentCount++;
                                } else {
                                    icon.classList.remove('fa-heart');
                                    icon.classList.add('fa-heart-o');
                                    currentCount--;
                                }
                                countSpan.textContent = currentCount;
                            });
                        }
                    });

                    const commentForm = document.querySelector('.comment-form');
                    const commentTextarea = commentForm?.querySelector('textarea');
                    const submitCommentBtn = commentForm?.querySelector('.submit-btn');
                    const loggedInCustId = '${cust != null ? cust.custId : ""}';
                    const boardKey = '${board.boardKey}';
                    const postAuthorId = '${board.custId}';

                    if (commentForm && commentTextarea && submitCommentBtn) {
                        submitCommentBtn.addEventListener('click', () => {
                            if (!loggedInCustId || loggedInCustId === '') {
                                alert('댓글을 작성하려면 로그인이 필요합니다.');
                                window.location.href = '<c:url value="/gologin"/>';
                                return;
                            }

                            const commentsContent = commentTextarea.value.trim();

                            if (!commentsContent) {
                                alert('댓글 내용을 입력해주세요.');
                                commentTextarea.focus();
                                return;
                            }

                            const commentData = {
                                commentsContent: commentsContent
                            };

                            fetch('/api/posts/' + boardKey + '/comments', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json',
                                },
                                body: JSON.stringify(commentData),
                            })
                                .then(response => {
                                    if (!response.ok) {
                                        return response.text().then(text => {
                                            throw new Error(text || `댓글 등록 처리 중 오류 발생 (HTTP ${response.status})`);
                                        });
                                    }

                                    return response.json();
                                })
                                .then(newComment => {
                                    appendComment(newComment);
                                    commentTextarea.value = '';

                                    const commentCountSpan = document.querySelector('.comment-count');
                                    if (commentCountSpan) {
                                        let currentCount = parseInt(commentCountSpan.textContent || '0', 10);
                                        commentCountSpan.textContent = currentCount + 1;
                                    }
                                })
                                .catch(error => {
                                    console.error('댓글 등록 중 오류:', error);
                                    alert('댓글 등록 중 오류가 발생했습니다. \n' + error.message);
                                });
                        });
                    }

                    const commentSection = document.querySelector('.comment-section');
                    if (commentSection) {
                        commentSection.addEventListener('click', function (event) {
                            const target = event.target;

                            if (target.classList.contains('delete-comment-btn')) {
                                event.preventDefault();
                                const commentId = target.dataset.commentKey;
                                if (!commentId) {
                                    alert('댓글 정보를 찾을 수 없습니다.');
                                    return;
                                }

                                if (confirm('정말로 이 댓글을 삭제하시겠습니까?')) {
                                    deleteComment(commentId, target);
                                }
                            }

                            else if (target.classList.contains('edit-comment-btn')) {
                                event.preventDefault();
                                const commentItem = target.closest('.comment-item');
                                if (commentItem) {
                                    showEditForm(commentItem);
                                }
                            }

                            else if (target.classList.contains('save-edit-btn')) {
                                event.preventDefault();
                                const commentItem = target.closest('.comment-item')
                                const commentId = commentItem?.dataset.commentKey;
                                const textarea = commentItem?.querySelector('.edit-textarea');
                                if (commentItem && commentId && textarea) {
                                    saveCommentEdit(commentId, textarea.value, commentItem);
                                } else {
                                    console.error("수정 저장 버튼 클릭 오류: 댓글 정보 또는 입력 필드를 찾을 수 없습니다.");
                                    alert("댓글 수정 정보를 찾는 중 오류가 발생했습니다.");
                                }
                            }

                            else if (target.classList.contains('cancel-edit-btn')) {
                                event.preventDefault();
                                const commentItem = target.closest('.comment-item');
                                if (commentItem) {
                                    cancelCommentEdit(commentItem);
                                }
                            }

                            // --- 답글쓰기 링크 클릭 처리 ---
                            if (target.classList.contains('reply-link')) {
                                event.preventDefault();
                                if (!loggedInCustId) {
                                    alert('답글을 작성하려면 로그인이 필요합니다.');
                                    window.location.href = '<c:url value="/gologin"/>';
                                    return;
                                }
                                const parentCommentItem = target.closest('.comment-item');
                                const parentCommentKey = target.dataset.commentKey;
                                if (parentCommentItem && parentCommentKey) {
                                    showReplyForm(parentCommentItem, parentCommentKey);
                                } else {
                                    console.error("답글쓰기 오류: 부모 댓글 정보를 찾을 수 없습니다.");
                                }
                            }

                            // --- 답글 폼 취소 버튼 클릭 처리 ---
                            else if (target.classList.contains('cancel-reply-btn')) {
                                event.preventDefault();
                                const replyFormContainer = target.closest('.reply-form-container');
                                if (replyFormContainer) {
                                    removeReplyForm(replyFormContainer);
                                }
                            }

                            // --- 답글 폼 등록 버튼 클릭 처리 ---
                            else if (target.classList.contains('save-reply-btn')) {
                                event.preventDefault();
                                const replyForm = target.closest('.reply-form');
                                const parentCommentKey = replyForm?.dataset.parentKey;
                                const textarea = replyForm?.querySelector('textarea');
                                const content = textarea?.value;
                                const parentCommentItem = replyForm?.closest('.comment-item');

                                if (replyForm && parentCommentKey && textarea && parentCommentItem) {
                                    saveReply(parentCommentKey, content, parentCommentItem, replyForm);
                                } else {
                                    console.error("답글 저장 버튼 클릭 오류: 답글 폼 정보를 찾을 수 없습니다.");
                                    alert("답글 저장 정보를 찾는 중 오류가 발생했습니다.");
                                }
                            }
                        });
                    }
                </script>