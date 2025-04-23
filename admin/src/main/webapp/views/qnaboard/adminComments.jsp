<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
  const admincomments_detail = {
    update: function (id) {
      if (confirm('수정하시겠습니까?')) {
        location.href = '<c:url value="/board/detail"/>?id=' + id;
      }
    },
    delete: function (id, boardKey) {
      if (confirm('삭제하시겠습니까?')) {
        location.href = '<c:url value="/admincomments/delete"/>?adcommentsKey=' + id + '&boardKey=' + boardKey;
      }
    }
  };
</script>

<!-- 관리자 답변 카드 -->
<div class="card shadow-sm p-4 mb-4" style="background-color: #1d1d1f; border-radius: 18px;">
  <h5 style="color: #f5f5f7; font-weight: 600; margin-bottom: 20px;">🛠 관리자 답변</h5>

  <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
    <div style="color: #b0b0b0; font-size: 0.95rem; margin-bottom: 10px;">
      <strong>작성자:</strong> ${adminComments.adminId}
    </div>
    <div style="color: #8e8e93; font-size: 0.85rem;">
      등록일: <fmt:formatDate value="${adminComments.adcommentsRdate}" pattern="yyyy-MM-dd HH:mm" />
      &nbsp;|&nbsp;
      수정일: <fmt:formatDate value="${adminComments.adcommentsUpdate}" pattern="yyyy-MM-dd HH:mm" />
    </div>
  </div>

  <div style="margin-top: 14px; background-color: #2c2c2e; padding: 18px; border-radius: 12px; color: #ffffff; line-height: 1.6; font-size: 0.95rem;">
    ${adminComments.adcommentsContent}
  </div>

  <div style="margin-top: 16px; display: flex; gap: 12px;">
    <button onclick="admincomments_detail.update('${adminComments.adcommentsKey}')" class="btn btn-sm btn-outline-light">수정</button>
    <button onclick="admincomments_detail.delete('${adminComments.adcommentsKey}', '${board.boardKey}')" class="btn btn-sm btn-outline-danger">삭제</button>
  </div>
</div>
