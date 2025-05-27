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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" />
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.4.1/css/responsive.bootstrap5.min.css" />
    <link rel="stylesheet" href="/css/order/totalorder.css" />
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
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${totalorderList}">
                        <tr
                                data-orderkey="${o.orderKey}"
                                data-order-addr="${o.orderAddr}"
                                data-order-addr-detail="${o.orderAddrdetail}"
                                data-order-homecode="${o.orderHomecode}"
                                data-orderreq="${o.orderReq}"
                                data-paymethod="${o.orderCard}"
                                data-approvalnum="${o.orderShootNum}"
                                data-totalprice="<fmt:formatNumber value='${o.orderTotalPrice}' type='number' groupingUsed='true'/>"
                                data-delete-url="${pageContext.request.contextPath}/totalorder/delete/${o.orderKey}"
                        >
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
<script src="/js/order/totalorder.js"></script>
<canvas id="snow-canvas"></canvas>
</body>
</html>
