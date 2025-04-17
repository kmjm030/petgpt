<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>PetGPT 관리자 로그인</title>

  <link href="https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;600&display=swap" rel="stylesheet">

  <style>
    body {
      margin: 0;
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #f5f5f7;
      font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
    }

    .login-box {
      background: #fff;
      padding: 3rem 2.5rem;
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
      width: 360px;
      text-align: center;
      animation: fadeInUp 0.4s ease-out;
      box-sizing: border-box;
    }

    .login-logo {
      width: 200px;
      height: auto;
      margin-bottom: 1.2rem;
      transition: transform 0.3s ease;
    }

    .login-logo:hover {
      transform: scale(1.03);
    }

    .login-title {
      font-size: 1.4rem;
      font-weight: 600;
      margin-bottom: 2rem;
      color: #1d1d1f;
    }

    .form-input {
      width: 100%;
      padding: 12px;
      margin-bottom: 1rem;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 0.95rem;
      box-sizing: border-box;
      transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    .form-input:focus {
      outline: none;
      border-color: #0071e3;
      box-shadow: 0 0 0 2px rgba(0, 113, 227, 0.2);
    }

    ::placeholder {
      color: #999;
      font-size: 0.9rem;
    }

    .login-btn {
      width: 100%;
      padding: 12px;
      background-color: #1d1d1f;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      font-size: 1rem;
      cursor: pointer;
      transition: background-color 0.2s ease;
    }

    .login-btn:hover {
      background-color: #000;
    }

    .error-msg {
      color: red;
      font-size: 0.9rem;
      margin-bottom: 1rem;
    }

    @media (max-width: 480px) {
      .login-box {
        width: 90%;
        padding: 2rem 1.5rem;
      }
    }

    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
  </style>
</head>

<body>

<div class="login-box">
  <img src="<c:url value='/img/logo.png'/>" class="login-logo" alt="PetGPT 로고">
  <div class="login-title">관리자 로그인</div>

  <c:if test="${not empty error}">
    <div class="error-msg">${error}</div>
  </c:if>

  <form method="post" action="<c:url value='/loginimpl'/>">
    <input type="text" name="id" placeholder="아이디" class="form-input" required>
    <input type="password" name="pwd" placeholder="비밀번호" class="form-input" required>
    <button type="submit" class="login-btn">로그인</button>
  </form>
</div>

</body>
</html>
