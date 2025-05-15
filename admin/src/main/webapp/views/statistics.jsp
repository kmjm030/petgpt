<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>매출 통계</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://code.highcharts.com/highcharts.js"></script>
</head>
<body class="container py-4">

<h1 class="mb-4">📊 실시간 매출 통계</h1>

<div class="row text-center">
  <div class="col-lg-4 col-md-12 mb-4">
    <div id="dailySalesChart" style="height: 300px;"></div>
  </div>
  <div class="col-lg-4 col-md-12 mb-4">
    <div id="weeklySalesChart" style="height: 300px;"></div>
  </div>
  <div class="col-lg-4 col-md-12 mb-4">
    <div id="monthlySalesChart" style="height: 300px;"></div>
  </div>
</div>


<script src="<c:url value='/js/statistics.js'/>"></script>
</body>
</html>
