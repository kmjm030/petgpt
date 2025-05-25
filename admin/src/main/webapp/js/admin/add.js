window.addEventListener('DOMContentLoaded', function () {
  const content = document.getElementById('content');
  const titleInput = document.getElementById('title');
  const titleCount = document.getElementById('titleCount');
  const toast = document.getElementById('toast');
  const form = document.querySelector('form');
  const previewBtn = document.getElementById('previewBtn');

  // CKEditor 적용
  if (content) {
    CKEDITOR.replace('content', {
      height: 300,
      removePlugins: 'elementspath',
      resize_enabled: false
    });
  }

  // 제목 글자 수 표시
  if (titleInput && titleCount) {
    const updateCount = () => {
      titleCount.textContent = `${titleInput.value.length} / 50자`;
    };
    titleInput.addEventListener('input', updateCount);
    updateCount();
  }

  // 제출 시 유효성 검사
  if (form) {
    form.addEventListener('submit', function (e) {
      const title = titleInput.value.trim();
      const contentData = CKEDITOR.instances.content.getData().trim();

      if (!title) {
        alert('공지 제목을 입력해주세요.');
        titleInput.focus();
        e.preventDefault();
        return;
      }

      if (!contentData) {
        alert('공지 내용을 입력해주세요.');
        CKEDITOR.instances.content.focus();
        e.preventDefault();
        return;
      }
    });
  }

  // ✅ 미리보기 버튼 클릭 시 팝업 출력
  if (previewBtn) {
    previewBtn.addEventListener('click', function () {
      const title = titleInput.value.trim();
      const contentHtml = CKEDITOR.instances.content.getData();

      if (!title || !contentHtml.trim()) {
        alert('제목과 내용을 모두 입력해야 미리보기가 가능합니다.');
        return;
      }

      const previewWindow = window.open('', '_blank', 'width=800,height=600');
      if (!previewWindow) {
        alert('팝업이 차단되었습니다. 브라우저 설정을 확인하세요.');
        return;
      }

      previewWindow.document.open();
      previewWindow.document.write(`
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
            <title>공지 미리보기</title>
            <style>
              body { font-family: 'Segoe UI', sans-serif; padding: 20px; }
              h2 { border-bottom: 2px solid #333; padding-bottom: 10px; }
              .content { margin-top: 20px; }
            </style>
          </head>
          <body>
            <h2>${title}</h2>
            <div class="content">${contentHtml}</div>
          </body>
        </html>
      `);
      previewWindow.document.close();
    });
  }

  // 토스트 메시지 표시
  if (toast && toast.textContent.trim().length > 0) {
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
  }
});
