document.addEventListener("DOMContentLoaded", () => {
  const themes = [
    {
      key: "system",
      // Lucide Monitor SVG (https://lucide.dev/icons/monitor)
      iconSVG: `
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" class="icon">
                    <rect width="20" height="14" x="2" y="3" rx="2" />
                    <line x1="8" x2="16" y1="21" y2="21" />
                    <line x1="12" x2="12" y1="17" y2="21" />
                </svg>`,
      label: "System theme",
    },
    {
      key: "light",
      // Lucide Sun SVG (https://lucide.dev/icons/sun)
      iconSVG: `
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" class="icon">
                    <circle cx="12" cy="12" r="4" />
                    <path d="M12 2v2" />
                    <path d="M12 20v2" />
                    <path d="m4.93 4.93 1.41 1.41" />
                    <path d="m17.66 17.66 1.41 1.41" />
                    <path d="M2 12h2" />
                    <path d="M20 12h2" />
                    <path d="m6.34 17.66-1.41 1.41" />
                    <path d="m19.07 4.93-1.41 1.41" />
                </svg>`,
      label: "Light theme",
    },
    {
      key: "dark",
      // Lucide Moon SVG (https://lucide.dev/icons/moon)
      iconSVG: `
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" class="icon">
                    <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" />
                </svg>`,
      label: "Dark theme",
    },
  ];

  const switcherContainer = document.getElementById("themeSwitcher");
  const selectedThemeValueElement =
    document.getElementById("selectedThemeValue");

  // --- Configurable State ---
  let currentTheme = "system"; // Default value
  const onChangeCallbacks = []; // To simulate prop onChange

  // --- Create Active Theme Indicator ---
  const activeIndicator = document.createElement("div");
  activeIndicator.className = "active-theme-indicator";
  switcherContainer.appendChild(activeIndicator); // Add to container first for positioning

  // --- Create Theme Buttons ---
  themes.forEach((themeOption, index) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "theme-button";
    button.setAttribute("aria-label", themeOption.label);
    button.dataset.themeKey = themeOption.key; // For easy identification
    button.innerHTML = themeOption.iconSVG;

    button.addEventListener("click", () => {
      setActiveTheme(themeOption.key);
    });

    switcherContainer.appendChild(button);
  });

  // --- Functions ---
  function setActiveTheme(newThemeKey, initialSetup = false) {
    if (currentTheme === newThemeKey && !initialSetup) return;

    currentTheme = newThemeKey;

    // Update button active states
    const buttons = switcherContainer.querySelectorAll(".theme-button");
    let activeIndex = 0;
    buttons.forEach((btn, index) => {
      if (btn.dataset.themeKey === currentTheme) {
        btn.classList.add("active");
        activeIndex = index;
      } else {
        btn.classList.remove("active");
      }
    });

    // Move active indicator
    // Each button is 24px wide, padding is 4px.
    // So, 0th button is at 4px, 1st at 4+24+4 = 32px, 2nd at 32+24+4 = 60px
    const buttonWidth = parseFloat(getComputedStyle(buttons[0]).width); // 24px
    const gap = parseFloat(
      getComputedStyle(switcherContainer).gap ||
        getComputedStyle(switcherContainer).paddingLeft
    ); // 4px, gap or padding as fallback
    const indicatorPosition = gap + activeIndex * (buttonWidth + gap);

    activeIndicator.style.transform = `translateX(${
      indicatorPosition - gap
    }px)`; // Subtract initial left padding to align correctly
    // Initial left of indicator is already at `gap` (var(--switcher-padding))
    // So we need to translate it by `activeIndex * (buttonWidth + gap)`

    // Update body data-theme for visual feedback (actual theming)
    // For 'system', you'd need to check system preference
    if (currentTheme === "system") {
      const prefersDark =
        window.matchMedia &&
        window.matchMedia("(prefers-color-scheme: dark)").matches;
      document.body.dataset.theme = prefersDark ? "dark" : "light";
      // For system, we might want to reflect the resolved theme
      selectedThemeValueElement.textContent = `system (${
        prefersDark ? "dark" : "light"
      })`;
    } else {
      document.body.dataset.theme = currentTheme;
      selectedThemeValueElement.textContent = currentTheme;
    }

    // Call onChange callbacks (if any)
    if (!initialSetup) {
      onChangeCallbacks.forEach((callback) => callback(currentTheme));
    }
  }

  // --- System Theme Listener (Optional, for dynamic updates if system theme changes) ---
  const prefersDarkScheme = window.matchMedia("(prefers-color-scheme: dark)");
  function handleSystemThemeChange(event) {
    if (currentTheme === "system") {
      // Re-apply 'system' to trigger UI update based on new system preference
      setActiveTheme("system", true); // Use true to avoid infinite loop if callback changes currentTheme
    }
  }
  prefersDarkScheme.addEventListener("change", handleSystemThemeChange);

  // --- Public API (similar to props) ---
  window.themeSwitcherAPI = {
    setValue: (newTheme) => {
      if (themes.find((t) => t.key === newTheme)) {
        setActiveTheme(newTheme);
      }
    },
    getValue: () => currentTheme,
    onChange: (callback) => {
      if (typeof callback === "function") {
        onChangeCallbacks.push(callback);
      }
    },
    setDefaultValue: (defaultTheme) => {
      // Only set if not already set by setValue
      // This is a simplified version of controllable state.
      // For a true equivalent, initialization order and prop precedence matter.
      if (themes.find((t) => t.key === defaultTheme)) {
        // If currentTheme is still its initial 'system', or matches default, allow update.
        // This logic can be more complex depending on desired behavior.
        currentTheme = defaultTheme; // Directly set before initial render
      }
    },
  };

  // --- Initial Setup ---
  // Example: Set a default value before initial rendering (if `defaultValue` prop was used)
  // window.themeSwitcherAPI.setDefaultValue('dark'); // Uncomment to test

  setActiveTheme(currentTheme, true); // Apply initial theme (default 'system' or one set by setDefaultValue)

  // Example: Simulate external onChange listener
  window.themeSwitcherAPI.onChange((theme) => {
    console.log("Theme changed to (from API):", theme);
  });

  // Example: Simulate external control
  // setTimeout(() => {
  //     console.log("Setting theme to 'light' via API");
  //     window.themeSwitcherAPI.setValue('light');
  // }, 3000);
});
