<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/admin.css">
<div class="notice-list">
    <h2>
        <i class="fas fa-bullhorn" style="color:#1d1d1f;"></i>
        관리자 공지사항
    </h2>

    <a href="<c:url value='/admin/notice/add'/>" class="add-btn">➕ 새 공지 등록</a>

    <table class="notice-table">
        <thead>
        <tr>
            <th>#</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
            <th>관리</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="notice" items="${noticeList}" varStatus="status">
            <tr>
                <td>${status.index + 1}</td>
                <td>
                    <a href="<c:url value='/admin/notice/detail?id=${notice.id}'/>" style="color:inherit; text-decoration:none;">
                            ${notice.title}
                    </a>
                </td>
                <td>${notice.adminName}</td>
                <td>${notice.createdAt}</td>
                <td>
                    <a href="<c:url value='/admin/notice/delete?id=${notice.id}'/>"
                       class="delete-btn"
                       onclick="return confirm('정말 삭제하시겠습니까?');">
                        삭제
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty noticeList}">
            <tr>
                <td colspan="5" style="text-align:center; color: #999;">등록된 공지가 없습니다.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
