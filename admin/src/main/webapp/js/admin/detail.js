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

const canvas = document.getElementById('snow-canvas');
const ctx = canvas.getContext('2d');
let width, height;
let snowflakes = [];

function resizeCanvas() {
  width = canvas.width = window.innerWidth;
  height = canvas.height = window.innerHeight;
}

function createSnowflakes(count) {
  snowflakes = [];
  for (let i = 0; i < count; i++) {
    snowflakes.push({
      x: Math.random() * width,
      y: Math.random() * height,
      radius: Math.random() * 3 + 1,
      speed: Math.random() * 1 + 0.5,
      wind: Math.random() * 0.5 - 0.25
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
  updateSnowflakes();
  requestAnimationFrame(drawSnowflakes);
}

function updateSnowflakes() {
  for (let flake of snowflakes) {
    flake.y += flake.speed;
    flake.x += flake.wind;

    if (flake.y > height) flake.y = -flake.radius;
    if (flake.x > width) flake.x = 0;
    if (flake.x < 0) flake.x = width;
  }
}

window.addEventListener('resize', () => {
  resizeCanvas();
  createSnowflakes(100);
});

window.addEventListener('DOMContentLoaded', () => {
  resizeCanvas();
  createSnowflakes(100);
  drawSnowflakes();
});
