<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="/css/item.css">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/item/detail.js"></script>

<div class="container-fluid">
  <h1 class="h3 mb-4 font-weight-bold">
    상품 상세 정보
    <span class="badge ${item.isActive == 1 ? 'badge-success' : 'badge-secondary'} ml-2">
      ${item.isActive == 1 ? '활성화됨' : '비활성화됨'}
    </span>
  </h1>

  <div class="card shadow-sm p-4 mb-4">
    <form id="item_update_form">

      <section class="mb-4">
        <h5 class="section-title mb-3">기본 정보</h5>
        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="itemKey">상품 ID</label>
            <input type="text" readonly class="form-control" id="itemKey" name="itemKey" value="${item.itemKey}">
          </div>
          <div class="form-group col-md-4">
            <label for="categoryKey">카테고리</label>
            <select class="form-control" name="categoryKey" id="categoryKey">
              <option value="1" ${item.categoryKey == 1 ? 'selected' : ''}>고양이</option>
              <option value="2" ${item.categoryKey == 2 ? 'selected' : ''}>강아지</option>
            </select>
          </div>
          <div class="form-group col-md-4">
            <label for="itemName">상품명</label>
            <input type="text" class="form-control" name="itemName" id="itemName" value="${item.itemName}">
          </div>
        </div>
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">상품 설명</h5>
        <textarea class="form-control" name="itemContent" id="itemContent" rows="3">${item.itemContent}</textarea>
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">가격 및 재고</h5>
        <div class="form-row">
          <div class="form-group col-md-4">
            <label for="itemPrice">정가</label>
            <input type="number" class="form-control" name="itemPrice" id="itemPrice" value="${item.itemPrice}">
          </div>
          <div class="form-group col-md-4">
            <label for="itemSprice">할인가</label>
            <input type="number" class="form-control" name="itemSprice" id="itemSprice" value="${item.itemSprice}">
          </div>
          <div class="form-group col-md-4">
            <label for="itemCount">재고 수량</label>
            <input type="number" class="form-control" name="itemCount" id="itemCount" value="${item.itemCount}">
          </div>
        </div>
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">등록된 이미지</h5>
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
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">새 이미지 업로드</h5>
        <div class="form-row">
          <c:forEach var="i" begin="1" end="3">
            <div class="form-group col-md-4">
              <label for="img${i}">새 이미지 ${i}</label>
              <input type="file" class="form-control" name="img${i}" id="img${i}">
            </div>
          </c:forEach>
        </div>
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">옵션 정보 수정</h5>
        <div class="form-row">
          <div class="form-group col-md-3">
            <label for="size">사이즈</label>
            <input type="text" class="form-control" name="size" id="size" value="${option.size}">
          </div>
          <div class="form-group col-md-3">
            <label for="color">색상</label>
            <input type="text" class="form-control" name="color" id="color" value="${option.color}">
          </div>
          <div class="form-group col-md-3">
            <label for="stock">옵션 재고</label>
            <input type="number" class="form-control" name="stock" id="stock" value="${option.stock}">
          </div>
          <div class="form-group col-md-3">
            <label for="additionalPrice">추가금액</label>
            <input type="number" class="form-control" name="additionalPrice" id="additionalPrice" value="${option.additionalPrice}">
          </div>
        </div>
      </section>

      <section class="mb-4">
        <h5 class="section-title mb-3">관리 정보</h5>
        <table class="table table-bordered">
          <tr>
            <th>등록일</th>
            <td>
              <c:choose>
                <c:when test="${not empty itemRdateDate}">
                  <fmt:formatDate value="${itemRdateDate}" pattern="yyyy-MM-dd" />
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
          </tr>
          <tr>
            <th>수정일</th>
            <td>
              <c:choose>
                <c:when test="${not empty itemUdateDate}">
                  <fmt:formatDate value="${itemUdateDate}" pattern="yyyy-MM-dd" />
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </table>
      </section>

      <div class="btn-group-fixed">
        <button type="button" class="btn ${item.isActive == 1 ? 'btn-success' : 'btn-secondary'}"
                onclick="window.location.href='/item/toggleStatus?item_key=${item.itemKey}'">
          ${item.isActive == 1 ? '활성화됨' : '비활성화됨'}
        </button>
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
