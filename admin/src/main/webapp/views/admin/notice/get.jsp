<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/admin/get.css">

<div class="notice-list">
  <h2>
    <i class="fas fa-bullhorn" style="color:#1d1d1f;"></i>
    관리자 공지사항
  </h2>

  <input type="text" id="searchInput" placeholder="제목 또는 작성자 검색..." class="search-input" />

  <a href="<c:url value='/admin/notice/add'/>" class="add-btn">새 공지 등록</a>

  <table class="notice-table" id="noticeTable">
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
      <tr class="notice-row">
        <td>${status.index + 1}</td>
        <td class="title-cell">
          <a href="<c:url value='/admin/notice/detail?id=${notice.id}'/>" style="color:inherit; text-decoration:none;">
              ${notice.title}
          </a>
        </td>
        <td class="writer-cell">${notice.adminName}</td>
        <td>${notice.createdAt}</td>
        <td>
          <a href="#" class="delete-btn" onclick="confirmDelete(event, '${notice.id}')">삭제</a>
        </td>
      </tr>
    </c:forEach>

    <c:if test="${empty noticeList}">
      <tr>
        <td colspan="5" class="text-center text-muted">등록된 공지가 없습니다.</td>
      </tr>
    </c:if>
    </tbody>
  </table>
</div>

<script src="/js/admin/get.js"></script>
