<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

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
      <div class="modal-body" id="salesDiffModalBody">
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="<c:url value='/js/statistics.js'/>"></script>
