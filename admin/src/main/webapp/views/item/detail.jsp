<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
    let item_detail = {
        init:function(){
            $('#btn_delete').click(()=>{
                const key = $('#itemKey').val();
                if(confirm('삭제하시겠습니까?')){
                    location.href = '<c:url value="/item/del"/>?item_key=' + key;
                }
            });

            $('#btn_update').click(()=>{
                if(confirm('수정하시겠습니까?')){
                    $('#item_update_form').attr({
                        'method': 'post',
                        'enctype': 'multipart/form-data',
                        'action': '<c:url value="/item/update"/>'
                    }).submit();
                }
            });
        }
    };
    $(function(){
        item_detail.init();
    });
</script>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">상품 상세 보기</h1>

    <div class="card shadow mb-4">
        <div class="card-body">
            <form id="item_update_form">

                <div class="form-group">
                    <label>상품 번호</label>
                    <input type="text" readonly class="form-control" id="itemKey" name="itemKey" value="${item.itemKey}">
                </div>

                <div class="form-group">
                    <label>상품명</label>
                    <input type="text" class="form-control" name="itemName" value="${item.itemName}">
                </div>

                <div class="form-group">
                    <label>가격</label>
                    <input type="number" class="form-control" name="itemPrice" value="${item.itemPrice}">
                </div>

                <div class="form-group">
                    <label>할인가</label>
                    <input type="number" class="form-control" name="itemSprice" value="${item.itemSprice}">
                </div>

                <div class="form-group">
                    <label>이미지 1</label><br>
                    <img src="<c:url value='/img/item/${item.itemImg1}'/>" width="100"><br>
                    <input type="hidden" name="itemImg1" value="${item.itemImg1}">
                </div>
                <div class="form-group">
                    <label>이미지 2</label><br>
                    <img src="<c:url value='/img/item/${item.itemImg2}'/>" width="100"><br>
                    <input type="hidden" name="itemImg2" value="${item.itemImg2}">
                </div>
                <div class="form-group">
                    <label>이미지 3</label><br>
                    <img src="<c:url value='/img/item/${item.itemImg3}'/>" width="100"><br>
                    <input type="hidden" name="itemImg3" value="${item.itemImg3}">
                </div>

                <!-- 새 이미지 업로드 -->
                <div class="form-group">
                    <label>새 이미지 1</label>
                    <input type="file" class="form-control" name="img1">
                </div>
                <div class="form-group">
                    <label>새 이미지 2</label>
                    <input type="file" class="form-control" name="img2">
                </div>
                <div class="form-group">
                    <label>새 이미지 3</label>
                    <input type="file" class="form-control" name="img3">
                </div>

                <hr>
                <h5 class="mt-4">옵션 정보</h5>
                <table class="table table-bordered">
                    <tr><th>사이즈</th><td>${option.size}</td></tr>
                    <tr><th>색상</th><td>${option.color}</td></tr>
                    <tr><th>재고</th><td>${option.stock}</td></tr>
                    <tr><th>추가 금액</th><td><fmt:formatNumber value="${option.additionalPrice}" pattern="#,###"/></td></tr>
                </table>

                <button id="btn_update" type="button" class="btn btn-primary">수정</button>
                <button id="btn_delete" type="button" class="btn btn-danger">삭제</button>

            </form>
        </div>
    </div>
</div>



