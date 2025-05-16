window.addEventListener('DOMContentLoaded', function() {
  const content = document.getElementById('content');
  const titleInput = document.getElementById('title');
  const titleCount = document.getElementById('titleCount');
  const toast = document.getElementById('toast');

  if (content) CKEDITOR.replace('content');

  if (titleInput && titleCount) {
    const updateCount = () => {
      titleCount.textContent = `${titleInput.value.length} / 50자`;
    };

    titleInput.addEventListener('input', updateCount);
    updateCount();
  }

  if (toast) {
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3000);
  }
});
