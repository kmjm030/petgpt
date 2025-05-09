document.addEventListener("DOMContentLoaded", function () {
  // Password Toggle
  const passwordInput = document.getElementById("pwd");
  const togglePasswordButton = document.getElementById("togglePassword");

  if (togglePasswordButton && passwordInput) {
    togglePasswordButton.addEventListener("click", function () {
      const type =
        passwordInput.getAttribute("type") === "password" ? "text" : "password";
      passwordInput.setAttribute("type", type);
      this.textContent = type === "password" ? "비밀번호 표시" : "숨기기";
    });
  }

  // Floating Label Logic (ensure labels are up if inputs have pre-filled values)
  const inputs = document.querySelectorAll(".input-field input");
  inputs.forEach((input) => {
    // For pre-filled values on page load
    if (input.value.trim() !== "" || document.activeElement === input) {
      input.classList.add("has-content"); // Add class to style label
      if (input.labels && input.labels.length > 0) {
        input.labels[0].classList.add("active-label");
      }
    }

    input.addEventListener("focus", function () {
      if (this.labels && this.labels.length > 0) {
        this.labels[0].classList.add("active-label");
      }
    });

    input.addEventListener("blur", function () {
      if (this.value.trim() === "" && this.labels && this.labels.length > 0) {
        this.labels[0].classList.remove("active-label");
      }
    });

    // Initial check for value (especially for 'value' attribute in HTML)
    if (input.value) {
      if (input.labels && input.labels.length > 0) {
        input.labels[0].classList.add("active-label");
      }
    }
  });

  // Login Form Logic
  const loginForm = document.getElementById("loginForm");
  if (loginForm) {
    loginForm.addEventListener("submit", function (event) {
      event.preventDefault(); // Prevent actual form submission for demo
      const username = loginForm.username.value;
      const password = loginForm.password.value;
      if (username && password) {
        alert(
          `로그인 시도:\n사용자: ${username}\n비밀번호: (보안상 표시 안함)`
        );
        // In a real app, you'd send this to a server
      } else {
        alert("사용자 이름과 비밀번호를 모두 입력해주세요.");
      }
    });
  }

  // 소셜 로그인 버튼 스타일 조정 (a 태그로 변경되었으므로)
  const socialButtons = document.querySelectorAll(".social-login-buttons a");
  if (socialButtons) {
    socialButtons.forEach((button) => {
      button.style.textDecoration = "none";
    });
  }
});
