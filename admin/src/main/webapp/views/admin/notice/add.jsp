<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .notice-form {
        max-width: 600px;
        margin: 0 auto;
        background-color: #fff;
        padding: 2rem;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    .notice-form h2 {
        font-size: 1.5rem;
        margin-bottom: 1.5rem;
        color: #1d1d1f;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .form-group {
        margin-bottom: 1.2rem;
    }

    .form-group label {
        display: block;
        font-weight: 500;
        margin-bottom: 0.5rem;
        color: #333;
    }

    .form-group input,
    .form-group textarea {
        width: 100%;
        padding: 0.6rem;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 0.95rem;
    }

    .form-group textarea {
        resize: vertical;
        min-height: 120px;
    }

    .submit-btn {
        background-color: #1d1d1f;
        color: white;
        padding: 0.6rem 1.5rem;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 0.95rem;
    }

    .submit-btn:hover {
        background-color: #333;
    }
</style>

<div class="notice-form">
    <h2><i class="fas fa-bullhorn" style="color:#1d1d1f;"></i> 관리자 공지 등록</h2>
    <form method="post" action="<c:url value='/admin/notice/addimpl'/>">
        <div class="form-group">
            <label for="adminId">작성자 ID</label>
            <input type="text" id="adminId" name="adminId" required>
        </div>

        <div class="form-group">
            <label for="title">공지 제목</label>
            <input type="text" id="title" name="title" required>
        </div>

        <div class="form-group">
            <label for="content">공지 내용</label>
            <textarea id="content" name="content" required></textarea>
        </div>

        <button type="submit" class="submit-btn">등록</button>
    </form>
</div>
