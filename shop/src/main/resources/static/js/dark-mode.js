document.addEventListener("DOMContentLoaded", function () {
  const mainLogo = document.getElementById("main-logo");
  const lightLogoSrc = mainLogo ? mainLogo.dataset.lightSrc : "";
  const darkLogoSrc = mainLogo ? mainLogo.dataset.darkSrc : "";

  // 다크모드 전환 애니메이션 시간 (CSS 변수와 일치)
  const TRANSITION_DURATION = 300; // 0.3s = 300ms

  // jQuery 없이도 작동하는 배경 이미지 설정 함수
  function applyThemeBackgrounds() {
    const isDarkMode =
      document.body.classList.contains("dark-mode") ||
      document.body.dataset.theme === "dark";

    // jQuery를 사용하는 기존 방식
    if (typeof $ === "function") {
      $(".set-bg").each(function () {
        const $this = $(this);
        const lightBg = $this.data("setbg");
        const darkBg = $this.data("setbg-dark");
        let targetBg = lightBg;

        if (isDarkMode && darkBg && !$this.closest(".hero").length) {
          targetBg = darkBg;
        }

        if (targetBg) {
          const currentBg = $this.css("background-image");
          const targetUrl = 'url("' + targetBg + '")';

          if (currentBg !== targetUrl) {
            $this.css("background-image", "url(" + targetBg + ")");
          }
        }
      });
    } else {
      // jQuery 없이 순수 JavaScript로 구현
      document.querySelectorAll(".set-bg").forEach(function (element) {
        const lightBg = element.dataset.setbg;
        const darkBg = element.dataset.setbgDark;
        let targetBg = lightBg;

        // 다크모드이고 다크모드용 배경이 있고 hero 클래스를 가진 부모 요소가 없을 때
        if (isDarkMode && darkBg && !element.closest(".hero")) {
          targetBg = darkBg;
        }

        if (targetBg) {
          const currentBg = getComputedStyle(element).backgroundImage;
          const targetUrl = 'url("' + targetBg + '")';

          if (currentBg !== targetUrl) {
            element.style.backgroundImage = "url(" + targetBg + ")";
          }
        }
      });
    }
  }

  // 테마 감시 및 로고 변경 이벤트 처리
  function observeThemeChanges() {
    // body의 data-theme 속성 변경을 감시
    const observer = new MutationObserver(function (mutations) {
      mutations.forEach(function (mutation) {
        if (mutation.attributeName === "data-theme") {
          const isDarkMode = document.body.dataset.theme === "dark";

          if (isDarkMode) {
            document.body.classList.add("dark-mode");
            if (mainLogo && darkLogoSrc) mainLogo.src = darkLogoSrc;
          } else {
            document.body.classList.remove("dark-mode");
            if (mainLogo && lightLogoSrc) mainLogo.src = lightLogoSrc;
          }

          setTimeout(applyThemeBackgrounds, TRANSITION_DURATION / 2);
        }
      });
    });

    observer.observe(document.body, {
      attributes: true,
      attributeFilter: ["data-theme"],
    });
  }

  // 테마를 감시하는 MutationObserver 설정
  observeThemeChanges();

  // 모바일 메뉴의 모드 변경 옵션 이벤트
  document
    .querySelectorAll(".offcanvas__top__hover ul li")
    .forEach((option) => {
      option.addEventListener("click", () => {
        const selectedMode = option.getAttribute("data-mode");
        if (selectedMode) {
          document.body.dataset.theme =
            selectedMode === "dark" ? "dark" : "light";
        }
      });
    });

  // 시스템 테마 변경 감지 (다크모드 자동 전환 지원)
  if (window.matchMedia) {
    const colorSchemeQuery = window.matchMedia("(prefers-color-scheme: dark)");

    // 시스템 테마 변경 시 자동 적용 (사용자가 수동으로 설정하지 않은 경우)
    colorSchemeQuery.addEventListener("change", (e) => {
      if (localStorage.getItem("theme") === null) {
        document.body.dataset.theme = e.matches ? "dark" : "light";
      }
    });

    // 초기 로드시 localStorage에 설정이 없는 경우 시스템 테마 적용
    if (localStorage.getItem("theme") === null) {
      document.body.dataset.theme = colorSchemeQuery.matches ? "dark" : "light";
    }
  }
});
