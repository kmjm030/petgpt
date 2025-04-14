<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    let item_add = {
        init:function(){
            $('#btn_add').click(()=>{
                if(confirm('등록하시겠습니까?')){
                    $('#item_add_form').attr({
                        method: 'post',
                        enctype: 'multipart/form-data',
                        action: '<c:url value="/item/addimpl"/>'
                    }).submit();
                }
            });

            $('#btn_reset').click(function(){
                $('#item_add_form')[0].reset();
                const today = new Date().toISOString().slice(0, 10);
                $('#regDate').val(today);
            });
        }
    };

    $(function(){
        item_add.init();
        const today = new Date().toISOString().slice(0, 10);
        $('#regDate').val(today);
    });
</script>

<style>
    .section-title {
        font-size: 1.2rem;
        font-weight: 600;
        margin-top: 2rem;
        margin-bottom: 1rem;
        border-bottom: 2px solid #ddd;
        padding-bottom: 0.5rem;
    }
    .form-group label {
        font-weight: 500;
    }
    .btn-group-fixed {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }
</style>

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">상품 등록</h1>

    <div class="card shadow mb-4 p-4">
        <form id="item_add_form">

            <div class="section-title">기본 상품 정보</div>

            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>등록일</label>
                    <input type="text" class="form-control" name="regDate" id="regDate" readonly>
                </div>

                <div class="form-group col-md-4">
                    <label>카테고리</label>
                    <select class="form-control" name="categoryKey" required>
                        <option value="">선택하세요</option>
                        <option value="1">고양이</option>
                        <option value="2">강아지</option>
                    </select>
                </div>

                <div class="form-group col-md-4">
                    <label>상품명</label>
                    <input type="text" class="form-control font-weight-bold" name="itemName" required>
                </div>
            </div>

            <div class="form-group">
                <label>상품 설명</label>
                <textarea class="form-control" name="itemContent" rows="4" placeholder="상품에 대한 설명을 입력하세요."></textarea>
            </div>

            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>정가</label>
                    <input type="number" class="form-control" name="itemPrice" required>
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
                    <select class="form-control" name="size" required>
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
                    <input type="text" class="form-control" name="color" required>
                </div>

                <div class="form-group col-md-4">
                    <label>추가 금액</label>
                    <input type="number" class="form-control" name="additionalPrice" value="0" required>
                </div>
            </div>

            <div class="form-group">
                <label>재고 수량</label>
                <input type="number" class="form-control" name="stock" required>
            </div>

            <div class="btn-group-fixed">
                <button id="btn_add" type="button" class="btn btn-primary">등록하기</button>
                <button id="btn_reset" type="button" class="btn btn-secondary">초기화</button>
            </div>

        </form>
    </div>
</div>
