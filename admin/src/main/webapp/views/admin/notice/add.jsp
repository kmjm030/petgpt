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
    <input type="text" id="adminId" name="adminId"
           value="${admin.adminId}" readonly
           class="form-control" style="background-color: #f5f5f5; color: #333;">
  </div>

  <div class="form-group">
    <label for="title">공지 제목</label>
    <input type="text" id="title" name="title" required class="form-control">
  </div>

  <div class="form-group">
    <label for="content">공지 내용</label>
    <textarea id="content" name="content" required class="form-control"></textarea>
  </div>

  <div class="form-group button-group">
    <button type="submit" class="submit-btn">등록</button>
    <button type="button" class="cancel-btn"
            onclick="window.location.href='<c:url value='/admin/notice/get'/>'">취소</button>
    <button type="reset" class="reset-btn">초기화</button>
  </div>
</form>
