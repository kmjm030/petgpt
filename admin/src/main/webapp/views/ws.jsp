<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/css/websocket.css">

<div class="container chat-container">
    <h2 class="text-center">관리자 실시간 채팅</h2>

    <!-- 1) 모두에게 전송 -->
    <div class="chat-header">모두에게 전송</div>
    <div class="input-group mb-3">
        <input type="text" id="alltext" class="form-control" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendall" class="btn-send">Send</button>
        </div>
    </div>

    <div id="all" class="chat-box"></div>

    <!-- 특정 대상에게 보내기 -->
    <div class="chat-header">특정 대상에게</div>
    <div class="input-group mb-3">
        <input type="text" id="target" class="form-control col-3" placeholder="대상 ID">
        <input type="text" id="totext" class="form-control col-6" placeholder="메시지 입력">
        <div class="input-group-append">
            <button id="sendto" class="btn-send">Send</button>
        </div>
    </div>
    <div id="to" class="chat-box"></div>
</div>

<span id="adm_id" style="display: none;">${admin.adminId}</span>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script src="<c:url value='/js/websocket.js'/>"></script>
