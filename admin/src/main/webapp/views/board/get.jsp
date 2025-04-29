<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/board.css">
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

<div class="board-list-container">
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
