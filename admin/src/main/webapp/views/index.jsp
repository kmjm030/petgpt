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
    <link href="<c:url value='/css/dark-mode.css'/>" rel="stylesheet">

    <style>
        body {
            background-color: #f5f5f7;
            color: #1d1d1f;
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            padding-top: 60px !important;
        }

        #admin-info-bar {
            position: fixed;
            top: 0;
            right: 0;
            padding: 10px 20px;
            background-color: #ffffff;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            z-index: 9999;
            display: flex;
            align-items: center;
            gap: 14px;
            border-bottom-left-radius: 14px;
            height: 60px;
        }

        #admin-info-bar .admin-name {
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        #admin-info-bar a {
            background-color: #1d1d1f;
            color: white;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 0.85rem;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.2s ease;
        }

        #admin-info-bar a:hover {
            background-color: #333333;
        }

        #welcome-overlay {
            position: fixed;
            z-index: 9998;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #f5f5f7;
            display: flex;
            align-items: center;
            justify-content: center;
            animation: fadeOut 1s ease 2.5s forwards;
        }

        .welcome-box {
            text-align: center;
            font-size: 1.6rem;
            font-weight: 600;
            color: #1d1d1f;
            opacity: 0;
            animation: fadeIn 1s ease-in-out 0.5s forwards;
        }

        @keyframes fadeIn {
            to { opacity: 1; }
        }

        @keyframes fadeOut {
            to {
                opacity: 0;
                visibility: hidden;
            }
        }

        .hover-sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 220px;
            height: 100%;
            background-color: #ffffff;
            border-right: 1px solid #d2d2d7;
            transform: translateX(-100%);
            transition: transform 0.3s ease-in-out;
            z-index: 9997;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        }

        .hover-sidebar .sidebar-content {
            padding: 2rem 1rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .hover-sidebar a {
            color: #1d1d1f;
            text-decoration: none;
            font-size: 1rem;
            transition: all 0.2s ease;
        }

        .hover-sidebar a:hover {
            color: #0071e3;
        }

        .hover-sidebar .logo {
            margin-bottom: 2rem;
            text-align: center;
        }

        .hover-sidebar .logo img {
            width: 80px;
        }

        .custom-logo {
            max-width: 120px;
            margin-right: 20px;
        }
    </style>
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
        <a href="<c:url value='/'/>"><i class="fas fa-tachometer-alt"></i> 대시보드</a>
        <a href="<c:url value='/cust/get'/>"><i class="fas fa-users"></i> 사용자 관리</a>
        <a href="<c:url value='/item/get'/>"><i class="fas fa-box"></i> 상품 관리</a>
        <a href="<c:url value='/orderdetail'/>"><i class="fas fa-shopping-cart"></i> 주문 관리</a>
        <a href="<c:url value='/qnaboard/get'/>"><i class="fas fa-comment-dots"></i> 문의글 관리</a>
        <a href="<c:url value='/qnaboard/get'/>"><i class="fas fa-comment-dots"></i> 상품 문의글</a>
        <a href="<c:url value='/ws'/>"><i class="fas fa-comments"></i> 채팅</a>
        <a href="<c:url value='/admin/notice/get'/>"><i class="fas fa-bullhorn"></i> 관리자 공지사항</a>
    </div>
</div>

<c:choose>
    <c:when test="${center == null}">
        <jsp:include page="center.jsp"/>
    </c:when>
    <c:otherwise>
        <jsp:include page="${center}.jsp"/>
    </c:otherwise>
</c:choose>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const sidebar = document.getElementById("hover-sidebar");
        document.addEventListener("mousemove", (e) => {
            if (e.clientX < 20) {
                sidebar.style.transform = "translateX(0)";
            } else if (!sidebar.matches(":hover")) {
                sidebar.style.transform = "translateX(-100%)";
            }
        });
        sidebar.addEventListener("mouseleave", () => {
            sidebar.style.transform = "translateX(-100%)";
        });

        // 환영 오버레이 처리
        const overlay = document.getElementById("welcome-overlay");
        if (overlay) {
            const hasShown = sessionStorage.getItem("welcomeShown");
            if (hasShown) {
                overlay.style.display = "none";
            } else {
                sessionStorage.setItem("welcomeShown", "true");
                setTimeout(() => {
                    overlay.style.display = "none";
                }, 7000);
            }
        }

        const toggle = document.getElementById("darkModeToggle");
        const isDark = localStorage.getItem("dark-mode") === "true";
        if (isDark) {
            document.body.classList.add("dark-mode");
            if (toggle) toggle.textContent = "☀️";
        }

        if (toggle) {
            toggle.addEventListener("click", () => {
                const enabled = document.body.classList.toggle("dark-mode");
                toggle.textContent = enabled ? "☀️" : "🌙";
                localStorage.setItem("dark-mode", enabled);
            });
        }
    });
</script>

</body>
</html>
