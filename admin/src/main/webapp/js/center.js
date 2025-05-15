function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function drawDailySalesChart() {
  const data = Array.from({ length: 7 }, (_, i) => ({
    date: `05-${i + 7}`,
    total: getRandomInt(100000, 1000000)
  }));

  Highcharts.chart('dailySalesChart', {
    chart: { type: 'line' },
    title: { text: '📈 일별 매출 추이' },
    xAxis: { categories: data.map(d => d.date) },
    yAxis: { title: { text: '매출 (원)' } },
    series: [{ name: '매출', data: data.map(d => d.total) }]
  });
}

function drawCategorySalesChart() {
  const categories = ['의류', '식품', '전자', '가구', '기타'];
  const data = categories.map(c => [c, getRandomInt(100000, 1000000)]);

  Highcharts.chart('categorySalesDonut', {
    chart: { type: 'pie' },
    title: { text: '📊 카테고리별 매출' },
    plotOptions: { pie: { innerSize: '50%' } },
    series: [{ name: '매출', data }]
  });
}

function drawHourlySalesChart() {
  const hours = Array.from({ length: 24 }, (_, i) => `${i}시`);
  const data = hours.map(h => ({ hour: h, total: getRandomInt(0, 200000) }));

  Highcharts.chart('hourlySalesChart', {
    chart: { type: 'area' },
    title: { text: '🕐 시간대별 매출' },
    xAxis: { categories: data.map(d => d.hour) },
    yAxis: { title: { text: '매출 (원)' } },
    series: [{ name: '매출', data: data.map(d => d.total) }]
  });
}

function drawMonthlyCandleChart() {
  const months = ['2025-01', '2025-02', '2025-03', '2025-04', '2025-05'];
  const data = months.map(m => {
    const open = getRandomInt(100000, 500000);
    const close = getRandomInt(100000, 500000);
    const high = Math.max(open, close) + getRandomInt(0, 200000);
    const low = Math.min(open, close) - getRandomInt(0, 200000);
    return [Date.parse(`${m}-01`), open, high, low, close];
  });

  Highcharts.stockChart('monthlyCandleChart', {
    title: { text: '💹 월별 매출 캔들차트' },
    rangeSelector: { enabled: false },
    series: [{
      type: 'candlestick',
      name: '월 매출',
      data
    }]
  });
}

function drawLowStockChart() {
  const categories = ['의류', '식품', '전자', '가구', '기타'];
  const data = categories.map(c => getRandomInt(0, 20));

  Highcharts.chart('lowStockBarChart', {
    chart: { type: 'column' },
    title: { text: '⚠️ 재고 경고 상품 수' },
    xAxis: { categories },
    yAxis: { title: { text: '상품 수' } },
    series: [{ name: '부족 수량', data }]
  });
}
function drawWeeklySalesChart() {
  const weeks = ['1주차', '2주차', '3주차', '4주차'];
  const data = weeks.map(() => getRandomInt(500000, 1500000));

  Highcharts.chart('weeklySalesChart', {
    chart: { type: 'line' },
    title: { text: '📅 주별 매출' },
    xAxis: { categories: weeks },
    yAxis: { title: { text: '매출 (원)' } },
    series: [{ name: '매출', data }]
  });
}

function drawMonthlySalesChart() {
  const months = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
  const data = months.map(() => getRandomInt(1000000, 5000000));

  Highcharts.chart('monthlySalesChart', {
    chart: { type: 'column' },
    title: { text: '🗓️ 월별 매출' },
    xAxis: { categories: months },
    yAxis: { title: { text: '매출 (원)' } },
    series: [{ name: '매출', data }]
  });
}
function drawPaymentMethodChart() {
  const data = [
    ['신용카드', getRandomInt(100000, 500000)],
    ['계좌이체', getRandomInt(100000, 500000)],
    ['간편결제', getRandomInt(100000, 500000)],
    ['기타', getRandomInt(10000, 100000)]
  ];

  Highcharts.chart('paymentMethodChart', {
    chart: { type: 'pie' },
    title: { text: '💳 결제 수단별 매출' },
    plotOptions: { pie: { innerSize: '50%' } },
    series: [{ name: '매출', data }]
  });
}

function drawDeliveryStatusChart() {
  const data = [
    ['결제 완료', getRandomInt(10, 50)],
    ['배송 중', getRandomInt(10, 50)],
    ['배송 완료', getRandomInt(10, 50)]
  ];

  Highcharts.chart('deliveryStatusChart', {
    chart: { type: 'pie' },
    title: { text: '🚚 배송 상태별 주문 비율' },
    plotOptions: { pie: { dataLabels: { enabled: true, format: '{point.name}: {point.y}' } } },
    series: [{ name: '주문 수', data }]
  });
}

function drawPriceRangeChart() {
  const categories = ['~1만원', '1~5만원', '5~10만원', '10만원~'];
  const data = categories.map(() => getRandomInt(10, 100));

  Highcharts.chart('priceRangeChart', {
    chart: { type: 'column' },
    title: { text: '💸 가격대별 판매량' },
    xAxis: { categories },
    yAxis: { title: { text: '판매량 (개)' } },
    series: [{ name: '판매 수량', data }]
  });
}
function drawCategoryStockChart() {
  const categories = ['의류', '식품', '전자', '가구', '기타'];
  const data = categories.map(() => getRandomInt(100, 1000));

  Highcharts.chart('categoryStockChart', {
    chart: { type: 'column' },
    title: { text: '📦 카테고리별 재고량' },
    xAxis: { categories },
    yAxis: { title: { text: '재고 수량 (개)' } },
    series: [{ name: '재고량', data }]
  });
}

function drawMonthlySignupChart() {
  const months = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
  const data = months.map(() => getRandomInt(50, 300));

  Highcharts.chart('monthlySignupChart', {
    chart: { type: 'line' },
    title: { text: '📈 월별 신규 가입자 수' },
    xAxis: { categories: months },
    yAxis: { title: { text: '가입자 수 (명)' } },
    series: [{ name: '신규 가입자', data }]
  });
}

function drawCartConversionChart() {
  const added = getRandomInt(100, 300);
  const purchased = getRandomInt(50, added);
  const conversionRate = ((purchased / added) * 100).toFixed(1);

  Highcharts.chart('cartConversionChart', {
    chart: { type: 'column' },
    title: { text: `🛒 장바구니→구매 전환율: ${conversionRate}%` },
    xAxis: { categories: ['장바구니 담은 수', '구매 수'] },
    yAxis: { title: { text: '건수' } },
    series: [{
      name: '건수',
      data: [added, purchased],
      colorByPoint: true
    }]
  });
}
function drawSalesMap() {
  const container = document.getElementById('salesMap');
  const map = new kakao.maps.Map(container, {
    center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울
    level: 7
  });

  const geocoder = new kakao.maps.services.Geocoder();
  const regionSales = [
    '서울 강남구', '서울 마포구', '부산 해운대구', '대구 수성구',
    '광주 북구', '대전 유성구', '인천 연수구', '울산 남구'
  ];

  regionSales.forEach(region => {
    const sales = Math.floor(Math.random() * 3000000) + 500000;
    geocoder.addressSearch(region, function(result, status) {
      if (status === kakao.maps.services.Status.OK) {
        const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
        const circle = new kakao.maps.Circle({
          center: coords,
          radius: 2000 + sales / 10000,
          strokeWeight: 1,
          strokeColor: '#004f9e',
          strokeOpacity: 0.7,
          fillColor: '#00aaff',
          fillOpacity: 0.4
        });
        circle.setMap(map);

        const infowindow = new kakao.maps.InfoWindow({
          content: `<div style="padding:5px;font-size:14px;"><strong>${region}</strong><br>매출: ${sales.toLocaleString()}원</div>`
        });
        kakao.maps.event.addListener(circle, 'click', function() {
          infowindow.open(map, circle);
        });
      }
    });
  });
}
function drawUserHeatmap() {
  const map = L.map('userHeatmap').setView([37.5665, 126.9780], 11);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap'
  }).addTo(map);

  const heatPoints = Array.from({ length: 100 }, () => {
    const lat = 37.4 + Math.random() * 0.3;
    const lng = 126.8 + Math.random() * 0.4;
    return [lat, lng, 0.6];
  });

  L.heatLayer(heatPoints, { radius: 25 }).addTo(map);
}

function refreshAllCharts() {
  drawDailySalesChart();
  drawWeeklySalesChart();
  drawMonthlySalesChart();
  drawCategorySalesChart();
  drawHourlySalesChart();
  drawMonthlyCandleChart();
  drawLowStockChart();
  drawPaymentMethodChart();
  drawDeliveryStatusChart();
  drawPriceRangeChart();
  drawCategoryStockChart();
  drawMonthlySignupChart();
  drawCartConversionChart();
  drawSalesMap();
  drawUserHeatmap();

}


document.addEventListener('DOMContentLoaded', () => {
  const petalCount = 20;
  for (let i = 0; i < petalCount; i++) {
    const petal = document.createElement('div');
    petal.className = 'petal';
    petal.textContent = '🌸';
    petal.style.left = Math.random() * 100 + 'vw';
    petal.style.animationDelay = (Math.random() * 10) + 's';
    petal.style.animationDuration = (8 + Math.random() * 5) + 's';
    document.body.appendChild(petal);
  }

  const orderItems = document.querySelectorAll('.recent-order-item');
  orderItems.forEach(item => {
    item.addEventListener('click', (e) => {
      e.stopPropagation();
      document.getElementById('modalOrderKey').innerText = item.dataset.orderkey;
      document.getElementById('modalCustId').innerText = item.dataset.custid;
      document.getElementById('modalStatus').innerText = item.dataset.status;
      document.getElementById('modalDate').innerText = item.dataset.date;
      document.getElementById('modalTotalPrice').innerText = item.dataset.totalprice;

      const orderDetailModal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
      orderDetailModal.show();
    });
  });

  refreshAllCharts();
  setInterval(refreshAllCharts, 8000);
});

