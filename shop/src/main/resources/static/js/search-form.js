document.addEventListener("DOMContentLoaded", () => {
  // --- Elements ---
  const searchForm = document.getElementById("animatedSearchForm");
  const searchInput = document.getElementById("searchInput");
  const placeholderTextElement = document.getElementById("currentPlaceholder");
  const submitButton = document.getElementById("submitSearchButton");
  const arrowLine = submitButton.querySelector("#arrowLine");

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
    placeholderTextElement.classList.remove("visible");
    placeholderTextElement.classList.add("exiting");

    setTimeout(() => {
      currentPlaceholderIndex =
        (currentPlaceholderIndex + 1) % placeholders.length;
      placeholderTextElement.textContent =
        placeholders[currentPlaceholderIndex];
      placeholderTextElement.classList.remove("exiting");
      void placeholderTextElement.offsetWidth;
      placeholderTextElement.classList.add("visible");
    }, PLACEHOLDER_TRANSITION_DURATION);
  }

  function startPlaceholderAnimation() {
    if (
      placeholderInterval ||
      searchInput.value.trim() !== "" ||
      document.visibilityState !== "visible"
    ) {
      return;
    }
    placeholderTextElement.textContent = placeholders[currentPlaceholderIndex];
    placeholderTextElement.classList.remove("exiting");
    placeholderTextElement.classList.add("visible");
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

  // --- Initial State ---
  submitButton.disabled = true; // Start with button disabled
  startPlaceholderAnimation(); // Start placeholder animation
});
