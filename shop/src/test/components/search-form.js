document.addEventListener("DOMContentLoaded", () => {
  const searchForm = document.getElementById("animatedSearchForm");
  const searchInput = document.getElementById("searchInput");
  const placeholderTextElement = document.getElementById("currentPlaceholder");
  const submitButton = document.getElementById("submitSearchButton");
  const arrowLine = submitButton.querySelector("#arrowLine");

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

  if (arrowLine) {
    arrowLine.setAttribute("pathLength", "1");
  }

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

  searchInput.addEventListener("input", () => {
    const inputValue = searchInput.value.trim();
    if (inputValue !== "") {
      stopPlaceholderAnimation();
      placeholderTextElement.classList.remove("visible", "exiting");
      placeholderTextElement.style.opacity = "0";
      submitButton.disabled = false;
    } else {
      placeholderTextElement.style.opacity = "";
      startPlaceholderAnimation();
      submitButton.disabled = true;
    }
  });

  searchForm.addEventListener("submit", (e) => {
    e.preventDefault();
    if (!submitButton.disabled) {
      const searchTerm = searchInput.value.trim();
      console.log("검색어 제출:", searchTerm);
    }
  });

  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "visible") {
      if (searchInput.value.trim() === "") {
        startPlaceholderAnimation();
      }
    } else {
      stopPlaceholderAnimation();
    }
  });

  submitButton.disabled = true;
  startPlaceholderAnimation();
});
