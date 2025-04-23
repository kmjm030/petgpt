<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    body {
        background-color: #f5f5f7;
        color: #1d1d1f;
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        padding: 2rem;
    }

    h1 {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 1rem;
    }

    .card {
        background-color: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 20px;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
    }

    .card-header {
        padding: 1.25rem;
        background-color: #fff;
        border-bottom: 1px solid #e0e0e0;
    }

    .card-header h6 {
        font-size: 1.1rem;
        font-weight: 600;
        color: #1d1d1f;
    }

    .form-group {
        margin-bottom: 1.2rem;
    }

    label {
        font-weight: 500;
        margin-bottom: 0.5rem;
    }

    .form-control {
        border-radius: 10px;
        padding: 0.75rem;
        border: 1px solid #ccc;
        font-size: 0.95rem;
        background-color: #fff;
        color: #1d1d1f;
    }

    .btn {
        border-radius: 10px;
        padding: 0.5rem 1.2rem;
        font-weight: 600;
        background-color: #1d1d1f;
        color: #fff;
        margin-right: 0.5rem;
        border: none;
    }

    .btn:hover {
        background-color: #333;
    }

    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }

    body.dark-mode .card,
    body.dark-mode .card-header {
        background-color: #2c2c2e;
        border-color: #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode .form-control {
        background-color: #2c2c2e;
        border-color: #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode label {
        color: #f5f5f7;
    }

    body.dark-mode .btn {
        background-color: #3a3a3c;
        border: 1px solid #4a4a4a;
        color: #f5f5f7;
    }

    body.dark-mode .btn:hover {
        background-color: #4a4a4a;
    }
</style>

<script>
    const cust_detail = {
        init: function () {
            $('#detail_form > #btn_update').click(() => this.send());
            $('#detail_form > #btn_delete').click(() => {
                if (confirm('삭제하시겠습니까?')) {
                    const id = $('#id').val();
                    location.href = '<c:url value="/cust/delete"/>?id=' + id;
                }
            });
            $('#detail_form > #btn_showlist').click(() => {
                location.href = '<c:url value="/cust/get"/>';
            });
        },
        send: function () {
            $('#detail_form').attr({ method: 'post', action: '<c:url value="/cust/update"/>' }).submit();
        }
    };
    $(function () {
        cust_detail.init();
    });
</script>

<div class="container-fluid">
    <h1>${cust.custName}님, 회원정보 수정</h1>

    <div class="card">
        <div class="card-body">
            <form id="detail_form">
                <div class="form-group">
                    <label for="id">ID</label>
                    <input type="text" readonly value="${cust.custId}" class="form-control" id="id" name="custId">
                </div>
                <div class="form-group">
                    <label for="pwd">Password</label>
                    <input type="password" value="${cust.custPwd}" class="form-control" id="pwd" name="custPwd">
                </div>
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" value="${cust.custName}" class="form-control" id="name" name="custName">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="text" value="${cust.custEmail}" class="form-control" id="email" name="custEmail">
                </div>
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" value="${cust.custPhone}" class="form-control" id="phone" name="custPhone">
                </div>
                <div class="form-group">
                    <label for="point">Point</label>
                    <input type="text" value="${cust.custPoint}" class="form-control" id="point" name="custPoint">
                </div>
                <div class="form-group">
                    <label for="nick">Nick</label>
                    <input type="text" value="${cust.custNick}" class="form-control" id="nick" name="custNick">
                </div>
                <div class="form-group">
                    <label for="pointcharge">Point Charge</label>
                    <input type="text" value="${cust.pointCharge}" class="form-control" id="pointcharge" name="pointCharge">
                </div>
                <div class="form-group">
                    <label for="pointreason">Point Reason</label>
                    <input type="text" value="${cust.pointReason}" class="form-control" id="pointreason" name="pointReason">
                </div>

                <button id="btn_update" type="button" class="btn">수정</button>
                <button id="btn_delete" type="button" class="btn">삭제</button>
                <button id="btn_showlist" type="button" class="btn">목록보기</button>
            </form>
        </div>
    </div>
</div>
