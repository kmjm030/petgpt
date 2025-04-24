<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card-body">
  <div class="table-responsive">
    <h4 class="font-weight-bold mb-3">문의 글 목록</h4>
    <c:forEach var="qna" items="${qnaList}">
      <div class="border rounded mb-3">
        <!-- 질문 헤더 (클릭 영역) -->
        <div class="p-3 bg-light d-flex justify-content-between align-items-center inquiry-toggle" style="cursor: pointer;">
          <div>
            <strong>[${qna.boardKey}] ${qna.boardTitle}</strong>
            <small class="ml-3 text-muted">작성자: ${qna.custId} | 작성일: <fmt:formatDate value="${qna.boardRdate}" pattern="yyyy-MM-dd HH:mm"/></small>
          </div>
          <i class="bi bi-chevron-down toggle-icon"></i>
        </div>

        <!-- 답변 영역 -->
        <div class="answer-content px-4 py-3" style="display: none;">
          <div><strong>📌 질문 내용:</strong><br>${qna.boardContent}</div>
          <hr>
          <c:if test="${not empty qna.adcommentsContent}">
            <div><strong>🛡 관리자(${qna.adminId})의 답변:</strong><br>${qna.adcommentsContent}</div>
            <div class="text-muted mt-2" style="font-size: 12px;">
              답변일: <fmt:formatDate value="${qna.adcommentsRdate}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
          </c:if>
          <c:if test="${empty qna.adcommentsContent}">
            <div class="text-muted">⏳ 아직 답변이 등록되지 않았습니다.</div>
          </c:if>
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<script>
  $(document).ready(function () {
    $('.inquiry-toggle').click(function () {
      const $answer = $(this).next('.answer-content');
      const isVisible = $answer.is(':visible');

      $('.answer-content').slideUp();
      $('.toggle-icon').removeClass('bi-chevron-up').addClass('bi-chevron-down');

      if (!isVisible) {
        $answer.slideDown();
        $(this).find('.toggle-icon').removeClass('bi-chevron-down').addClass('bi-chevron-up');
      }
    });
  });
</script>
