window.addEventListener('DOMContentLoaded', function() {
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
});
