<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/board.css">
<script>
    const board_detail = {
        init() {
            $('#btn_update').click(() => this.send());
            $('#btn_delete').click(() => {
                if (confirm('삭제하시겠습니까?')) {
                    const id = $('#id').val();
                    location.href = '<c:url value="/board/delete"/>?id=' + id;
                }
            });
        },
        send() {
            $('#detail_form').attr({
                method: 'post',
                action: '<c:url value="/board/update"/>'
            }).submit();
        }
    };

    $(function () {
        board_detail.init();
    });
</script>

<div class="board-detail-container">
    <h1>문의글 상세보기</h1>

    <div class="card">
        <div class="card-header">
            <h6 class="mb-0">문의글 - ${board.boardRe}</h6>
        </div>
        <div class="card-body">
            <form id="detail_form">
                <div class="form-group">
                    <label for="id">Board Key</label>
                    <input type="text" readonly value="${board.boardKey}" class="form-control" id="id" name="boardKey">
                </div>
                <div class="form-group">
                    <label for="title">Title</label>
                    <input type="text" value="${board.boardTitle}" class="form-control" id="title" name="boardTitle">
                </div>
                <div class="form-group">
                    <label for="content">Content</label>
                    <textarea name="boardContent" class="form-control" rows="5" id="content">${board.boardContent}</textarea>
                </div>
                <div class="form-group">
                    <label>상품 이미지</label><br>
                    <img src="<c:url value='/img/item/${item.itemImg1}'/>" alt="상품 이미지">
                </div>
                <div class="form-group">
                    <label>옵션</label>
                    <p>${board.boardOption}</p>
                </div>
                <div class="form-group">
                    <label>등록일</label>
                    <p><fmt:formatDate value="${board.boardRdate}" pattern="yyyy-MM-dd : HH:mm:ss" /></p>
                </div>
                <div class="form-group">
                    <label>수정일</label>
                    <p><fmt:formatDate value="${board.boardUpdate}" pattern="yyyy-MM-dd : HH:mm:ss" /></p>
                </div>

                <button id="btn_update" type="button" class="btn btn-primary">수정</button>
                <button id="btn_delete" type="button" class="btn btn-primary">삭제</button>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${adminComments == null}">
            <jsp:include page="addAdminComments.jsp"/>
        </c:when>
        <c:otherwise>
            <jsp:include page="adminComments.jsp"/>
        </c:otherwise>
    </c:choose>
</div>
