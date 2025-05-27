window.addEventListener('DOMContentLoaded', function () {
  const content = document.getElementById('content');
  const titleInput = document.getElementById('title');
  const titleCount = document.getElementById('titleCount');
  const toast = document.getElementById('toast');
  const form = document.querySelector('form');
  const previewBtn = document.getElementById('previewBtn');
  const submitBtn = document.querySelector('.submit-btn');

  if (content) {
    CKEDITOR.replace('content', {
      height: 300,
      removePlugins: 'elementspath',
      resize_enabled: false,
      toolbar: [
        { name: 'basicstyles', items: ['Bold', 'Italic', 'Underline'] },
        { name: 'paragraph', items: ['NumberedList', 'BulletedList'] },
        { name: 'insert', items: ['Link', 'Image'] },
        { name: 'tools', items: ['Maximize'] }
      ]
    });
  }

  if (titleInput && titleCount) {
    const updateCount = () => {
      titleCount.textContent = `${titleInput.value.length} / 50자`;
    };
    titleInput.addEventListener('input', updateCount);
    updateCount();
  }

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

    const confirmResult = confirm('정말 이 공지를 등록하시겠습니까?');
    if (!confirmResult) {
      e.preventDefault();
      return;
    }

    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.textContent = '등록 중...';
    }
  });

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

  if (toast && toast.textContent.trim().length > 0) {
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
  }
});

window.addEventListener('DOMContentLoaded', () => {
  const canvas = document.createElement('canvas');
  canvas.id = 'snow-canvas';
  document.body.appendChild(canvas);

  const ctx = canvas.getContext('2d');
  let width = canvas.width = window.innerWidth;
  let height = canvas.height = window.innerHeight;

  const flakes = [];
  for (let i = 0; i < 100; i++) {
    flakes.push({
      x: Math.random() * width,
      y: Math.random() * height,
      r: Math.random() * 3 + 1,
      d: Math.random() + 1
    });
  }

  function drawFlakes() {
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = 'white';
    ctx.beginPath();
    for (let i = 0; i < flakes.length; i++) {
      const f = flakes[i];
      ctx.moveTo(f.x, f.y);
      ctx.arc(f.x, f.y, f.r, 0, Math.PI * 2, true);
    }
    ctx.fill();
    moveFlakes();
  }

  function moveFlakes() {
    for (let i = 0; i < flakes.length; i++) {
      const f = flakes[i];
      f.y += Math.pow(f.d, 2);
      if (f.y > height) {
        flakes[i] = { x: Math.random() * width, y: 0, r: f.r, d: f.d };
      }
    }
  }

  setInterval(drawFlakes, 25);

  window.addEventListener('resize', () => {
    width = canvas.width = window.innerWidth;
    height = canvas.height = window.innerHeight;
  });
});
