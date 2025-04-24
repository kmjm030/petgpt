<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
    const board_get = {
        update: function(id) {
            if (confirm('수정하시겠습니까?')) {
                location.href = '<c:url value="/board/detail"/>' + '?id=' + id;
            }
        },
        delete: function(id) {
            if (confirm('삭제하시겠습니까?')) {
                location.href = '<c:url value="/board/delete"/>' + '?id=' + id;
            }
        }
    };
</script>

<style>
    body {
        background-color: #fff;
        color: #1d1d1f;
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        padding: 2rem;
    }
    .card {
        border-radius: 16px;
        border: 1px solid #e0e0e0;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
        padding: 2rem;
        background-color: #fff;
    }
    h1 {
        font-size: 1.75rem;
        font-weight: 700;
        margin-bottom: 1rem;
    }
    table th, table td {
        text-align: center;
        vertical-align: middle;
    }
    table th {
        background-color: #f9f9fa;
        font-size: 0.9rem;
        font-weight: 600;
        text-transform: uppercase;
        color: #6e6e73;
    }
    table td {
        background-color: #fff;
        font-size: 0.95rem;
    }
    .btn-secondary {
        background-color: #1d1d1f;
        color: white;
        font-weight: 600;
        border-radius: 8px;
        border: none;
        padding: 6px 14px;
        font-size: 0.85rem;
    }
    .btn-secondary:hover {
        background-color: #333;
    }

    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }
    body.dark-mode .card {
        background-color: #2c2c2e;
        border-color: #3a3a3c;
    }
    body.dark-mode table th,
    body.dark-mode table td {
        background-color: #2c2c2e;
        color: #f5f5f7;
        border-color: #3a3a3c;
    }
    body.dark-mode table th {
        background-color: #3a3a3c;
    }
    body.dark-mode .btn-secondary {
        background-color: #3a3a3c;
        border: 1px solid #4a4a4a;
        color: #f5f5f7;
    }
    body.dark-mode .btn-secondary:hover {
        background-color: #4a4a4a;
    }
</style>

<div class="container-fluid">
    <h1>문의글 게시판 목록</h1>
    <div class="card">
        <div class="table-responsive">
            <table class="table table-bordered" id="dataTable">
                <thead>
                <tr>
                    <th>No</th>
                    <th>상품 번호</th>
                    <th>작성자</th>
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
                        <td><a href="<c:url value='/board/detail'/>?id=${board.boardKey}">${board.boardKey}</a></td>
                        <td>${board.itemKey}</td>
                        <td>${board.custId}</td>
                        <td>${board.boardTitle}</td>
                        <td>${board.boardRdate}</td>
                        <td>${board.boardContent}</td>
                        <td>${board.boardImg}</td>
                        <td>${board.boardOption}</td>
                        <td>${board.boardUpdate}</td>
                        <td><button onclick="board_get.update('${board.boardKey}')" class="btn btn-secondary">수정</button></td>
                        <td><button onclick="board_get.delete('${board.boardKey}')" class="btn btn-secondary">삭제</button></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
