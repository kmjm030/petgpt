$(document).ready(function () {
    var table = $('#totalOrderTable').DataTable({
        order: [[0, 'asc']],
        responsive: true,
        autoWidth: false,
        columnDefs: [
            { orderable: true, targets: 0 },
            { orderable: false, targets: [1, 2, 3, 4, 5, 6] }
        ]
    });

    $('#totalOrderTable tbody').on('click', '.toggle-detail', function () {
        var $tr = $(this).closest('tr');
        var row = table.row($tr);
        var d = $tr.data();

        if (row.child.isShown()) {
            row.child.hide();
            $tr.removeClass('shown');
        } else {
            var fullAddr = (d.orderAddr || '') + (d.orderAddrDetail ? ' ' + d.orderAddrDetail : '') + (d.orderHomecode ? ' (' + d.orderHomecode + ')' : '');
            row.child(
                '<div class="detail-panel p-3">' +
                '<p><strong>배송지 : </strong>' + fullAddr + '</p>' +
                '<p><strong>총금액 : </strong>' + d.totalprice + '원</p>' +
                '<p><strong>요청사항 : </strong>' + d.orderreq + '</p>' +
                '<p><strong>결제수단 : </strong>' + d.paymethod + '</p>' +
                '<p><strong>승인번호 : </strong>' + d.approvalnum + '</p>' +
                '</div>'
            ).show();
            $tr.addClass('shown');
        }
    });

    $('#totalOrderTable tbody').on('click', '.toggle-delete', function () {
        var $tr = $(this).closest('tr');
        var row = table.row($tr);
        if ($tr.hasClass('deleting')) {
            row.child.hide();
            $tr.removeClass('deleting');
        } else {
            var url = $tr.data('delete-url');
            row.child(
                '<div class="confirm-panel p-3">' +
                '<p>정말 삭제하시겠습니까?</p>' +
                '<button type="button" class="btn btn-light btn-sm btn-confirm-delete me-2" data-url="' + url + '">확인</button>' +
                '<button type="button" class="btn btn-secondary btn-sm btn-cancel-delete">취소</button>' +
                '</div>'
            ).show();
            $tr.addClass('deleting');
        }
    });

    $('#totalOrderTable tbody').on('click', '.btn-cancel-delete', function () {
        var $tr = $(this).closest('tr');
        var row = table.row($tr);
        row.child.hide();
        $tr.removeClass('deleting');
    });

    $('#totalOrderTable tbody').on('click', '.btn-confirm-delete', function () {
        window.location.href = $(this).data('url');
    });
});

document.addEventListener('DOMContentLoaded', function () {
    const canvas = document.getElementById('snow-canvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');

    let snowflakes = [];

    function resizeCanvas() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }
    window.addEventListener('resize', resizeCanvas);
    resizeCanvas();

    function createSnowflake() {
        const x = Math.random() * canvas.width;
        const y = Math.random() * -canvas.height;
        const radius = Math.random() * 3 + 1;
        const speed = Math.random() * 1 + 0.5;
        return { x, y, radius, speed };
    }

    function drawSnowflakes() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
        ctx.beginPath();
        snowflakes.forEach(flake => {
            ctx.moveTo(flake.x, flake.y);
            ctx.arc(flake.x, flake.y, flake.radius, 0, Math.PI * 2);
        });
        ctx.fill();
        updateSnowflakes();
        requestAnimationFrame(drawSnowflakes);
    }

    function updateSnowflakes() {
        snowflakes.forEach(flake => {
            flake.y += flake.speed;
            flake.x += Math.sin(flake.y * 0.01);
            if (flake.y > canvas.height) {
                Object.assign(flake, createSnowflake());
                flake.y = 0;
            }
        });
    }

    for (let i = 0; i < 150; i++) {
        snowflakes.push(createSnowflake());
    }

    drawSnowflakes();
});
