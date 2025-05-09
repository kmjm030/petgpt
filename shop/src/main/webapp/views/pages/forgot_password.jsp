<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>비밀번호 찾기 - PetGPT</title>
      <link rel="stylesheet" href="<c:url value='/css/signin.css'/>">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
      <style>
        .success-message {
          color: #4CAF50;
          margin-top: 15px;
          text-align: center;
          font-weight: bold;
        }

        .error-message {
          color: #f44336;
          margin-top: 15px;
          text-align: center;
        }

        .forgot-container {
          max-width: 550px;
          margin: 85px auto;
          display: flex;
          flex-direction: column;
          align-items: center;
        }

        .forgot-box {
          background-color: #ffffff;
          border: 1px solid #dbdbdb;
          padding: 50px 70px;
          margin-bottom: 20px;
          text-align: center;
          border-radius: 8px;
          width: 100%;
          box-sizing: border-box;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .logo-section {
          text-align: center;
          margin-bottom: 35px;
        }

        .form-title {
          text-align: center;
          margin-bottom: 22px;
          color: #333;
          font-size: 28px;
        }

        .instruction {
          text-align: center;
          color: #666;
          margin-bottom: 25px;
          font-size: 16px;
          line-height: 1.5;
        }

        .input-field {
          position: relative;
          margin-bottom: 20px;
        }

        .input-field input {
          width: 100%;
          padding: 20px 14px 8px;
          background-color: #ffffff;
          border: 1px solid #dbdbdb;
          border-radius: 8px;
          color: #000000;
          font-size: 17px;
          box-sizing: border-box;
          outline: none;
        }

        .submit-btn {
          width: 100%;
          padding: 14px;
          background-color: #000000;
          border: none;
          border-radius: 10px;
          color: white;
          font-weight: 600;
          font-size: 18px;
          cursor: pointer;
          margin-top: 25px;
          opacity: 1;
          transition: opacity 0.2s;
        }

        .submit-btn:disabled {
          background-color: #cccccc;
          cursor: not-allowed;
        }

        .back-link {
          text-align: center;
          margin-top: 25px;
          font-size: 17px;
        }

        .back-link a {
          color: #000000;
          text-decoration: none;
          font-weight: 600;
        }

        .back-link a:hover {
          text-decoration: underline;
        }
      </style>
    </head>

    <body>
      <div class="forgot-container">
        <div class="forgot-box">
          <div class="logo-section">
            <img src="<c:url value='/img/logo/logo.png'/>" alt="PetGPT" style="width: 260px; margin: 30px auto 40px;">
          </div>

          <h2 class="form-title">비밀번호 찾기</h2>
          <p class="instruction">가입 시 등록한 아이디와 이메일을 입력하시면<br>비밀번호 재설정 링크를 이메일로 보내드립니다.</p>

          <div id="resetForm">
            <div class="input-field">
              <input type="text" id="custId" name="custId" placeholder="아이디" required>
            </div>
            <div class="input-field">
              <input type="email" id="email" name="email" placeholder="이메일" required>
            </div>
            <button type="button" id="requestResetBtn" class="submit-btn">비밀번호 재설정 링크 받기</button>
          </div>

          <div id="message" class="success-message" style="display: none;"></div>

          <div class="back-link">
            <a href="<c:url value='/signin'/>">로그인 화면으로 돌아가기</a>
          </div>
        </div>
      </div>

      <script>
        document.addEventListener('DOMContentLoaded', function () {
          const requestResetBtn = document.getElementById('requestResetBtn');
          const messageDiv = document.getElementById('message');

          requestResetBtn.addEventListener('click', function () {
            const custId = document.getElementById('custId').value.trim();
            const email = document.getElementById('email').value.trim();

            if (!custId) {
              showError('아이디를 입력해주세요.');
              return;
            }

            if (!email) {
              showError('이메일을 입력해주세요.');
              return;
            }

            // 버튼 비활성화 및 로딩 상태 표시
            requestResetBtn.disabled = true;
            requestResetBtn.textContent = '처리 중...';

            // AJAX 요청
            fetch('/password/request-reset', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body: 'custId=' + encodeURIComponent(custId) + '&email=' + encodeURIComponent(email)
            })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  showSuccess(data.message);
                  // 입력 폼 숨기기
                  document.getElementById('resetForm').style.display = 'none';
                } else {
                  showError(data.message);
                }
              })
              .catch(error => {
                console.error('Error:', error);
                showError('요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
              })
              .finally(() => {
                // 버튼 상태 복원
                requestResetBtn.disabled = false;
                requestResetBtn.textContent = '비밀번호 재설정 링크 받기';
              });
          });

          function showSuccess(message) {
            messageDiv.innerHTML = message.replace(/\n/g, '<br>');
            messageDiv.className = 'success-message';
            messageDiv.style.display = 'block';
          }

          function showError(message) {
            messageDiv.innerHTML = message.replace(/\n/g, '<br>');
            messageDiv.className = 'error-message';
            messageDiv.style.display = 'block';
          }
        });
      </script>
    </body>

    </html>