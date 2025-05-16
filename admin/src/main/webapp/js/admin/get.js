window.addEventListener('DOMContentLoaded', function() {
  const content = document.getElementById('content');
  const compareBtn = document.getElementById('compareBtn');
  const compareSection = document.getElementById('compareSection');
  const newContentBox = document.getElementById('newContent');
  const toast = document.getElementById('toast');

  if (content) CKEDITOR.replace('content');

  if (compareBtn) {
    compareBtn.addEventListener('click', function() {
      newContentBox.innerHTML = CKEDITOR.instances.content.getData();
      compareSection.style.display = compareSection.style.display === 'none' ? 'block' : 'none';
    });
  }

  if (toast) {
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
  }
});

function confirmDelete(event, noticeId) {
  event.preventDefault();

  const confirmation = prompt("삭제를 진행하려면 '삭제'라고 입력하세요:");
  if (confirmation === '삭제') {
    window.location.href = `/admin/notice/delete?id=${noticeId}`;
  } else {
    alert("삭제가 취소되었습니다.");
  }
}
