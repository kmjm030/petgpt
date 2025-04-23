<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(function () {
        $('#btn_delete').click(() => {
            const key = $('#itemKey').val();
            if (confirm('정말로 이 상품을 삭제하시겠습니까?')) {
                location.href = '<c:url value="/item/del"/>' + '?item_key=' + key;
            }
        });

        $('#btn_update').click(() => {
            if (confirm('이 상품 정보를 수정하시겠습니까?')) {
                $('#item_update_form').attr({
                    method: 'post',
                    enctype: 'multipart/form-data',
                    action: '<c:url value="/item/update"/>'
                }).submit();
            }
        });
    });
</script>

<style>
    body {
        background-color: #fff;
        color: #1d1d1f;
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
    }
    h1, label, th, td { color: #1d1d1f; }
    label { font-weight: 500; margin-bottom: 6px; display: block; }

    .section-title {
        font-size: 1.2rem;
        font-weight: 600;
        margin-bottom: 1rem;
        border-bottom: 1px solid #e0e0e0;
        padding-bottom: 0.5rem;
    }
    .card-section {
        background-color: #fafafa;
        padding: 20px;
        border-radius: 14px;
        margin-bottom: 24px;
    }
    .img-thumb {
        width: 100px;
        border: 1px solid #ccc;
        border-radius: 8px;
        margin-bottom: 10px;
        filter: grayscale(10%);
        transition: transform 0.2s ease;
    }
    .img-thumb:hover {
        transform: scale(1.04);
        filter: none;
        border-color: #1d1d1f;
    }

    .form-control,
    select.form-control,
    input[type="file"] {
        background-color: #fff;
        color: #1d1d1f;
        border: 1px solid #ccc;
        border-radius: 10px;
        font-size: 0.95rem;
        padding: 10px;
        height: 38px;
        line-height: 1.5;
        vertical-align: middle;
    }
    select.form-control,
    input[type="file"] {
        padding-top: 6px;
        padding-bottom: 6px;
    }
    .form-control:focus {
        box-shadow: none;
        border-color: #1d1d1f;
    }

    .btn-dark {
        background-color: #1d1d1f;
        color: #fff;
        font-weight: 600;
        border-radius: 12px;
        padding: 10px 24px;
        border: none;
        min-width: 120px;
    }
    .btn-outline-danger {
        border: 1px solid #999;
        background-color: transparent;
        color: #1d1d1f;
        font-weight: 600;
        border-radius: 12px;
        padding: 10px 24px;
        min-width: 120px;
    }
    .btn-outline-danger:hover {
        background-color: #1d1d1f;
        color: #fff;
        border-color: #1d1d1f;
    }

    .badge-secondary {
        background-color: #f2f2f2;
        color: #888;
        font-size: 13px;
        padding: 5px 10px;
        border-radius: 20px;
    }
    .btn-group-fixed {
        display: flex;
        gap: 12px;
        margin-top: 30px;
    }
    .card {
        background-color: #fff;
        border: none;
        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.05);
        border-radius: 20px;
    }
    .table-bordered th,
    .table-bordered td {
        background-color: #fff;
        border-color: #e0e0e0;
        color: #1d1d1f;
    }
</style>

<div class="container-fluid">
    <h1 class="h3 mb-4 font-weight-bold">상품 상세 정보</h1>
    <div class="card shadow-sm p-4 mb-4">
        <form id="item_update_form">

            <div class="card-section">
                <div class="section-title">기본 정보</div>
                <div class="form-row">
                    <div class="form-group col-md-4">
                        <label>상품 ID</label>
                        <input type="text" readonly class="form-control" id="itemKey" name="itemKey" value="${item.itemKey}">
                    </div>
                    <div class="form-group col-md-4">
                        <label>카테고리</label>
                        <select class="form-control" name="categoryKey">
                            <option value="1" ${item.categoryKey == 1 ? 'selected' : ''}>고양이</option>
                            <option value="2" ${item.categoryKey == 2 ? 'selected' : ''}>강아지</option>
                        </select>
                    </div>
                    <div class="form-group col-md-4">
                        <label>상품명</label>
                        <input type="text" class="form-control" name="itemName" value="${item.itemName}">
                    </div>
                </div>
            </div>

            <div class="card-section">
                <div class="section-title">상품 설명</div>
                <textarea class="form-control" name="itemContent" rows="3">${item.itemContent}</textarea>
            </div>

            <div class="card-section">
                <div class="section-title">가격 및 재고</div>
                <div class="form-row">
                    <div class="form-group col-md-4">
                        <label>정가</label>
                        <input type="number" class="form-control" name="itemPrice" value="${item.itemPrice}">
                    </div>
                    <div class="form-group col-md-4">
                        <label>할인가</label>
                        <input type="number" class="form-control" name="itemSprice" value="${item.itemSprice}">
                    </div>
                    <div class="form-group col-md-4">
                        <label>재고 수량</label>
                        <input type="number" class="form-control" name="itemCount" value="${item.itemCount}">
                    </div>
                </div>
            </div>

            <div class="card-section">
                <div class="section-title">등록된 이미지</div>
                <div class="form-row">
                    <c:forEach var="i" begin="1" end="3">
                        <c:set var="img" value="${item['itemImg' += i]}" />
                        <div class="form-group col-md-4">
                            <label>이미지 ${i}</label><br>
                            <c:choose>
                                <c:when test="${not empty img}">
                                    <img src="<c:url value='/img/item/${img}'/>" class="img-thumb"><br>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-secondary">이미지 없음</span><br>
                                </c:otherwise>
                            </c:choose>
                            <input type="hidden" name="itemImg${i}" value="${img}">
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="card-section">
                <div class="section-title">새 이미지 업로드</div>
                <div class="form-row">
                    <c:forEach var="i" begin="1" end="3">
                        <div class="form-group col-md-4">
                            <label>새 이미지 ${i}</label>
                            <input type="file" class="form-control" name="img${i}">
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="card-section">
                <div class="section-title">옵션 정보</div>
                <table class="table table-bordered">
                    <tr><th>사이즈</th><td>${option.size}</td></tr>
                    <tr><th>색상</th><td>${option.color}</td></tr>
                    <tr><th>옵션 재고</th><td>${option.stock}</td></tr>
                    <tr><th>추가금액</th><td><fmt:formatNumber value="${option.additionalPrice}" pattern="#,##0"/> 원</td></tr>
                </table>
            </div>

            <div class="btn-group-fixed">
                <button id="btn_update" type="button" class="btn btn-dark">
                    <i class="bi bi-pencil-square me-1"></i> 수정하기
                </button>
                <button id="btn_delete" type="button" class="btn btn-outline-danger">
                    <i class="bi bi-trash me-1"></i> 삭제하기
                </button>
            </div>
        </form>

        <jsp:include page="adminComments.jsp"/>
    </div>
</div>