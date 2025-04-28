<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(function () {
        const form = $('#item_add_form');
        const today = new Date().toISOString().slice(0, 10);
        $('#regDate').val(today);

        $('#btn_add').click(() => {
            $('#errorMsg').hide();
            const fields = [
                'select[name="categoryKey"]',
                'input[name="itemName"]',
                'input[name="itemPrice"]',
                'select[name="size"]',
                'input[name="color"]',
                'input[name="additionalPrice"]',
                'input[name="stock"]'
            ];
            for (let selector of fields) {
                if (!$(selector).val()?.trim()) {
                    $('#errorMsg').show();
                    return;
                }
            }
            if (confirm('등록하시겠습니까?')) {
                form.attr({ method: 'post', enctype: 'multipart/form-data', action: '<c:url value="/item/addimpl"/>' }).submit();
            }
        });

        $('#btn_reset').click(() => {
            form[0].reset();
            $('#regDate').val(today);
            $('#errorMsg').hide();
        });
    });
</script>

<style>
    body {
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        background-color: #fff;
        color: #1d1d1f;
        padding: 2rem;
    }

    h1 {
        font-size: 1.75rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
    }

    .card {
        border-radius: 16px;
        padding: 2rem;
        border: 1px solid #e0e0e0;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
        background-color: #fff;
    }

    .section-title {
        font-size: 1.1rem;
        font-weight: 600;
        margin: 2rem 0 1rem;
        border-bottom: 2px solid #ddd;
        padding-bottom: 0.5rem;
    }

    label {
        font-weight: 500;
        margin-bottom: 0.4rem;
    }

    .form-control {
        font-size: 0.95rem;
    }

    .btn-group-fixed {
        display: flex;
        gap: 12px;
        margin-top: 2rem;
    }

    #errorMsg {
        display: none;
        font-size: 0.9rem;
        color: #dc3545;
        margin-top: 1rem;
    }

    /* Dark Mode */
    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }

    body.dark-mode .card {
        background-color: #2c2c2e;
        border-color: #3a3a3c;
    }

    body.dark-mode input,
    body.dark-mode select,
    body.dark-mode textarea {
        background-color: #2c2c2e;
        border: 1px solid #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode input::placeholder,
    body.dark-mode textarea::placeholder {
        color: #aaa;
    }

    body.dark-mode .btn-primary,
    body.dark-mode .btn-secondary {
        background-color: #3a3a3c;
        border: 1px solid #4a4a4a;
        color: #f5f5f7;
    }

    body.dark-mode .btn-primary:hover,
    body.dark-mode .btn-secondary:hover {
        background-color: #4a4a4a;
    }
</style>

<div class="container-fluid">
    <h1>상품 등록</h1>
    <div class="card">
        <form id="item_add_form">
            <div class="section-title">기본 상품 정보</div>
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>등록일</label>
                    <input type="text" class="form-control" name="regDate" id="regDate" readonly>
                </div>
                <div class="form-group col-md-4">
                    <label>카테고리</label>
                    <select class="form-control" name="categoryKey">
                        <option value="">선택하세요</option>
                        <option value="1">고양이</option>
                        <option value="2">강아지</option>
                    </select>
                </div>
                <div class="form-group col-md-4">
                    <label>상품명</label>
                    <input type="text" class="form-control" name="itemName">
                </div>
            </div>

            <div class="form-group">
                <label>상품 설명</label>
                <textarea class="form-control" name="itemContent" rows="4"></textarea>
            </div>

            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>정가</label>
                    <input type="number" class="form-control" name="itemPrice">
                </div>
                <div class="form-group col-md-4">
                    <label>할인가</label>
                    <input type="number" class="form-control" name="itemSprice">
                </div>
            </div>

            <div class="section-title">상품 이미지</div>
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>대표 이미지</label>
                    <input type="file" class="form-control" name="img1">
                </div>
                <div class="form-group col-md-4">
                    <label>추가 이미지</label>
                    <input type="file" class="form-control" name="img2">
                </div>
                <div class="form-group col-md-4">
                    <label>추가 이미지</label>
                    <input type="file" class="form-control" name="img3">
                </div>
            </div>

            <div class="section-title">옵션 정보</div>
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>사이즈</label>
                    <select class="form-control" name="size">
                        <option value="">선택하세요</option>
                        <option>XS</option>
                        <option>S</option>
                        <option>M</option>
                        <option>L</option>
                        <option>XL</option>
                    </select>
                </div>
                <div class="form-group col-md-4">
                    <label>색상</label>
                    <input type="text" class="form-control" name="color">
                </div>
                <div class="form-group col-md-4">
                    <label>추가 금액</label>
                    <input type="number" class="form-control" name="additionalPrice" value="0">
                </div>
            </div>

            <div class="form-group">
                <label>재고 수량</label>
                <input type="number" class="form-control" name="stock">
            </div>

            <div class="btn-group-fixed">
                <button id="btn_add" type="button" class="btn btn-primary">등록하기</button>
                <button id="btn_reset" type="button" class="btn btn-secondary">초기화</button>
            </div>

            <div id="errorMsg">빈칸이 있습니다.</div>
        </form>
    </div>
</div>
