<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>주문 상세 목록</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <!-- DataTables CSS with Bootstrap -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" />
    <!-- FontAwesome & Custom Styles -->
    <link href="<c:url value='/vendor/fontawesome-free/css/all.min.css'/>" rel="stylesheet" />
    <link href="<c:url value='/css/sb-admin-2.min.css'/>" rel="stylesheet" />
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-body">
            <h2 class="card-title mb-4">주문 상세 목록</h2>
            <table id="orderDetailTable" class="table table-bordered table-hover">
                <thead class="table-light">
                <tr>
                    <th>이미지</th>
                    <th>주문ID</th>
                    <th>수량</th>
                    <th>가격</th>
                    <th>액션</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="orderdetail" items="${orderDetails}">
                    <tr>
                        <td>
                            <img src="<c:url value='/img/item/${orderdetail.itemKey}.jpg'/>" alt="상품" class="img-thumbnail" style="width:50px; height:50px;" />
                        </td>
                        <td>${orderdetail.orderKey}</td>
                        <td>${orderdetail.orderDetailCount}</td>
                        <td><fmt:formatNumber value="${orderdetail.orderDetailPrice}" type="currency" currencySymbol="₩" /></td>
                        <td>
                            <button class="btn btn-sm btn-primary me-1" type="button" data-bs-toggle="collapse" data-bs-target="#detail${orderdetail.orderDetailKey}">상세보기</button>
                            <a href="<c:url value='/orderdetail/delete/${orderdetail.orderDetailKey}'/>" class="btn btn-sm btn-danger" onclick="return confirm('정말 삭제할까요?');">삭제</a>
                            <div class="collapse mt-2" id="detail${orderdetail.orderDetailKey}">
                                <div class="card mt-2">
                                    <div class="card-body p-3">
                                        <h6>주문 상세 (ID: ${orderdetail.orderDetailKey})</h6>
                                        <ul class="list-unstyled mb-0">
                                            <li><strong>상품 키:</strong> ${orderdetail.itemKey}</li>
                                            <li><strong>옵션 키:</strong>
                                                <c:choose>
                                                    <c:when test="${orderdetail.optionKey != null}">${orderdetail.optionKey}</c:when>
                                                    <c:otherwise>없음</c:otherwise>
                                                </c:choose>
                                            </li>
                                            <li><strong>주문 키:</strong> ${orderdetail.orderKey}</li>
                                            <li><strong>단가:</strong> <fmt:formatNumber value="${orderdetail.orderDetailPrice}" type="currency" currencySymbol="₩" /></li>
                                            <li><strong>수량:</strong> ${orderdetail.orderDetailCount}</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- jQuery, Bootstrap JS, DataTables JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function () {
        $('#orderDetailTable').DataTable({
            columnDefs: [
                { orderable: true, targets: 1 },
                { orderable: false, targets: '_all' }
            ]
        });
    });
</script>
</body>
</html>
