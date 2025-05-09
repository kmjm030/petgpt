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
    <label for="title">공지 제목</label>
    <input type="text" id="title" name="title" required class="form-control" maxlength="50">
    <small id="titleCount" style="display:block; margin-top:5px; color:#666;">0 / 50자</small>
  </div>

  <!-- 공지 내용 -->
  <div class="form-group">
    <label for="content">공지 내용</label>
    <textarea id="content" name="content" required class="form-control"></textarea>
  </div>

  <button type="submit" class="submit-btn">등록</button>

  <!-- Toast 알림 -->
  <div id="toast" class="toast">공지 등록이 완료되었습니다!</div>

  <!-- Success 플래그 체크 및 Toast 처리 -->
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
</form>

<!-- CKEditor CDN -->
<script src="https://cdn.ckeditor.com/4.20.1/standard/ckeditor.js"></script>
<script src="/js/admin.js"></script>

<script>
  window.addEventListener('DOMContentLoaded', function() {
    // CKEditor 적용
    if (document.getElementById('content')) {
      CKEDITOR.replace('content');
    }

    // 제목 길이 카운터
    var titleInput = document.getElementById('title');
    var titleCount = document.getElementById('titleCount');

    function updateCount() {
      var count = titleInput.value.length;
      titleCount.textContent = count + ' / 50자';
    }

    if (titleInput && titleCount) {
      titleInput.addEventListener('input', updateCount);
      updateCount(); // 초기 표시
    }
  });
</script>

