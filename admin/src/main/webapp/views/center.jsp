<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  body, .container-fluid {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    background-color: #f5f5f7;
    color: #1d1d1f;
    margin: 0;
    padding: 2rem;
  }

  .dashboard-header {
    font-size: 2.5rem;
    font-weight: 600;
    margin-bottom: 2rem;
    color: #1d1d1f;
  }

  .dashboard-card, .chart-card {
    background-color: white;
    border: 1px solid #e0e0e0;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    padding: 1.5rem;
    transition: box-shadow 0.3s ease-in-out;
  }

  .dashboard-card:hover, .chart-card:hover {
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
    color: #1d1d1f;
  }

  ul.order-status {
    padding-left: 1rem;
    list-style: none;
  }

  ul.order-status li {
    margin-bottom: 0.25rem;
    color: #1d1d1f;
  }
</style>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    Highcharts.chart('highchartContainer', {
      chart: {
        type: 'line',
        backgroundColor: 'transparent',
        style: { fontFamily: '-apple-system, BlinkMacSystemFont' }
      },
      title: {
        text: '월별 매출'
      },
      xAxis: {
        categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
      },
      yAxis: {
        title: {
          text: '단위: 원 (₩)'
        }
      },
      series: [{
        name: '매출액',
        data: [29.9, 71.5, 106.4, 129.2, 144.0, 176.0, 160.0, 148.0, 132.0, 165.0, 178.0, 190.0]
      }]
    });

    // 메시지 대상 토글
    const sendToSelect = document.getElementById('sendToSelect');
    const targetInput = document.getElementById('targetInput');
    if (sendToSelect) {
      sendToSelect.addEventListener('change', function () {
        targetInput.style.display = this.value === 'individual' ? 'block' : 'none';
      });
    }
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
      <div class="chart-card">
        <h6 class="card-title">상품 판매 TOP 10</h6>
        <ul class="list-group list-group-flush" style="font-size: 0.95rem;">
          <c:forEach var="item" items="${topItemList}" varStatus="i">
            <li class="list-group-item d-flex justify-content-between align-items-center"
                style="background-color: transparent; color: #1d1d1f;">
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
        <h6 class="card-title">매출 추이</h6>
        <div id="highchartContainer" style="width:100%; height:300px;"></div>
      </div>
    </div>
  </div>

  <!-- ✅ 회원 메시지 전송 카드 -->
  <div class="row mb-4">
    <div class="col-lg-6 mb-4">
      <div class="dashboard-card h-100">
        <div class="card-title">회원 메시지 전송</div>
        <form method="post" action="/admin/message/send">
          <label for="sendToSelect">수신 대상</label>
          <select id="sendToSelect" name="sendTo"
                  style="width: 100%; padding: 0.6rem; margin-bottom: 1rem; border-radius: 8px; border: 1px solid #ccc;">
            <option value="all">전체 회원</option>
            <option value="individual">특정 회원</option>
          </select>

          <input type="text" name="targetMemberId" id="targetInput"
                 placeholder="회원 ID 입력"
                 style="width: 100%; padding: 0.6rem; margin-bottom: 1rem; border-radius: 8px; border: 1px solid #ccc; display: none;">

          <label for="messageContent">메시지 내용</label>
          <textarea name="messageContent" rows="4"
                    style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid #ccc; margin-bottom: 1rem;"
                    placeholder="보낼 메시지를 입력하세요"></textarea>

          <button type="submit"
                  style="background-color: #1d1d1f; color: white; padding: 0.5rem 1.5rem; border: none; border-radius: 8px; cursor: pointer;">
            전송
          </button>
        </form>
      </div>
    </div>
  </div>
</div>
