$(document).ready(function () {
    const table = $('#totalOrderTable').DataTable({
        order: [[0, 'asc']],
        responsive: true,
        autoWidth: false,
        columnDefs: [
            { orderable: true, targets: 0 },
            { orderable: false, targets: [1, 2, 3, 4, 5, 6] }
        ]
    });

    $('#totalOrderTable tbody').on('click', '.toggle-detail', function () {
        const $tr = $(this).closest('tr');
        const row = table.row($tr);

        if (row.child.isShown()) {
            row.child.hide();
            $tr.removeClass('shown');
        } else {
            const d = $tr.data();
            row.child(`
        <div class="detail-panel p-3">
          <p><strong>배송지:</strong> ${d.addrkey}</p>
          <p><strong>요청사항:</strong> ${d.orderreq}</p>
          <p><strong>결제수단:</strong> ${d.paymethod}</p>
          <p><strong>승인번호:</strong> ${d.approvalnum}</p>
        </div>
      `).show();
            $tr.addClass('shown');
        }
    });

    $('#totalOrderTable tbody').on('click', '.toggle-delete', function () {
        const $tr = $(this).closest('tr');
        const row = table.row($tr);

        if ($tr.hasClass('deleting')) {
            row.child.hide();
            $tr.removeClass('deleting');
        } else {
            const url = $tr.data('delete-url');
            row.child(`
        <div class="confirm-panel p-3">
          <p>정말 삭제하시겠습니까?</p>
          <button type="button" class="btn btn-light btn-sm btn-confirm-delete me-2" data-url="${url}">확인</button>
          <button type="button" class="btn btn-secondary btn-sm btn-cancel-delete">취소</button>
        </div>
      `).show();
            $tr.addClass('deleting');
        }
    });

    $('#totalOrderTable tbody').on('click', '.btn-cancel-delete', function () {
        const $tr = $(this).closest('tr');
        const row = table.row($tr);
        row.child.hide();
        $tr.removeClass('deleting');
    });

    $('#totalOrderTable tbody').on('click', '.btn-confirm-delete', function () {
        window.location.href = $(this).data('url');
    });
});
