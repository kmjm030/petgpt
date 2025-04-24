<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .detail-form {
    max-width: 600px;
    margin: 0 auto;
    background-color: #fff;
    padding: 2rem;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  }

  .detail-form h2 {
    font-size: 1.5rem;
    margin-bottom: 1.5rem;
    color: #1d1d1f;
  }

  .form-group {
    margin-bottom: 1.2rem;
  }

  .form-group label {
    font-weight: 500;
    color: #333;
    margin-bottom: 0.3rem;
    display: block;
  }

  .form-group input,
  .form-group textarea {
    width: 100%;
    padding: 0.6rem;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 0.95rem;
  }

  .form-group textarea {
    min-height: 150px;
    resize: vertical;
  }

  .form-actions {
    display: flex;
    gap: 10px;
    margin-top: 1rem;
  }

  .form-actions button,
  .form-actions a {
    font-size: 0.9rem;
    padding: 0.5rem 1.2rem;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    text-decoration: none;
  }

  .submit-btn {
    background-color: #1d1d1f;
    color: white;
  }

  .delete-btn {
    background-color: #e53935;
    color: white;
  }

  .form-actions a:hover {
    background-color: #c62828;
  }

  .back-link {
    display: inline-block;
    margin-top: 1.5rem;
    padding: 0.5rem 1.2rem;
    background-color: #f5f5f7;
    border: 1px solid #ccc;
    border-radius: 8px;
    text-decoration: none;
    color: #1d1d1f;
    font-size: 0.9rem;
  }

  .back-link:hover {
    background-color: #eaeaea;
  }

  body.dark-mode .detail-form {
    background-color: #1d1d1f;
    color: #f5f5f7;
    border: 1px solid #3a3a3c;
  }

  body.dark-mode .detail-form h2,
  body.dark-mode .detail-form label {
    color: #f5f5f7;
  }

  body.dark-mode .form-group input,
  body.dark-mode .form-group textarea {
    background-color: #2c2c2e;
    border: 1px solid #3a3a3c;
    color: #f5f5f7;
  }

  body.dark-mode .form-group input::placeholder,
  body.dark-mode .form-group textarea::placeholder {
    color: #aaa;
  }

  body.dark-mode .submit-btn {
    background-color: #3a3a3c;
    color: #f5f5f7;
  }

  body.dark-mode .submit-btn:hover {
    background-color: #4a4a4a;
  }

  body.dark-mode .delete-btn {
    background-color: #c62828;
  }

  body.dark-mode .back-link {
    background-color: #2c2c2e;
    color: #f5f5f7;
    border: 1px solid #3a3a3c;
  }

  body.dark-mode .back-link:hover {
    background-color: #3a3a3c;
  }
</style>

<div class="detail-form">
  <h2>📄 공지 수정</h2>

  <form method="post" action="<c:url value='/admin/notice/editimpl'/>">
    <input type="hidden" name="id" value="${notice.id}" />
    <input type="hidden" name="adminId" value="${notice.adminId}" />

    <div class="form-group">
      <label for="title">제목</label>
      <input type="text" id="title" name="title" value="${notice.title}" required />
    </div>

    <div class="form-group">
      <label for="content">내용</label>
      <textarea id="content" name="content" required>${notice.content}</textarea>
    </div>

    <div class="form-actions">
      <button type="submit" class="submit-btn">수정 완료</button>
      <a href="<c:url value='/admin/notice/delete?id=${notice.id}'/>"
         class="delete-btn"
         onclick="return confirm('정말 삭제하시겠습니까?');">
        삭제
      </a>
    </div>

    <a href="<c:url value='/admin/notice/get'/>" class="back-link">← 목록으로</a>
  </form>
</div>
