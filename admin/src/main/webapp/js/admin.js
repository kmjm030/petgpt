window.addEventListener('DOMContentLoaded', function() {
  // 제목 글자수 카운터
  var titleInput = document.getElementById('title');
  var titleCount = document.getElementById('titleCount');

  function updateCount() {
    var count = titleInput.value.length;
    titleCount.textContent = count + ' / 50자';
  }

  if (titleInput && titleCount) {
    titleInput.addEventListener('input', updateCount);
    updateCount();
  }

  // CKEditor 적용
  if (document.getElementById('content')) {
    CKEDITOR.replace('content');
  }
});
window.addEventListener('DOMContentLoaded', function() {
  // 수정 완료 후 Toast 메시지 표시
  const toast = document.getElementById('toast');
  if (toast) {
    toast.classList.add('show');
    setTimeout(() => {
      toast.classList.remove('show');
    }, 3000);
  }
});
