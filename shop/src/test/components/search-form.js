document.addEventListener("DOMContentLoaded", () => {
  // --- Elements ---
  const searchForm = document.getElementById("animatedSearchForm");
  const searchInput = document.getElementById("searchInput");
  const placeholderTextElement = document.getElementById("currentPlaceholder");
  const submitButton = document.getElementById("submitSearchButton");
  const arrowLine = submitButton.querySelector("#arrowLine");

  // --- Config & State for Placeholders ---
  const placeholders = [
    "오늘의 뉴스를 검색하세요...",
    "인기 레시피 찾아보기",
    "가까운 맛집은 어디에?",
    "최신 영화 정보 확인",
    "여행지 추천받기",
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
      // 여기에 실제 검색 로직 추가
      // searchInput.value = ""; // 제출 후 입력창 비우기 (선택적)
      // submitButton.disabled = true; // 제출 후 버튼 비활성화 (선택적)
      // startPlaceholderAnimation(); // 제출 후 플레이스홀더 다시 시작 (선택적)
    }
  });

  // --- Enter Key in Input also Submits ---
  // This is default form behavior, but explicitly handled if needed for other logic
  // searchInput.addEventListener("keydown", (e) => {
  //     if (e.key === "Enter" && !submitButton.disabled) {
  //         searchForm.requestSubmit(); // or searchForm.submit() if not needing specific event
  //     }
  // });

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
