<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
  $(function () {
    $("#toggleCommentFormBtn").click(() => {
      $("#admin-comment-form-wrapper").slideToggle(200);
    });

    $("#submitCommentBtn").click(() => {
      const formData = $("#adminCommentForm").serialize();
      $.ajax({
        type: "POST",
        url: "/admincomments/addimpl",
        data: formData,
        success: () => {
          alert("댓글이 등록되었습니다.");
          location.reload();
        },
        error: (xhr) => {
          alert("등록 실패: " + xhr.responseText);
        }
      });
    });
  });
</script>

<style>
  .comment-section {
    margin-top: 2rem;
  }

  .comment-section h3 {
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 1rem;
    color: #1d1d1f;
  }

  .btn-toggle {
    background-color: #1d1d1f;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 0.5rem 1.2rem;
    font-weight: 600;
    cursor: pointer;
  }

  .btn-toggle:hover {
    background-color: #333;
  }

  #admin-comment-form-wrapper {
    margin-top: 1rem;
    background-color: #fff;
    padding: 1.5rem;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    max-width: 700px;
  }

  #adminCommentForm input[type="text"],
  #adminCommentForm textarea {
    width: 100%;
    font-size: 0.95rem;
    padding: 0.6rem;
    margin-bottom: 1rem;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: #fff;
    color: #1d1d1f;
  }

  #adminCommentForm textarea {
    resize: vertical;
  }

  #submitCommentBtn {
    background-color: #1d1d1f;
    color: white;
    border: none;
    border-radius: 8px;
    padding: 0.5rem 1.2rem;
    font-weight: 600;
  }

  #submitCommentBtn:hover {
    background-color: #333;
  }

  body.dark-mode #admin-comment-form-wrapper {
    background-color: #2c2c2e;
    border-color: #3a3a3c;
  }

  body.dark-mode input,
  body.dark-mode textarea {
    background-color: #2c2c2e;
    color: #f5f5f7;
    border: 1px solid #3a3a3c;
  }

  body.dark-mode .comment-section h3 {
    color: #f5f5f7;
  }

  body.dark-mode .btn-toggle,
  body.dark-mode #submitCommentBtn {
    background-color: #3a3a3c;
    color: #f5f5f7;
  }

  body.dark-mode .btn-toggle:hover,
  body.dark-mode #submitCommentBtn:hover {
    background-color: #4a4a4a;
  }
</style>

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
