<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card-body">
  <div class="table-responsive">
    <c:forEach var="qna" items="${qnaList}">
      <h4 class="font-weight-bold mb-3">게시판 글</h4>
      <table class="table table-bordered mb-5">
        <thead class="thead-dark">
        <tr>
          <th>글 번호</th>
          <th>상품 번호</th>
          <th>작성자 ID</th>
          <th>제목</th>
          <th>내용</th>
          <th>작성일</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td><a href="<c:url value='/board/detail'/>?id=${qna.boardKey}" class="text-dark">${qna.boardKey}</a></td>
          <td>${qna.itemKey}</td>
          <td>${qna.custId}</td>
          <td>${qna.boardTitle}</td>
          <td>${qna.boardContent}</td>
          <td>${qna.boardRdate}</td>
        </tr>
        </tbody>
      </table>

      <h5 class="font-weight-bold mb-3 text-warning">관리자 답변</h5>
      <table class="table table-bordered">
        <thead class="thead-light">
        <tr class="bg-warning text-dark">
          <th>글 번호</th>
          <th>답변 번호</th>
          <th>상품 번호</th>
          <th>관리자 ID</th>
          <th>답변 내용</th>
          <th>답변일</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td>${qna.boardKey}</td>
          <td>${qna.adcommentsKey}</td>
          <td>${qna.itemKey}</td>
          <td>${qna.adminId}</td>
          <td>${qna.adcommentsContent}</td>
          <td>${qna.adcommentsRdate}</td>
        </tr>
        </tbody>
      </table>
    </c:forEach>
  </div>
</div>
