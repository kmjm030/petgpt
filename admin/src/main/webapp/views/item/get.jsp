<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.7.0/css/buttons.bootstrap4.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/item.css">

<div class="container-fluid">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="page-title mb-0">상품 목록</h1>
    <a href="<c:url value='/item/add'/>" class="btn btn-dark shadow-sm px-4 py-2 rounded-pill">
      <i class="bi bi-plus-circle me-1"></i> 상품 추가
    </a>
  </div>

  <div class="card">
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-hover table-bordered" id="dataTable">
          <thead class="thead-light">
          <tr>
            <th>이미지</th>
            <th>상품 번호</th>
            <th>상품명</th>
            <th>가격</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="item" items="${itemlist}">
            <tr>
              <td>
                <c:choose>
                  <c:when test="${not empty item.itemImg1}">
                    <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}">
                      <img src="<c:url value='/img/item/${item.itemImg1}'/>" alt="상품 이미지" class="img-thumbnail" style="max-height: 60px;">
                    </a>
                  </c:when>
                  <c:otherwise>
                    <div class="img-thumb text-center">
                      <i class="bi bi-image" style="font-size: 1.5rem;"></i>
                    </div>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>${item.itemKey}</td>
              <td class="font-weight-bold">
                <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}" style="color: inherit; text-decoration: none;">
                    ${item.itemName}
                </a>
              </td>
              <td class="price-cell">
                <fmt:formatNumber value="${item.itemPrice}" pattern="#,##0"/> 원
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<script src="https://cdn.datatables.net/buttons/1.7.0/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.0/js/buttons.bootstrap4.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.0/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/1.7.0/js/buttons.print.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="/js/item/get.js"></script>

