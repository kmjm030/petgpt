<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ⚠️ 직접 배경/색상 지정 제거, 상속으로 처리 -->
<style>
  .container-fluid {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    background-color: inherit;
    color: inherit;
    margin: 0;
    padding: 2rem;
  }

  .dashboard-header {
    font-size: 2.5rem;
    font-weight: 600;
    margin-bottom: 2rem;
  }

  .dashboard-card,
  .chart-card {
    background-color: #fff;
    border: 1px solid #e0e0e0;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    padding: 1.5rem;
    transition: box-shadow 0.3s ease-in-out;
  }

  .dashboard-card:hover,
  .chart-card:hover {
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  }

  .card-title {
    font-size: 1rem;
    font-weight: 500;
    margin-bottom: 0.75rem;
    text-transform: uppercase;
    color: #6e6e73;
  }

  .card-value {
    font-size: 1.75rem;
    font-weight: 600;
  }

  ul.order-status {
    padding-left: 1rem;
    list-style: none;
  }

  ul.order-status li {
    margin-bottom: 0.25rem;
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
      series: [{
        name: '매출',
        data: values
      }]
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
        <div class="card-title">오늘 매출</div>
        <div class="card-value">${todayRevenue} ₩</div>
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
        <ul class="list-group list-group-flush" style="font-size: 0.95rem;">
          <c:forEach var="alert" items="${adminAlerts}">
            <li class="list-group-item" style="background: transparent;">${alert}</li>
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
        <ul class="list-group list-group-flush" style="font-size: 0.95rem;">
          <c:forEach var="item" items="${topItemList}" varStatus="i">
            <li class="list-group-item d-flex justify-content-between align-items-center"
                style="background-color: transparent;">
              <span>${i.index + 1}. ${item.itemName}</span>
              <span class="badge badge-pill badge-dark">${item.salesCount}개</span>
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
        <ul class="list-group list-group-flush" style="font-size: 0.95rem;">
          <c:forEach var="notice" items="${adminNotices}">
            <li class="list-group-item" style="background: transparent;">
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
