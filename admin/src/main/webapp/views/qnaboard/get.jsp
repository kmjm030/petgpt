<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
    const board_get = {
        update(id) {
            if (confirm('수정하시겠습니까?')) {
                location.href = '<c:url value="/qnaboard/detail"/>' + '?id=' + encodeURIComponent(id);
            }
        },
        delete(id) {
            if (confirm('삭제하시겠습니까?')) {
                location.href = '<c:url value="/qnaboard/delete"/>' + '?id=' + encodeURIComponent(id);
            }
        }
    };
</script>

<style>
    body {
        background-color: #f5f5f7;
        color: #1d1d1f;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        padding: 2rem;
    }

    h2 {
        font-size: 1.6rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
    }

    .card {
        background-color: #fff;
        border-radius: 18px;
        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.05);
        padding: 1.5rem;
    }

    .table {
        font-size: 0.9rem;
        text-align: center;
    }

    .table thead th {
        background-color: #f0f0f5;
        font-weight: 600;
        color: #6e6e73;
        padding: 0.75rem;
        text-transform: uppercase;
        font-size: 0.8rem;
    }

    .table td {
        vertical-align: middle;
        padding: 0.75rem;
    }

    .table img {
        width: 50px;
        border-radius: 8px;
        border: 1px solid #ccc;
    }

    .btn {
        padding: 0.4rem 1rem;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.85rem;
    }

    .btn-outline-primary {
        color: #1d1d1f;
        border: 1px solid #ccc;
    }

    .btn-outline-primary:hover {
        background-color: #1d1d1f;
        color: #fff;
        border-color: #1d1d1f;
    }

    .btn-outline-danger {
        color: #d32f2f;
        border: 1px solid #d32f2f;
    }

    .btn-outline-danger:hover {
        background-color: #d32f2f;
        color: #fff;
    }

    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }

    body.dark-mode .card {
        background-color: #2c2c2e;
        border: 1px solid #3a3a3c;
    }

    body.dark-mode .table thead th {
        background-color: #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode .table td {
        background-color: #2c2c2e;
        color: #f5f5f7;
    }

    body.dark-mode .btn-outline-primary {
        color: #f5f5f7;
        border-color: #888;
    }

    body.dark-mode .btn-outline-primary:hover {
        background-color: #444;
        border-color: #f5f5f7;
    }

    body.dark-mode .btn-outline-danger {
        border-color: #ff6f6f;
        color: #ff6f6f;
    }

    body.dark-mode .btn-outline-danger:hover {
        background-color: #ff6f6f;
        color: #1d1d1f;
    }
</style>

<div class="container-fluid">
    <h2>상품 문의게시판</h2>
    <div class="card">
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                <tr>
                    <th>번호</th>
                    <th>답변</th>
                    <th>상품번호</th>
                    <th>작성자</th>
                    <th>주문번호</th>
                    <th>제목</th>
                    <th>작성일</th>
                    <th>내용</th>
                    <th>이미지</th>
                    <th>옵션</th>
                    <th>수정일</th>
                    <th>수정</th>
                    <th>삭제</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="board" items="${boards}">
                    <tr>
                        <td>${board.boardKey}</td>
                        <td>${board.boardRe}</td>
                        <td>${board.itemKey}</td>
                        <td>${board.custId}</td>
                        <td>${board.orderKey}</td>
                        <td>${board.boardTitle}</td>
                        <td><fmt:formatDate value="${board.boardRdate}" pattern="yyyy-MM-dd HH:mm" /></td>
                        <td>${board.boardContent}</td>
                        <td>
                            <c:if test="${not empty board.boardImg}">
                                <img src="<c:url value='/img/item/${board.boardImg}'/>" alt="이미지">
                            </c:if>
                        </td>
                        <td>${board.boardOption}</td>
                        <td><fmt:formatDate value="${board.boardUpdate}" pattern="yyyy-MM-dd HH:mm" /></td>
                        <td><button onclick="board_get.update('${board.boardKey}')" class="btn btn-outline-primary">수정</button></td>
                        <td><button onclick="board_get.delete('${board.boardKey}')" class="btn btn-outline-danger">삭제</button></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
