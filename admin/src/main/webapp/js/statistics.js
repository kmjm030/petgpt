function fillMissingDays(data) {
  const filled = [];
  const today = new Date();
  for (let i = 6; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(today.getDate() - i);
    const label = date.toISOString().slice(0, 10);
    const found = data.find(d => d.label === label);
    filled.push({ label, total_sales: found ? found.total_sales : 0 });
  }
  return filled;
}

function fillMissingWeeks(data) {
  const filled = [];
  const now = new Date();
  for (let i = 3; i >= 0; i--) {
    const weekDate = new Date(now);
    weekDate.setDate(weekDate.getDate() - (i * 7));
    const year = weekDate.getFullYear();
    const week = getISOWeek(weekDate);
    const label = `${year}-W${week.toString().padStart(2, '0')}`;
    const found = data.find(d => d.label === label);
    filled.push({ label, total_sales: found ? found.total_sales : 0 });
  }
  return filled;
}

function getISOWeek(date) {
  const temp = new Date(date.getTime());
  temp.setHours(0, 0, 0, 0);
  temp.setDate(temp.getDate() + 3 - ((temp.getDay() + 6) % 7));
  const week1 = new Date(temp.getFullYear(), 0, 4);
  return 1 + Math.round(((temp - week1) / 86400000 - 3 + ((week1.getDay() + 6) % 7)) / 7);
}

function fillMissingRecentMonths(data) {
  const filled = [];
  const now = new Date();
  for (let i = 0; i < 6; i++) {
    const date = new Date(now.getFullYear(), now.getMonth() - (4 - i));
    const label = date.toISOString().slice(0, 7); // YYYY-MM
    const found = data.find(d => d.label === label);
    filled.push({ label, total_sales: found ? found.total_sales : 0 });
  }
  return filled;
}

function drawSalesChart(apiUrl, containerId, title) {
  fetch(apiUrl)
    .then(response => response.json())
    .then(raw => {
      let data = raw;

      if (containerId === 'dailySalesChart') {
        data = fillMissingDays(data);
      } else if (containerId === 'weeklySalesChart') {
        data = fillMissingWeeks(data);
      } else if (containerId === 'monthlySalesChart') {
        data = fillMissingRecentMonths(data);
      }

      Highcharts.chart(containerId, {
        chart: { type: 'line' },
        title: { text: title },
        xAxis: {
          categories: data.map(d => d.label),
          labels: { style: { fontWeight: 'bold' } }
        },
        yAxis: {
          title: { text: '매출 (원)' },
          labels: {
            formatter() {
              return this.value.toLocaleString();
            }
          }
        },
        tooltip: {
          valueSuffix: ' 원',
          valueDecimals: 0,
          shared: true
        },
        series: [{
          name: '매출',
          data: data.map((d, i) => ({
            y: d.total_sales,
            label: d.label,
            index: i
          })),
          color: '#007bff',
          point: {
            events: {
              click: function () {
                const current = this.y;
                const prev = this.series.data[this.index - 1];
                let content;
                if (prev) {
                  const diff = current - prev.y;
                  const rate = ((diff / prev.y) * 100).toFixed(1);
                  const sign = diff >= 0 ? '▲' : '▼';
                  content = `
                    <p><strong>${this.label}</strong> 매출: ${current.toLocaleString()}원</p>
                    <p>이전 대비: <span style="color:${diff >= 0 ? 'green' : 'red'}">
                      ${sign} ${Math.abs(diff).toLocaleString()}원 (${Math.abs(rate)}%)
                    </span></p>`;
                } else {
                  content = `<p><strong>${this.label}</strong> 매출: ${current.toLocaleString()}원</p>
                             <p>이전 데이터가 없어 비교할 수 없습니다.</p>`;
                }
                document.getElementById('salesDiffModalBody').innerHTML = content;
                $('#salesDiffModal').modal('show');
              }
            }
          }
        }],
        credits: { enabled: false }
      });
    })
    .catch(err => console.error(`[${containerId}] 차트 불러오기 실패:`, err));
}

function fillMissingMonths(data) {
  const filled = [];
  const now = new Date();
  for (let i = 0; i < 12; i++) {
    const date = new Date(now.getFullYear(), i);
    const label = date.toISOString().slice(0, 7);
    const found = data.find(d => d.label === label);
    filled.push({ label, count: found ? found.count : 0 });
  }
  return filled;
}

function fillMissingYears(data) {
  const filled = [];
  const thisYear = new Date().getFullYear();
  for (let y = thisYear - 4; y <= thisYear; y++) {
    const label = String(y);
    const found = data.find(d => d.label === label);
    filled.push({ label, count: found ? found.count : 0 });
  }
  return filled;
}

function drawUserChart(apiUrl, containerId, title) {
  fetch(apiUrl)
    .then(response => response.json())
    .then(data => {
      if (containerId === 'dailyUserChart') {
        data = fillMissingDays(data.map(d => ({ label: d.label, total_sales: d.count })))
          .map(d => ({ label: d.label, count: d.total_sales }));
      } else if (containerId === 'monthlyUserChart') {
        data = fillMissingMonths(data);
      } else if (containerId === 'yearlyUserChart') {
        data = fillMissingYears(data);
      }

      Highcharts.chart(containerId, {
        chart: { type: 'column' },
        title: { text: title },
        xAxis: {
          categories: data.map(d => d.label),
          labels: { style: { fontWeight: 'bold' } }
        },
        yAxis: {
          title: { text: '가입자 수' },
          allowDecimals: false
        },
        tooltip: {
          valueSuffix: ' 명',
          shared: true
        },
        series: [{
          name: '가입자 수',
          data: data.map((d, i) => ({
            y: d.count,
            label: d.label,
            index: i
          })),
          color: '#28a745',
          point: {
            events: {
              click: function () {
                const current = this.y;
                const prev = this.series.data[this.index - 1];
                let content;
                if (prev) {
                  const diff = current - prev.y;
                  const rate = ((diff / prev.y) * 100).toFixed(1);
                  const sign = diff >= 0 ? '▲' : '▼';
                  content = `
                    <p><strong>${this.label}</strong> 가입자 수: ${current.toLocaleString()}명</p>
                    <p>이전 대비: <span style="color:${diff >= 0 ? 'green' : 'red'}">
                      ${sign} ${Math.abs(diff).toLocaleString()}명 (${Math.abs(rate)}%)
                    </span></p>`;
                } else {
                  content = `<p><strong>${this.label}</strong> 가입자 수: ${current.toLocaleString()}명</p>
                             <p>이전 데이터가 없어 비교할 수 없습니다.</p>`;
                }
                document.getElementById('salesDiffModalBody').innerHTML = content;
                $('#salesDiffModal').modal('show');
              }
            }
          }
        }],
        credits: { enabled: false }
      });
    })
    .catch(err => console.error(`[${containerId}] 가입자 차트 실패:`, err));
}
function drawRegionSalesMap() {
  fetch('/api/sales/region')
    .then(res => res.json())
    .then(data => {
      if (!Array.isArray(data)) {
        console.error('[지역 매출 지도] 받은 데이터가 배열이 아님:', data);
        return;
      }

      const map = new kakao.maps.Map(document.getElementById('regionSalesMap'), {
        center: new kakao.maps.LatLng(36.5, 127.5),
        level: 13
      });

      const geocoder = new kakao.maps.services.Geocoder();
      let openInfoWindow = null;

      data.forEach(region => {
        geocoder.addressSearch(region.region, (result, status) => {
          if (status === kakao.maps.services.Status.OK) {
            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            const marker = new kakao.maps.Marker({ map: map, position: coords });

            const sales = region.total_sales.toLocaleString();
            const infowindow = new kakao.maps.InfoWindow({
              content: `<div style="padding:5px;font-weight:bold;">
                          ${region.region}<br/>매출: ${sales}원
                        </div>`
            });

            kakao.maps.event.addListener(marker, 'click', () => {
              if (openInfoWindow === infowindow) {
                infowindow.close();
                openInfoWindow = null;
              } else {
                if (openInfoWindow) openInfoWindow.close();
                infowindow.open(map, marker);
                openInfoWindow = infowindow;
              }
            });
          }
        });
      });
    })
    .catch(err => console.error('[지역 매출 지도] 로딩 실패:', err));
}

function drawTopProductsChart() {
  fetch('/api/sales/top-products?limit=5')
    .then(res => res.json())
    .then(data => {
      if (!Array.isArray(data)) {
        console.error('[상품별 매출] API 응답이 배열이 아님:', data);
        return;
      }

      Highcharts.chart('topProductsChart', {
        chart: { type: 'bar' },
        title: { text: '상품별 매출 TOP 5' },
        xAxis: {
          categories: data.map(p => p.product_name),
          title: { text: null }
        },
        yAxis: {
          min: 0,
          title: { text: '매출 (원)', align: 'high' },
          labels: { overflow: 'justify' }
        },
        tooltip: {
          valueSuffix: ' 원',
          valueDecimals: 0
        },
        plotOptions: {
          bar: {
            dataLabels: {
              enabled: true,
              format: '{point.y:,.0f} 원'
            }
          }
        },
        series: [{
          name: '매출',
          data: data.map(p => p.total_sales),
          color: '#ffc107'
        }],
        credits: { enabled: false }
      });
    })
    .catch(err => console.error('[상품별 매출] 로딩 실패:', err));
}

function drawHourlySalesChart() {
  fetch('/api/sales/hourly')
    .then(res => res.json())
    .then(data => {
      if (!Array.isArray(data)) {
        console.error('[시간대별 매출] 응답이 배열이 아님:', data);
        return;
      }

      const now = new Date();
      const currentHour = now.getHours();
      const recentHours = [];

      for (let i = 5; i >= 0; i--) {
        recentHours.push((currentHour - i + 24) % 24);
      }

      const filled = recentHours.map(hour => {
        const found = data.find(d => d.hour === hour);
        return {
          hour,
          total_sales: found ? found.total_sales : 0
        };
      });

      Highcharts.chart('hourlySalesChart', {
        chart: { type: 'line' },
        title: { text: '최근 6시간 매출' },
        xAxis: {
          categories: filled.map(d => `${d.hour}시`),
          labels: { style: { fontWeight: 'bold' } }
        },
        yAxis: {
          title: { text: '매출 (원)' },
          labels: {
            formatter() {
              return this.value.toLocaleString();
            }
          }
        },
        tooltip: {
          valueSuffix: ' 원',
          shared: true
        },
        series: [{
          name: '매출',
          data: filled.map(d => d.total_sales),
          color: '#17a2b8'
        }],
        credits: { enabled: false }
      });
    })
    .catch(err => console.error('[시간대별 매출] 로딩 실패:', err));
}

function updateActiveUsers() {
  fetch('/api/traffic/active-users')
    .then(res => res.json())
    .then(data => {
      document.getElementById('activeUserCount').innerText = data.count.toLocaleString();
    })
    .catch(err => console.error('[실시간 접속자] 로딩 실패:', err));
}

setInterval(updateActiveUsers, 10000);

document.addEventListener('DOMContentLoaded', () => {
  drawSalesChart('/api/sales/daily', 'dailySalesChart', '일별 매출');
  drawSalesChart('/api/sales/weekly', 'weeklySalesChart', '주별 매출');
  drawSalesChart('/api/sales/monthly', 'monthlySalesChart', '월별 매출');

  drawUserChart('/api/users/daily', 'dailyUserChart', '일별 가입자 수');
  drawUserChart('/api/users/monthly', 'monthlyUserChart', '월별 가입자 수');
  drawUserChart('/api/users/yearly', 'yearlyUserChart', '연도별 가입자 수');

  drawRegionSalesMap();
  drawTopProductsChart();
  drawHourlySalesChart();
  updateActiveUsers();
});
