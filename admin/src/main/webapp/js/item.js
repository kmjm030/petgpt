$(function () {
  const form = $('#item_add_form');
  const today = new Date().toISOString().slice(0, 10);
  $('#regDate').val(today);

  $('#btn_add').click(function () {
    $('#errorMsg').hide();
    const requiredFields = [
      'select[name="categoryKey"]',
      'input[name="itemName"]',
      'input[name="itemPrice"]',
      'select[name="size"]',
      'input[name="color"]',
      'input[name="additionalPrice"]',
      'input[name="stock"]'
    ];
    for (const field of requiredFields) {
      if (!$(field).val()?.trim()) {
        $('#errorMsg').show();
        return;
      }
    }

    Swal.fire({
      title: '등록하시겠습니까?',
      text: '입력하신 내용으로 상품을 등록합니다.',
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#aaa',
      confirmButtonText: '등록',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        form.attr({
          method: 'post',
          enctype: 'multipart/form-data',
          action: '/item/addimpl'
        }).submit();
      }
    });
  });

  $('#btn_reset').click(function () {
    form[0].reset();
    $('#regDate').val(today);
    $('#errorMsg').hide();
  });
});

$(function () {
  $('#btn_delete').click(() => {
    const key = $('#itemKey').val();
    Swal.fire({
      title: '정말로 이 상품을 삭제하시겠습니까?',
      text: '삭제된 상품은 복구할 수 없습니다.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        window.location.href = `/item/del?item_key=${key}`;
      }
    });
  });

  $('#btn_update').click(() => {
    const $form = $('#item_update_form');
    if ($form.length === 0) {
      console.error('⚠ item_update_form not found in HTML');
      Swal.fire({
        icon: 'error',
        title: '폼 오류',
        text: '업데이트 폼이 페이지에서 발견되지 않았습니다.'
      });
      return;
    }
    Swal.fire({
      title: '이 상품 정보를 수정하시겠습니까?',
      text: '상품 정보가 변경됩니다.',
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#aaa',
      confirmButtonText: '수정',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        $form.attr({
          method: 'post',
          enctype: 'multipart/form-data',
          action: '/item/update'
        }).submit();
      }
    });
  });
});

$('#dataTable').DataTable({
  pageLength: 10,
  lengthMenu: [10, 25, 50, 100],
  stateSave: true,
  columnDefs: [
    { orderable: true, targets: 1 },
    { orderable: false, targets: [0, 2, 3] }
  ],
  order: [[1, 'desc']],
  dom: 'Bf t<"d-flex justify-content-between mt-3 px-1"lip>',
  buttons: [
    { extend: 'copy', text: '복사' },
    { extend: 'csv', text: 'CSV 다운로드' },
    { extend: 'excel', text: 'Excel 다운로드' },
    { extend: 'pdf', text: 'PDF 다운로드' },
    { extend: 'print', text: '프린트' }
  ],
  language: {
    search: '검색:',
    searchPlaceholder: '검색어를 입력하세요',
    lengthMenu: '페이지당 _MENU_개씩 보기',
    info: '총 _TOTAL_개 중 _START_부터 _END_까지 표시',
    paginate: {
      first: '처음',
      last: '마지막',
      next: '다음',
      previous: '이전'
    },
    zeroRecords: '일치하는 결과가 없습니다.',
    infoEmpty: '데이터가 없습니다.',
    infoFiltered: '(총 _MAX_개 중 필터링됨)'
  }
});

$('#dataTable tbody').on('click', 'tr', function () {
  const key = $(this).find('td:nth-child(2)').text().trim();
  if (key) {
    window.location.href = `/item/detail?item_key=${key}`;
  }
});
