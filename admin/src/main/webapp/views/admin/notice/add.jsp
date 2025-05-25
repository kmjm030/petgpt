<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/admin/add.css">

<h2>
  <i class="fas fa-bullhorn" style="color:#1d1d1f;"></i>
  관리자 공지 등록
</h2>

<form method="post" action="<c:url value='/admin/notice/addimpl'/>">
  <div id="autosave-toast" class="toast" style="bottom: 80px;">임시 저장 완료</div>

  <div class="form-group">
    <label for="title">공지 제목</label>
    <input type="text" id="title" name="title" required class="form-control" maxlength="50">
    <small id="titleCount" class="text-muted">0 / 50자</small>
  </div>

  <div class="form-group">
    <label for="content">공지 내용</label>
    <textarea id="content" name="content" required class="form-control"></textarea>
  </div>

  <div class="form-group">
    <label for="publishAt">공지 게시 시간 (선택)</label>
    <input type="datetime-local" id="publishAt" name="publishAt" class="form-control">
    <small class="text-muted">지정하지 않으면 즉시 게시됩니다.</small>
  </div>

  <div class="form-group d-flex justify-content-end gap-2">
    <button type="button" id="previewBtn" class="btn btn-outline-dark mr-2">미리보기</button>
    <button type="submit" class="btn btn-primary submit-btn">등록</button>
  </div>

  <c:if test="${not empty success}">
    <div id="toast" class="toast">공지 등록이 완료되었습니다!</div>
    <script>
      setTimeout(() => {
        window.location.href = '<c:url value="/admin/notice/get"/>';
      }, 3000);
    </script>
  </c:if>
</form>

<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<script src="/js/admin/add.js"></script>
