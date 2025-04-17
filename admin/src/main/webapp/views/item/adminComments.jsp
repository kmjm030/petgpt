<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>



<div class="card-body">
  <div class="table-responsive">
    <c:forEach var="qna" items="${qnaList}">
<%--      <H1>${qna.boardKey}</H1>--%>
<%--      <H5>난는 ${map.get(qna.boardKey)}</H5>--%>
<%--       게시판원글  --%>
      <h4> 게시판글</h4>
      <table class="table table-bordered"  width="100%" cellspacing="0">
        <thead class="thead-dark">
        <tr class="table-dark">
          <th>boardKey</th>
          <th>ItemKey</th>
          <th>custId</th>
          <th>boardTitle</th>
          <th>boardContent</th>
          <th>boardRdate</th>
<%--          <th>boardImg</th>--%>
<%--          <th>boardOption</th>--%>
<%--          <th>boardUpdate</th>--%>

        </tr>
        </thead>
        <tbody>
          <%--                    <c:forEach var="a" items="${adminComments}">--%>

        <tr>
          <td><a href="<c:url value="/board/detail"/>?id=${qna.boardKey}">${qna.boardKey}</a></td>
          <td>${qna.itemKey}</td>
          <td>${qna.custId}</td>
          <td>${qna.boardTitle}</td>
          <td>${qna.boardContent}</td>
          <td>${qna.boardRdate}</td>
<%--          <td>${qna.boardImg}</td>--%>
<%--          <td>${qna.boardOption}</td>--%>
<%--          <td>${qna.boardUpdate}</td>--%>


        </tr>
          <%--                    </c:forEach>--%>
        </tbody>
      </table>


<%--        게시판원글끝--%>


      <h5> 관리자답변</h5>
      <table class="table table-bordered"  width="100%" cellspacing="0">
        <thead class="thead-light">
        <tr class="table-warning">
          <th>qna.adminComments.boardKey</th>
          <th>qna.adminComments.adcommentsKey</th>
          <th>qna.adminComments.ItemKey</th>
          <th>qna.adminComments.adminId</th>
          <th>qna.adminComments.adcommentsContent</th>
          <th>qna.adminComments.adcommentsRdate</th>
<%--          <th>adcommentsUpdate</th>--%>

        </tr>
        </thead>
        <tbody>
        <%--                    <c:forEach var="a" items="${adminComments}">--%>

        <tr>
          <td><a href="<c:url value="/board/detail"/>?id=${qna.boardKey}">${qna.boardKey}</a></td>
          <td>${qna.adcommentsKey}</td>
<%--          <td>${qna.boardKey}</td>--%>
          <td>${qna.itemKey}</td>
          <td>${qna.adminId}</td>
          <td>${qna.adcommentsContent}</td>
          <td>${qna.adcommentsRdate}</td>
<%--          <td>${qna.adminComments.adcommentsUpdate}</td>--%>


        </tr>
        <%--                    </c:forEach>--%>
        </tbody>
      </table>
    </c:forEach>
  </div>
</div>