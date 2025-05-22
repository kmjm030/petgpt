<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- CSS/JS 라이브러리 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1d80cc061f948248f9465d96f87b1f5c&libraries=services"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

<div class="container py-4">
  <h1 class="mb-4">실시간 매출 통계</h1>

  <!-- ✅ 월별 매출 제목 + 버튼 줄 추가 -->
  <div class="d-flex justify-content-between align-items-center mb-2 mt-4 px-1">
    <h5 class="mb-0 font-weight-bold">월별 매출</h5>
    <button id="openSummaryModal" class="btn btn-sm btn-outline-primary">
      📋 요약 보고서
    </button>
  </div>

  <div class="row text-center">
    <div class="col-lg-4 col-md-6 mb-4">
      <div id="dailySalesChart" style="height: 300px;"></div>
    </div>
    <div class="col-lg-4 col-md-6 mb-4">
      <div id="weeklySalesChart" style="height: 300px;"></div>
    </div>
    <div class="col-lg-4 col-md-12 mb-4">
      <div id="monthlySalesChart" style="height: 300px;"></div>
    </div>
  </div>

  <h1 class="mb-4 mt-5">가입자 통계</h1>
  <div class="row text-center">
    <div class="col-lg-4 col-md-6 mb-4">
      <div id="dailyUserChart" style="height: 300px;"></div>
    </div>
    <div class="col-lg-4 col-md-6 mb-4">
      <div id="monthlyUserChart" style="height: 300px;"></div>
    </div>
    <div class="col-lg-4 col-md-12 mb-4">
      <div id="yearlyUserChart" style="height: 300px;"></div>
    </div>
  </div>

  <h1 class="mb-4 mt-5">추가 매출 분석</h1>
  <div class="row text-center">
    <div class="col-lg-4 col-md-6 mb-4">
      <div id="topProductsChart" style="height: 300px;"></div>
    </div>
    <div class="col-lg-4 col-md-6 mb-4">
      <div id="hourlySalesChart" style="height: 300px;"></div>
    </div>
    <div class="col-lg-4 col-md-12 mb-4 d-flex align-items-center justify-content-center">
      <div id="activeUserBox" style="width: 100%; background: #e9f7ef; border-left: 5px solid #28a745; padding: 20px; font-weight: bold; font-size: 1.2rem;">
        현재 접속자 수: <span id="activeUserCount">-</span> 명
      </div>
    </div>
  </div>

  <h1 class="mb-4 mt-5">지역별 매출 분포</h1>
  <div id="regionSalesMap" style="width: 100%; height: 600px;"></div>
</div>

<!-- 매출 비교용 모달 -->
<div class="modal fade" id="salesDiffModal" tabindex="-1" role="dialog" aria-labelledby="salesDiffModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="salesDiffModalLabel">매출 비교</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="salesDiffModalBody"></div>
    </div>
  </div>
</div>

<!-- 요약 보고서 모달 -->
<div class="modal fade" id="summaryModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">📋 관리자 요약 보고서</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="summaryModalBody">
        <p>로딩 중...</p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">닫기</button>
        <button class="btn btn-outline-primary" onclick="printSummary()">🖨️ 인쇄</button>
        <button class="btn btn-outline-success" onclick="downloadSummaryAsPDF()">📥 PDF 다운로드</button>
      </div>
    </div>
  </div>
</div>

<!-- 스크립트 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="<c:url value='/js/statistics.js'/>"></script>

<!-- 요약 보고서 로직 -->
<script>
  document.getElementById('openSummaryModal').addEventListener('click', () => {
    const modal = new bootstrap.Modal(document.getElementById('summaryModal'));
    modal.show();

    Promise.all([
      fetch('/api/sales/summary').then(res => res.json()),
      fetch('/api/users/summary').then(res => res.json())
    ])
      .then(([sales, users]) => {
        const body = document.getElementById('summaryModalBody');
        body.innerHTML = `
    <h6>📈 매출 요약</h6>
    <table class="table table-bordered">
      <tr><th>오늘</th><td>${sales.today != null ? Number(sales.today).toLocaleString() : '0'} 원</td></tr>
      <tr><th>이번 주</th><td>${sales.week != null ? Number(sales.week).toLocaleString() : '0'} 원</td></tr>
      <tr><th>이번 달</th><td>${sales.month != null ? Number(sales.month).toLocaleString() : '0'} 원</td></tr>
    </table>

    <h6>👥 가입자 요약</h6>
    <table class="table table-bordered">
      <tr><th>오늘</th><td>${users.today != null ? Number(users.today).toLocaleString() : '0'} 명</td></tr>
      <tr><th>이번 주</th><td>${users.week != null ? Number(users.week).toLocaleString() : '0'} 명</td></tr>
      <tr><th>이번 달</th><td>${users.month != null ? Number(users.month).toLocaleString() : '0'} 명</td></tr>
    </table>
  `;
      })

      .catch(err => {
        console.error('[요약 보고서] 로딩 실패:', err);
        document.getElementById('summaryModalBody').innerHTML = `<p class="text-danger">데이터를 불러오는 데 실패했습니다.</p>`;
      });
  });

  function printSummary() {
    const printContents = document.getElementById('summaryModalBody').innerHTML;
    const printWindow = window.open('', '', 'width=800,height=600');
    printWindow.document.write(`
      <html>
        <head>
          <title>요약 보고서</title>
          <style>
            body { font-family: sans-serif; padding: 20px; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
            th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
          </style>
        </head>
        <body>
          <h2>📋 관리자 요약 보고서</h2>
          ${printContents}
        </body>
      </html>
    `);
    printWindow.document.close();
    printWindow.focus();
    printWindow.print();
    printWindow.close();
  }

  function downloadSummaryAsPDF() {
    const element = document.getElementById('summaryModalBody');
    const opt = {
      margin:       0.5,
      filename:     '요약_보고서.pdf',
      image:        { type: 'jpeg', quality: 0.98 },
      html2canvas:  { scale: 2 },
      jsPDF:        { unit: 'in', format: 'a4', orientation: 'portrait' }
    };
    html2pdf().from(element).set(opt).save();
  }
</script>
