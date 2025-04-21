<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(function() {
    // 버튼 클릭 시 폼 보이기
    $("#toggleCommentFormBtn").click(function() {
      $("#admin-comment-form-wrapper").slideToggle();
    });

    // 댓글 등록 Ajax
    $("#submitCommentBtn").click(function() {
      const formData = $("#adminCommentForm").serialize();

      $.ajax({
        type: "POST",
        url: "/admincomments/addimpl",
        data: formData,
        success: function() {
          alert("댓글이 등록되었습니다.");
          location.reload();
        },
        error: function(xhr) {
          alert("등록 실패: " + xhr.responseText);
        }
      });
    });
  });
</script>

<h3>관리자 답변</h3>

<!-- 관리자 댓글쓰기 버튼 -->
<c:if test="${empty adminComment}">
  <button id="toggleCommentFormBtn" class="btn btn-secondary">관리자 댓글쓰기</button>
</c:if>

<!-- 댓글 입력 폼: 기본은 숨김 -->
<div id="admin-comment-form-wrapper" style="display:none; margin-top: 10px;">
  <form id="adminCommentForm">
    <input type="text" name="boardKey" value="${board.boardKey}" />
    <input type="text" name="itemKey" value="${board.itemKey}" />
    <input type="text" name="adminId" value="${sessionScope.admin.adminId}" />
    <textarea name="adcommentsContent" rows="4" cols="100" placeholder="댓글을 입력하세요."></textarea><br/>
    <button type="button" id="submitCommentBtn" class="btn btn-secondary">등록</button>
  </form>
  <div id="adminCommentResult"></div>
</div>