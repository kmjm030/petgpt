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

    <style>
        #welcome-overlay {
            position: fixed;
            z-index: 9999;
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
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #1d1d1f;
            opacity: 0;
            animation: fadeIn 1s ease-in-out 0.5s forwards;
        }

        @keyframes fadeIn {
            to {
                opacity: 1;
            }
        }

        @keyframes fadeOut {
            to {
                opacity: 0;
                visibility: hidden;
            }
        }

        body {
            background-color: #f5f5f7;
            color: #1d1d1f;
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
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
            z-index: 9998;
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
    <div id="welcome-overlay">
        <div class="welcome-box">
            <div class="welcome-text">
                <span>${sessionScope.admin.adminName}님, 환영합니다 !</span>
            </div>
        </div>
    </div>
</c:if>

<c:if test="${not empty sessionScope.admin}">
    <div style="position: fixed; top: 20px; right: 30px; z-index: 9999; display: flex; align-items: center; gap: 12px; font-family: 'SF Pro Display', sans-serif;">
    <span style="font-weight: 600; font-size: 0.95rem;">
      <i class="fas fa-user-circle"></i> ${sessionScope.admin.adminName} 님
    </span>
        <a href="<c:url value='/logoutimpl'/>"
           onclick="sessionStorage.clear();"
           style="background-color: #1d1d1f; color: white; padding: 6px 14px; border-radius: 8px; font-size: 0.85rem; text-decoration: none; font-weight: 500;">
            로그아웃
        </a>
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
        <a href="<c:url value='/orders.jsp'/>"><i class="fas fa-shopping-cart"></i> 주문 관리</a>
        <a href="<c:url value='/inquiries.jsp'/>"><i class="fas fa-question-circle"></i> 문의글 관리</a>
        <a href="<c:url value='/qnaboard/get'/>"><i class="fas fa-comment-dots"></i> 상품 문의글</a>
        <a href="<c:url value='/ws'/>"><i class="fas fa-comments"></i> 채팅</a>
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
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
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
    });
</script>
</body>
</html>
