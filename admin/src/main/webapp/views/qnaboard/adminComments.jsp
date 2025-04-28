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

<style>
  .admin-comment-card {
    background-color: #fff;
    border-radius: 18px;
    padding: 2rem;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.06);
    margin-bottom: 2rem;
    transition: all 0.3s ease;
  }

  .admin-comment-header {
    font-size: 1.2rem;
    font-weight: 600;
    margin-bottom: 1rem;
    color: #1d1d1f;
  }

  .admin-comment-meta {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    font-size: 0.9rem;
    color: #666;
    margin-bottom: 1rem;
  }

  .admin-comment-content {
    background-color: #f8f9fa;
    border-radius: 12px;
    padding: 1rem;
    font-size: 0.95rem;
    line-height: 1.6;
    color: #1d1d1f;
  }

  .admin-comment-actions {
    margin-top: 1rem;
    display: flex;
    gap: 12px;
  }

  .admin-comment-actions .btn {
    font-size: 0.85rem;
    padding: 0.45rem 1.1rem;
    border-radius: 10px;
    font-weight: 600;
  }

  body.dark-mode .admin-comment-card {
    background-color: #1d1d1f;
    color: #f5f5f7;
  }

  body.dark-mode .admin-comment-header {
    color: #f5f5f7;
  }

  body.dark-mode .admin-comment-meta {
    color: #aaa;
  }

  body.dark-mode .admin-comment-content {
    background-color: #2c2c2e;
    color: #f5f5f7;
  }

  body.dark-mode .btn-outline-light {
    border: 1px solid #aaa;
    color: #f5f5f7;
  }

  body.dark-mode .btn-outline-light:hover {
    background-color: #444;
  }

  body.dark-mode .btn-outline-danger {
    color: #ff6b6b;
    border-color: #ff6b6b;
  }

  body.dark-mode .btn-outline-danger:hover {
    background-color: #ff6b6b;
    color: #fff;
  }
</style>

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
