<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="<c:url value='/css/center.css'/>">

<div class="container-fluid">
  <div class="dashboard-header">메인화면</div>

  <div class="row mb-4">
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/cust/get'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card">
          <div class="card-title">전체 사용자</div>
          <div class="card-value">${custCount}</div>
        </div>
      </a>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/item/get'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card">
          <div class="card-title">전체 상품</div>
          <div class="card-value">${itemCount}</div>
        </div>
      </a>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/cust/today'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card">
          <div class="card-title">오늘 가입자 수</div>
          <div class="card-value">${todayJoinCount}</div>
        </div>
      </a>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/totalorder'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card">
          <div class="card-title">총 주문 수</div>
          <div class="card-value">${orderCount}</div>
        </div>
      </a>
    </div>
  </div>

  <div class="row mb-4">
    <div class="col-lg-6 mb-4">
      <div class="dashboard-card">
        <div class="card-title">총 매출</div>
        <div class="card-value">
          <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/>원
        </div>
      </div>
    </div>

    <div class="col-lg-6 mb-4">
      <div class="dashboard-card">
        <div class="card-title">배송 상태</div>
        <ul class="order-status">
          <li>결제 완료: ${orderStatusMap['결제완료']}</li>
          <li>배송 중: ${orderStatusMap['배송중']}</li>
          <li>배송 완료: ${orderStatusMap['배송완료']}</li>
        </ul>
      </div>
    </div>
  </div>

  <div class="row mb-4">
    <div class="col-lg-12 mb-4">
      <div class="dashboard-card">
        <div class="card-title">최근 7일 매출 추이</div>
        <div id="dailySalesChart" style="height: 300px;"></div>
      </div>
    </div>
  </div>

  <div class="row mb-4">
    <div class="col-lg-4 mb-4">
      <div class="dashboard-card">
        <div class="card-title">관리자 알림</div>
        <ul class="list-group list-group-flush">
          <c:forEach var="alert" items="${adminAlerts}">
            <li class="list-group-item">${alert}</li>
          </c:forEach>
          <c:if test="${empty adminAlerts}">
            <li class="list-group-item text-muted">현재 표시할 알림이 없습니다.</li>
          </c:if>
        </ul>
      </div>
    </div>
    <div class="col-lg-4 mb-4">
      <div class="chart-card">
        <h6 class="card-title">상품 판매 TOP 10</h6>
        <ul class="list-group list-group-flush">
          <c:forEach var="item" items="${topItemList}" varStatus="i">
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <span>${i.index + 1}. ${item.itemName}</span>
              <span class="badge badge-dark">${item.salesCount}개</span>
            </li>
          </c:forEach>
          <c:if test="${empty topItemList}">
            <li class="list-group-item text-muted">판매 데이터가 없습니다.</li>
          </c:if>
        </ul>
      </div>
    </div>
    <div class="col-lg-4 mb-4">
      <div class="dashboard-card">
        <div class="card-title">관리자 공지사항</div>
        <ul class="list-group list-group-flush">
          <c:forEach var="notice" items="${adminNotices}">
            <li class="list-group-item">
              <a href="<c:url value='/admin/notice/detail?id=${notice.id}'/>" style="text-decoration: none; color: inherit;">
                  ${notice.title}
              </a>
            </li>
          </c:forEach>
          <c:if test="${empty adminNotices}">
            <li class="list-group-item text-muted">현재 등록된 공지사항이 없습니다.</li>
          </c:if>
        </ul>
      </div>
    </div>
  </div>

  <div class="row mb-4">
    <div class="col-lg-6 mb-4">
      <div class="dashboard-card">
        <div class="card-title">최근 주문 내역</div>
        <ul class="list-group list-group-flush">
          <c:forEach var="order" items="${recentOrders}">
            <li class="list-group-item d-flex justify-content-between align-items-center recent-order-item"
                data-orderkey="${order.orderKey}"
                data-custid="${order.custId}"
                data-status="${order.orderStatus}"
                data-date="${order.orderDate}"
                data-totalprice="${order.orderTotalPrice}">
              <span>주문번호: ${order.orderKey} / 주문자: ${order.custId}</span>
              <span class="badge badge-info">${order.orderStatus}</span>
            </li>
          </c:forEach>
          <c:if test="${empty recentOrders}">
            <li class="list-group-item text-muted">최근 주문이 없습니다.</li>
          </c:if>
        </ul>
      </div>
    </div>

    <div class="col-lg-6 mb-4">
      <div class="dashboard-card">
        <div class="card-title">최근 문의사항</div>
        <ul class="list-group list-group-flush">
          <c:forEach var="qna" items="${recentQnaList}">
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <a href="<c:url value='/qnaboard/detail?id=${qna.boardKey}'/>" style="text-decoration: none; color: inherit;">
                  ${qna.boardTitle}
              </a>
              <fmt:formatDate value="${qna.boardRdate}" pattern="yyyy-MM-dd" />
            </li>
          </c:forEach>
          <c:if test="${empty recentQnaList}">
            <li class="list-group-item text-muted">최근 문의가 없습니다.</li>
          </c:if>
        </ul>
      </div>
    </div>
  </div>
</div>

<script>
  window.dailySalesData = <c:out value="${empty dailySalesDataJson ? '[]' : dailySalesDataJson}" escapeXml="false" />;
</script>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="<c:url value='/js/center.js'/>"></script>
