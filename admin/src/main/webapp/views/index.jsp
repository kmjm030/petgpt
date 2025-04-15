<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>PetGPT Admin</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap" rel="stylesheet">
    <link href="<c:url value='/vendor/fontawesome-free/css/all.min.css'/>" rel="stylesheet">
    <link href="<c:url value='/css/sb-admin-2.min.css'/>" rel="stylesheet">

    <!-- Matrix Background Style -->
    <style>
        body, .sidebar, .topbar, .navbar, .card, .modal-content, .dropdown-menu,
        .form-control, .collapse-inner, .modal-body, .modal-footer, .bg-white, .bg-light {
            background-color: #000 !important;
            color: #00ff41 !important;
            font-family: 'Share Tech Mono', monospace !important;
            border-color: #00ff41 !important;
        }

        .form-control::placeholder,
        .nav-link,
        .dropdown-item,
        .modal-title,
        .text-gray-500,
        .text-gray-600,
        .text-gray-800,
        .text-dark,
        .text-center,
        .small {
            color: #00ff41 !important;
        }

        .btn, .input-group-text {
            background-color: #000 !important;
            color: #00ff41 !important;
            border: 1px solid #00ff41 !important;
        }

        .btn:hover {
            background-color: #00ff41 !important;
            color: #000 !important;
        }

        .scroll-to-top {
            background-color: #00ff41 !important;
            color: black !important;
        }

        .scroll-to-top:hover {
            background-color: #00cc00 !important;
        }

        .badge-counter, .sidebar-divider {
            background-color: #00ff41 !important;
            color: black;
            border-color: #00ff41 !important;
        }

        .custom-logo, .custom-logo1 {
            max-width: 120px;
            margin-right: 20px;
            filter: drop-shadow(0 0 6px #00ff41);
        }

        #matrix-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -1;
            pointer-events: none;
            background-color: transparent;
            opacity: 1;
        }

        #matrix-loader {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background-color: black;
            z-index: 9999;
            overflow: hidden;
        }

        #matrix-canvas {
            display: block;
            width: 100%;
            height: 100%;
        }

        .matrix-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .matrix-logo {
            width: 120px;
            margin-bottom: 20px;
            filter: drop-shadow(0 0 6px #00ff41);
        }

        .matrix-text {
            font-size: 2rem;
            font-weight: bold;
            color: #00ff41;
            font-family: monospace;
            text-shadow: 0 0 10px #00ff41, 0 0 20px #00ff41;
        }
    </style>
</head>

<body id="page-top">
<!-- ✅ 매트릭스 배경 캔버스 -->
<canvas id="matrix-background"></canvas>

<!-- ✅ 매트릭스 로딩 화면 -->
<div id="matrix-loader">
    <canvas id="matrix-canvas"></canvas>
    <div class="matrix-overlay">
        <img src="<c:url value='/img/logo.png'/>" alt="로고" class="matrix-logo">
        <div class="matrix-text">로딩중...</div>
    </div>
</div>

<!-- ✅ 본문 콘텐츠 (center.jsp 등 삽입 영역) -->
<c:choose>
    <c:when test="${center == null}">
        <jsp:include page="center.jsp"/>
    </c:when>
    <c:otherwise>
        <jsp:include page="${center}.jsp"/>
    </c:otherwise>
</c:choose>

<!-- ✅ 매트릭스 애니메이션 스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const isFirstVisit = sessionStorage.getItem("visited_index");
        const loader = document.getElementById("matrix-loader");

        if (!isFirstVisit && loader) {
            sessionStorage.setItem("visited_index", "true");

            const canvas = document.getElementById("matrix-canvas");
            const ctx = canvas.getContext("2d");
            const textEl = document.querySelector(".matrix-text");

            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            const letters = "アァイィウヴエェオABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            const fontSize = 18;
            const columns = Math.floor(canvas.width / fontSize);
            const drops = Array(columns).fill(1);

            loader.style.display = "block";

            function draw() {
                ctx.fillStyle = "rgba(0, 0, 0, 0.03)";
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                ctx.fillStyle = "#00ff41";
                ctx.shadowColor = "transparent";
                ctx.shadowBlur = 0;
                ctx.font = fontSize + "px monospace";

                for (let i = 0; i < drops.length; i++) {
                    const text = letters.charAt(Math.floor(Math.random() * letters.length));
                    ctx.fillText(text, i * fontSize, drops[i] * fontSize);
                    if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                        drops[i] = 0;
                    }
                    drops[i]++;
                }
            }

            const interval = setInterval(draw, 33);

            setTimeout(() => {
                textEl.textContent = "Welcome to PetGPT!";
            }, 2000);

            setTimeout(() => {
                clearInterval(interval);
                loader.style.transition = "opacity 1s";
                loader.style.opacity = 0;
                setTimeout(() => loader.remove(), 1000);
            }, 7000);
        }
    });
</script>
</body>
</html>
