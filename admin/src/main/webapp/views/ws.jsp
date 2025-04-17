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
    #all h6 {
        display: inline-block;       /* 말풍선 폭만큼만 넓어지도록 */
        position: relative;          /* 꼬리 위치 기준 */
        margin: 8px 0;               /* 위아래 여백 */
        padding: 8px 14px;           /* 안쪽 여백 */
        max-width: 70%;              /* 가로 폭 제한 */
        background-color: #ffffff;   /* 말풍선 배경색 */
        color: #333333;              /* 텍스트 색 */
        border-radius: 0 12px 12px 12px; /* 왼쪽 꼬리 방향으로 덜 둥글게 */
        word-break: break-word;      /* 길게 쭉 이어지는 단어 줄바꿈 */
        font-size: 14px;
        line-height: 1.4;
    }
    #all h6::before {
        content: "";
        position: absolute;
        top: 12px;                   /* 말풍선 세로 위치에 맞춰 */
        left: -8px;                  /* 말풍선 바깥쪽으로 */
        border: 8px solid transparent;
        border-right-color: #ffffff; /* 왼쪽 꼬리 색은 말풍선 배경색과 동일 */
    }
    #me h6 {
        display: inline-block;
        position: relative;
        margin: 8px 0;
        padding: 8px 14px;
        max-width: 70%;
        background-color: #fde500;
        color: #000000;
        border-radius: 12px 0 12px 12px; /* 오른쪽 꼬리 방향으로 덜 둥글게 */
        word-break: break-word;
        font-size: 14px;
        line-height: 1.4;
    }

    /* 오른쪽 꼬리 */
    #me h6::after {
        content: "";
        position: absolute;
        top: 12px;
        right: -8px;
        border: 8px solid transparent;
        border-left-color: #fde500;  /* 꼬리 색은 말풍선 배경색과 동일 */
    }
    #to h6 {
        display: inline-block;
        position: relative;
        margin: 8px 0;
        padding: 8px 14px;
        max-width: 70%;
        background-color: #fde500;
        color: #000000;
        border-radius: 12px 0 12px 12px; /* 오른쪽 꼬리 방향으로 덜 둥글게 */
        word-break: break-word;
        font-size: 14px;
        line-height: 1.4;
    }
    #me h6::after {
        content: "";
        position: absolute;
        top: 12px;
        right: -8px;
        border: 8px solid transparent;
        border-left-color: #fde500;  /* 꼬리 색은 말풍선 배경색과 동일 */
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
<html><span id="adm_id"  >${admin.adminId}</span></html>
<script>
    const ws = {
        id: '',
        stompClient: null,
        connect: function () {
            this.id = $('#adm_id').text().trim();
            const sid = this.id;
            const socket = new SockJS('/ws');
            this.stompClient = Stomp.over(socket);
            this.stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);

                this.subscribe('/send', function(msg) {
                    $("#all").prepend(
                        "<h6>" + JSON.parse(msg.body).sendid +":"+
                        JSON.parse(msg.body).content1
                        + "</h6>");
                });
                this.subscribe('/send/'+sid, function(msg) {
                    $("#me").prepend(
                        "<h6>" + JSON.parse(msg.body).sendid +":"+
                        JSON.parse(msg.body).content1+ "</h6>");
                });
                this.subscribe('/send/to/'+sid, function(msg) {
                    $("#to").prepend(
                        "<h6>" + JSON.parse(msg.body).sendid +":"+
                        JSON.parse(msg.body).content1
                        + "</h6>");
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
