<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    #dataTable img {
        width: 100px !important;
    }
</style>

<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">상품 목록</h1>
    <p class="mb-4">DataTables를 사용하여 동적 테이블을 구성합니다.</p>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">상품 목록 테이블</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>Image</th>
                        <th>Item Key</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Reg Date</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="item" items="${itemlist}">
                        <tr>
                            <td>
                                <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}">
                                    <img src="<c:url value='/img/item/${item.itemImg1}'/>">
                                </a>
                            </td>
                            <td>${item.itemKey}</td>
                            <td>${item.itemName}</td>
                            <td>
                                <fmt:formatNumber type="number" pattern="###,###원" value="${item.itemPrice}" />
                            </td>
                            <td>
                                <fmt:formatDate value="${item.itemRdate}" pattern="yyyy-MM-dd" />
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>


