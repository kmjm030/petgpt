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

  .dashboard-card {
    background: #ffffff;
    border-radius: 20px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.06);
    transition: all 0.3s ease-in-out;
  }

  .dashboard-card:hover {
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
  }

  .dashboard-card .card-body {
    padding: 1.5rem;
  }

  .card-title {
    font-size: 1rem;
    font-weight: 600;
    color: #0071e3;
  }

  .card-value {
    font-size: 2rem;
    font-weight: bold;
    color: #1d1d1f;
    margin-top: 0.5rem;
  }

  .chart-card {
    background: #ffffff;
    border-radius: 20px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.06);
    padding: 1.5rem;
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

  <div class="row mb-4">
    <!-- 총 사용자 수 카드 -->
    <div class="col-xl-6 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-body">
          <div class="card-title">총 사용자 수</div>
          <div class="card-value">${custCount}</div>
        </div>
      </div>
    </div>

    <!-- 총 상품 수 카드 -->
    <div class="col-xl-6 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-body">
          <div class="card-title">총 상품 수</div>
          <div class="card-value">${itemCount}</div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-xl-4 col-md-6 mb-4">
    <div class="dashboard-card h-100">
      <div class="card-body">
        <div class="card-title">오늘 가입자 수</div>
        <div class="card-value">${todayJoinCount}</div>
      </div>
    </div>
  </div>

  <div class="col-xl-4 col-md-6 mb-4">
    <div class="dashboard-card h-100">
      <div class="card-body">
        <div class="card-title">총 주문 건수</div>
        <div class="card-value">${orderCount}</div>
      </div>
    </div>
  </div>

  <div class="row">
    <!-- 최근 활동 -->
    <div class="col-xl-6 col-lg-6 mb-4">
      <div class="chart-card">
        <h6 class="card-title">최근 활동 내역, 통계, 로그</h6>
        <div id="live_chart" style="height:300px;"></div>
      </div>
    </div>

    <!-- 판매량 차트 -->
    <div class="col-xl-6 col-lg-6 mb-4">
      <div class="chart-card">
        <h6 class="card-title">판매량</h6>
        <div id="highchartContainer" style="width:100%; height:300px;"></div>
      </div>
    </div>
  </div>
</div>