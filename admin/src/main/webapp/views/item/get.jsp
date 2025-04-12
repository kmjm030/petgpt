<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    #dataTable img {
        width: 100px !important;
    }
</style>

<div class="container-fluid">

    <h1 class="h3 mb-2 text-gray-800">상품 목록</h1>
    <p class="mb-4">DataTables를 사용하여 동적 테이블을 구성합니다.</p>

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
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="item" items="${itemlist}">
                        <tr>
                            <td>
                                <a href="<c:url value='/item/detail'/>?item_key=${item.itemKey}">
                                    <c:choose>
                                        <c:when test="${not empty item.itemImg1}">
                                            <img src="<c:url value='/img/item/${item.itemImg1}'/>">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">이미지 없음</span>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </td>
                            <td>${item.itemKey}</td>
                            <td>${item.itemName}</td>
                            <td>
                                <fmt:formatNumber type="number" pattern="###,###원" value="${item.itemPrice}" />
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<script>
    $(document).ready(function () {
        $('#dataTable').DataTable({
            columnDefs: [
                { orderable: true, targets: 1 },
                { orderable: false, targets: [0, 2, 3] }
            ],
            order: [[1, "asc"]]
        });
    });
</script>




