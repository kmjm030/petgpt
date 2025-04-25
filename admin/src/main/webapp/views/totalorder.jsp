<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>주문 목록 (반응형)</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.4.1/css/responsive.bootstrap5.min.css" />
    <style>
        table { width:100% !important; }
        .align-middle { vertical-align: middle !important; }
        .action-btns { display:flex; gap:0.25rem; }
        div.dataTables_wrapper .dataTables_filter input { width:100%; max-width:200px; }
        div.dataTables_wrapper .dataTables_paginate { margin-top: .5rem; }
    </style>
</head>
<body>
<div class="container-fluid px-2 px-md-4">
    <h1 class="mt-4 mb-3">주문 목록</h1>
    <div class="table-responsive">
        <table id="totalOrderTable" class="table table-striped table-bordered table-hover nowrap align-middle" style="width:100%">
            <thead class="table-light">
            <tr>
                <th>주문번호</th>
                <th>고객 ID</th>
                <th>상품명</th>
                <th>주문일시</th>
                <th>수신자</th>
                <th>전화번호</th>
                <th>액션</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="o" items="${totalorderList}">
                <tr data-orderkey="${o.orderKey}" data-custid="${o.custId}" data-itemkey="${o.itemKey}" data-addrkey="${o.addrKey}" data-orderreq="${o.orderReq}" data-paymethod="${o.orderCard}" data-approvalnum="${o.orderShootNum}">
                    <td>${o.orderKey}</td>
                    <td>${o.custId}</td>
                    <td>${itemNameMap[o.itemKey]}</td>
                    <td>${o.orderDate}</td>
                    <td>${o.recipientName}</td>
                    <td>${o.recipientPhone}</td>
                    <td>
                        <div class="action-btns">
                            <button class="btn btn-sm btn-primary toggle-detail">상세</button>
                            <button class="btn btn-sm btn-danger toggle-delete">삭제</button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/dataTables.responsive/2.4.1/js/dataTables.responsive.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/responsive/2.4.1/js/responsive.bootstrap5.min.js"></script>
<script>
    $(function(){
        var table = $('#totalOrderTable').DataTable({
            order: [[0,'asc']],
            responsive:true,
            autoWidth:false,
            columnDefs:[
                {orderable:true,targets:0},
                {orderable:false,targets:[1,2,3,4,5,6]}
            ]
        });
        $('#totalOrderTable').on('click','.toggle-detail',function(){
            var tr=$(this).closest('tr'),row=table.row(tr);
            if(row.child.isShown()){ row.child.hide();tr.removeClass('shown'); }
            else{
                var detailHtml='<div class="card card-body mt-2">'
                    +'<p><strong>배송지:</strong>'+tr.data('addrkey')+'</p>'
                    +'<p><strong>요청사항:</strong>'+tr.data('orderreq')+'</p>'
                    +'<p><strong>결제수단:</strong>'+tr.data('paymethod')+'</p>'
                    +'<p><strong>승인번호:</strong>'+tr.data('approvalnum')+'</p>'
                    +'</div>';
                row.child(detailHtml).show();tr.addClass('shown');
            }
        });
        $('#totalOrderTable').on('click','.toggle-delete',function(){
            var tr=$(this).closest('tr'),row=table.row(tr);
            if(row.child.isShown()&&tr.hasClass('deleting')){ row.child.hide();tr.removeClass('deleting'); }
            else{
                var delHtml='<div class="card card-body mt-2">'
                    +'<p>정말 삭제하시겠습니까?</p>'
                    +'<a href="'+tr.data('delete-url')+'" class="btn btn-sm btn-danger me-2">삭제</a>'
                    +'<button class="btn btn-sm btn-secondary btn-cancel">취소</button>'
                    +'</div>';
                row.child(delHtml).show();tr.addClass('deleting');
            }
        });
        $('#totalOrderTable').on('click','.btn-cancel',function(){
            var tr=$(this).closest('tr'),row=table.row(tr);
            row.child.hide();tr.removeClass('deleting');
        });
    });
</script>
</body>
</html>