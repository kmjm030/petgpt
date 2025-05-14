document.addEventListener("DOMContentLoaded", () => {
  // --- Elements ---
  const searchForm = document.getElementById("animatedSearchForm");
  const searchInput = document.getElementById("searchInput");
  const placeholderTextElement = document.getElementById("currentPlaceholder");
  const submitButton = document.getElementById("submitSearchButton");
  const arrowLine = submitButton.querySelector("#arrowLine");

  // --- 다크모드 체크 함수 ---
  function isDarkMode() {
    return document.body.classList.contains("dark-mode");
  }

  // --- 다크모드에 맞게 플레이스홀더 스타일 조정 ---
  function updatePlaceholderForDarkMode() {
    if (isDarkMode()) {
      placeholderTextElement.classList.add("dark-placeholder");
    } else {
      placeholderTextElement.classList.remove("dark-placeholder");
    }
  }

  // --- Config & State for Placeholders ---
  const placeholders = [
    "우리 아이 간식 뭐가 좋을까?",
    "강아지 산책 용품 찾아보기",
    "고양이 장난감 추천받기",
    "요즘 인기 펫템은?",
    "자동 급식기 검색해보기",
    "부드러운 강아지 쿠션 찾아볼까?",
    "고양이 해먹 뭐가 괜찮지?",
    "털관리 용품 검색해보기",
    "반려동물 옷 예쁜 거 있을까?",
    "초보 집사를 위한 필수템 찾기",
  ];
  let currentPlaceholderIndex = 0;
  let placeholderInterval = null;
  const PLACEHOLDER_ANIMATION_DELAY = 3000; // ms
  const PLACEHOLDER_TRANSITION_DURATION = 300; // ms

  // --- Initialize SVG path for animation ---
  if (arrowLine) {
    arrowLine.setAttribute("pathLength", "1");
  }

  // --- Placeholder Animation Functions ---
  function showNextPlaceholder() {
    if (
      searchInput.value.trim() !== "" ||
      placeholderTextElement.classList.contains("exiting")
    ) {
      return;
    }

    console.log("→ showNextPlaceholder 실행: 현재 플레이스홀더 숨기기");
    console.log("   현재 클래스:", [...placeholderTextElement.classList]);

    // 애니메이션 시작 전 현재 다크모드 상태 확인하여 적용
    updatePlaceholderForDarkMode();

    placeholderTextElement.classList.remove("visible");
    placeholderTextElement.classList.add("exiting");

    setTimeout(() => {
      currentPlaceholderIndex =
        (currentPlaceholderIndex + 1) % placeholders.length;
      placeholderTextElement.textContent =
        placeholders[currentPlaceholderIndex];

      console.log(
        "→ 새 플레이스홀더 텍스트:",
        placeholders[currentPlaceholderIndex]
      );
      console.log("   exiting 클래스 제거 전:", [
        ...placeholderTextElement.classList,
      ]);

      placeholderTextElement.classList.remove("exiting");

      // 리플로우를 강제로 발생시켜 CSS 애니메이션이 제대로 동작하도록 함
      void placeholderTextElement.offsetWidth;

      console.log("→ visible 클래스 추가 전:", [
        ...placeholderTextElement.classList,
      ]);

      // 애니메이션 시작 전 다크모드 상태 다시 확인
      updatePlaceholderForDarkMode();

      placeholderTextElement.classList.add("visible");

      console.log("→ visible 클래스 추가 후:", [
        ...placeholderTextElement.classList,
      ]);
      console.log("   현재 스타일:", {
        opacity: getComputedStyle(placeholderTextElement).opacity,
        transform: getComputedStyle(placeholderTextElement).transform,
        transition: getComputedStyle(placeholderTextElement).transition,
      });
    }, PLACEHOLDER_TRANSITION_DURATION);
  }

  function startPlaceholderAnimation() {
    if (
      placeholderInterval ||
      searchInput.value.trim() !== "" ||
      document.visibilityState !== "visible"
    ) {
      console.log("→ startPlaceholderAnimation 실행 중단:", {
        hasInterval: !!placeholderInterval,
        hasInputValue: searchInput.value.trim() !== "",
        visibilityState: document.visibilityState,
      });
      return;
    }

    console.log("→ startPlaceholderAnimation 시작");
    console.log("   초기 텍스트:", placeholders[currentPlaceholderIndex]);

    placeholderTextElement.textContent = placeholders[currentPlaceholderIndex];
    placeholderTextElement.classList.remove("exiting");

    // 애니메이션 시작 전 다크모드 상태 확인
    updatePlaceholderForDarkMode();

    // visible 클래스 추가 전에 리플로우 강제 발생
    void placeholderTextElement.offsetWidth;

    placeholderTextElement.classList.add("visible");

    console.log("   visible 클래스 추가 후:", [
      ...placeholderTextElement.classList,
    ]);
    console.log("   스타일 정보:", {
      display: getComputedStyle(placeholderTextElement).display,
      opacity: getComputedStyle(placeholderTextElement).opacity,
      visibility: getComputedStyle(placeholderTextElement).visibility,
      transition: getComputedStyle(placeholderTextElement).transition,
    });

    placeholderInterval = setInterval(
      showNextPlaceholder,
      PLACEHOLDER_ANIMATION_DELAY
    );
  }

  function stopPlaceholderAnimation() {
    clearInterval(placeholderInterval);
    placeholderInterval = null;
  }

  // --- Input Event Handler ---
  searchInput.addEventListener("input", () => {
    const inputValue = searchInput.value.trim();
    if (inputValue !== "") {
      stopPlaceholderAnimation();
      placeholderTextElement.classList.remove("visible", "exiting");
      placeholderTextElement.style.opacity = "0";
      submitButton.disabled = false;
    } else {
      placeholderTextElement.style.opacity = ""; // Clear direct style to allow CSS transition
      startPlaceholderAnimation();
      submitButton.disabled = true;
    }
  });

  // --- Form Submission Handler ---
  searchForm.addEventListener("submit", (e) => {
    e.preventDefault();
    if (!submitButton.disabled) {
      const searchTerm = searchInput.value.trim();
      console.log("검색어 제출:", searchTerm);
      searchForm.submit(); // 실제 폼 제출
    }
  });

  // --- Tab Visibility Change Handler ---
  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "visible") {
      if (searchInput.value.trim() === "") {
        startPlaceholderAnimation();
      }
    } else {
      stopPlaceholderAnimation();
    }
  });

  // --- 다크모드 전환 감지 ---
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (
        mutation.attributeName === "class" &&
        mutation.target === document.body
      ) {
        updatePlaceholderForDarkMode();
      }
    });
  });

  observer.observe(document.body, { attributes: true });

  // --- Initial State ---
  submitButton.disabled = true; // Start with button disabled
  startPlaceholderAnimation(); // Start placeholder animation
});
