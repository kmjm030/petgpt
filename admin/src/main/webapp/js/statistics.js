function fillMissingDays(data) {
  const filled = [];
  const today = new Date();
  for (let i = 6; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(today.getDate() - i);
    const label = date.toISOString().slice(0, 10); // YYYY-MM-DD
    const found = data.find(d => d.label === label);
    filled.push({ label, count: found ? found.count : 0 });
  }
  return filled;
}

function fillMissingMonths(data) {
  const filled = [];
  const now = new Date();
  for (let i = 0; i < 12; i++) {
    const date = new Date(now.getFullYear(), i);
    const label = date.toISOString().slice(0, 7); // YYYY-MM
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

function drawSalesChart(apiUrl, containerId, title) {
  fetch(apiUrl)
    .then(response => response.json())
    .then(data => {
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
                    </span></p>
                  `;
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

function drawUserChart(apiUrl, containerId, title) {
  fetch(apiUrl)
    .then(response => response.json())
    .then(data => {
      if (containerId === 'dailyUserChart') {
        data = fillMissingDays(data);
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
                    </span></p>
                  `;
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

document.addEventListener('DOMContentLoaded', () => {
  drawSalesChart('/api/sales/daily', 'dailySalesChart', '일별 매출');
  drawSalesChart('/api/sales/weekly', 'weeklySalesChart', '주별 매출');
  drawSalesChart('/api/sales/monthly', 'monthlySalesChart', '월별 매출');

  drawUserChart('/api/users/daily', 'dailyUserChart', '일별 가입자 수');
  drawUserChart('/api/users/monthly', 'monthlyUserChart', '월별 가입자 수');
  drawUserChart('/api/users/yearly', 'yearlyUserChart', '연도별 가입자 수');
});
