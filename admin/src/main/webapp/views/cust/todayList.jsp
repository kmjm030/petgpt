<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>오늘 가입한 회원</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>오늘 가입한 회원 목록</h2>
    <table class="table table-bordered">
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
            <tr>
                <td>${cust.custId}</td>
                <td>${cust.custName}</td>
                <td>${cust.custEmail}</td>
                <td>${cust.custRdate}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty todayJoinedList}">
            <tr>
                <td colspan="4">오늘 가입한 회원이 없습니다.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>
