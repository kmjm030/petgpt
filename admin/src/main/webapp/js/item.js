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

        if (confirm('등록하시겠습니까?')) {
            form.attr({
                method: 'post',
                enctype: 'multipart/form-data',
                action: '/item/addimpl'
            }).submit();
        }
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
        if (confirm('정말로 이 상품을 삭제하시겠습니까?')) {
            location.href = `/item/del?item_key=${key}`;
        }
    });


    $('#btn_update').click(() => {
        if (confirm('이 상품 정보를 수정하시겠습니까?')) {
            $('#item_update_form').attr({
                method: 'post',
                enctype: 'multipart/form-data',
                action: '/item/update'
            }).submit();
        }
    });
});

$('#dataTable').DataTable({
  pageLength: 10,
  lengthMenu: [10, 25, 50, 100],
  columnDefs: [
    { orderable: true, targets: 1 },
    { orderable: false, targets: [0, 2, 3] }
  ],
  order: [[1, 'desc']],
  dom: 'f t<"d-flex justify-content-between mt-3 px-1"lip>',
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


