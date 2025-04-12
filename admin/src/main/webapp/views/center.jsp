<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>

  $(function(){

  });
</script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    Highcharts.chart('highchartContainer', {
      chart: {
        type: 'line'  // 원하는 차트 유형 (예: line, bar, pie 등)
      },
      title: {
        text: '상품별 판매량 '
      },
      subtitle: {
        text: 'Sample Subtitle'
      },
      xAxis: {
        categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
      },
      yAxis: {
        title: {
          text: '원(Won)'
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

  <!-- Page Heading -->
  <div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
    <a href="#" class="d-none d-sm-inline-block btn btn-sm btn-dark shadow-sm"><i
            class="fas fa-download fa-sm text-white-50"></i> 그래서 이건 뭐죠?(보고서생성?)</a>
  </div>

  <!-- Content Row -->
  <div class="row">

    <!-- Earnings (Monthly) Card Example -->
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card dashboard-card border-left-primary shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">총 사용자 수</div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">1,234</div>
            </div>
            <div class="col-auto">
              <i class="fas fa-users fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card dashboard-card border-left-primary shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">총 사용자 수</div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">1,234</div>
            </div>
            <div class="col-auto">
              <i class="fas fa-users fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card dashboard-card border-left-success shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div class="text-xs font-weight-bold text-success text-uppercase mb-1">신규 주문</div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">567</div>
            </div>
            <div class="col-auto">
              <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
      <div class="card dashboard-card border-left-success shadow h-100 py-2">
        <div class="card-body">
          <div class="row no-gutters align-items-center">
            <div class="col mr-2">
              <div class="text-xs font-weight-bold text-success text-uppercase mb-1">신규 주문</div>
              <div class="h5 mb-0 font-weight-bold text-gray-800">567</div>
            </div>
            <div class="col-auto">
              <i class="fas fa-shopping-cart fa-2x text-gray-300"></i>
            </div>
          </div>
        </div>
      </div>
    </div>


  </div>

  <!-- Content Row -->

  <div class="row">

    <!-- Area Chart -->
    <div class="col-xl-8 col-lg-7">
      <div class="card shadow mb-4">
        <!-- Card Header - Dropdown -->
        <div
                class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary">여기에 최근 활동 내역, 통계, 로그 등을 표시할 수 있습니다.</h6>
        </div>
        <!-- Card Body -->
        <div class="card-body">
          <div id="live_chart">

          </div>
        </div>
      </div>
    </div>

    <!-- Pie Chart -->
    <div class="col-xl-4 col-lg-5">
      <div class="card shadow mb-4">
        <!-- Card Header - Dropdown -->
        <div
                class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
          <h6 class="m-0 font-weight-bold text-primary"> 판매량</h6>
          <div class="dropdown no-arrow">
            <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink"
               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in"
                 aria-labelledby="dropdownMenuLink">
              <div class="dropdown-header">Dropdown Header:</div>
              <a class="dropdown-item" href="#">Action</a>
              <a class="dropdown-item" href="#">Another action</a>
              <div class="dropdown-divider"></div>
              <a class="dropdown-item" href="#">Something else here</a>
            </div>
          </div>
        </div>
        <!-- Card Body -->
        <!-- 대시보드 카드 내 Highcharts 차트 예제 -->
        <div class="card shadow mb-4">
          <div class="card-body">
            <!-- 차트를 렌더링할 컨테이너 -->
            <div id="highchartContainer" style="width:100%; height:400px;"></div>

          </div>
        </div>
      </div>
    </div>
  </div>



</div>