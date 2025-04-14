<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<style>
    #dataTable img {
        width: 80px;
        height: auto;
        border-radius: 8px;
        border: 1px solid #ccc;
    }

    #dataTable a {
        text-decoration: none;
        color: inherit;
    }

    .no-image-badge {
        display: inline-block;
        padding: 5px 10px;
        font-size: 12px;
        background-color: #e0e0e0;
        border-radius: 5px;
        color: #666;
    }
</style>

<div class="container-fluid">

    <h1 class="h3 mb-3 text-gray-800">상품 목록</h1>
    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead class="thead-light text-center">
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
                                <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}">
                                    <c:choose>
                                        <c:when test="${not empty item.itemImg1}">
                                            <img src="<c:url value='/img/item/${item.itemImg1}'/>">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-image-badge">이미지 없음</span>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </td>
                            <td>${item.itemKey}</td>
                            <td class="font-weight-bold">${item.itemName}</td>
                            <td>
                                <fmt:formatNumber value="${item.itemPrice}" pattern="#,###"/>원
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
            columnDefs: [
                { orderable: true, targets: 1 },
                { orderable: false, targets: [0, 2, 3] }
            ],
            order: [[1, "asc"]],
            language: {
                search: "검색:",
                lengthMenu: "페이지당 _MENU_개 보기",
                info: "총 _TOTAL_개 중 _START_부터 _END_까지 표시",
                paginate: {
                    first: "처음",
                    last: "마지막",
                    next: "다음",
                    previous: "이전"
                },
                zeroRecords: "일치하는 항목이 없습니다.",
            }
        });
    });
</script>





