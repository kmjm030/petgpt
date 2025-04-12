<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
        }
    };
    $(function(){
        item_add.init();
    });
</script>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">상품 등록</h1>

    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <form id="item_add_form">

                    <!-- 상품 정보 입력 -->
                    <div class="form-group">
                        <label>카테고리 번호</label>
                        <input type="number" class="form-control" name="categoryKey" required>
                    </div>

                    <div class="form-group">
                        <label>상품명</label>
                        <input type="text" class="form-control" name="itemName" required>
                    </div>

                    <div class="form-group">
                        <label>상품 설명</label>
                        <textarea class="form-control" name="itemContent" rows="4"></textarea>
                    </div>

                    <div class="form-group">
                        <label>정가</label>
                        <input type="number" class="form-control" name="itemPrice" required>
                    </div>

                    <div class="form-group">
                        <label>할인가</label>
                        <input type="number" class="form-control" name="itemSprice">
                    </div>

                    <div class="form-group">
                        <label>대표 이미지 (img1)</label>
                        <input type="file" class="form-control" name="img1">
                    </div>
                    <div class="form-group">
                        <label>추가 이미지 2 (img2)</label>
                        <input type="file" class="form-control" name="img2">
                    </div>
                    <div class="form-group">
                        <label>추가 이미지 3 (img3)</label>
                        <input type="file" class="form-control" name="img3">
                    </div>

                    <hr>
                    <h5 class="mb-3 mt-4">옵션 정보</h5>

                    <div class="form-group">
                        <label>사이즈</label>
                        <input type="text" class="form-control" name="size" required>
                    </div>

                    <div class="form-group">
                        <label>색상</label>
                        <input type="text" class="form-control" name="color" required>
                    </div>

                    <div class="form-group">
                        <label>추가 금액</label>
                        <input type="number" class="form-control" name="additionalPrice" value="0" required>
                    </div>

                    <div class="form-group">
                        <label>재고 수량</label>
                        <input type="number" class="form-control" name="stock" required>
                    </div>

                    <button id="btn_add" type="button" class="btn btn-primary mt-3">등록하기</button>

                </form>
            </div>
        </div>
    </div>
</div>




