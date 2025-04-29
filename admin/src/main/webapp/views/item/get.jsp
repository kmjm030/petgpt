<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>
<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/item.css">

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
                                <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}" style="color: inherit; text-decoration: none;">
                                        ${item.itemName}
                                </a>
                            </td>
                            <td class="price-cell">
                                <fmt:formatNumber value="${item.itemPrice}" pattern="#,##0"/> 원
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
    $(function () {
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
