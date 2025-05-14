document.addEventListener("DOMContentLoaded", () => {
  // --- Elements ---
  const vanishForm = document.getElementById("vanishForm");
  const vanishInput = document.getElementById("vanishInput");
  const submitButton = document.getElementById("submitButton");
  const arrowLine = document.getElementById("arrowLine");
  const submitIcon = submitButton.querySelector(".submit-icon");

  const canvas = document.getElementById("vanishCanvas");
  const ctx = canvas.getContext("2d");

  const placeholderContainer = document.getElementById("placeholderContainer");
  const currentPlaceholderTextEl = document.getElementById(
    "currentPlaceholderText"
  );

  // --- Config & State ---
  const placeholders = [
    "What's the first rule of Fight Club?",
    "Who is Tyler Durden?",
    "Where is Andrew Laeddis Hiding?",
    "Write a Javascript method to reverse a string",
    "How to assemble your own PC?",
  ];
  let currentPlaceholderIndex = 0;
  let placeholderInterval = null;
  const PLACEHOLDER_DELAY = 3000;

  let inputValue = "";
  let isAnimatingParticles = false;
  let particleData = [];

  // --- Dark Mode (Optional: based on system preference or a toggle) ---
  const preferDark =
    window.matchMedia &&
    window.matchMedia("(prefers-color-scheme: dark)").matches;
  if (preferDark) {
    document.body.classList.add("dark-mode");
  }
  // Add a toggle button if you want manual control
  // document.getElementById('darkModeToggle').addEventListener('click', () => {
  //     document.body.classList.toggle('dark-mode');
  // });

  // --- Placeholder Animation ---
  function showNextPlaceholder() {
    if (inputValue || isAnimatingParticles) return; // Don't animate if user is typing or particles animating

    const oldPlaceholderText = currentPlaceholderTextEl.textContent;

    // Exit animation for current placeholder
    currentPlaceholderTextEl.classList.remove("visible");
    currentPlaceholderTextEl.classList.add("exiting");

    setTimeout(() => {
      currentPlaceholderIndex =
        (currentPlaceholderIndex + 1) % placeholders.length;
      currentPlaceholderTextEl.textContent =
        placeholders[currentPlaceholderIndex];

      currentPlaceholderTextEl.classList.remove("exiting");
      // Force reflow for new animation start
      void currentPlaceholderTextEl.offsetWidth;
      currentPlaceholderTextEl.classList.add("visible");
    }, 300); // Match CSS transition duration
  }

  function startPlaceholderAnimation() {
    if (placeholderInterval) clearInterval(placeholderInterval);
    if (
      inputValue ||
      isAnimatingParticles ||
      document.visibilityState !== "visible"
    )
      return;

    // Initial display without exit animation
    currentPlaceholderTextEl.textContent =
      placeholders[currentPlaceholderIndex];
    currentPlaceholderTextEl.classList.remove("exiting");
    currentPlaceholderTextEl.classList.add("visible");

    placeholderInterval = setInterval(showNextPlaceholder, PLACEHOLDER_DELAY);
  }

  function stopPlaceholderAnimation() {
    clearInterval(placeholderInterval);
    placeholderInterval = null;
    // currentPlaceholderTextEl.classList.remove("visible", "exiting"); // Hide immediately
  }

  function handleVisibilityChange() {
    if (document.visibilityState === "visible") {
      startPlaceholderAnimation();
    } else {
      stopPlaceholderAnimation();
    }
  }

  // --- Input & Form Logic ---
  vanishInput.addEventListener("input", (e) => {
    inputValue = e.target.value;
    if (inputValue) {
      stopPlaceholderAnimation();
      currentPlaceholderTextEl.classList.remove("visible", "exiting");
      vanishForm.classList.add("has-value");
      submitButton.disabled = false;
      submitIcon.classList.add("active");
    } else {
      vanishForm.classList.remove("has-value");
      submitButton.disabled = true;
      submitIcon.classList.remove("active");
      startPlaceholderAnimation(); // Restart placeholder if input is cleared
    }
    // onChange prop equivalent
    console.log("Input changed:", inputValue);
  });

  vanishForm.addEventListener("submit", (e) => {
    e.preventDefault();
    if (!isAnimatingParticles && inputValue) {
      vanishAndSubmit();
    }
    // onSubmit prop equivalent
    console.log("Form submitted with:", inputValue);
  });

  vanishInput.addEventListener("keydown", (e) => {
    if (e.key === "Enter" && !isAnimatingParticles && inputValue) {
      e.preventDefault(); // Prevent form submission if already handled
      vanishAndSubmit();
    }
  });

  // --- Particle Vanish Animation ---
  function drawTextForParticles() {
    if (!vanishInput) return;

    canvas.width = 800; // Match React component's canvas size
    canvas.height = 800;
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const computedStyles = getComputedStyle(vanishInput);
    const fontSize = parseFloat(computedStyles.getPropertyValue("font-size"));
    // Adjust font size due to canvas scaling (scale(0.5))
    // If canvas is scaled down by 0.5, text needs to be drawn 2x larger
    ctx.font = `${fontSize * 2}px ${computedStyles.fontFamily}`;
    // Use a color that contrasts with the canvas filter for visibility before filtering
    // If dark mode inverts canvas, use black. If light mode inverts, use white.
    // The original used #FFF and then `filter invert dark:invert-0`
    // Assuming filter: invert(1) for light mode, invert(0) for dark.
    // So, for light mode (canvas inverted), draw with black to appear white.
    // For dark mode (canvas not inverted), draw with white to appear white.
    ctx.fillStyle = document.body.classList.contains("dark-mode")
      ? "#FFFFFF"
      : "#000000";

    ctx.fillText(inputValue, 16, 40); // Approx. same padding/positioning

    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const pixelData = imageData.data;
    const newParticleData = [];

    for (let t = 0; t < canvas.height; t++) {
      let i = 4 * t * canvas.width;
      for (let n = 0; n < canvas.width; n++) {
        let e = i + 4 * n;
        if (
          pixelData[e] !== 0 && // R
          pixelData[e + 1] !== 0 && // G
          pixelData[e + 2] !== 0 // B
          // Alpha (pixelData[e + 3]) can be non-zero for anti-aliased text
        ) {
          newParticleData.push({
            x: n,
            y: t,
            color: [
              // Store original color before potential filter
              pixelData[e],
              pixelData[e + 1],
              pixelData[e + 2],
              pixelData[e + 3],
            ],
            r: 1, // Initial radius/size of particle
          });
        }
      }
    }
    particleData = newParticleData.map(({ x, y, color, r }) => ({
      x,
      y,
      r,
      // Apply the rgba color directly, filter is on canvas element
      colorStr: `rgba(${color[0]}, ${color[1]}, ${color[2]}, ${
        color[3] / 255
      })`,
    }));
  }

  let animationFrameId = null;
  function animateParticles(startPos) {
    isAnimatingParticles = true;
    vanishInput.classList.add("animating"); // Make input text transparent
    canvas.classList.add("animating"); // Make canvas visible

    function frame(currentPos) {
      const newArr = [];
      let maxVisibleX = 0; // Track the rightmost particle to clear efficiently

      for (let i = 0; i < particleData.length; i++) {
        const current = particleData[i];
        if (current.x < currentPos) {
          // Particles to the left of "vanishing line"
          newArr.push(current);
          if (current.x > maxVisibleX) maxVisibleX = current.x;
        } else {
          // Particles at or to the right of "vanishing line" - animate these
          if (current.r <= 0) {
            current.r = 0; // Keep it in array until fully processed or make it disappear
            continue;
          }
          current.x += Math.random() > 0.5 ? 1 : -1;
          current.y += Math.random() > 0.5 ? 1 : -1;
          current.r -= 0.05 * Math.random();
          if (current.r < 0) current.r = 0;
          newArr.push(current);
          if (current.x > maxVisibleX) maxVisibleX = current.x;
        }
      }
      particleData = newArr;

      if (ctx) {
        // Clear only the part of the canvas that needs redrawing
        // From the current vanishing position to the right edge (or max particle x)
        // Clearing from currentPos ensures the "eaten" effect
        ctx.clearRect(
          currentPos - 8,
          0,
          canvas.width - (currentPos - 8),
          canvas.height
        );

        particleData.forEach((p) => {
          if (p.r > 0 && p.x > currentPos) {
            // Only draw dissolving particles
            ctx.beginPath();
            ctx.rect(p.x, p.y, p.r, p.r); // Draw as small rects
            ctx.fillStyle = p.colorStr;
            // ctx.strokeStyle = p.colorStr; // stroke can make it look bolder
            ctx.fill();
          }
        });
      }

      if (
        particleData.some(
          (p) => p.r > 0 && p.x > currentPos - canvas.width * 0.1
        ) &&
        currentPos > -canvas.width * 0.2
      ) {
        // Condition to continue
        // Ensure animation continues as long as there are visible particles to animate
        // and the vanishing line hasn't gone too far left.
        animationFrameId = requestAnimationFrame(() => frame(currentPos - 8));
      } else {
        // Animation finished
        ctx.clearRect(0, 0, canvas.width, canvas.height); // Final clear
        inputValue = "";
        vanishInput.value = "";
        vanishInput.classList.remove("animating");
        canvas.classList.remove("animating");
        isAnimatingParticles = false;
        submitButton.disabled = true;
        submitIcon.classList.remove("active");
        vanishForm.classList.remove("has-value");
        particleData = []; // Clear data
        startPlaceholderAnimation(); // Restart placeholders
      }
    }
    frame(startPos);
  }

  function vanishAndSubmit() {
    if (isAnimatingParticles || !inputValue) return;

    stopPlaceholderAnimation(); // Stop placeholders during text vanish
    currentPlaceholderTextEl.classList.remove("visible", "exiting");

    drawTextForParticles();

    if (inputValue && vanishInput && particleData.length > 0) {
      const maxX = particleData.reduce(
        (prev, current) => (current.x > prev ? current.x : prev),
        0
      );
      if (animationFrameId) cancelAnimationFrame(animationFrameId);
      animateParticles(maxX);
    } else {
      // If no text or no particles, just clear input and reset
      inputValue = "";
      vanishInput.value = "";
      isAnimatingParticles = false;
      submitButton.disabled = true;
      submitIcon.classList.remove("active");
      vanishForm.classList.remove("has-value");
      startPlaceholderAnimation();
    }
  }

  // --- Initial Setup ---
  arrowLine.setAttribute("pathLength", "1"); // For easier dasharray/dashoffset in %
  // Default state for arrow (half hidden)
  arrowLine.style.strokeDasharray = "0.5"; // Path length is 1, so 0.5 is 50%
  arrowLine.style.strokeDashoffset = "0.5";
  // Update CSS if you prefer class-based:
  // .submit-icon #arrowLine { path-length: 1; stroke-dasharray: 0.5; stroke-dashoffset: 0.5; ...}
  // .submit-icon.active #arrowLine { stroke-dashoffset: 0; }

  submitButton.disabled = true; // Initially disabled
  document.addEventListener("visibilitychange", handleVisibilityChange);
  startPlaceholderAnimation(); // Start placeholders
});
