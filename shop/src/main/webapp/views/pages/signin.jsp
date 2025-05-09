<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>PetGPT 로그인</title>
      <link rel="stylesheet" href="<c:url value='/css/signin.css'/>">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
      <style>
        #msg {
          color: darkred;
          margin-top: 10px;
          text-align: center;
        }
      </style>
    </head>

    <body>
      <div class="main-container">
        <div class="left-panel">
          <div class="image-carousel">
            <div class="ui-overlay overlay1"></div>
            <div class="ui-overlay overlay2"></div>
            <div class="ui-overlay overlay3"></div>
            <div class="ui-overlay overlay4"></div>
            <div class="ui-overlay overlay5"></div>
          </div>
        </div>

        <div class="right-panel">
          <div class="login-form-container">
            <div class="login-box">
              <img src="<c:url value='/img/logo/logo.png'/>" alt="PetGPT" class="instagram-logo"
                onerror="this.style.display='none'; document.getElementById('logo-text').style.display='block';">
              <h1 id="logo-text" class="logo-text">PetGPT</h1>

              <form id="loginForm" data-action-url="<c:url value='/loginimpl'/>">
                <div class="input-field">
                  <input type="text" id="id" name="id" required>
                  <label for="id">아이디</label>
                </div>
                <div class="input-field password-field">
                  <input type="password" id="pwd" name="pwd" required>
                  <label for="pwd">비밀번호</label>
                  <button type="button" id="togglePassword">비밀번호 표시</button>
                </div>
                <button type="button" class="login-button" onclick="login.send()">로그인</button>
              </form>

              <!-- 오류 메시지 표시 -->
              <c:if test="${msg != null}">
                <h6 id="msg">${msg}</h6>
              </c:if>

              <div class="separator">
                <div class="line"></div>
                <div class="or-text">또는</div>
                <div class="line"></div>
              </div>

              <div class="social-login-buttons">
                <a href="<c:url value='/auth/google'/>" class="google-login-btn">
                  <i class="fab fa-google"></i> Google로 로그인
                </a>
                <a href="javascript:login.kakaoLogin()" class="kakao-login-btn">
                  <i class="fas fa-comment"></i> 카카오 로그인
                </a>
              </div>

              <a href="<c:url value='/password/forgot'/>" class="forgot-password">비밀번호를 잊으셨나요?</a>
            </div>

            <div class="signup-box">
              <p>계정이 없으신가요? <a href="<c:url value='/signup'/>">가입하기</a></p>
            </div>

          </div>
        </div>
      </div>

      <script src="<c:url value='/js/signin.js'/>"></script>

      <script>
        let login = {
          send: function () {
            const form = document.getElementById('loginForm');
            const actionUrl = form.getAttribute('data-action-url');
            const id = document.getElementById('id').value;
            const pwd = document.getElementById('pwd').value;

            if (id.trim() === '' || pwd.trim() === '') {
              alert('아이디와 비밀번호를 모두 입력해주세요.');
              return;
            }

            const formData = new FormData();
            formData.append('id', id);
            formData.append('pwd', pwd);

            fetch(actionUrl, {
              method: 'POST',
              body: formData
            })
              .then(response => {
                if (response.redirected) {
                  window.location.href = response.url;
                } else {
                  return response.text();
                }
              })
              .then(data => {
                if (data && !data.includes('<!DOCTYPE html>')) {
                  const msg = document.getElementById('msg');
                  if (msg) {
                    msg.textContent = data;
                  } else {
                    const msgElement = document.createElement('h6');
                    msgElement.id = 'msg';
                    msgElement.textContent = data;
                    document.getElementById('loginForm').after(msgElement);
                  }
                }
              })
              .catch(error => {
                console.error('Error:', error);
              });
          },

          kakaoLogin: function () {
            window.location.href = '/auth/kakao';
          }
        };
      </script>
    </body>

    </html>