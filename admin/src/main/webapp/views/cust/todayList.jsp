<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>오늘 가입한 회원</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/cherry-blossom.css">
    <link rel="stylesheet" href="/css/cust.css">
</head>
<body>
<div class="container py-4">
    <h1 class="page-title mb-4">오늘 가입한 회원 목록</h1>
    <div class="card p-4 shadow-sm">
        <c:choose>
            <c:when test="${not empty todayJoinedList}">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered mb-0">
                        <thead class="thead-light">
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
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-data">오늘 가입한 회원이 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
