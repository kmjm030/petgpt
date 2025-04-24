<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .notice-list {
        max-width: 900px;
        margin: 0 auto;
        background-color: #fff;
        padding: 2rem;
        border-radius: 14px;
        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.05);
    }

    .notice-list h2 {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
        color: #1d1d1f;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .notice-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.95rem;
    }

    .notice-table th,
    .notice-table td {
        padding: 0.75rem;
        border: 1px solid #e0e0e0;
        text-align: left;
    }

    .notice-table th {
        background-color: #f5f5f7;
        color: #6e6e73;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.85rem;
    }

    .notice-table tr:hover {
        background-color: #f0f0f5;
    }

    .add-btn {
        display: inline-block;
        margin-bottom: 1.2rem;
        background-color: #1d1d1f;
        color: #fff;
        padding: 0.5rem 1.2rem;
        border-radius: 8px;
        font-size: 0.9rem;
        text-decoration: none;
        font-weight: 500;
        transition: background-color 0.2s ease;
    }

    .add-btn:hover {
        background-color: #333;
    }

    .delete-btn {
        color: #d32f2f;
        font-size: 0.85rem;
        font-weight: 600;
        text-decoration: none;
    }

    .delete-btn:hover {
        text-decoration: underline;
    }

    /* 다크모드 대응 */
    body.dark-mode .notice-list {
        background-color: #2c2c2e;
        color: #f5f5f7;
    }

    body.dark-mode .notice-list h2 {
        color: #f5f5f7;
    }

    body.dark-mode .notice-table th,
    body.dark-mode .notice-table td {
        background-color: #2c2c2e;
        border-color: #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode .notice-table th {
        background-color: #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode .notice-table tr:hover {
        background-color: #3c3c3e;
    }

    body.dark-mode .add-btn {
        background-color: #3a3a3c;
        color: #f5f5f7;
        border: 1px solid #4a4a4a;
    }

    body.dark-mode .add-btn:hover {
        background-color: #4a4a4a;
    }

    body.dark-mode .delete-btn {
        color: #ff6b6b;
    }
</style>

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
