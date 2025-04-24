<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>주문 상세 목록</title>

    <!-- DataTables + jQuery -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>

    <style>
        body {
            font-family: "Pretendard", sans-serif;
            background-color: #f9f9f9;
            color: #1d1d1f;
        }
        body.dark-mode {
            background-color: #1d1d1f;
            color: #f5f5f7;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            width: 90%;
            max-width: 1000px;
            margin: 40px auto;
        }
        body.dark-mode .container {
            background: #2c2c2e;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
        }
        h2 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        table img {
            width: 50px;
            height: 50px;
            object-fit: cover;
        }
        .action-buttons button {
            padding: 4px 8px;
            font-size: 12px;
            margin: 0 2px;
        }
        body.dark-mode table.dataTable {
            color: #f5f5f7;
            background-color: #2c2c2e;
        }
        body.dark-mode table.dataTable th {
            background-color: #3a3a3c;
            color: #f5f5f7;
        }
        body.dark-mode table.dataTable td {
            background-color: #2c2c2e;
            color: #f5f5f7;
        }
    </style>

    <script>
        $(document).ready(function () {
            $('#orderDetailTable').DataTable({
                "columnDefs": [
                    { "orderable": true, "targets": [1] },     // 주문ID만 정렬 허용
                    { "orderable": false, "targets": "_all" }  // 나머지 정렬 비활성화
                ]
            });
        });
    </script>
</head>
<body>
<div class="container">
    <h2>주문 상세 목록</h2>

    <table id="orderDetailTable" class="display">
        <thead>
        <tr>
            <th>이미지</th>
            <th>주문ID</th>
            <th>수량</th>
            <th>가격</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="orderdetail" items="${orderDetails}">
            <tr>
                <td><img src="/img/item/${orderdetail.itemKey}.jpg" onerror="this.src='/img/noimage.png'" /></td>
                <td>${orderdetail.orderKey}</td>
                <td>${orderdetail.orderDetailCount}</td>
                <td><fmt:formatNumber value="${orderdetail.orderDetailPrice}" type="currency" currencySymbol="₩" /></td>
                <td>
                    <div style="display: flex; gap: 6px; justify-content: center;">
                        <a href="/orderdetail/view/${orderdetail.orderDetailKey}">
                            <button style="padding: 4px 10px; font-size: 13px; border: 1px solid #007bff; background: white; color: #007bff; border-radius: 4px; cursor: pointer;">
                                상세
                            </button>
                        </a>
                        <a href="/orderdetail/delete/${orderdetail.orderDetailKey}" onclick="return confirm('정말 삭제할까요?')">
                            <button style="padding: 4px 10px; font-size: 13px; border: 1px solid #dc3545; background: white; color: #dc3545; border-radius: 4px; cursor: pointer;">
                                삭제
                            </button>
                        </a>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
