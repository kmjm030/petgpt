<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>주문 목록</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.4.1/css/responsive.bootstrap5.min.css" />
    <!-- Inline Custom Styles -->
    <style>
        :root {
            --primary-color: #e91e63;
            --secondary-color: #ffd6e8;
            --bg-color: #ffeaf0;
            --text-color: #4a4a4a;
            --card-bg: #ffffff;
            --card-border: #f8c1de;
            --shadow-color: rgba(233,30,99,0.1);
            --hover-bg: #fff0f6;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            background: var(--bg-color);
            font-family: 'Noto Sans KR', sans-serif;
            color: var(--text-color);
            line-height:1.6;
        }
        h1 {
            font-size:2rem;
            color:var(--primary-color);
            text-align:center;
            margin:1.5rem 0;
        }
        .card-table {
            background:var(--card-bg);
            border:1px solid var(--card-border);
            border-radius:12px;
            box-shadow:0 4px 12px var(--shadow-color);
            margin:0 auto 2rem;
            padding:1rem;
            max-width:1200px;
        }
        table { width:100%; border-collapse:collapse; }
        thead { background:var(--secondary-color); }
        thead th {
            color:var(--primary-color);
            font-weight:600;
            border-bottom:2px solid var(--card-border);
            padding:0.75rem;
            text-align:left;
        }
        tbody td {
            padding:0.75rem;
            vertical-align:middle;
        }
        tbody tr:hover { background:var(--hover-bg); }
        .action-btns { display:flex; flex-wrap:wrap; gap:0.5rem; }
        .btn { border-radius:20px; font-size:0.9rem; padding:0.4rem 0.8rem; }
        .btn-primary {
            background:var(--primary-color);
            border:1px solid var(--primary-color);
            color:#fff;
        }
        .btn-primary:hover {
            background:#d81b60; border-color:#d81b60;
        }
        .btn-danger {
            background:#ff80ab; border:1px solid #ff80ab; color:#fff;
        }
        .btn-danger:hover {
            background:#ff4081; border-color:#ff4081;
        }
        @media (max-width:992px) {
            .d-lg-table-cell { display:none !important; }
        }
        @media (max-width:768px) {
            .d-md-table-cell { display:none !important; }
        }
        @media (max-width:576px) {
            table, thead, tbody, th, td, tr { display:block; }
            thead tr { position:absolute; top:-9999px; left:-9999px; }
            tr { margin:0 0 1rem 0; }
            td {
                border:none;
                position:relative;
                padding-left:50%;
                text-align:left;
            }
            td:before {
                position:absolute;
                top:0;
                left:0;
                width:45%;
                padding-left:1rem;
                white-space:nowrap;
                font-weight:600;
            }
            td:nth-of-type(1):before { content: "주문번호"; }
            td:nth-of-type(2):before { content: "고객 ID"; }
            td:nth-of-type(3):before { content: "상품명"; }
            td:nth-of-type(4):before { content: "주문일시"; }
            td:nth-of-type(5):before { content: "수신자"; }
            td:nth-of-type(6):before { content: "전화번호"; }
            td:nth-of-type(7):before { content: "액션"; }
        }
        .detail-panel,
        .confirm-panel {
            background:var(--card-bg);
            border:1px solid var(--card-border);
            border-radius:8px;
            box-shadow:0 2px 8px var(--shadow-color);
            margin-top:0.5rem;
            padding:1rem;
        }
    </style>
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

<!-- JS Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.4.1/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.4.1/js/responsive.bootstrap5.min.js"></script>
<script>
    $(document).ready(function() {
        var table = $('#totalOrderTable').DataTable({
            order:[[0,'asc']], responsive:true, autoWidth:false,
            columnDefs:[{orderable:true,targets:0},{orderable:false,targets:[1,2,3,4,5,6]}]
        });
        $('#totalOrderTable tbody').on('click','.toggle-detail',function(){
            var $tr=$(this).closest('tr'),row=table.row($tr);
            if(row.child.isShown()){row.child.hide();$tr.removeClass('shown');}
            else{var d=$tr.data();row.child(
                '<div class="detail-panel p-3">'
                +'<p><strong>배송지:</strong>'+d.addrkey+'</p>'
                +'<p><strong>요청사항:</strong>'+d.orderreq+'</p>'
                +'<p><strong>결제수단:</strong>'+d.paymethod+'</p>'
                +'<p><strong>승인번호:</strong>'+d.approvalnum+'</p>'
                +'</div>'
            ).show();$tr.addClass('shown');}
        });
        // 삭제 확인 패널 토글
        $('#totalOrderTable tbody').on('click', '.toggle-delete', function() {
            var $tr = $(this).closest('tr'),
                row = table.row($tr);

            if ($tr.hasClass('deleting')) {
                row.child.hide();
                $tr.removeClass('deleting');
            } else {
                var url = $tr.data('delete-url');
                row.child(
                    '<div class="confirm-panel p-3">'
                    + '<p>정말 삭제하시겠습니까?</p>'
                    + '<button type="button" class="btn btn-danger btn-sm btn-confirm-delete me-2" data-url="' + url + '">확인</button>'
                    + '<button type="button" class="btn btn-secondary btn-sm btn-cancel-delete">취소</button>'
                    + '</div>'
                ).show();
                $tr.addClass('deleting');
            }
        });

// 삭제 취소 버튼 클릭 시 이벤트 처리
        $('#totalOrderTable tbody').on('click', '.btn-cancel-delete', function() {
            var $tr = $(this).closest('tr').prev('tr');
            table.row($tr).child.hide();
            $tr.removeClass('deleting');
        });

// 삭제 확인 버튼 클릭 시 AJAX로 삭제 요청 처리
        $('#totalOrderTable tbody').on('click', '.btn-confirm-delete', function() {
            var url = $(this).data('url');

            if (!url) {
                alert("삭제할 URL이 설정되지 않았습니다.");
                return;
            }

            if (!confirm("정말 삭제하시겠습니까?")) {
                return;
            }

            $.ajax({
                url: url,
                type: 'POST',
                success: function(response) {
                    alert('주문이 성공적으로 삭제되었습니다.');
                    location.reload();  // 삭제 후 새로고침
                },
                error: function(xhr, status, error) {
                    alert('삭제 중 오류가 발생했습니다.');
                    console.error(error);
                }
            });
        });
    });
</script>
</body>
</html>
