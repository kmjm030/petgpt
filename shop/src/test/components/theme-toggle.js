document.addEventListener("DOMContentLoaded", () => {
  const themeToggleButton = document.getElementById("themeToggleButton");
  const bodyElement = document.body;

  // 초기 테마 설정 (localStorage에서 가져오거나 시스템 설정을 사용)
  function getInitialTheme() {
    const savedTheme = localStorage.getItem("theme");

    if (savedTheme) {
      return savedTheme;
    }

    // 시스템 설정 확인
    if (
      window.matchMedia &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
    ) {
      return "dark";
    }

    return "light";
  }

  // 초기 테마 설정
  let currentTheme = getInitialTheme();

  function applyTheme(theme) {
    bodyElement.dataset.theme = theme; // body 태그에 data-theme 속성 설정
    themeToggleButton.dataset.state = theme === "dark" ? "on" : "off";
    themeToggleButton.setAttribute(
      "aria-pressed",
      (theme === "dark").toString()
    );
    themeToggleButton.setAttribute(
      "aria-label",
      `Switch to ${theme === "dark" ? "light" : "dark"} mode`
    );

    // localStorage에 테마 저장
    localStorage.setItem("theme", theme);
    console.log("Theme set to:", theme);
  }

  // 버튼 클릭 이벤트
  themeToggleButton.addEventListener("click", () => {
    currentTheme = currentTheme === "dark" ? "light" : "dark";
    applyTheme(currentTheme);
  });

  // 초기 테마 적용
  applyTheme(currentTheme);
});
