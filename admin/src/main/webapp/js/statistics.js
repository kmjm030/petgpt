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
          data: data.map(d => d.total_sales),
          color: '#007bff'
        }],
        credits: { enabled: false }
      });
    })
    .catch(err => console.error(`[${containerId}] 차트 불러오기 실패:`, err));
}

document.addEventListener('DOMContentLoaded', () => {
  drawSalesChart('/api/sales/daily', 'dailySalesChart', '📅 일별 매출 추이');
  drawSalesChart('/api/sales/weekly', 'weeklySalesChart', '🗓️ 주별 매출');
  drawSalesChart('/api/sales/monthly', 'monthlySalesChart', '📈 월별 매출');
});
