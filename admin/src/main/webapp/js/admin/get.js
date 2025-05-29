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

document.getElementById('searchInput')?.addEventListener('input', function () {
  const keyword = this.value.toLowerCase();
  const rows = document.querySelectorAll('#noticeTable .notice-row');

  rows.forEach(row => {
    const title = row.querySelector('.title-cell')?.textContent.toLowerCase() || '';
    const writer = row.querySelector('.writer-cell')?.textContent.toLowerCase() || '';
    const match = title.includes(keyword) || writer.includes(keyword);
    row.style.display = match ? '' : 'none';
  });
});

document.getElementById('searchInput')?.addEventListener('input', function () {
  const keyword = this.value.toLowerCase();
  const rows = document.querySelectorAll('#noticeTable .notice-row');

  rows.forEach(row => {
    const title = row.querySelector('.title-cell')?.textContent.toLowerCase() || '';
    const writer = row.querySelector('.writer-cell')?.textContent.toLowerCase() || '';
    const match = title.includes(keyword) || writer.includes(keyword);
    row.style.display = match ? '' : 'none';
  });
});

const canvas = document.getElementById('snow-canvas');
const ctx = canvas.getContext('2d');
let width = canvas.width = window.innerWidth;
let height = canvas.height = window.innerHeight;

const snowflakes = [];

function createSnowflakes() {
  const count = 100;
  for (let i = 0; i < count; i++) {
    snowflakes.push({
      x: Math.random() * width,
      y: Math.random() * height,
      radius: Math.random() * 3 + 1,
      speed: Math.random() * 1 + 0.5,
      drift: Math.random() * 1 - 0.5
    });
  }
}

function drawSnowflakes() {
  ctx.clearRect(0, 0, width, height);
  ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
  ctx.beginPath();
  for (let flake of snowflakes) {
    ctx.moveTo(flake.x, flake.y);
    ctx.arc(flake.x, flake.y, flake.radius, 0, Math.PI * 2);
  }
  ctx.fill();
  moveSnowflakes();
}

function moveSnowflakes() {
  for (let flake of snowflakes) {
    flake.y += flake.speed;
    flake.x += flake.drift;
    if (flake.y > height) {
      flake.y = 0;
      flake.x = Math.random() * width;
    }
  }
}

function animateSnow() {
  drawSnowflakes();
  requestAnimationFrame(animateSnow);
}

window.addEventListener('resize', () => {
  width = canvas.width = window.innerWidth;
  height = canvas.height = window.innerHeight;
});

createSnowflakes();
animateSnow();
