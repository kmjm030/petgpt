<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ✅ 메인 콘텐츠만 출력하는 center.jsp -->

<canvas id="matrix-background"></canvas>

<style>
  #matrix-background {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    z-index: 0;
    pointer-events: none;
    background-color: transparent;
    opacity: 0.15;
  }

  .container-fluid {
    position: relative;
    z-index: 1;
    background-color: transparent !important;
    color: #00ff41;
    font-family: 'Share Tech Mono', monospace;
  }

  .dashboard-header {
    font-size: 2.5rem;
    font-weight: bold;
    color: #00ff41;
    margin-bottom: 2rem;
    text-shadow: 0 0 10px #00ff41;
  }

  .dashboard-card, .chart-card {
    background: rgba(0, 0, 0, 0.6);
    border: 1px solid #00ff41;
    border-radius: 12px;
    box-shadow: 0 0 10px #00ff41;
    padding: 1.5rem;
    transition: all 0.3s ease-in-out;
    color: #00ff41;
  }

  .dashboard-card:hover, .chart-card:hover {
    box-shadow: 0 0 20px #00ff41;
  }

  .card-title {
    font-size: 1.1rem;
    font-weight: bold;
    color: #00ff41;
    margin-bottom: 0.5rem;
    text-transform: uppercase;
  }

  .card-value {
    font-size: 2rem;
    font-weight: bold;
    color: #00ff41;
    text-shadow: 0 0 5px #00ff41;
  }

  ul.order-status {
    padding-left: 1rem;
  }

  ul.order-status li {
    margin-bottom: 0.25rem;
    color: #00ff41;
  }
</style>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    const isFirstVisit = sessionStorage.getItem("visited_center");
    const canvas = document.getElementById("matrix-background");
    const ctx = canvas.getContext("2d");

    function resizeCanvas() {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }

    if (!isFirstVisit) {
      sessionStorage.setItem("visited_center", "true");
      resizeCanvas();
      window.addEventListener("resize", resizeCanvas);

      const letters = "アァイィウヴエェオカキクケコサシスセソABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
      const fontSize = 18;
      const columns = Math.floor(window.innerWidth / fontSize);
      const drops = Array(columns).fill(1);

      function draw() {
        ctx.fillStyle = "rgba(0, 0, 0, 0.03)";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        ctx.fillStyle = "#00ff41";
        ctx.shadowColor = "#00ff41";
        ctx.shadowBlur = 30;
        ctx.font = fontSize + "px monospace";

        for (let i = 0; i < drops.length; i++) {
          const text = letters.charAt(Math.floor(Math.random() * letters.length));
          ctx.fillText(text, i * fontSize, drops[i] * fontSize);

          if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) {
            drops[i] = 0;
          }
          drops[i]++;
        }
      }

      setInterval(draw, 33);
    } else {
      canvas.remove();
    }
  });
</script>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    Highcharts.chart('highchartContainer', {
      chart: {
        type: 'line',
        backgroundColor: 'transparent',
        style: { fontFamily: 'Share Tech Mono' }
      },
      title: {
        text: '상품별 판매량',
        style: { color: '#00ff41' }
      },
      subtitle: {
        text: '월별 수익 추이',
        style: { color: '#00ff41' }
      },
      xAxis: {
        categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
        labels: { style: { color: '#00ff41' } },
        lineColor: '#00ff41'
      },
      yAxis: {
        title: {
          text: '원 (₩)',
          style: { color: '#00ff41' }
        },
        labels: { style: { color: '#00ff41' } },
        gridLineColor: '#003300'
      },
      series: [{
        name: '판매수익',
        data: [29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 160.0, 148.0, 132.0, 165.0, 178.0, 190.0],
        color: '#00ff41'
      }],
      legend: {
        itemStyle: { color: '#00ff41' }
      }
    });
  });
</script>

<div class="container-fluid">
  <div class="dashboard-header">Dashboard</div>

  <div class="row mb-4">
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">총 사용자 수</div>
        <div class="card-value">${custCount} 명</div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">총 상품 수</div>
        <div class="card-value">${itemCount} 개</div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">오늘 가입자 수</div>
        <div class="card-value">${todayJoinCount} 명</div>
      </div>
    </div>
    <div class="col-lg-3 col-md-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">총 주문 건수</div>
        <div class="card-value">${orderCount} 건</div>
      </div>
    </div>
  </div>

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
