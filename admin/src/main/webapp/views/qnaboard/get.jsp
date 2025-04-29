<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/board.css">

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
                    <th>제목</th>
                    <th>작성일</th>
                    <th>내용</th>
                    <th>옵션</th>
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
                        <td>${board.boardTitle}</td>
                        <td><fmt:formatDate value="${board.boardRdate}" pattern="yyyy-MM-dd HH:mm" /></td>
                        <td>${board.boardContent}</td>
                        <td>${board.boardOption}</td>
                        <td><button onclick="board_get.update('${board.boardKey}')" class="btn btn-outline-primary">수정</button></td>
                        <td><button onclick="board_get.delete('${board.boardKey}')" class="btn btn-outline-danger">삭제</button></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
