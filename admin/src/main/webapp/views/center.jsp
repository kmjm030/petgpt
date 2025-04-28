<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  body {
    background: linear-gradient(to bottom right, #fff0f5, #ffe4e1);
    color: #d63384; /* 기본 핑크톤 */
    font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    padding: 2rem;
    overflow-x: hidden;
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
    color: #d63384; /* 카드 안 전체 핑크톤으로 */
  }

  body.dark-mode .dashboard-card,
  body.dark-mode .chart-card {
    background-color: #2c2c2e;
    border-color: #3a3a3c;
    color: #f5f5f7;
  }

  .dashboard-card:hover,
  .chart-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 24px rgba(255, 182, 193, 0.3);
  }

  .card-title {
    font-size: 1rem;
    font-weight: 600;
    margin-bottom: 0.75rem;
    text-transform: uppercase;
    text-align: center;
    color: #d63384;
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

  ul.order-status li,
  ul.list-group li,
  .list-group-item {
    color: #d63384;
    font-size: 0.95rem;
    background-color: transparent;
    border: none;
  }

  body.dark-mode ul.order-status li,
  body.dark-mode ul.list-group li,
  body.dark-mode .list-group-item {
    color: #f5f5f7;
  }

  .list-group-item.text-muted {
    color: #bdbdbd;
  }

  body.dark-mode .list-group-item.text-muted {
    color: #888;
  }

  .list-group-item a {
    color: #d63384;
    text-decoration: none;
  }

  .list-group-item a:hover {
    color: #ad1457;
    text-decoration: underline;
  }

  body.dark-mode .list-group-item a {
    color: #f5f5f7;
  }

  body.dark-mode .list-group-item a:hover {
    color: #ff90c2;
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

  .petal {
    position: fixed;
    top: -50px;
    width: 32px;
    height: 32px;
    font-size: 24px;
    line-height: 32px;
    text-align: center;
    color: #ff69b4;
    animation: fall 10s linear infinite;
    z-index: 1000;
    pointer-events: none;
  }

  @keyframes fall {
    0% {
      transform: translateY(-100px) rotate(0deg);
      opacity: 1;
    }
    100% {
      transform: translateY(100vh) rotate(360deg);
      opacity: 0;
    }
  }
</style>




<script>
  document.addEventListener('DOMContentLoaded', function () {
    const petalCount = 20;
    for (let i = 0; i < petalCount; i++) {
      const petal = document.createElement('div');
      petal.className = 'petal';
      petal.textContent = '🌸';
      petal.style.left = Math.random() * 100 + 'vw';
      petal.style.animationDelay = (Math.random() * 10) + 's';
      petal.style.animationDuration = (8 + Math.random() * 5) + 's';
      document.body.appendChild(petal);
    }
  });
</script>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const chart = Highcharts.chart('hourlySalesChart', {
      chart: {
        type: 'areaspline',
        backgroundColor: 'transparent'
      },
      title: {
        text: '',
        style: {
          color: '#d63384',
          fontSize: '20px',
          fontWeight: 'bold'
        }
      },
      xAxis: {
        categories: ["09시", "10시", "11시", "12시", "13시", "14시"],
        labels: {
          style: {
            color: '#c9184a',
            fontWeight: '600'
          }
        }
      },
      yAxis: {
        title: { text: '' },
        labels: {
          formatter: function () {
            return this.value / 1000 + 'k';
          },
          style: {
            color: '#c9184a',
            fontWeight: '600'
          }
        }
      },
      tooltip: {
        valueSuffix: ' 원',
        backgroundColor: '#ffe4e1',
        borderColor: '#d63384',
        style: {
          color: '#4b2c2c'
        }
      },
      plotOptions: {
        areaspline: {
          fillOpacity: 0.4,
          marker: {
            radius: 4,
            fillColor: '#d63384'
          },
          lineWidth: 3
        }
      },
      series: [{
        name: '매출',
        color: '#d63384',
        fillColor: {
          linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
          stops: [
            [0, 'rgba(214, 51, 132, 0.5)'],
            [1, 'rgba(255, 255, 255, 0)']
          ]
        },
        data: []
      }],
      credits: { enabled: false }
    });

    function generateRandomData() {
      return [9, 10, 11, 12, 13, 14].map(() => Math.floor(Math.random() * 30000) + 15000);
    }

    function updateChartData() {
      const newData = generateRandomData();
      chart.series[0].setData(newData, true);
    }

    updateChartData();
    setInterval(updateChartData, 5000);
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
