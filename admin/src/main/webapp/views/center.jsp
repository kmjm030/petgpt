<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  body {
    background-color: #fff0f5; /* 봄 벚꽃 느낌의 배경 */
    color: #4b2c2c;
    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    padding: 2rem;
    background-image: linear-gradient(to bottom right, #fff0f5, #ffe4e1);
  }

  body.dark-mode {
    background-color: #2c2c2e;
    color: #f5f5f7;
  }

  .dashboard-header {
    font-size: 2.5rem;
    font-weight: 800;
    margin-bottom: 2.5rem;
    text-align: center;
    color: #d63384;
  }

  .dashboard-card,
  .chart-card {
    background-color: #ffffffcc;
    border: 1px solid #f8c1d0;
    border-radius: 16px;
    box-shadow: 0 6px 16px rgba(255, 182, 193, 0.2);
    padding: 1.5rem;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    transition: transform 0.3s ease;
  }

  .dashboard-card:hover,
  .chart-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 24px rgba(255, 182, 193, 0.3);
  }

  body.dark-mode .dashboard-card,
  body.dark-mode .chart-card {
    background-color: #2c2c2e;
    border-color: #3a3a3c;
  }

  .card-title {
    font-size: 1rem;
    font-weight: 600;
    margin-bottom: 0.75rem;
    text-transform: uppercase;
    color: #d63384;
    text-align: center;
  }

  body.dark-mode .card-title {
    color: #bbb;
  }

  .card-value {
    font-size: 2.2rem;
    font-weight: 800;
    text-align: center;
    color: #c9184a;
  }

  body.dark-mode .card-value {
    color: #fff;
  }

  ul.order-status,
  .list-group {
    padding-left: 0;
    list-style: none;
    margin: 0;
  }

  .order-status li,
  .list-group-item {
    padding: 0.5rem 0;
    font-size: 0.95rem;
  }

  .list-group-item {
    background-color: transparent;
    border: none;
    color: inherit;
  }

  .badge-dark {
    background-color: #d63384;
    color: #fff;
    padding: 0.3rem 0.75rem;
    border-radius: 12px;
  }

  body.dark-mode .badge-dark {
    background-color: #f5f5f7;
    color: #1d1d1f;
  }
</style>



<script src="https://code.highcharts.com/highcharts.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const data = [
      { hour: "09", total: 15000 },
      { hour: "10", total: 23000 },
      { hour: "11", total: 18000 },
      { hour: "12", total: 32000 },
      { hour: "13", total: 27500 },
      { hour: "14", total: 22000 }
    ];
    const categories = data.map(d => d.hour + '시');
    const values = data.map(d => d.total);
    Highcharts.chart('hourlySalesChart', {
      chart: { type: 'column', backgroundColor: 'transparent' },
      title: { text: '오늘 시간대별 매출' },
      xAxis: { categories, title: { text: '시간대' } },
      yAxis: { title: { text: '매출액 (₩)' } },
      series: [{ name: '매출', data: values }]
    });
  });
</script>

<div class="container-fluid">
  <div class="dashboard-header">대시보드</div>

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
      <a href="<c:url value='/orderdetail'/>" style="text-decoration: none; color: inherit;">
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
    <div class="col-lg-6 mb-4">
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
    <div class="col-lg-6 mb-4">
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
    <div class="col-lg-6 mb-4">
      <div class="chart-card">
        <h6 class="card-title">오늘 시간대별 매출</h6>
        <div id="hourlySalesChart" style="width:100%; height:300px;"></div>
      </div>
    </div>
    <div class="col-lg-6 mb-4">
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
</div>
