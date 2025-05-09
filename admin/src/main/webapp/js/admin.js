// 페이지 로드 후 실행되는 코드
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

  // 수정 완료 후 Toast 알림 처리
  var toast = document.getElementById('toast');
  if (toast) {
    toast.classList.add('show');
    setTimeout(function() {
      toast.classList.remove('show');
    }, 3000);
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
function confirmDelete(event, noticeId) {
  event.preventDefault(); // 기본 동작을 막음 (삭제 링크의 이동을 막음)

  const confirmation = prompt("삭제를 진행하려면 '삭제'라고 입력하세요:");
  if (confirmation === '삭제') {
    // 삭제 진행
    window.location.href = `/admin/notice/delete?id=${noticeId}`;
  } else {
    alert("삭제가 취소되었습니다.");
  }
}

// 검색 기능
function searchNotices() {
  var input = document.getElementById('searchInput').value.toLowerCase();
  var rows = document.querySelectorAll('.notice-table tbody tr');

  rows.forEach(function(row) {
    var title = row.cells[1].textContent.toLowerCase();
    var adminName = row.cells[2].textContent.toLowerCase();
    var date = row.cells[3].textContent.toLowerCase();

    // 제목, 작성자, 작성일을 기준으로 필터링
    if (title.includes(input) || adminName.includes(input) || date.includes(input)) {
      row.style.display = '';
    } else {
      row.style.display = 'none';
    }
  });
}
