<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>오늘 가입한 회원</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <style>
        body {
            padding: 2rem;
            background-color: #f5f5f7;
            color: #1d1d1f;
            font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        .title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 2rem;
        }

        .card {
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            border: none;
            background-color: #fff;
            overflow: hidden;
        }

        .table thead th {
            background-color: #f0f0f5;
            color: #555;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.05rem;
        }

        .table td {
            vertical-align: middle;
            font-size: 0.95rem;
        }

        .no-data {
            text-align: center;
            padding: 2rem;
            color: #6e6e73;
            font-style: italic;
        }

        tr.clickable-row {
            cursor: pointer;
            transition: background-color 0.2s ease-in-out;
        }

        tr.clickable-row:hover {
            background-color: #eef3ff;
        }

        body.dark-mode {
            background-color: #1d1d1f;
            color: #f5f5f7;
        }

        body.dark-mode .card {
            background-color: #2c2c2e;
            color: #f5f5f7;
            border: 1px solid #3a3a3c;
        }

        body.dark-mode .table thead th {
            background-color: #3a3a3c;
            color: #e0e0e0;
        }

        body.dark-mode .table td {
            background-color: #2c2c2e;
            color: #f5f5f7;
        }

        body.dark-mode tr.clickable-row:hover {
            background-color: #3c3c3e;
        }

        body.dark-mode .no-data {
            color: #aaa;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="title">오늘 가입한 회원 목록</div>
    <div class="card p-3">
        <c:choose>
            <c:when test="${not empty todayJoinedList}">
                <table class="table table-hover mb-0">
                    <thead>
                    <tr>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>가입일</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="cust" items="${todayJoinedList}">
                        <tr class="clickable-row" onclick="location.href='<c:url value='/cust/detail'/>?id=${cust.custId}'">
                            <td>${cust.custId}</td>
                            <td>${cust.custName}</td>
                            <td>${cust.custEmail}</td>
                            <td>${cust.custRdate}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-data">오늘 가입한 회원이 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>