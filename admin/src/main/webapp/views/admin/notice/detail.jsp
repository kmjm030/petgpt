<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/admin.css">
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
