<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<style>
    body {
        background-color: #ffffff;
        color: #1d1d1f;
        font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        padding: 2rem;
    }

    h1.page-title {
        font-weight: 700;
        font-size: 2rem;
        margin-bottom: 1.5rem;
        color: #1d1d1f;
    }

    .card {
        background-color: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 20px;
        padding: 2rem;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
    }

    #dataTable {
        border-collapse: separate;
        border-spacing: 0;
        width: 100%;
    }

    #dataTable thead {
        background-color: #f8f8f8;
    }

    #dataTable th {
        font-weight: 600;
        font-size: 0.95rem;
        text-align: center;
        padding: 1rem;
        border-bottom: 1px solid #e0e0e0;
    }

    #dataTable td {
        font-size: 0.95rem;
        padding: 1rem;
        vertical-align: middle;
        text-align: center;
        border-bottom: 1px solid #f0f0f0;
    }

    #dataTable tr:hover {
        background-color: #fafafa;
        transition: background-color 0.2s ease;
    }

    #dataTable img {
        width: 80px;
        height: auto;
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

    .no-image-badge {
        display: inline-block;
        padding: 6px 12px;
        font-size: 13px;
        background-color: #f2f2f2;
        border-radius: 20px;
        color: #999;
        font-weight: 500;
    }

    .price-cell {
        font-weight: 600;
        color: #1d1d1f;
    }

    .font-weight-bold {
        font-weight: 600;
        font-size: 1rem;
    }

    .dataTables_wrapper .pagination .page-item .page-link {
        background-color: transparent;
        color: #1d1d1f;
        border: none;
        font-weight: 500;
    }

    .dataTables_wrapper .pagination .page-item.active .page-link {
        background-color: #1d1d1f;
        color: #fff;
        border-radius: 6px;
    }

    .dataTables_wrapper .pagination .page-item .page-link:hover {
        background-color: #1d1d1f;
        color: #fff;
    }

    .dataTables_wrapper .dataTables_length,
    .dataTables_wrapper .dataTables_info,
    .dataTables_wrapper .dataTables_filter,
    .dataTables_wrapper .dataTables_paginate {
        color: #666;
        font-size: 0.9rem;
    }

    .dataTables_wrapper .dataTables_filter input {
        background-color: #fff;
        border: 1px solid #ccc;
        color: #1d1d1f;
        border-radius: 8px;
        padding: 6px 10px;
    }

    table.dataTable.no-footer {
        border-bottom: none;
    }

    table.dataTable tbody tr:last-child td {
        border-bottom: none;
    }
</style>

<div class="container-fluid">
    <h1 class="page-title">상품 목록</h1>

    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead class="text-center">
                    <tr>
                        <th>이미지</th>
                        <th>상품 번호</th>
                        <th>상품명</th>
                        <th>가격</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${itemlist}">
                        <tr class="text-center align-middle">
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.itemImg1}">
                                        <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}">
                                            <img src="<c:url value='/img/item/${item.itemImg1}'/>">
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="no-image-badge">이미지 없음</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${item.itemKey}</td>
                            <td class="font-weight-bold">${item.itemName}</td>
                            <td><fmt:formatNumber value="${item.itemPrice}" pattern="#,#00"/> 원</td>
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
            dom: 't<"d-flex justify-content-between mt-3 px-1"lip>', // 👈 안내 제거 핵심 옵션
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
