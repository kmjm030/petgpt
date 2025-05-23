<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1d80cc061f948248f9465d96f87b1f5c&libraries=services"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500&family=Roboto&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/css/statistics.css">

<body class="statistics-page">

<div class="text-right mt-3 mb-0 pr-4">
  <button id="pdfDownloadBtn" class="btn btn-sm btn-outline-info neon-download-btn">Summary</button>
</div>

<div id="pdfReportArea">
  <div class="container py-4">
    <h1 class="mb-4">Real-Time Sales Statistics</h1>
    <div class="row text-center">
      <div class="col-lg-4 col-md-6 mb-4">
        <div id="dailySalesChart" class="chart-container" style="height: 300px;"></div>
      </div>
      <div class="col-lg-4 col-md-6 mb-4">
        <div id="weeklySalesChart" class="chart-container" style="height: 300px;"></div>
      </div>
      <div class="col-lg-4 col-md-12 mb-4">
        <div id="monthlySalesChart" class="chart-container" style="height: 300px;"></div>
      </div>
    </div>

    <h1 class="mb-4 mt-5">User Registration Statistics</h1>
    <div class="row text-center">
      <div class="col-lg-4 col-md-6 mb-4">
        <div id="dailyUserChart" class="chart-container" style="height: 300px;"></div>
      </div>
      <div class="col-lg-4 col-md-6 mb-4">
        <div id="monthlyUserChart" class="chart-container" style="height: 300px;"></div>
      </div>
      <div class="col-lg-4 col-md-12 mb-4">
        <div id="yearlyUserChart" class="chart-container" style="height: 300px;"></div>
      </div>
    </div>

    <h1 class="mb-4 mt-5">Additional Sales Analysis</h1>
    <div class="row text-center">
      <div class="col-lg-4 col-md-6 mb-4">
        <div id="topProductsChart" class="chart-container" style="height: 300px;"></div>
      </div>
      <div class="col-lg-4 col-md-6 mb-4">
        <div id="hourlySalesChart" class="chart-container" style="height: 300px;"></div>
      </div>
      <div class="col-lg-4 col-md-12 mb-4 d-flex align-items-center justify-content-center">
        <div id="activeUserBox">
          <div class="label">Active Users</div>
          <div class="value-with-unit">
            <span class="value" id="activeUserCount">-</span><span class="unit"> users</span>
          </div>
        </div>
      </div>
    </div>

    <h1 class="mb-4 mt-5">Sales by Region</h1>
    <div id="regionSalesMap" class="chart-container" style="width: 100%; height: 600px;"></div>
  </div>
</div>

<div class="modal fade" id="salesDiffModal" tabindex="-1" role="dialog" aria-labelledby="salesDiffModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="salesDiffModalLabel">Sales Comparison</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="salesDiffModalBody"></div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="<c:url value='/js/statistics.js'/>"></script>

</body>
