<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/admin/detail.css">

<div class="detail-form">
  <h2>공지 수정</h2>

  <form method="post" action="<c:url value='/admin/notice/editimpl'/>">
    <input type="hidden" name="id" value="${notice.id}" />
    <input type="hidden" name="adminId" value="${notice.adminId}" />

    <div class="form-group">
      <label for="title">제목</label>
      <input type="text" id="title" name="title" value="${notice.title}" required maxlength="50" />
      <small id="titleCount" class="text-muted">0 / 50자</small>
    </div>

    <div class="form-group">
      <label for="content">내용</label>
      <textarea id="content" name="content" required>${notice.content}</textarea>
    </div>

    <button type="button" class="compare-btn" id="compareBtn">수정 전/후 비교</button>

    <div id="compareSection" class="compare-section" style="display:none;">
      <h3>수정 전 내용</h3>
      <div class="compare-box" id="originalContent">${notice.content}</div>
      <h3>수정 후 내용</h3>
      <div class="compare-box" id="newContent"></div>
    </div>

    <div class="form-actions">
      <button type="submit" class="submit-btn">수정 완료</button>
      <button type="button" class="delete-btn" onclick="confirmDelete(event, '${notice.id}')">삭제</button>
    </div>

    <a href="<c:url value='/admin/notice/get'/>" class="back-link">← 목록으로</a>
  </form>

  <div id="toast" class="toast">공지 수정이 완료되었습니다!</div>

  <c:if test="${not empty success}">
    <script>
      window.addEventListener('DOMContentLoaded', function() {
        const toast = document.getElementById('toast');
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3000);
      });
    </script>
  </c:if>
</div>

<script src="https://cdn.ckeditor.com/4.20.1/standard/ckeditor.js"></script>
<script src="/js/admin/detail.js"></script>
