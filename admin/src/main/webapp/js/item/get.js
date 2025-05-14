$(function () {
  $('#dataTable').DataTable({
    pageLength: 10,
    lengthMenu: [10, 25, 50, 100],
    stateSave: true,
    columnDefs: [
      { orderable: true, targets: 1 },
      { orderable: false, targets: [0, 2, 3] }
    ],
    order: [[1, 'desc']],
    dom:
      '<"d-flex justify-content-between align-items-center flex-wrap mb-2"lf>' +
      't' +
      '<"d-flex justify-content-between align-items-center flex-wrap mt-3 px-1"ip>',

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
});
