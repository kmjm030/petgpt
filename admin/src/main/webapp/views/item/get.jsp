<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<style>
    body {
        background-color: #fff;
        color: #1d1d1f;
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        padding: 2rem;
    }
    .page-title {
        font-weight: 700;
        font-size: 2rem;
        margin-bottom: 1.5rem;
    }
    .card {
        background-color: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 20px;
        padding: 2rem;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
    }
    #dataTable {
        width: 100%;
        border-collapse: collapse;
    }
    #dataTable thead {
        background-color: #f0f0f0;
    }
    #dataTable th,
    #dataTable td {
        text-align: center;
        padding: 1rem;
        font-size: 0.95rem;
        border-bottom: 1px solid #e0e0e0;
        vertical-align: middle;
    }
    #dataTable thead th {
        font-weight: 600;
        color: #1d1d1f;
    }
    #dataTable tr:hover {
        background-color: #fafafa;
        transition: background-color 0.2s ease;
    }
    #dataTable img {
        width: 80px;
        border-radius: 12px;
        border: 1px solid #ccc;
        filter: grayscale(10%);
        transition: all 0.2s ease;
    }
    #dataTable img:hover {
        filter: none;
        transform: scale(1.04);
        border-color: #1d1d1f;
    }
    .img-thumb {
        width: 80px;
        height: 80px;
        border-radius: 12px;
        border: 1px solid #ccc;
        background-color: #f8f9fa;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        color: #888;
    }
    .font-weight-bold {
        font-weight: 600;
        font-size: 1rem;
    }
    .price-cell {
        font-weight: 600;
        color: #1d1d1f;
        font-size: 1rem;
        letter-spacing: -0.2px;
    }
    .dataTables_wrapper .pagination .page-item .page-link {
        background-color: transparent;
        color: #1d1d1f;
        border: none;
        font-weight: 500;
    }
    .dataTables_wrapper .pagination .page-item.active .page-link,
    .dataTables_wrapper .pagination .page-item .page-link:hover {
        background-color: #1d1d1f;
        color: #fff;
        border-radius: 6px;
    }
    .dataTables_wrapper .dataTables_length,
    .dataTables_wrapper .dataTables_info,
    .dataTables_wrapper .dataTables_filter,
    .dataTables_wrapper .dataTables_paginate {
        font-size: 0.9rem;
        color: #666;
    }
    .dataTables_wrapper .dataTables_filter input {
        background-color: #fff;
        border: 1px solid #ccc;
        border-radius: 8px;
        padding: 6px 10px;
        color: #1d1d1f;
    }
    table.dataTable.no-footer,
    table.dataTable tbody tr:last-child td {
        border-bottom: none;
    }

    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }
    body.dark-mode .card,
    body.dark-mode .img-thumb {
        background-color: #2c2c2e;
        color: #f5f5f7;
        border-color: #3a3a3c;
    }
    body.dark-mode #dataTable th,
    body.dark-mode #dataTable td {
        background-color: #2c2c2e;
        color: #f5f5f7;
        border-color: #3a3a3c;
    }
    body.dark-mode #dataTable thead th {
        background-color: #3a3a3c;
        color: #f5f5f7;
    }
    body.dark-mode .dataTables_wrapper .dataTables_filter input,
    body.dark-mode .dataTables_wrapper .dataTables_length select {
        background-color: #2c2c2e;
        border: 1px solid #3a3a3c;
        color: #f5f5f7;
    }
    body.dark-mode .dataTables_wrapper .dataTables_info,
    body.dark-mode .dataTables_wrapper .dataTables_length,
    body.dark-mode .dataTables_wrapper .dataTables_filter label,
    body.dark-mode .dataTables_wrapper .dataTables_paginate {
        color: #ccc;
    }
    body.dark-mode a {
        color: #58a6ff;
    }
</style>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="page-title mb-0">상품 목록</h1>
        <a href="<c:url value='/item/add'/>" class="btn btn-dark shadow-sm px-4 py-2 rounded-pill">
            <i class="bi bi-plus-circle me-1"></i> 상품 추가
        </a>
    </div>

    <div class="card">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover table-bordered" id="dataTable">
                    <thead>
                    <tr>
                        <th>이미지</th>
                        <th>상품 번호</th>
                        <th>상품명</th>
                        <th>가격</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${itemlist}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.itemImg1}">
                                        <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}">
                                            <img src="<c:url value='/img/item/${item.itemImg1}'/>" alt="상품 이미지">
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="img-thumb">
                                            <i class="bi bi-image"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${item.itemKey}</td>
                            <td class="font-weight-bold">
                                <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}" style="color:inherit; text-decoration:none;">
                                        ${item.itemName}
                                </a>
                            </td>
                            <td class="price-cell">
                                <fmt:formatNumber value="${item.itemPrice}" pattern="#,#00"/> 원
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#dataTable').DataTable({
            pageLength: 10,
            lengthMenu: [10, 25, 50, 100],
            columnDefs: [
                { orderable: true, targets: 1 },
                { orderable: false, targets: [0, 2, 3] }
            ],
            order: [[1, 'desc']],
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
</script>