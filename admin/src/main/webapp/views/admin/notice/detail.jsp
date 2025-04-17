<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .notice-detail {
    max-width: 800px;
    margin: 0 auto;
    background-color: #fff;
    padding: 2rem;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  }

  .notice-detail h2 {
    font-size: 1.6rem;
    margin-bottom: 1.2rem;
    color: #1d1d1f;
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .notice-meta {
    font-size: 0.9rem;
    color: #6e6e73;
    margin-bottom: 1.5rem;
  }

  .notice-content {
    font-size: 1rem;
    line-height: 1.6;
    color: #1d1d1f;
    white-space: pre-line;
  }

  .back-link {
    display: inline-block;
    margin-top: 1.5rem;
    text-decoration: none;
    font-size: 0.9rem;
    color: #0071e3;
  }

  .back-link:hover {
    text-decoration: underline;
  }
</style>

<div class="notice-detail">
  <h2><i class="fas fa-bullhorn" style="color:#1d1d1f;"></i> ${notice.title}</h2>

  <div class="notice-meta">
    작성자: ${notice.adminId} | 작성일: ${notice.createdAt}
  </div>

  <div class="notice-content">
    ${notice.content}
  </div>

  <a href="<c:url value='/admin/notice/get'/>" class="back-link">← 공지 목록으로 돌아가기</a>
</div>
