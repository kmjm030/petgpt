document.addEventListener("DOMContentLoaded", () => {
  const animatedInput = document.getElementById("animatedPlaceholderInput");
  const placeholderTextElement = document.getElementById("currentPlaceholder");

  const placeholders = [
    "첫 번째 질문은 무엇인가요?",
    "타일러 더든은 누구죠?",
    "앤드류 레디스는 어디에 숨어있나요?",
    "문자열을 뒤집는 자바스크립트 메소드를 작성하세요",
    "PC를 직접 조립하는 방법은?",
  ];
  let currentPlaceholderIndex = 0;
  let placeholderInterval = null;
  const PLACEHOLDER_ANIMATION_DELAY = 3000; // ms, 다음 플레이스홀더로 넘어가는 시간
  const PLACEHOLDER_TRANSITION_DURATION = 300; // ms, CSS 트랜지션 시간과 일치

  function showNextPlaceholder() {
    // 입력창에 값이 있거나, 이미 애니메이션(exiting) 중이면 실행 안 함
    if (
      animatedInput.value.trim() !== "" ||
      placeholderTextElement.classList.contains("exiting")
    ) {
      return;
    }

    // 현재 플레이스홀더 사라지는 애니메이션
    placeholderTextElement.classList.remove("visible");
    placeholderTextElement.classList.add("exiting");

    setTimeout(() => {
      currentPlaceholderIndex =
        (currentPlaceholderIndex + 1) % placeholders.length;
      placeholderTextElement.textContent =
        placeholders[currentPlaceholderIndex];

      // 새 플레이스홀더 나타나는 애니메이션
      placeholderTextElement.classList.remove("exiting");
      // 브라우저가 변경을 감지하도록 강제 리플로우 (선택적이지만 안정적)
      void placeholderTextElement.offsetWidth;
      placeholderTextElement.classList.add("visible");
    }, PLACEHOLDER_TRANSITION_DURATION);
  }

  function startPlaceholderAnimation() {
    // 이미 실행 중이거나, 입력값이 있거나, 탭이 비활성화 상태면 시작 안 함
    if (
      placeholderInterval ||
      animatedInput.value.trim() !== "" ||
      document.visibilityState !== "visible"
    ) {
      return;
    }

    // 첫 플레이스홀더 즉시 표시 (사라지는 애니메이션 없이)
    placeholderTextElement.textContent = placeholders[currentPlaceholderIndex];
    placeholderTextElement.classList.remove("exiting"); // 혹시 남아있을 수 있는 exiting 클래스 제거
    placeholderTextElement.classList.add("visible");

    placeholderInterval = setInterval(
      showNextPlaceholder,
      PLACEHOLDER_ANIMATION_DELAY
    );
  }

  function stopPlaceholderAnimation() {
    clearInterval(placeholderInterval);
    placeholderInterval = null;
    // 플레이스홀더 즉시 숨기기 (선택적: 입력 시작시 바로 안 보이게)
    // placeholderTextElement.classList.remove("visible", "exiting");
    // placeholderTextElement.style.opacity = '0'; // 더 확실한 방법
  }

  // 입력 이벤트 처리
  animatedInput.addEventListener("input", () => {
    if (animatedInput.value.trim() !== "") {
      stopPlaceholderAnimation();
      // 사용자가 입력 시작 시 플레이스홀더 강제 숨김
      placeholderTextElement.classList.remove("visible");
      placeholderTextElement.classList.remove("exiting"); // 애니메이션 중이었다면 중단
      placeholderTextElement.style.opacity = "0"; // 즉시 숨김
    } else {
      placeholderTextElement.style.opacity = ""; // opacity 스타일 제거하여 CSS 애니메이션이 다시 적용될 수 있도록 함
      startPlaceholderAnimation(); // 입력창이 비워지면 다시 애니메이션 시작
    }
  });

  // 포커스 이벤트 (선택적: 포커스 시에도 애니메이션 제어)
  animatedInput.addEventListener("focus", () => {
    if (animatedInput.value.trim() !== "") {
      stopPlaceholderAnimation();
      placeholderTextElement.style.opacity = "0";
    }
  });

  animatedInput.addEventListener("blur", () => {
    if (animatedInput.value.trim() === "") {
      startPlaceholderAnimation();
    }
  });

  // 탭 가시성 변경 처리
  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "visible") {
      // 입력값이 없을 때만 애니메이션 재시작
      if (animatedInput.value.trim() === "") {
        startPlaceholderAnimation();
      }
    } else {
      stopPlaceholderAnimation();
    }
  });

  // 초기 애니메이션 시작
  startPlaceholderAnimation();
});
