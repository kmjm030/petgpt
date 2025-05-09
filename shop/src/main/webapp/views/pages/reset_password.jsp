<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>비밀번호 재설정 - PetGPT</title>
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

        .reset-container {
          max-width: 550px;
          margin: 85px auto;
          display: flex;
          flex-direction: column;
          align-items: center;
        }

        .reset-box {
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

        .password-strength {
          height: 5px;
          margin-top: -5px;
          margin-bottom: 10px;
          border-radius: 0 0 8px 8px;
          transition: all 0.3s;
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

        .password-info {
          font-size: 14px;
          color: #666;
          margin-top: 8px;
          margin-bottom: 15px;
          text-align: left;
        }

        .password-toggle {
          position: absolute;
          right: 15px;
          top: 14px;
          cursor: pointer;
          color: #888;
          font-size: 16px;
        }
      </style>
    </head>

    <body>
      <div class="reset-container">
        <div class="reset-box">
          <div class="logo-section">
            <img src="<c:url value='/img/logo/logo.png'/>" alt="PetGPT" style="width: 260px; margin: 30px auto 40px;">
          </div>

          <h2 class="form-title">비밀번호 재설정</h2>

          <div id="resetForm">
            <input type="hidden" id="token" value="${token}">

            <div class="input-field">
              <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호" required>
              <i class="password-toggle fas fa-eye-slash" id="toggleNewPassword"></i>
            </div>
            <div class="password-strength" id="passwordStrength"></div>
            <p class="password-info">비밀번호는 8자 이상이어야 합니다.</p>

            <div class="input-field">
              <input type="password" id="confirmPassword" name="confirmPassword" placeholder="새 비밀번호 확인" required>
              <i class="password-toggle fas fa-eye-slash" id="toggleConfirmPassword"></i>
            </div>

            <button type="button" id="resetPasswordBtn" class="submit-btn" disabled>비밀번호 변경하기</button>
          </div>

          <div id="message" class="success-message" style="display: none;"></div>

          <div class="back-link" id="loginLink" style="display: none;">
            <a href="<c:url value='/signin'/>">로그인 화면으로 이동</a>
          </div>
        </div>
      </div>

      <script>
        document.addEventListener('DOMContentLoaded', function () {
          const resetPasswordBtn = document.getElementById('resetPasswordBtn');
          const messageDiv = document.getElementById('message');
          const newPasswordInput = document.getElementById('newPassword');
          const confirmPasswordInput = document.getElementById('confirmPassword');
          const passwordStrength = document.getElementById('passwordStrength');
          const loginLink = document.getElementById('loginLink');

          document.getElementById('toggleNewPassword').addEventListener('click', function () {
            togglePasswordVisibility(newPasswordInput, this);
          });

          document.getElementById('toggleConfirmPassword').addEventListener('click', function () {
            togglePasswordVisibility(confirmPasswordInput, this);
          });

          function togglePasswordVisibility(input, icon) {
            if (input.type === 'password') {
              input.type = 'text';
              icon.classList.remove('fa-eye-slash');
              icon.classList.add('fa-eye');
            } else {
              input.type = 'password';
              icon.classList.remove('fa-eye');
              icon.classList.add('fa-eye-slash');
            }
          }

          newPasswordInput.addEventListener('input', validatePasswords);
          confirmPasswordInput.addEventListener('input', validatePasswords);

          function validatePasswords() {
            const newPassword = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            let strength = 0;
            if (newPassword.length >= 8) strength += 1;
            if (newPassword.length >= 10) strength += 1;
            if (/[A-Z]/.test(newPassword)) strength += 1;
            if (/[0-9]/.test(newPassword)) strength += 1;
            if (/[^A-Za-z0-9]/.test(newPassword)) strength += 1;

            let color = '';
            switch (strength) {
              case 0: case 1:
                color = '#f44336';
                break;
              case 2: case 3:
                color = '#FF9800';
                break;
              case 4: case 5:
                color = '#4CAF50';
                break;
            }

            passwordStrength.style.backgroundColor = color;
            passwordStrength.style.width = (strength * 20) + '%';

            resetPasswordBtn.disabled = !(newPassword.length >= 8 && newPassword === confirmPassword);
          }

          resetPasswordBtn.addEventListener('click', function () {
            const token = document.getElementById('token').value;
            const newPassword = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (newPassword.length < 8) {
              showError('비밀번호는 8자 이상이어야 합니다.');
              return;
            }

            if (newPassword !== confirmPassword) {
              showError('비밀번호가 일치하지 않습니다.');
              return;
            }

            resetPasswordBtn.disabled = true;
            resetPasswordBtn.textContent = '처리 중...';

            fetch('/password/reset', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body: 'token=' + encodeURIComponent(token) +
                '&newPassword=' + encodeURIComponent(newPassword) +
                '&confirmPassword=' + encodeURIComponent(confirmPassword)
            })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  showSuccess(data.message);
                  document.getElementById('resetForm').style.display = 'none';
                  loginLink.style.display = 'block';
                } else {
                  showError(data.message);
                }
              })
              .catch(error => {
                console.error('Error:', error);
                showError('요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
              })
              .finally(() => {
                resetPasswordBtn.disabled = false;
                resetPasswordBtn.textContent = '비밀번호 변경하기';
              });
          });

          function showSuccess(message) {
            messageDiv.innerHTML = message.replace(/\n/g, '<br>');
            messageDiv.className = 'success-message';
            messageDiv.style.display = 'block';
          }

          function showError(message) {
            messageDiv.textContent = message;
            messageDiv.className = 'error-message';
            messageDiv.style.display = 'block';
          }
        });
      </script>
    </body>

    </html>