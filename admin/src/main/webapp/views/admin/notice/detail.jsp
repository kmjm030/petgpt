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
      <input type="text" id="title" name="title" value="${notice.title}" required maxlength="50" />
      <small id="titleCount" style="display:block; margin-top:5px; color:#666;">0 / 50자</small>
    </div>

    <div class="form-group">
      <label for="content">내용</label>
      <textarea id="content" name="content" required>${notice.content}</textarea>
    </div>

    <!-- 비교 버튼 추가 -->
    <button type="button" class="compare-btn" id="compareBtn">수정 전/후 비교</button>

    <!-- 수정 전/후 비교 영역 -->
    <div id="compareSection" class="compare-section" style="display:none;">
      <h3>수정 전 내용</h3>
      <div class="compare-box" id="originalContent">${notice.content}</div>
      <h3>수정 후 내용</h3>
      <div class="compare-box" id="newContent"></div>
    </div>

    <div class="form-actions">
      <button type="submit" class="submit-btn">수정 완료</button>
      <!-- 삭제 버튼 수정 -->
      <button type="button" class="delete-btn" onclick="confirmDelete()">삭제</button>
    </div>

    <a href="<c:url value='/admin/notice/get'/>" class="back-link">← 목록으로</a>
  </form>

  <!-- ✅ 수정 완료 후 Toast 알림 -->
  <div id="toast" class="toast">공지 수정이 완료되었습니다!</div>

  <!-- ✅ 수정 완료 후 알림 처리 -->
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

</div>

<!-- ✅ CKEditor CDN -->
<script src="https://cdn.ckeditor.com/4.20.1/standard/ckeditor.js"></script>

<!-- ✅ JavaScript (글자수 카운터, CKEditor, 비교기능) -->
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

    // 수정 전/후 내용 비교 기능
    var compareBtn = document.getElementById('compareBtn');
    var compareSection = document.getElementById('compareSection');
    var newContentBox = document.getElementById('newContent');

    compareBtn.addEventListener('click', function() {
      // 수정 후 내용을 비교 영역에 추가 (HTML 내용도 제대로 렌더링)
      newContentBox.innerHTML = CKEDITOR.instances.content.getData(); // CKEditor로 입력된 HTML 내용 가져오기

      // 비교 영역 토글
      compareSection.style.display = compareSection.style.display === 'none' ? 'block' : 'none';
    });
  });

  // 삭제 확인 절차
  function confirmDelete() {
    var confirmation = prompt("삭제를 진행하려면 '삭제'라고 입력하세요:");
    if (confirmation === '삭제') {
      window.location.href = "<c:url value='/admin/notice/delete?id=${notice.id}'/>";
    } else {
      alert("삭제가 취소되었습니다.");
    }
  }
</script>
