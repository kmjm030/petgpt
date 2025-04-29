<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>주문 목록</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.4.1/css/responsive.bootstrap5.min.css">
    <link rel="stylesheet" href="/css/cherry-blossom.css">
    <link rel="stylesheet" href="/css/order.css">
</head>
<body>
<div class="container-fluid py-3">
    <h1>주문 목록</h1>
    <div class="card card-table">
        <div class="card-body">
            <div class="table-responsive">
                <table id="totalOrderTable" class="table table-striped table-hover nowrap align-middle mb-0">
                    <thead>
                    <tr>
                        <th>주문번호</th>
                        <th class="d-lg-table-cell d-md-none d-sm-none">고객 ID</th>
                        <th>상품명</th>
                        <th class="d-lg-table-cell d-md-none d-sm-none">주문일시</th>
                        <th class="d-lg-table-cell d-md-none d-sm-none">수신자</th>
                        <th class="d-lg-table-cell d-md-none d-sm-none">전화번호</th>
                        <th>액션</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${totalorderList}">
                        <tr data-orderkey="${o.orderKey}"
                            data-addrkey="${o.addrKey}"
                            data-orderreq="${o.orderReq}"
                            data-paymethod="${o.orderCard}"
                            data-approvalnum="${o.orderShootNum}"
                            data-delete-url="${pageContext.request.contextPath}/totalorder/delete/${o.orderKey}">
                            <td class="fw-bold text-primary">${o.orderKey}</td>
                            <td class="d-lg-table-cell d-md-none d-sm-none">${o.custId}</td>
                            <td>${itemNameMap[o.itemKey]}</td>
                            <td class="d-lg-table-cell d-md-none d-sm-none">${fn:replace(o.orderDate, 'T', ' ')}</td>
                            <td class="d-lg-table-cell d-md-none d-sm-none">${o.recipientName}</td>
                            <td class="d-lg-table-cell d-md-none d-sm-none">${o.recipientPhone}</td>
                            <td>
                                <div class="action-btns">
                                    <button type="button" class="btn btn-primary btn-sm toggle-detail">상세</button>
                                    <button type="button" class="btn btn-danger btn-sm toggle-delete">삭제</button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.4.1/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.4.1/js/responsive.bootstrap5.min.js"></script>
<script>
    $(document).ready(function() {
        var table = $('#totalOrderTable').DataTable({
            order: [[0, 'asc']],
            responsive: true,
            autoWidth: false,
            columnDefs: [
                { orderable: true, targets: 0 },
                { orderable: false, targets: [1, 2, 3, 4, 5, 6] }
            ]
        });

        $('#totalOrderTable tbody').on('click', '.toggle-detail', function() {
            var $tr = $(this).closest('tr');
            var row = table.row($tr);
            if (row.child.isShown()) {
                row.child.hide();
                $tr.removeClass('shown');
            } else {
                var d = $tr.data();
                row.child('<div class="detail-panel p-3">'
                    + '<p><strong>배송지:</strong> ' + d.addrkey + '</p>'
                    + '<p><strong>요청사항:</strong> ' + d.orderreq + '</p>'
                    + '<p><strong>결제수단:</strong> ' + d.paymethod + '</p>'
                    + '<p><strong>승인번호:</strong> ' + d.approvalnum + '</p>'
                    + '</div>').show();
                $tr.addClass('shown');
            }
        });

        $('#totalOrderTable tbody').on('click', '.toggle-delete', function() {
            var $tr = $(this).closest('tr');
            var row = table.row($tr);
            if ($tr.hasClass('deleting')) {
                row.child.hide();
                $tr.removeClass('deleting');
            } else {
                var url = $tr.data('delete-url');
                row.child('<div class="confirm-panel p-3">'
                    + '<p>정말 삭제하시겠습니까?</p>'
                    + '<button type="button" class="btn btn-light btn-sm btn-confirm-delete me-2" data-url="' + url + '">확인</button>'
                    + '<button type="button" class="btn btn-secondary btn-sm btn-cancel-delete">취소</button>'
                    + '</div>').show();
                $tr.addClass('deleting');
            }
        });

        $('#totalOrderTable tbody').on('click', '.btn-cancel-delete', function() {
            var $tr = $(this).closest('tr');
            var row = table.row($tr);
            row.child.hide();
            $tr.removeClass('deleting');
        });

        $('#totalOrderTable tbody').on('click', '.btn-confirm-delete', function() {
            window.location.href = $(this).data('url');
        });
    });
</script>
</body>
</html>