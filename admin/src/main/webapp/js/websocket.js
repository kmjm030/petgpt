const ws = {
    id: '',
    stompClient: null,

    connect: function () {
        this.id = document.getElementById('adm_id').textContent.trim();
        const socket = new SockJS('/ws');
        this.stompClient = Stomp.over(socket);

        this.stompClient.connect({}, (frame) => {
            console.log('Connected: ' + frame);
            const sid = this.id;

            this.stompClient.subscribe('/send', (msg) => {
                document.getElementById("all").insertAdjacentHTML("afterbegin", `<h6>${JSON.parse(msg.body).sendid}: ${JSON.parse(msg.body).content1}</h6>`);
            });
            this.stompClient.subscribe(`/send/${sid}`, (msg) => {
                document.getElementById("me").insertAdjacentHTML("afterbegin", `<h6>${JSON.parse(msg.body).sendid}: ${JSON.parse(msg.body).content1}</h6>`);
            });
            this.stompClient.subscribe(`/send/to/${sid}`, (msg) => {
                document.getElementById("to").insertAdjacentHTML("afterbegin", `<h6>${JSON.parse(msg.body).sendid}: ${JSON.parse(msg.body).content1}</h6>`);
            });
            this.stompClient.subscribe('/livechat/public', (msg) => {
                document.getElementById("all").insertAdjacentHTML("afterbegin", `<h6>[Public] ${JSON.parse(msg.body).sendid}: ${JSON.parse(msg.body).content1}</h6>`);
            });
        });
    },

    sendAll: function () {
        const text = document.getElementById('alltext').value.trim();
        if (text) {
            const msg = JSON.stringify({ sendid: this.id, content1: text });
            this.stompClient.send('/app/livechat.sendMessage', {}, msg);
            document.getElementById('alltext').value = '';
        }
    },

    sendMe: function () {
        const text = document.getElementById('metext').value.trim();
        if (text) {
            const msg = JSON.stringify({ sendid: this.id, content1: text });
            this.stompClient.send('/receiveme', {}, msg);
            document.getElementById('metext').value = '';
        }
    },

    sendTo: function () {
        const targetId = document.getElementById('target').value.trim();
        const text = document.getElementById('totext').value.trim();
        if (targetId && text) {
            const msg = JSON.stringify({ sendid: this.id, receiveid: targetId, content1: text });
            this.stompClient.send('/receiveto', {}, msg);
            document.getElementById('totext').value = '';
        }
    }
};

document.addEventListener('DOMContentLoaded', () => {
    ws.connect();

    document.getElementById('sendall').addEventListener('click', ws.sendAll.bind(ws));
    const sendMeBtn = document.getElementById('sendme');
    if (sendMeBtn) sendMeBtn.addEventListener('click', ws.sendMe.bind(ws));
    document.getElementById('sendto').addEventListener('click', ws.sendTo.bind(ws));

    document.getElementById('alltext').addEventListener('keypress', (e) => {
        if (e.which === 13) ws.sendAll();
    });

    const metext = document.getElementById('metext');
    if (metext) {
        metext.addEventListener('keypress', (e) => {
            if (e.which === 13) ws.sendMe();
        });
    }

    document.getElementById('totext').addEventListener('keypress', (e) => {
        if (e.which === 13) ws.sendTo();
    });
});
