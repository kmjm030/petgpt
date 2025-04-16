<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;600&display=swap" rel="stylesheet">

<style>
    body {
        background-color: #f5f5f7;
        font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
    }

    .chat-container {
        max-width: 800px;
        margin: 40px auto;
        padding: 30px;
        background: white;
        border-radius: 16px;
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.05);
    }

    h2.text-center {
        font-weight: 600;
        margin-bottom: 30px;
        color: #1d1d1f;
    }

    .chat-box {
        height: 200px;
        overflow-y: auto;
        border: 1px solid #d2d2d7;
        padding: 12px;
        border-radius: 12px;
        margin-bottom: 20px;
        background-color: #f9f9fa;
        display: flex;
        flex-direction: column-reverse;
    }

    .chat-bubble {
        display: inline-block;
        max-width: 80%;
        padding: 12px 16px;
        margin: 6px 0;
        border-radius: 18px;
        font-size: 14px;
        word-break: break-word;
        line-height: 1.5;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }

    .chat-bubble.me {
        background-color: #1d1d1f;
        color: white;
        align-self: flex-end;
    }

    .chat-bubble.other {
        background-color: white;
        color: #1d1d1f;
        border: 1px solid #ccc;
        align-self: flex-start;
    }

    .chat-bubble.to {
        background-color: #ededed;
        color: #000;
        align-self: center;
    }

    .chat-header {
        font-weight: 600;
        color: #1d1d1f;
        margin: 20px 0 10px;
        font-size: 1.1rem;
    }

    .form-control {
        border-radius: 10px !important;
        font-size: 14px;
    }

    .btn {
        border-radius: 10px;
        font-weight: 500;
        font-size: 14px;
    }

    .btn-outline-primary, .btn-outline-info, .btn-outline-success {
        border: 1px solid #1d1d1f;
        color: #1d1d1f;
    }

    .btn-outline-primary:hover, .btn-outline-info:hover, .btn-outline-success:hover {
        background-color: #1d1d1f;
        color: white;
    }
</style>

<div class="container chat-container">
    <h2 class="text-center">관리자 실시간 채팅</h2>

    <div class="chat-header">모두에게 전송</div>
    <div class="input-group mb-3">
        <input type="text" id="alltext" class="form-control" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendall" class="btn btn-outline-primary">Send</button>
        </div>
    </div>
    <div id="all" class="chat-box"></div>

    <div class="chat-header">자기 자신에게</div>
    <div class="input-group mb-3">
        <input type="text" id="metext" class="form-control" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendme" class="btn btn-outline-info">Send</button>
        </div>
    </div>
    <div id="me" class="chat-box"></div>

    <div class="chat-header">특정 대상에게</div>
    <div class="input-group mb-3">
        <input type="text" id="target" class="form-control col-3" placeholder="대상 ID">
        <input type="text" id="totext" class="form-control col-6" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendto" class="btn btn-outline-success">Send</button>
        </div>
    </div>
    <div id="to" class="chat-box"></div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
    const ws = {
        id: '',
        stompClient: null,
        connect: function () {
            this.id = $('#adm_id').text().trim();
            const sid = this.id;
            const socket = new SockJS('/ws');
            this.stompClient = Stomp.over(socket);
            const self = this;

            this.stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);

                self.stompClient.subscribe('/send', function (msg) {
                    $("#all").prepend(`<div class="chat-bubble other"><b>${JSON.parse(msg.body).sendid}</b>: ${JSON.parse(msg.body).content1}</div>`);
                });

                self.stompClient.subscribe('/send/' + sid, function (msg) {
                    $("#me").prepend(`<div class="chat-bubble me"><b>${JSON.parse(msg.body).sendid}</b>: ${JSON.parse(msg.body).content1}</div>`);
                });

                self.stompClient.subscribe('/send/to/' + sid, function (msg) {
                    $("#to").prepend(`<div class="chat-bubble to"><b>${JSON.parse(msg.body).sendid}</b>: ${JSON.parse(msg.body).content1}</div>`);
                });
            });
        },
        sendAll: function () {
            const text = $('#alltext').val().trim();
            if (text) {
                const msg = JSON.stringify({ sendid: this.id, content1: text });
                this.stompClient.send('/receiveall', {}, msg);
                $('#alltext').val('');
            }
        },
        sendMe: function () {
            const text = $('#metext').val().trim();
            if (text) {
                const msg = JSON.stringify({ sendid: this.id, content1: text });
                this.stompClient.send('/receiveme', {}, msg);
                $('#metext').val('');
            }
        },
        sendTo: function () {
            const targetId = $('#target').val().trim();
            const text = $('#totext').val().trim();
            if (targetId && text) {
                const msg = JSON.stringify({ sendid: this.id, receiveid: targetId, content1: text });
                this.stompClient.send('/receiveto', {}, msg);
                $('#totext').val('');
            }
        }
    };

    $(function () {
        ws.connect();
        $('#sendall').click(() => ws.sendAll());
        $('#sendme').click(() => ws.sendMe());
        $('#sendto').click(() => ws.sendTo());

        $('#alltext').keypress(function (e) {
            if (e.which === 13) { $('#sendall').click(); return false; }
        });
        $('#metext').keypress(function (e) {
            if (e.which === 13) { $('#sendme').click(); return false; }
        });
        $('#totext').keypress(function (e) {
            if (e.which === 13) { $('#sendto').click(); return false; }
        });
    });
</script>
