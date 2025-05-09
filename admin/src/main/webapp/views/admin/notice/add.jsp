<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/admin.css">

<h2>
    <i class="fas fa-bullhorn" style="color:#1d1d1f;"></i>
    관리자 공지 등록
</h2>

<form method="post" action="<c:url value='/admin/notice/addimpl'/>">
    <div class="form-group">
        <label for="adminId">작성자 ID</label>
      <input type="text" id="adminId" name="adminId" value="${admin.adminId}" readonly>
    </div>

  <div class="form-group">
    <label for="title">공지 제목</label>
    <input type="text" id="title" name="title" required class="form-control" maxlength="50">
    <small id="titleCount" style="display:block; margin-top:5px; color:#666;">0 / 50자</small>
  </div>
  <script src="/js/admin.js"></script>
    <div class="form-group">
        <label for="content">공지 내용</label>
        <textarea id="content" name="content" required></textarea>
    </div>

    <button type="submit" class="submit-btn">등록</button>

  <div id="toast" class="toast">공지 등록이 완료되었습니다!</div>

  <c:if test="${not empty success}">
  <script>
    window.addEventListener('DOMContentLoaded', function() {
      var toast = document.getElementById('toast');
      toast.classList.add('show');
      setTimeout(function() {
        toast.classList.remove('show');
      }, 3000);
    });
  </script>
  </c:if>
