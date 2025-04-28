<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    $(function () {
        $('#btn_add').click(() => {
            if (confirm('등록하시겠습니까?')) {
                $('#board_form').attr({
                    method: 'post',
                    action: '<c:url value="/board/addimpl"/>'
                }).submit();
            }
        });
    });
</script>

<style>
    body {
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        background-color: #fff;
        color: #1d1d1f;
        padding: 2rem;
    }

    h1 {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 1rem;
    }

    .card {
        background-color: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 20px;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
        padding: 2rem;
    }

    label {
        font-weight: 600;
        margin-bottom: 0.5rem;
    }

    .form-control {
        font-size: 0.95rem;
        border-radius: 10px;
    }

    .btn-primary {
        background-color: #1d1d1f;
        border: none;
        border-radius: 12px;
        padding: 10px 24px;
        font-weight: 600;
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
        border-color: #3a3a3c;
    }

    body.dark-mode input,
    body.dark-mode textarea {
        background-color: #2c2c2e;
        border: 1px solid #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode input::placeholder,
    body.dark-mode textarea::placeholder {
        color: #aaa;
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
    <h1>문의글 등록</h1>
    <div class="card">
        <form id="board_form">
            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" class="form-control" id="title" name="boardTitle" placeholder="제목을 입력하세요.">
            </div>
            <div class="form-group">
                <label for="content">내용</label>
                <textarea class="form-control" id="content" name="boardContent" rows="5" placeholder="문의 내용을 입력하세요."></textarea>
            </div>
            <input type="hidden" name="boardAuthor" value="${sessionScope.admin}">
            <button id="btn_add" type="button" class="btn btn-primary">등록하기</button>
        </form>
    </div>
</div>
