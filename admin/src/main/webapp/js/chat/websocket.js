const ws = {
  id: "",
  stompClient: null,

  generateMessageId: function () {
    return Date.now() + "-" + Math.random().toString(36).substr(2, 9);
  },

  connect: function () {
    this.id = document.getElementById("adm_id").textContent.trim();
    const socket = new SockJS("/ws");
    this.stompClient = Stomp.over(socket);

    this.stompClient.connect({}, (frame) => {
      console.log("Connected: " + frame);
      const sid = this.id;

      this.stompClient.subscribe("/send", (msg) => {
        document
          .getElementById("all")
          .insertAdjacentHTML(
            "afterbegin",
            `<h6>${JSON.parse(msg.body).sendid}: ${
              JSON.parse(msg.body).content1
            }</h6>`
          );
      });
      this.stompClient.subscribe(`/send/${sid}`, (msg) => {
        document
          .getElementById("me")
          .insertAdjacentHTML(
            "afterbegin",
            `<h6>${JSON.parse(msg.body).sendid}: ${
              JSON.parse(msg.body).content1
            }</h6>`
          );
      });
      this.stompClient.subscribe(`/send/to/${sid}`, (msg) => {
        document
          .getElementById("to")
          .insertAdjacentHTML(
            "afterbegin",
            `<h6>${JSON.parse(msg.body).sendid}: ${
              JSON.parse(msg.body).content1
            }</h6>`
          );
      });
      this.stompClient.subscribe("/livechat/public", (msg) => {
        document
          .getElementById("all")
          .insertAdjacentHTML(
            "afterbegin",
            `<h6>[Public] ${JSON.parse(msg.body).sendid}: ${
              JSON.parse(msg.body).content1
            }</h6>`
          );
      });
    });
  },

  sendAll: function () {
    const text = document.getElementById("alltext").value.trim();
    if (text) {
      const msg = JSON.stringify({ sendid: this.id, content1: text });
      this.stompClient.send("/app/livechat.sendMessage", {}, msg);
      document.getElementById("alltext").value = "";
    }
  },

  sendMe: function () {
    const text = document.getElementById("metext").value.trim();
    if (text) {
      const msg = JSON.stringify({ sendid: this.id, content1: text });
      this.stompClient.send("/receiveme", {}, msg);
      document.getElementById("metext").value = "";
    }
  },

  sendTo: function () {
    const targetId = document.getElementById("target").value.trim();
    const text = document.getElementById("totext").value.trim();
    if (targetId && text) {
      const msg = JSON.stringify({
        messageId: this.generateMessageId(),
        sendid: this.id,
        receiveid: targetId,
        content1: text,
      });
      this.stompClient.send("/receiveto", {}, msg);
      document.getElementById("totext").value = "";
    }
  },
};

document.addEventListener("DOMContentLoaded", () => {
  ws.connect();

  document
    .getElementById("sendall")
    .addEventListener("click", ws.sendAll.bind(ws));
  const sendMeBtn = document.getElementById("sendme");
  if (sendMeBtn) sendMeBtn.addEventListener("click", ws.sendMe.bind(ws));
  document
    .getElementById("sendto")
    .addEventListener("click", ws.sendTo.bind(ws));

  document.getElementById("alltext").addEventListener("keypress", (e) => {
    if (e.which === 13) ws.sendAll();
  });

  const metext = document.getElementById("metext");
  if (metext) {
    metext.addEventListener("keypress", (e) => {
      if (e.which === 13) ws.sendMe();
    });
  }

  document.getElementById("totext").addEventListener("keypress", (e) => {
    if (e.which === 13) ws.sendTo();
  });

  const canvas = document.getElementById("snow-canvas");
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
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
