<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
    $(function () {
        $('#btn_update').click(() => {
            $('#detail_form').attr({
                method: 'post',
                action: '<c:url value="/board/update"/>'
            }).submit();
        });

        $('#btn_delete').click(() => {
            const id = $('#id').val();
            if (confirm('삭제하시겠습니까?')) {
                location.href = '<c:url value="/board/delete"/>' + '?id=' + id;
            }
        });
    });
</script>

<div class="container-fluid">
    <div class="card p-4 mb-4">
        <h2 class="mb-3 font-weight-bold">문의글 상세</h2>
        <form id="detail_form">
            <div class="form-group">
                <label>Board Key</label>
                <input type="text" readonly class="form-control" id="id" name="boardKey" value="${board.boardKey}">
            </div>
            <div class="form-group">
                <label>Title</label>
                <input type="text" class="form-control" name="boardTitle" value="${board.boardTitle}">
            </div>
            <div class="form-group">
                <label>Content</label>
                <textarea name="boardContent" class="form-control" rows="5">${board.boardContent}</textarea>
            </div>
            <div class="form-group">
                <label>상품 이미지</label><br>
                <img src="<c:url value='/img/item/${item.itemImg1}'/>" width="300" class="rounded">
            </div>
            <div class="form-group">
                <label>Option</label>
                <p>${board.boardOption}</p>
            </div>
            <div class="form-group">
                <label>등록일</label>
                <p><fmt:formatDate value="${board.boardRdate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
            </div>
            <div class="form-group">
                <label>수정일</label>
                <p><fmt:formatDate value="${board.boardUpdate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
            </div>
            <div class="d-flex gap-2">
                <button type="button" id="btn_update" class="btn btn-dark">수정</button>
                <button type="button" id="btn_delete" class="btn btn-outline-danger">삭제</button>
            </div>
        </form>
    </div>

    <c:if test="${not empty adminComments}">
        <div class="card p-4 mb-4">
            <h3 class="mb-3">관리자 댓글</h3>
            <table class="table table-bordered">
                <thead class="thead-light">
                <tr>
                    <th>게시판글번호</th>
                    <th>댓글번호</th>
                    <th>관리자ID</th>
                    <th>내용</th>
                    <th>작성일</th>
                    <th>수정일</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>${adminComments.boardKey}</td>
                    <td>${adminComments.adcommentsKey}</td>
                    <td>${adminComments.adminId}</td>
                    <td>${adminComments.adcommentsContent}</td>
                    <td>${adminComments.adcommentsRdate}</td>
                    <td>${adminComments.adcommentsUpdate}</td>
                </tr>
                </tbody>
            </table>
        </div>
    </c:if>

    <div class="card p-4">
        <h3 class="mb-3">관련 상품 정보</h3>
        <form>
            <div class="form-group">
                <label>상품 번호</label>
                <input type="text" readonly class="form-control" value="${item.itemKey}">
            </div>
            <div class="form-group">
                <label>카테고리 번호</label>
                <input type="number" class="form-control" value="${item.categoryKey}">
            </div>
            <div class="form-group">
                <label>상품명</label>
                <input type="text" class="form-control" value="${item.itemName}">
            </div>
            <div class="form-group">
                <label>상품 설명</label>
                <textarea class="form-control" rows="4">${item.itemContent}</textarea>
            </div>
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label>정가</label>
                    <input type="number" class="form-control" value="${item.itemPrice}">
                </div>
                <div class="form-group col-md-4">
                    <label>할인가</label>
                    <input type="number" class="form-control" value="${item.itemSprice}">
                </div>
                <div class="form-group col-md-4">
                    <label>재고 수량</label>
                    <input type="number" class="form-control" value="${item.itemCount}">
                </div>
            </div>
            <div class="form-group">
                <label>이미지</label><br>
                <c:forEach var="i" begin="1" end="3">
                    <c:set var="img" value="${item['itemImg' += i]}"/>
                    <c:choose>
                        <c:when test="${not empty img}">
                            <img src="<c:url value='/img/item/${img}'/>" width="100" class="mr-2 mb-2">
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">이미지 없음</span>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </form>
    </div>
</div>