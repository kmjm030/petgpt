<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>주문 상세 보기</title>

  <!-- Bootstrap 5 -->
  <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet"
  />
  <!-- FontAwesome (뒤로 가기 아이콘) -->
  <link
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
          rel="stylesheet"
  />

  <style>
    /* 뒤로 가기 버튼 커스터마이즈 */
    .btn-back {
      font-size: 0.95rem;
      padding: 0.4rem 0.8rem;
      border-radius: 0.35rem;
      transition: background-color .2s, color .2s;
    }
    .btn-back:hover {
      background-color: #e9ecef;
      color: #0d6efd;
    }

    /* 카드 헤더 컬러 */
    .detail-card .card-header {
      background-color: #0d6efd;
      color: #fff;
    }
    /* 리스트 그룹 레이블 강조 */
    .detail-card .list-group-item dt {
      font-weight: 600;
      color: #495057;
    }
    .detail-card .list-group-item dd {
      margin: 0;
    }
  </style>
</head>
<body class="bg-light">
<div class="container py-5">

  <!-- 1) 뒤로 가기 버튼 -->
  <a href="${pageContext.request.contextPath}/orderdetail"
     class="btn btn-outline-primary btn-back mb-4 d-inline-flex align-items-center">
    <i class="fas fa-arrow-left me-2"></i>목록으로 돌아가기
  </a>

  <!-- 2) 상세 카드 -->
  <div class="card detail-card shadow-sm rounded">
    <div class="card-header d-flex justify-content-between align-items-center">
      <h5 class="mb-0">주문 상세 정보</h5>
      <small>ID: ${orderDetail.orderDetailKey}</small>
    </div>
    <ul class="list-group list-group-flush">
      <li class="list-group-item d-flex">
        <dt class="col-4">주문 상세 키</dt>
        <dd class="col-8">${orderDetail.orderDetailKey}</dd>
      </li>
      <li class="list-group-item d-flex">
        <dt class="col-4">상품 키</dt>
        <dd class="col-8">${orderDetail.itemKey}</dd>
      </li>
      <li class="list-group-item d-flex">
        <dt class="col-4">옵션 키</dt>
        <dd class="col-8">
          <c:choose>
            <c:when test="${orderDetail.optionKey != null}">
              ${orderDetail.optionKey}
            </c:when>
            <c:otherwise>없음</c:otherwise>
          </c:choose>
        </dd>
      </li>
      <li class="list-group-item d-flex">
        <dt class="col-4">주문 순서</dt>
        <dd class="col-8">${orderDetail.orderKey}</dd>
      </li>
      <li class="list-group-item d-flex">
        <dt class="col-4">주문 상세 가격</dt>
        <dd class="col-8">${orderDetail.orderDetailPrice} 원</dd>
      </li>
      <li class="list-group-item d-flex">
        <dt class="col-4">주문 수량</dt>
        <dd class="col-8">${orderDetail.orderDetailCount} 개</dd>
      </li>
    </ul>
  </div>
</div>

<!-- Bootstrap JS -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
></script>
</body>
</html>
