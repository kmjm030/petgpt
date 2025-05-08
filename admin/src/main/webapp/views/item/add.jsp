<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/css/item.css">

<div class="container-fluid">
  <h1 class="my-4 font-weight-bold">상품 등록</h1>
  <div class="card p-4">
    <form id="item_add_form">
      <section class="mb-4">
        <h5 class="section-title mb-3">기본 상품 정보</h5>
        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="regDate">등록일</label>
            <input type="text" class="form-control" name="regDate" id="regDate" readonly>
          </div>
          <div class="form-group col-md-4">
            <label for="categoryKey">카테고리</label>
            <select class="form-control" name="categoryKey" id="categoryKey">
              <option value="">선택하세요</option>
              <option value="1">고양이</option>
              <option value="2">강아지</option>
            </select>
          </div>
          <div class="form-group col-md-4">
            <label for="itemName">상품명</label>
            <input type="text" class="form-control" name="itemName" id="itemName">
          </div>
        </div>
        <div class="form-group">
          <label for="itemContent">상품 설명</label>
          <textarea class="form-control" name="itemContent" id="itemContent" rows="4"></textarea>
        </div>
        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="itemPrice">정가</label>
            <input type="number" class="form-control" name="itemPrice" id="itemPrice">
          </div>
          <div class="form-group col-md-4">
            <label for="itemSprice">할인가</label>
            <input type="number" class="form-control" name="itemSprice" id="itemSprice">
          </div>
        </div>
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">상품 이미지</h5>
        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="img1">대표 이미지</label>
            <input type="file" class="form-control" name="img1" id="img1">
          </div>
          <div class="form-group col-md-4">
            <label for="img2">추가 이미지</label>
            <input type="file" class="form-control" name="img2" id="img2">
          </div>
          <div class="form-group col-md-4">
            <label for="img3">추가 이미지</label>
            <input type="file" class="form-control" name="img3" id="img3">
          </div>
        </div>
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">옵션 정보</h5>
        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="size">사이즈</label>
            <select class="form-control" name="size" id="size">
              <option value="">선택하세요</option>
              <option>XS</option>
              <option>S</option>
              <option>M</option>
              <option>L</option>
              <option>XL</option>
            </select>
          </div>
          <div class="form-group col-md-4">
            <label for="color">색상</label>
            <input type="text" class="form-control" name="color" id="color">
          </div>
          <div class="form-group col-md-4">
            <label for="additionalPrice">추가 금액</label>
            <input type="number" class="form-control" name="additionalPrice" id="additionalPrice" value="0">
          </div>
        </div>
        <div class="form-group">
          <label for="stock">재고 수량</label>
          <input type="number" class="form-control" name="stock" id="stock">
        </div>
      </section>

      <div class="btn-group-fixed mb-3">
        <button id="btn_add" type="button" class="btn btn-primary">등록하기</button>
        <button id="btn_reset" type="button" class="btn btn-secondary">초기화</button>
      </div>

      <div id="errorMsg" class="text-danger" style="display:none; margin-top:1rem;">빈칸이 있습니다.</div>
    </form>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/item/add.js"></script>
