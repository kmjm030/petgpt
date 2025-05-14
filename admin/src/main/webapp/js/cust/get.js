$(function () {
  const table = $('#dataTable').DataTable({
    pageLength: 10,
    lengthMenu: [10, 25, 50, 100],
    ordering: false,
    dom: 't<"d-flex justify-content-between mt-3 px-1"lip>',
    language: {
      search: '검색:',
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

  $.fn.dataTable.ext.search.push(function (settings, data, dataIndex) {
    const min = parseInt($('#filterMinPoint').val(), 10);
    const max = parseInt($('#filterMaxPoint').val(), 10);
    const point = parseInt(data[6]) || 0;

    if ((isNaN(min) || point >= min) && (isNaN(max) || point <= max)) {
      return true;
    }
    return false;
  });

  $('#filterName').on('keyup', function () {
    table.column(2).search(this.value).draw();
  });

  $('#filterEmail').on('keyup', function () {
    table.column(3).search(this.value).draw();
  });

  $('#filterMinPoint, #filterMaxPoint').on('input', function () {
    table.draw();
  });
});

const cust_get = {
  delete: function (id) {
    const check = prompt('정말 삭제하시려면 "삭제"를 입력하세요.');
    if (check === '삭제') {
      location.href = '/cust/delete?id=' + encodeURIComponent(id);
    } else {
      alert('삭제가 취소되었습니다.');
    }
  }
};

function downloadExcel() {
  const table = document.getElementById("dataTable");
  const workbook = XLSX.utils.table_to_book(table, { sheet: "고객목록" });
  XLSX.writeFile(workbook, "customers.xlsx");
}
