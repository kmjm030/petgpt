<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="/js/qnaboard/addadmincomments.js"></script>

<div class="comment-section">
  <h3>관리자 답변</h3>

  <c:if test="${empty adminComment}">
    <button id="toggleCommentFormBtn" class="btn-toggle">댓글 쓰기</button>
  </c:if>

  <div id="admin-comment-form-wrapper" style="display:none;">
    <form id="adminCommentForm">
      <input type="text" name="boardKey" value="${board.boardKey}" hidden />
      <input type="text" name="itemKey" value="${board.itemKey}" hidden />
      <input type="text" name="adminId" value="${sessionScope.admin.adminId}" hidden />

      <label for="adcommentsContent">댓글 내용</label>
      <textarea name="adcommentsContent" id="adcommentsContent" placeholder="댓글을 입력하세요." rows="5" required></textarea>

      <button type="button" id="submitCommentBtn">등록</button>
    </form>
  </div>
</div>
