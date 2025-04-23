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
                        margin-bottom: 25px;
                        padding-bottom: 25px;
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
                    .comment-meta .comment-like-button {
                        cursor: pointer;
                        color: #888;
                    }

                    .comment-meta .reply-link:hover {
                        text-decoration: underline;
                    }

                    .comment-meta .delete-comment-btn {
                        color: #888;
                        text-decoration: none;
                        cursor: pointer;
                    }

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
                                            <div class="comment-item" data-comment-key="${comment.commentsKey}">
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
                                                    </div>
                                                    <div class="comment-text">
                                                        <c:out value="${comment.commentsContent}" />
                                                    </div>
                                                    <div class="comment-meta">
                                                        <span class="comment-timestamp">
                                                            ${comment.formattedCommentsRdate}
                                                        </span>
                                                        <a href="#" class="reply-link">답글쓰기</a>
                                                        <c:if
                                                            test="${not empty loggedInUser && loggedInUser.custId eq comment.custId}">
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

                    function appendComment(comment) {
                        const commentSection = document.querySelector('.comment-section');
                        if (!commentSection) return;

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

                        const profileImgUrl = comment.custProfileImgUrl || '<c:url value="/img/default-profile.png"/>';
                        const formattedDate = formatDateTime(comment.commentsRdate);
                        const commentId = comment.commentsKey || '';
                        const commentAuthorId = comment.custId || '';

                        let deleteButtonHTML = '';
                        if (loggedInCustId && loggedInCustId === commentAuthorId) {
                            deleteButtonHTML = ' <a href="#" class="delete-comment-btn" data-comment-key="' + commentId + '">삭제</a>';
                        }

                        const commentItemHTML =
                            '<div class="comment-item" data-comment-key="' + commentId + '">' +
                            '<div class="comment-author-img">' +
                            '<img src="' + profileImgUrl + '" alt="프로필 이미지">' +
                            '</div>' +
                            '<div class="comment-content-wrap">' +
                            '<div class="comment-author-name">' + (comment.custId || '익명') + '</div>' +
                            '<div class="comment-text">' + (comment.commentsContent || '') + '</div>' +
                            '<div class="comment-meta">' +
                            '<span class="comment-timestamp">' + formattedDate + '</span>' +
                            ' <a href="#" class="reply-link">답글쓰기</a> ' +
                            deleteButtonHTML +
                            ' <span class="comment-like-button" data-comment-key="' + commentId + '">' +
                            ' <i class="fa fa-heart-o"></i>' +
                            ' <span class="count">' + (comment.likeCount || 0) + '</span>' +
                            '</span>' +
                            '</div>' +
                            '</div>' +
                            '</div>';

                        commentSection.insertAdjacentHTML('beforeend', commentItemHTML);
                    }

                    const commentSection = document.querySelector('.comment-section');
                    if (commentSection) {
                        commentSection.addEventListener('click', function (event) {

                            if (event.target.classList.contains('delete-comment-btn')) {
                                event.preventDefault();

                                const commentId = event.target.dataset.commentKey;
                                if (!commentId) {
                                    alert('댓글 정보를 찾을 수 없습니다.');
                                    return;
                                }

                                if (confirm('정말로 이 댓글을 삭제하시겠습니까?')) {
                                    deleteComment(commentId, event.target);
                                }
                            }
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
                                alert(successMessage || '댓글이 성공적으로 삭제되었습니다.');

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
                </script>