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
$(function () {
    $('#dataTable').DataTable({
        pageLength: 10,
        lengthMenu: [10, 25, 50, 100],
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
});

const cust_get = {
    update: function (id) {
        if (confirm('수정하시겠습니까?')) {
            location.href = '/cust/detail?id=' + encodeURIComponent(id);
        }
    },
    delete: function (id) {
        if (confirm('삭제하시겠습니까?')) {
            location.href = '/cust/delete?id=' + encodeURIComponent(id);
        }
    }
};

