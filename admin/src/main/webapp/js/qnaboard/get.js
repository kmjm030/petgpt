const board_get = {
    update(id) {
        if (confirm('수정하시겠습니까?')) {
            location.href = `/qnaboard/detail?id=${encodeURIComponent(id)}`;
        }
    },
    delete(id) {
        if (confirm('삭제하시겠습니까?')) {
            location.href = `/qnaboard/delete?id=${encodeURIComponent(id)}`;
        }
    }
};

document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.getElementById('snow-canvas');
    const ctx = canvas.getContext('2d');
    let W = window.innerWidth;
    let H = window.innerHeight;
    canvas.width = W;
    canvas.height = H;

    const maxFlakes = 100;
    const flakes = [];

    function Flake() {
        this.x = Math.random() * W;
        this.y = Math.random() * H;
        this.r = Math.random() * 4 + 1;
        this.d = Math.random() * maxFlakes;
        this.tilt = Math.random() * 10 - 5;
        this.tiltAngle = 0;
        this.tiltAngleIncrement = Math.random() * 0.05;
    }

    for (let i = 0; i < maxFlakes; i++) {
        flakes.push(new Flake());
    }

    function drawFlakes() {
        ctx.clearRect(0, 0, W, H);
        ctx.fillStyle = "rgba(255, 255, 255, 0.8)";
        ctx.beginPath();
        for (let i = 0; i < maxFlakes; i++) {
            let f = flakes[i];
            ctx.moveTo(f.x, f.y);
            ctx.arc(f.x, f.y, f.r, 0, Math.PI * 2, true);
        }
        ctx.fill();
        moveFlakes();
    }

    let angle = 0;

    function moveFlakes() {
        angle += 0.01;
        for (let i = 0; i < maxFlakes; i++) {
            let f = flakes[i];
            f.y += Math.cos(angle + f.d) + 1 + f.r / 2;
            f.x += Math.sin(angle) * 2;

            if (f.y > H) {
                flakes[i] = new Flake();
                flakes[i].y = 0;
            }
        }
    }

    function animate() {
        drawFlakes();
        requestAnimationFrame(animate);
    }

    animate();

    window.addEventListener("resize", () => {
        W = window.innerWidth;
        H = window.innerHeight;
        canvas.width = W;
        canvas.height = H;
    });
});
