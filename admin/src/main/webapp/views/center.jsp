<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  body {
    background-color: #f5f5f7;
    color: #1d1d1f;
    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    padding: 2rem;
  }

  body.dark-mode {
    background-color: #1d1d1f;
    color: #f5f5f7;
  }

  .dashboard-header {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 2rem;
  }

  .dashboard-card,
  .chart-card {
    background-color: #fff;
    border: 1px solid #e0e0e0;
    border-radius: 16px;
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
    padding: 1.5rem;
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
    color: #6e6e73;
  }

  body.dark-mode .card-title {
    color: #bbb;
  }

  .card-value {
    font-size: 1.75rem;
    font-weight: 700;
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
    background-color: #1d1d1f;
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
      xAxis: {
        categories,
        title: { text: '시간대' }
      },
      yAxis: {
        title: { text: '매출액 (₩)' }
      },
      series: [{ name: '매출', data: values }]
    });
  });
</script>

<div class="container-fluid">
  <div class="dashboard-header">대시보드</div>

  <div class="row mb-4">
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/cust/get'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card h-100">
          <div class="card-title">전체 사용자</div>
          <div class="card-value">${custCount}</div>
        </div>
      </a>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/item/get'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card h-100">
          <div class="card-title">전체 상품</div>
          <div class="card-value">${itemCount}</div>
        </div>
      </a>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/cust/today'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card h-100">
          <div class="card-title">오늘 가입자 수</div>
          <div class="card-value">${todayJoinCount}</div>
        </div>
      </a>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <a href="<c:url value='/orderdetail'/>" style="text-decoration: none; color: inherit;">
        <div class="dashboard-card h-100">
          <div class="card-title">총 주문 수</div>
          <div class="card-value">${orderCount}</div>
        </div>
      </a>
    </div>
  </div>

  <div class="row mb-4">
    <div class="col-lg-8 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">총 매출</div>
        <div class="card-value">${totalRevenue} ₩</div>
      </div>
    </div>
    <div class="col-lg-4 mb-4">
      <div class="dashboard-card h-100">
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
      <div class="dashboard-card h-100">
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
      <div class="dashboard-card h-100">
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
