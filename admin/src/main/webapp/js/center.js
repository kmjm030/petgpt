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
});

document.addEventListener('DOMContentLoaded', function () {
  if (!window.dailySalesData) return;

  const categories = window.dailySalesData.map(item => item.orderDate);
  const data = window.dailySalesData.map(item => item.totalSales);

  Highcharts.chart('dailySalesChart', {
    chart: { type: 'line' },
    title: { text: null },
    xAxis: {
      categories,
      title: { text: '날짜' }
    },
    yAxis: {
      title: { text: '매출 (원)' },
      labels: { formatter: function () { return this.value.toLocaleString(); } }
    },
    tooltip: {
      pointFormatter: function () {
        return `<b>${this.y.toLocaleString()} 원</b>`;
      }
    },
    series: [{
      name: '일별 매출',
      data
    }]
  });
});
