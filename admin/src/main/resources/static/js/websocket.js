const ws = {
  id: "",
  stompClient: null,
  translationEnabled: false,

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
        const message = JSON.parse(msg.body);
        let messageHtml = `<h6>[Public] ${message.sendid}: ${message.content1}`;

        // 번역된 메시지가 있는 경우
        if (message.translatedContent) {
          messageHtml += `<br><span class="translation">(번역: ${message.translatedContent})</span>`;
        }

        messageHtml += "</h6>";
        document
          .getElementById("all")
          .insertAdjacentHTML("afterbegin", messageHtml);

        // 번역 버튼 이벤트 리스너 추가
        const translateButtons = document.querySelectorAll(".btn-translate");
        translateButtons.forEach((button) => {
          if (!button.hasEventListener) {
            button.addEventListener("click", function () {
              const textToTranslate = this.getAttribute("data-text");
              ws.translateText(textToTranslate, this);
            });
            button.hasEventListener = true;
          }
        });
      });
    });
  },

  sendAll: function () {
    const text = document.getElementById("alltext").value.trim();
    if (text) {
      const msg = JSON.stringify({
        sendid: this.id,
        content1: text,
        translationEnabled: this.translationEnabled,
      });
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
        sendid: this.id,
        receiveid: targetId,
        content1: text,
      });
      this.stompClient.send("/receiveto", {}, msg);
      document.getElementById("totext").value = "";
    }
  },

  toggleTranslation: function () {
    this.translationEnabled = !this.translationEnabled;
    const toggleBtn = document.getElementById("toggle-translation");
    toggleBtn.textContent = this.translationEnabled
      ? "번역 비활성화"
      : "번역 활성화";
    toggleBtn.classList.toggle("active");
  },

  translateText: function (text, button) {
    fetch("/api/translate", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ text: text, targetLang: "ko" }),
    })
      .then((response) => response.json())
      .then((data) => {
        const parent = button.parentElement;
        if (data.translatedText) {
          // 번역 버튼을 번역된 텍스트로 교체
          const translationSpan = document.createElement("span");
          translationSpan.className = "translation";
          translationSpan.textContent = `(번역: ${data.translatedText})`;
          parent.replaceChild(translationSpan, button);
        }
      })
      .catch((error) => {
        console.error("Error translating text:", error);
      });
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

  // 번역 토글 버튼 추가
  const actionRow = document.createElement("div");
  actionRow.className = "action-row";

  const toggleTranslationBtn = document.createElement("button");
  toggleTranslationBtn.id = "toggle-translation";
  toggleTranslationBtn.className = "btn-translate-toggle";
  toggleTranslationBtn.textContent = "번역 활성화";
  toggleTranslationBtn.addEventListener("click", ws.toggleTranslation.bind(ws));

  actionRow.appendChild(toggleTranslationBtn);
  document
    .querySelector(".chat-container")
    .insertBefore(actionRow, document.querySelector(".chat-header"));

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
});
