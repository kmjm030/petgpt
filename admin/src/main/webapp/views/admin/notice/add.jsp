<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/admin/add.css">

<canvas id="snow-canvas"></canvas>

<div class="container-fluid">
  <h2>
    <i class="fas fa-bullhorn"></i>
    관리자 공지 등록
  </h2>

  <form method="post" action="<c:url value='/admin/notice/addimpl'/>">
    <div class="form-group">
      <label for="title">공지 제목</label>
      <input type="text" id="title" name="title" required class="form-control" maxlength="50">
      <div class="d-flex justify-content-between align-items-center mt-1">
        <small id="titleCount" class="text-muted">0 / 50자</small>
        <div class="form-check mb-0">
          <input type="checkbox" class="form-check-input" id="pinned" name="pinned" value="true">
          <label class="form-check-label" for="pinned" style="font-size: 0.9rem;">상단 고정</label>
        </div>
      </div>
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
</div>

<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<script src="/js/admin/add.js"></script>
