<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<style>
    .chat-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
    }
    .chat-box {
        height: 200px;
        overflow-y: auto;
        border: 2px solid #dee2e6;
        padding: 10px;
        border-radius: 5px;
        margin-bottom: 10px;
        background-color: #f8f9fa;
        display: flex;
        flex-direction: column-reverse;
    }
    .chat-bubble {
        display: inline-block;
        max-width: 80%;
        padding: 10px;
        margin: 5px 0;
        border-radius: 10px;
        font-size: 14px;
        word-break: break-all;
    }
    .chat-bubble.me {
        background-color: #d1ecf1;
        color: #0c5460;
        align-self: flex-end;
    }
    .chat-bubble.other {
        background-color: #cce5ff;
        color: #004085;
        align-self: flex-start;
    }
    .chat-bubble.to {
        background-color: #d4edda;
        color: #155724;
    }
    .chat-header {
        font-weight: bold;
        color: #343a40;
        margin-top: 20px;
    }
</style>

<div class="container chat-container">
    <h2 class="text-center mb-4">관리자 실시간 채팅</h2>

    <div class="chat-header">모두에게 전송</div>
    <div class="input-group mb-2">
        <input type="text" id="alltext" class="form-control" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendall" class="btn btn-outline-primary">Send</button>
        </div>
    </div>
    <div id="all" class="chat-box border border-primary"></div>

    <div class="chat-header">자기 자신에게</div>
    <div class="input-group mb-2">
        <input type="text" id="metext" class="form-control" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendme" class="btn btn-outline-info">Send</button>
        </div>
    </div>
    <div id="me" class="chat-box border border-info"></div>

    <div class="chat-header">특정 대상에게</div>
    <div class="input-group mb-2">
        <input type="text" id="target" class="form-control col-3" placeholder="대상 ID">
        <input type="text" id="totext" class="form-control col-6" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendto" class="btn btn-outline-success">Send</button>
        </div>
    </div>
    <div id="to" class="chat-box border border-success"></div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
    const websocket = {
        id: '',
        stompClient: null,
        connect: function () {
            this.id = $('#adm_id').text().trim();
            const sid = this.id;
            const socket = new SockJS('/ws');
            this.stompClient = Stomp.over(socket);
            const self = this;

            this.stompClient.connect({}, function (frame) {
                $('#status').text('Connected');
                console.log('Connected: ' + frame);

                self.stompClient.subscribe('/send', function (msg) {
                    $("#all").prepend(
                        "<h6>" + JSON.parse(msg.body).sendid +":"+
                        JSON.parse(msg.body).content1
                        + "</h6>");
                });

                self.stompClient.subscribe('/send/' + sid, function (msg) {
                    $("#me").prepend(
                        "<h6>" + JSON.parse(msg.body).sendid +":"+
                        JSON.parse(msg.body).content1+ "</h6>");
                });

                self.stompClient.subscribe('/send/to/' + sid, function (msg) {
                    $("#to").prepend(
                        "<h4>" + JSON.parse(msg.body).sendid +":"+
                        JSON.parse(msg.body).content1
                        + "</h4>");
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
        websocket.connect();
        $('#sendall').click(() => websocket.sendAll());
        $('#sendme').click(() => websocket.sendMe());
        $('#sendto').click(() => websocket.sendTo());

        $('#alltext').keypress(function(e) {
            if (e.which === 13) { $('#sendall').click(); return false; }
        });
        $('#metext').keypress(function(e) {
            if (e.which === 13) { $('#sendme').click(); return false; }
        });
        $('#totext').keypress(function(e) {
            if (e.which === 13) { $('#sendto').click(); return false; }
        });
    });
</script>