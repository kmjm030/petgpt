<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1d80cc061f948248f9465d96f87b1f5c&libraries=services"></script>

<div class="container py-4">
  <h1 class="mb-4">실시간 매출 통계</h1>
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="<c:url value='/js/statistics.js'/>"></script>
