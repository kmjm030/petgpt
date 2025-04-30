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

    const chart = Highcharts.chart('hourlySalesChart', {
        chart: {
            type: 'areaspline',
            backgroundColor: 'transparent'
        },
        title: { text: '', style: { color: '#d63384', fontSize: '20px', fontWeight: 'bold' } },
        xAxis: {
            categories: ["09시", "10시", "11시", "12시", "13시", "14시"],
            labels: { style: { color: '#c9184a', fontWeight: '600' } }
        },
        yAxis: {
            title: { text: '' },
            labels: {
                formatter() { return this.value / 1000 + 'k'; },
                style: { color: '#c9184a', fontWeight: '600' }
            }
        },
        tooltip: {
            valueSuffix: ' 원',
            backgroundColor: '#ffe4e1',
            borderColor: '#d63384',
            style: { color: '#4b2c2c' }
        },
        plotOptions: {
            areaspline: {
                fillOpacity: 0.4,
                marker: { radius: 4, fillColor: '#d63384' },
                lineWidth: 3
            }
        },
        series: [{
            name: '매출',
            color: '#d63384',
            fillColor: {
                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                stops: [
                    [0, 'rgba(214, 51, 132, 0.5)'],
                    [1, 'rgba(255, 255, 255, 0)']
                ]
            },
            data: []
        }],
        credits: { enabled: false }
    });

    function generateRandomData() {
        return [9, 10, 11, 12, 13, 14].map(() => Math.floor(Math.random() * 30000) + 15000);
    }

    function updateChartData() {
        const newData = generateRandomData();
        chart.series[0].setData(newData, true);
    }

    updateChartData();
    setInterval(updateChartData, 5000);
});
