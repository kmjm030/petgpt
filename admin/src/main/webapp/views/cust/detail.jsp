<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="/css/cust/detail.css">
<link rel="stylesheet" href="/css/cust/leaf-fall.css">
<script src="/js/cust/leaf-fall.js"></script>
<script src="/js/cust/detail.js"></script>

<div class="container-fluid">
    <h1>${cust.custName}님, 회원정보 수정</h1>

    <div class="card">
        <form id="detail_form">
            <div class="form-group">
                <label for="id">ID</label>
                <input type="text" readonly class="form-control" id="id" name="custId" value="${cust.custId}">
            </div>
            <div class="form-group">
                <label for="pwd">Password</label>
                <input type="password" class="form-control" id="pwd" name="custPwd" value="${cust.custPwd}">
            </div>
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" class="form-control" id="name" name="custName" value="${cust.custName}">
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="text" class="form-control" id="email" name="custEmail" value="${cust.custEmail}">
            </div>
            <div class="form-group">
                <label for="phone">Phone</label>
                <input type="text" class="form-control" id="phone" name="custPhone" value="${cust.custPhone}">
            </div>
            <div class="form-group">
                <label for="point">Point</label>
                <input type="text" class="form-control" id="point" name="custPoint" value="${cust.custPoint}">
            </div>
            <div class="form-group">
                <label for="nick">Nick</label>
                <input type="text" class="form-control" id="nick" name="custNick" value="${cust.custNick}">
            </div>
            <div class="form-group">
                <label for="pointcharge">Point Charge</label>
                <input type="text" class="form-control" id="pointcharge" name="pointCharge" value="${cust.pointCharge}">
            </div>
            <div class="form-group">
                <label for="pointreason">Point Reason</label>
                <input type="text" class="form-control" id="pointreason" name="pointReason" value="${cust.pointReason}">
            </div>

            <div class="btn-group-fixed mt-3">
                <button id="btn_update" type="button" class="btn btn-dark">수정</button>
                <button id="btn_delete" type="button" class="btn btn-outline-danger">삭제</button>
                <button id="btn_showlist" type="button" class="btn btn-secondary">목록보기</button>
            </div>
        </form>
    </div>
</div>
