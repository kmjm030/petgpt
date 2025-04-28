<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<style>
    body {
        background-color: #f5f5f7;
        color: #1d1d1f;
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        padding: 2rem;
    }

    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }

    h1 {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
    }

    .card {
        background-color: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 20px;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
        padding: 2rem;
    }

    body.dark-mode .card {
        background-color: #2c2c2e;
        border-color: #3a3a3c;
    }

    .card-header h6 {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 1rem;
    }

    .table {
        width: 100%;
        font-size: 0.95rem;
        border-collapse: collapse;
    }

    .table thead th {
        background-color: #f9f9fa;
        color: #6e6e73;
        font-weight: 600;
        font-size: 0.8rem;
        padding: 0.75rem;
        text-align: center;
    }

    body.dark-mode .table thead th {
        background-color: #3a3a3c;
        color: #f5f5f7;
    }

    .table td {
        padding: 0.75rem;
        border-bottom: 1px solid #e0e0e0;
        text-align: center;
        vertical-align: middle;
    }

    body.dark-mode .table td {
        border-bottom: 1px solid #3a3a3c;
        color: #f5f5f7;
    }

    .table tbody tr:hover {
        background-color: #f0f0f5;
    }

    body.dark-mode .table tbody tr:hover {
        background-color: #3c3c3e;
    }

    .btn-secondary {
        background-color: #1d1d1f;
        color: #fff;
        border: none;
        border-radius: 12px;
        padding: 0.4rem 1rem;
        font-size: 0.85rem;
        font-weight: 600;
    }

    .btn-secondary:hover {
        background-color: #333;
    }

    a {
        color: inherit;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
        opacity: 0.8;
    }

    body.dark-mode a {
        color: #58a6ff;
    }
</style>

<script>
    const cust_get = {
        update: function (id) {
            if (confirm('수정하시겠습니까?')) {
                location.href = '<c:url value="/cust/detail"/>' + '?id=' + id;
            }
        },
        delete: function (id) {
            if (confirm('삭제하시겠습니까?')) {
                location.href = '<c:url value="/cust/delete"/>' + '?id=' + id;
            }
        }
    };
</script>

<div class="container-fluid">
    <h1>고객 정보 테이블</h1>
    <div class="card">
        <div class="card-header">
            <h6>고객 전체 정보 목록</h6>
        </div>
        <div class="table-responsive">
            <table class="table" id="dataTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>PWD</th>
                    <th>NAME</th>
                    <th>EMAIL</th>
                    <th>PHONE</th>
                    <th>가입일</th>
                    <th>포인트</th>
                    <th>별명</th>
                    <th>적립량</th>
                    <th>사유</th>
                    <th></th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${custs}">
                    <tr>
                        <td><a href="<c:url value='/cust/detail'/>?id=${c.custId}">${c.custId}</a></td>
                        <td>${c.custPwd}</td>
                        <td>${c.custName}</td>
                        <td>${c.custEmail}</td>
                        <td>${c.custPhone}</td>
                        <td>${c.custRdate}</td>
                        <td>${c.custPoint}</td>
                        <td>${c.custNick}</td>
                        <td>${c.pointCharge}</td>
                        <td>${c.pointReason}</td>
                        <td><button onclick="cust_get.update('${c.custId}')" class="btn-secondary">수정</button></td>
                        <td><button onclick="cust_get.delete('${c.custId}')" class="btn-secondary">삭제</button></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
