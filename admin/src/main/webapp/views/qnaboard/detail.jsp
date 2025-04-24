<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

<style>
    body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        background-color: #f5f5f7;
        color: #1d1d1f;
        padding: 2rem;
    }

    h1 {
        font-size: 1.6rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
    }

    .card {
        background-color: #fff;
        border-radius: 20px;
        padding: 2rem;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
        margin-bottom: 2rem;
    }

    .card-header {
        margin-bottom: 1rem;
    }

    .form-group {
        margin-bottom: 1.2rem;
    }

    label {
        font-weight: 600;
        display: block;
        margin-bottom: 0.5rem;
    }

    .form-control {
        border-radius: 10px;
        padding: 0.7rem;
        border: 1px solid #ccc;
        font-size: 0.95rem;
        width: 100%;
    }

    .form-group img {
        border-radius: 12px;
        max-width: 100%;
    }

    .btn {
        padding: 0.6rem 1.4rem;
        border-radius: 10px;
        font-weight: 600;
        border: none;
        margin-right: 0.5rem;
    }

    .btn-primary {
        background-color: #1d1d1f;
        color: #fff;
    }

    .btn-primary:hover {
        background-color: #333;
    }

    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }

    body.dark-mode .card {
        background-color: #2c2c2e;
        color: #f5f5f7;
        border: 1px solid #3a3a3c;
    }

    body.dark-mode .form-control {
        background-color: #2c2c2e;
        color: #f5f5f7;
        border: 1px solid #3a3a3c;
    }

    body.dark-mode .btn-primary {
        background-color: #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode .btn-primary:hover {
        background-color: #4a4a4a;
    }
</style>

<div class="container-fluid">
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
