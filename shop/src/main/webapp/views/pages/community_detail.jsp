<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .community-detail-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 30px 20px;
    }
    .post-header {
        border-bottom: 1px solid #eee;
        padding-bottom: 20px;
        margin-bottom: 30px;
    }
    .post-title {
        font-size: 28px;
        font-weight: 600;
        margin-bottom: 15px;
    }
    .post-meta {
        font-size: 14px;
        color: #888;
    }
    .post-meta span {
        margin-right: 15px;
    }
    .post-meta i {
        margin-right: 5px;
    }
    .post-content {
        margin-top: 30px;
        line-height: 1.7;
        font-size: 16px;
        /* Summernote에서 생성된 이미지 크기 조절 (선택 사항) */
        /* max-width: 100%; height: auto; */
    }
    .post-content img {
         max-width: 100%;
         height: auto;
         margin-top: 10px;
         margin-bottom: 10px;
    }
    .post-actions {
        margin-top: 40px;
        text-align: center;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }
    .post-actions .site-btn {
        margin: 0 5px;
        padding: 10px 25px;
    }
    .thumbnail-image {
        max-width: 100%;
        height: auto;
        margin-bottom: 20px;
        border-radius: 5px;
    }
</style>

<!-- Breadcrumb Section Begin -->
<section class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__text">
                    <h4><c:out value="${board.boardTitle}"/></h4>
                    <div class="breadcrumb__links">
                        <a href="<c:url value='/'/>">Home</a>
                        <a href="<c:url value='/community'/>">커뮤니티</a>
                        <span><c:out value="${board.boardTitle}"/></span>
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
                    <div class="post-header">
                        <h2 class="post-title"><c:out value="${board.boardTitle}"/></h2>
                        <div class="post-meta">
                            <span><i class="fa fa-user"></i> 작성자: <c:out value="${board.custId}"/></span>
                        </div>
                    </div>

                    
                    <c:if test="${not empty board.boardImg}">
                        <img src="<c:url value='${board.boardImg}'/>" alt="대표 이미지" class="thumbnail-image">
                    </c:if>

                    <div class="post-content">
                        
                        <c:out value="${board.boardContent}" escapeXml="false"/>
                    </div>

                    <div class="post-actions">
                        <a href="<c:url value='/community'/>" class="site-btn">목록</a>
                        
                        <c:if test="${not empty sessionScope.cust && sessionScope.cust.custId eq board.custId}">
                            <a href="<c:url value='/community/edit?id=${board.boardKey}'/>" class="site-btn">수정</a>
                            <a href="#" data-board-key="${board.boardKey}" onclick="deletePost(this); return false;" class="site-btn">삭제</a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>${errorMessage}</p>
                    <div class="post-actions">
                         <a href="<c:url value='/community'/>" class="site-btn">목록으로</a>
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
        // TODO: 삭제 처리를 위한 AJAX 요청 또는 폼 제출 로직 구현 필요
        alert('삭제 기능은 아직 구현되지 않았습니다. ID: ' + boardKey);
    }
}
</script>
