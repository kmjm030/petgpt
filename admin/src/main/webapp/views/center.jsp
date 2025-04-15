<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .dashboard-header {
    font-size: 2rem;
    font-weight: 600;
    margin-bottom: 2rem;
    color: #1d1d1f;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  }

  .dashboard-card, .chart-card {
    background: #ffffff;
    border-radius: 20px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.06);
    transition: all 0.3s ease-in-out;
    padding: 1.5rem;
  }

  .dashboard-card:hover, .chart-card:hover {
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
  }

  .card-title {
    font-size: 1rem;
    font-weight: 600;
    color: #0071e3;
    margin-bottom: 0.5rem;
  }

  .card-value {
    font-size: 2rem;
    font-weight: bold;
    color: #1d1d1f;
  }

  ul.order-status {
    padding-left: 1rem;
  }
  ul.order-status li {
    margin-bottom: 0.25rem;
  }
</style>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    Highcharts.chart('highchartContainer', {
      chart: {
        type: 'line'
      },
      title: {
        text: '상품별 판매량'
      },
      subtitle: {
        text: '월별 수익 추이'
      },
      xAxis: {
        categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
      },
      yAxis: {
        title: {
          text: '원 (₩)'
        }
      },
      series: [{
        name: '판매수익',
        data: [29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 176.0, 176.0, 176.0, 176.0, 176.0, 176.0]
      }]
    });
  });
</script>

<div class="container-fluid">
  <div class="dashboard-header">Dashboard</div>

  <!-- 1줄: 통계 카드 (1:1:1:1 비율로 4개) -->
  <div class="row mb-4">
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">총 사용자 수</div>
        <div class="card-value">${custCount}명</div>
      </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">총 상품 수</div>
        <div class="card-value">${itemCount}개</div>
      </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">오늘 가입자 수</div>
        <div class="card-value">${todayJoinCount}명</div>
      </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">총 주문 건수</div>
        <div class="card-value">${orderCount}건</div>
      </div>
    </div>
  </div>

  <!-- 2줄: 매출액 + 배송현황 (2:1 비율) -->
  <div class="row mb-4">
    <div class="col-lg-8 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">오늘 매출</div>
        <div class="card-value">${todayRevenue} 원</div>
      </div>
    </div>

    <div class="col-lg-4 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">배송현황</div>
        <ul class="order-status">
          <li>결제 완료: ${orderStatusMap['결제완료']}</li>
          <li>배송 중: ${orderStatusMap['배송중']}</li>
          <li>배송 완료: ${orderStatusMap['배송완료']}</li>
        </ul>
      </div>
    </div>
  </div>

  <!-- 3줄: 최근 활동 / 차트 -->
  <div class="row mb-4">
    <div class="col-lg-6 mb-4">
      <div class="chart-card">
        <h6 class="card-title">최근 활동 내역, 통계, 로그</h6>
        <div id="live_chart" style="height:300px;"></div>
      </div>
    </div>
    <div class="col-lg-6 mb-4">
      <div class="chart-card">
        <h6 class="card-title">판매량</h6>
        <div id="highchartContainer" style="width:100%; height:300px;"></div>
      </div>
    </div>
  </div>

  <!-- 4줄: 새 문의 게시글 -->
  <div class="row mb-4">
    <div class="col-lg-12 mb-4">
      <div class="dashboard-card">
        <div class="card-title">새 문의글</div>
        <c:forEach var="post" items="${recentPosts}">
          <div>${post.title} - ${post.writer} (${post.regDate})</div>
        </c:forEach>
      </div>
    </div>
  </div>
</div>
