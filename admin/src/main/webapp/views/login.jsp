<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>PetGPT 관리자 로그인</title>
  <link href="https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="<c:url value='/css/login.css'/>">
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