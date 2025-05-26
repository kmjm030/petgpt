<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="/css/qnaboard/get.css">

<div class="container-fluid px-3 py-4">
    <h2 class="mb-4 fw-bold text-primary">상품 문의게시판</h2>

    <form method="get" action="/qnaboard/get" class="row g-2 align-items-center mb-4">
        <div class="col-auto">
            <select name="field" class="form-select">
                <option value="title" ${field == 'title' ? 'selected' : ''}>제목</option>
                <option value="content" ${field == 'content' ? 'selected' : ''}>내용</option>
                <option value="cust_id" ${field == 'cust_id' ? 'selected' : ''}>작성자</option>
            </select>
        </div>
        <div class="col">
            <input type="text" name="keyword" class="form-control" placeholder="검색어 입력" value="${keyword}" />
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-outline-primary">
                <i class="bi bi-search"></i> 검색
            </button>
        </div>
    </form>

    <div class="card shadow-sm rounded-4">
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle mb-0">
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
                <thead class="table-light text-center">
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
                <tbody class="text-center">
                <c:forEach var="board" items="${boards}">
                    <tr>
                        <td>
                            <a href="<c:url value='/qnaboard/detail'/>?id=${board.boardKey}" class="text-decoration-none">
                                    ${board.boardKey}
                            </a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${board.boardRe eq '답변있음'}">
                                    ✅
                                </c:when>
                                <c:otherwise>
                                    ❌
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${board.itemKey}</td>
                        <td>${board.custId}</td>
                        <td>${board.boardTitle}</td>
                        <td class="text-nowrap no-truncate">
                            <fmt:formatDate value="${board.boardRdate}" pattern="yyyy-MM-dd HH:mm" />
                        </td>
                        <td class="text-start text-truncate" style="max-width: 300px;">
                            <a href="<c:url value='/qnaboard/detail'/>?id=${board.boardKey}" class="text-body text-decoration-none">
                                    ${board.boardContent}
                            </a>
                        </td>
                        <td>${board.boardOption}</td>
                        <td>
                            <button onclick="board_get.update('${board.boardKey}')" class="btn-icon" title="수정">
                                <i class="bi bi-pencil-square"></i>
                            </button>
                        </td>
                        <td>
                            <button onclick="board_get.delete('${board.boardKey}')" class="btn-icon danger" title="삭제">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="pagination justify-content-center py-3">
            <c:if test="${totalPages > 1}">
                <nav>
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&field=${field}&keyword=${keyword}" aria-label="이전">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&field=${field}&keyword=${keyword}">${i}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&field=${field}&keyword=${keyword}" aria-label="다음">
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

<canvas id="snow-canvas"></canvas>

<script src="/js/qnaboard/get.js"></script>
<script src="/js/qnaboard/snow.js"></script>
