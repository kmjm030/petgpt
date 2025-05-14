document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('detail_form');
  const idField = document.getElementById('id');

  document.getElementById('btn_update').addEventListener('click', () => {
    form.method = 'post';
    form.action = '/cust/update';
    form.submit();
  });

  document.getElementById('btn_delete').addEventListener('click', () => {
    if (confirm('삭제하시겠습니까?')) {
      location.href = '/cust/delete?id=' + encodeURIComponent(idField.value);
    }
  });

  document.getElementById('btn_showlist').addEventListener('click', () => {
    location.href = '/cust/get';
  });
});
