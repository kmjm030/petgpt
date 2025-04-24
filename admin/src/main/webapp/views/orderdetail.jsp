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

    <link href="https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;600&display=swap" rel="stylesheet">
    <link href="<c:url value='/vendor/fontawesome-free/css/all.min.css'/>" rel="stylesheet">
    <link href="<c:url value='/css/sb-admin-2.min.css'/>" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <style>
        body {
            font-family: "Pretendard", sans-serif;
            background-color: #f9f9f9;
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
        body {
            background-color: #f5f5f7;
            color: #1d1d1f;
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            padding-top: 60px !important;
        }

        body.dark-mode {
            background-color: #1d1d1f !important;
            color: #f5f5f7 !important;
        }

        body.dark-mode #admin-info-bar,
        body.dark-mode .hover-sidebar {
            background-color: #2c2c2e;
            color: #f5f5f7;
        }

        body.dark-mode .hover-sidebar a {
            color: #f5f5f7;
        }

        body.dark-mode .hover-sidebar a:hover {
            color: #0a84ff;
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

    <script>
        $(document).ready(function () {
            $('#orderDetailTable').DataTable({
                "columnDefs": [
                    { "orderable": true, "targets": [1] },     // 주문ID만 정렬 허용
                    { "orderable": false, "targets": "_all" }  // 나머지 정렬 비활성화
                ]
            });
        });
        document.addEventListener("DOMContentLoaded", () => {
            const sidebar = document.getElementById("hover-sidebar");

            document.addEventListener("mousemove", (e) => {
                if (e.clientX < 130) {
                    sidebar.style.transform = "translateX(0)";
                } else if (!sidebar.matches(":hover")) {
                    sidebar.style.transform = "translateX(-100%)";
                }
            });

            sidebar.addEventListener("mouseleave", () => {
                sidebar.style.transform = "translateX(-100%)";
            });

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

        document.addEventListener("DOMContentLoaded", () => {
            const toggle = document.getElementById("darkModeToggle");
            const isDark = localStorage.getItem("dark-mode") === "true";

            if (isDark) {
                document.body.classList.add("dark-mode");
                toggle.textContent = "☀️";
            }

            toggle.addEventListener("click", () => {
                const enabled = document.body.classList.toggle("dark-mode");
                toggle.textContent = enabled ? "☀️" : "🌙";
                localStorage.setItem("dark-mode", enabled);
            });
        });

    </script>

</head>
<body>
<div id="hover-sidebar" class="hover-sidebar">
    <div class="sidebar-content">
        <div class="logo">
            <img src="<c:url value='/img/logo.png'/>" class="custom-logo" alt="로고">
        </div>
        <a href="<c:url value='/'/>"><i class="fas fa-tachometer-alt"></i> 대시보드</a>
        <a href="<c:url value='/cust/get'/>"><i class="fas fa-users"></i> 사용자 관리</a>
        <a href="<c:url value='/item/get'/>"><i class="fas fa-box"></i> 상품 관리</a>
        <a href="<c:url value='/orderdetail'/>"><i class="fas fa-shopping-cart"></i> 주문 관리</a>
        <a href="<c:url value='/inquiries.jsp'/>"><i class="fas fa-question-circle"></i> 문의글 관리</a>
        <a href="<c:url value='/qnaboard/get'/>"><i class="fas fa-comment-dots"></i> 상품 문의글</a>
        <a href="<c:url value='/ws'/>"><i class="fas fa-comments"></i> 채팅</a>
        <a href="<c:url value='/admin/notice/get'/>"><i class="fas fa-bullhorn"></i> 관리자 공지사항</a>
    </div>
</div>


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
            <td>
                <img src="/img/item/${orderdetail.itemKey}.jpg"
                     style="width:50px; height:50px; object-fit:cover;"/>
            </td>
            <td>${orderdetail.orderKey}</td>
            <td>${orderdetail.orderDetailCount}</td>
            <td>
                <fmt:formatNumber
                        value="${orderdetail.orderDetailPrice}"
                        type="currency" currencySymbol="₩"/>
            </td>
            <td>
                <!-- ➊ 토글 버튼 -->
                <button
                        class="btn btn-sm btn-primary mb-1"
                        type="button"
                        data-bs-toggle="collapse"
                        data-bs-target="#detail${orderdetail.orderDetailKey}"
                        aria-expanded="false"
                        aria-controls="detail${orderdetail.orderDetailKey}">
                    상세보기
                </button>

                <!-- ➋ 삭제 버튼 -->
                <a href="<c:url value='/orderdetail/delete/${orderdetail.orderDetailKey}'/>"
                   onclick="return confirm('정말 삭제할까요?')"
                   class="btn btn-sm btn-danger mb-1">
                    삭제
                </a>

                <!-- ➌ Collapse 컨텐츠 (동일한 <td> 안에) -->
                <div
                        class="collapse mt-2"
                        id="detail${orderdetail.orderDetailKey}">
                    <div class="card card-body p-2">
                        <h6>주문 상세 (ID: ${orderdetail.orderDetailKey})</h6>
                        <ul class="list-unstyled mb-0">
                            <li>상품 키: ${orderdetail.itemKey}</li>
                            <li>
                                옵션 키:
                                <c:choose>
                                    <c:when test="${orderdetail.optionKey != null}">
                                        ${orderdetail.optionKey}
                                    </c:when>
                                    <c:otherwise>없음</c:otherwise>
                                </c:choose>
                            </li>
                            <li>주문 키: ${orderdetail.orderKey}</li>
                            <li>
                                단가:
                                <fmt:formatNumber
                                        value="${orderdetail.orderDetailPrice}"
                                        type="currency" currencySymbol="₩"/>
                            </li>
                            <li>수량: ${orderdetail.orderDetailCount}</li>
                        </ul>
                    </div>
                </div>
            </td>
        </tr>
    </c:forEach>

    </tbody>

</table>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
