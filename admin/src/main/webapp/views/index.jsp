<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>PetGPT 관리자 페이지</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;600&display=swap" rel="stylesheet">
    <link href="<c:url value='/vendor/fontawesome-free/css/all.min.css'/>" rel="stylesheet">
    <link href="<c:url value='/css/sb-admin-2.min.css'/>" rel="stylesheet">
    <link href="<c:url value='/css/darkmode.css'/>" rel="stylesheet">
    <link href="<c:url value='/css/index.css'/>" rel="stylesheet">
</head>

<body id="page-top">

<c:if test="${not empty sessionScope.admin}">
    <div id="admin-info-bar">
        <span class="admin-name">
            <i class="fas fa-user-circle"></i> ${sessionScope.admin.adminName} 님
        </span>
        <a href="<c:url value='/logoutimpl'/>" onclick="sessionStorage.clear();">로그아웃</a>
        <button id="darkModeToggle" title="다크모드 토글"
                style="background:none; border:none; font-size:1.2rem; cursor:pointer;">🌙</button>
    </div>

    <div id="welcome-overlay">
        <div class="welcome-box">
            <div class="welcome-text">
                <span>${sessionScope.admin.adminName}님, 환영합니다 !</span>
            </div>
        </div>
    </div>
</c:if>

<div id="hover-sidebar" class="hover-sidebar">
    <div class="sidebar-content">
        <div class="logo">
            <img src="<c:url value='/img/logo.png'/>" class="custom-logo" alt="로고">
        </div>
        <a href="<c:url value='/'/>"><i class="fas fa-tachometer-alt"></i> 메인화면</a>
        <a href="<c:url value='/cust/get'/>"><i class="fas fa-users"></i> 사용자 관리</a>
        <a href="<c:url value='/item/get'/>"><i class="fas fa-box"></i> 상품 관리</a>
        <a href="<c:url value='/totalorder'/>"><i class="fas fa-shopping-cart"></i> 주문 관리</a>
        <a href="<c:url value='/qnaboard/get'/>"><i class="fas fa-comment-dots"></i> 상품 문의글</a>
        <a href="<c:url value='/ws'/>"><i class="fas fa-comments"></i> 채팅</a>
        <a href="<c:url value='/admin/notice/get'/>"><i class="fas fa-bullhorn"></i> 관리자 공지사항</a>
    </div>
</div>

<c:choose>
    <c:when test="${center == null}">
        <jsp:include page="center.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="${center}.jsp" />
    </c:otherwise>
</c:choose>

<script src="<c:url value='/js/index.js'/>"></script>

</body>
</html>
