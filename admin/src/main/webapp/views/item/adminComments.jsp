<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="/css/item/list.css">

<div class="card-body">
  <div class="table-responsive">
    <h4 class="page-title mb-3 text-left">문의 글 목록</h4>
    <c:forEach var="qna" items="${qnaList}">
      <div class="qna-card mb-3">
        <div class="inquiry-toggle">
          <div class="qna-header">
            <strong>[${qna.boardKey}] ${qna.boardTitle}</strong>
            <small class="qna-meta">작성자: ${qna.custId} | 작성일:
              <fmt:formatDate value="${qna.boardRdate}" pattern="yyyy-MM-dd HH:mm"/>
            </small>
          </div>
          <i class="bi bi-chevron-down toggle-icon"></i>
        </div>

        <div class="answer-content">
          <div><strong>📌 질문 내용:</strong><br>${qna.boardContent}</div>
          <hr>
          <c:choose>
            <c:when test="${not empty qna.adcommentsContent}">
              <div><strong>🛡 관리자(${qna.adminId})의 답변:</strong><br>${qna.adcommentsContent}</div>
              <div class="text-muted mt-2">
                답변일: <fmt:formatDate value="${qna.adcommentsRdate}" pattern="yyyy-MM-dd HH:mm"/>
              </div>
            </c:when>
            <c:otherwise>
              <div class="text-muted-status">⏳ 아직 답변이 등록되지 않았습니다.</div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script src="/js/item/list.js"></script>
