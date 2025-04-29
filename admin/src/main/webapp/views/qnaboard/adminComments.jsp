<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
  const admincomments_detail = {
    update(id) {
      if (confirm('수정하시겠습니까?')) {
        location.href = '<c:url value="/board/detail"/>?id=' + id;
      }
    },
    delete(id, boardKey) {
      if (confirm('삭제하시겠습니까?')) {
        location.href = '<c:url value="/admincomments/delete"/>?adcommentsKey=' + id + '&boardKey=' + boardKey;
      }
    }
  };
</script>

<div class="admin-comment-card">
  <div class="admin-comment-header">🛠 관리자 답변</div>

  <div class="admin-comment-meta">
    <div><strong>작성자:</strong> ${adminComments.adminId}</div>
    <div>
      등록일: <fmt:formatDate value="${adminComments.adcommentsRdate}" pattern="yyyy-MM-dd HH:mm" />
      &nbsp;|&nbsp;
      수정일: <fmt:formatDate value="${adminComments.adcommentsUpdate}" pattern="yyyy-MM-dd HH:mm" />
    </div>
  </div>

  <div class="admin-comment-content">
    ${adminComments.adcommentsContent}
  </div>

  <div class="admin-comment-actions">
    <button onclick="admincomments_detail.update('${adminComments.adcommentsKey}')" class="btn btn-outline-light">수정</button>
    <button onclick="admincomments_detail.delete('${adminComments.adcommentsKey}', '${board.boardKey}')" class="btn btn-outline-danger">삭제</button>
  </div>
</div>
