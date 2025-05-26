<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="/css/qnaboard/get.css">
<script src="/js/qnaboard/get.js"></script>

<div class="container-fluid">
    <h2 class="mb-4">상품 문의게시판</h2>
    
    <div class="card">
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <colgroup>
                    <col style="width: 60px;">
                    <col style="width: 60px;">
                    <col style="width: 80px;">
                    <col style="width: 120px;">
                    <col style="width: 120px;">
                    <col style="width: 140px;">
                    <col style="width: auto;">
                    <col style="width: 80px;">
                    <col style="width: 90px;">
                    <col style="width: 90px;">
                </colgroup>
                <thead class="table-light">
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
                        <td>
                            <a href="<c:url value='/qnaboard/detail'/>?id=${board.boardKey}">
                                    ${board.boardKey}
                            </a>
                        </td>
                        <td>${board.boardRe}</td>
                        <td>${board.itemKey}</td>
                        <td>${board.custId}</td>
                        <td>${board.boardTitle}</td>
                        <td>
                            <fmt:formatDate value="${board.boardRdate}" pattern="yyyy-MM-dd HH:mm" />
                        </td>
                        <td>
                            <a href="<c:url value='/qnaboard/detail'/>?id=${board.boardKey}">
                                    ${board.boardContent}
                            </a>
                        </td>
                        <td>${board.boardOption}</td>
                        <td>
                            <button onclick="board_get.update('${board.boardKey}')" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-pencil-square"></i> 수정
                            </button>
                        </td>
                        <td>
                            <button onclick="board_get.delete('${board.boardKey}')" class="btn btn-outline-danger btn-sm">
                                <i class="bi bi-trash"></i> 삭제
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- ✅ 페이징 UI -->
        <div class="pagination justify-content-center mt-4">
            <c:if test="${totalPages > 1}">
                <nav>
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}" aria-label="이전">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}" aria-label="다음">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>
