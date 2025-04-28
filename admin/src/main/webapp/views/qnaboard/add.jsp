<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
    const board_add = {
        init: function () {
            $('#btn_add').click(() => {
                if (confirm('등록하시겠습니까?')) {
                    this.send();
                }
            });
        },
        send: function () {
            $('#board_form').attr({
                method: 'post',
                action: '<c:url value="/board/addimpl"/>'
            }).submit();
        }
    };

    $(function () {
        board_add.init();
    });
</script>

<style>
    body {
        background-color: #f5f5f7;
        color: #1d1d1f;
        font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        padding: 2rem;
    }

    .form-wrapper {
        max-width: 700px;
        margin: 0 auto;
        background-color: #fff;
        padding: 2rem;
        border-radius: 20px;
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
    }

    h1 {
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
    }

    .form-group {
        margin-bottom: 1.2rem;
    }

    .form-group label {
        font-weight: 600;
        margin-bottom: 0.4rem;
        display: block;
    }

    .form-control {
        font-size: 0.95rem;
        padding: 0.6rem;
        border-radius: 10px;
        border: 1px solid #ccc;
    }

    .btn-primary {
        background-color: #1d1d1f;
        color: #fff;
        border: none;
        padding: 0.6rem 1.5rem;
        border-radius: 10px;
        font-weight: 600;
        transition: background-color 0.2s ease;
    }

    .btn-primary:hover {
        background-color: #333;
    }

    body.dark-mode {
        background-color: #1d1d1f;
        color: #f5f5f7;
    }

    body.dark-mode .form-wrapper {
        background-color: #2c2c2e;
        border-color: #3a3a3c;
    }

    body.dark-mode .form-control {
        background-color: #2c2c2e;
        border: 1px solid #3a3a3c;
        color: #f5f5f7;
    }

    body.dark-mode .form-control::placeholder {
        color: #aaa;
    }

    body.dark-mode .btn-primary {
        background-color: #3a3a3c;
        border: 1px solid #4a4a4a;
        color: #f5f5f7;
    }

    body.dark-mode .btn-primary:hover {
        background-color: #4a4a4a;
    }
</style>

<div class="form-wrapper">
    <h1>문의글 작성</h1>
    <form id="board_form">
        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" class="form-control" id="title" name="boardTitle" placeholder="제목을 입력하세요" required>
        </div>
        <div class="form-group">
            <label for="content">내용</label>
            <textarea class="form-control" id="content" name="boardContent" rows="6" placeholder="내용을 입력하세요" required></textarea>
        </div>
        <input type="hidden" name="boardAuthor" value="${sessionScope.admin}" />
        <button id="btn_add" type="button" class="btn btn-primary">등록하기</button>
    </form>
</div>
