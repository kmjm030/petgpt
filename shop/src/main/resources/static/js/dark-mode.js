document.addEventListener("DOMContentLoaded", function () {
    const toggleBtn = document.getElementById("modeToggleBtn");
    const modeOptions = document.getElementById("modeOptions");
    const mainLogo = document.getElementById("main-logo");
    const lightLogoSrc = mainLogo ? mainLogo.dataset.lightSrc : '';
    const darkLogoSrc = mainLogo ? mainLogo.dataset.darkSrc : '';

    function applyThemeBackgrounds() {
        const isDarkMode = document.body.classList.contains('dark-mode');

        if (typeof $ === 'function') {
            $('.set-bg').each(function () {
                const $this = $(this);
                const lightBg = $this.data('setbg');
                const darkBg = $this.data('setbg-dark');
                let targetBg = lightBg;

                if (isDarkMode && darkBg) {
                    targetBg = darkBg;
                }

                if (targetBg) {
                    const currentBg = $this.css('background-image');
                    const targetUrl = 'url("' + targetBg + '")';

                    if (currentBg !== targetUrl) {
                        $this.css('background-image', 'url(' + targetBg + ')');
                    }
                }
            });
        } else {
            console.warn("jQuery not loaded when applyThemeBackgrounds was called.");
        }
    }

    const savedMode = localStorage.getItem("darkMode");
    if (savedMode === "true") {
        document.body.classList.add("dark-mode");
        if (mainLogo && darkLogoSrc) mainLogo.src = darkLogoSrc;
        applyThemeBackgrounds();
    } else {
        document.body.classList.remove("dark-mode");
        if (mainLogo && lightLogoSrc) mainLogo.src = lightLogoSrc;
        applyThemeBackgrounds();
    }

    toggleBtn.addEventListener("click", function (event) {
        event.stopPropagation();
        modeOptions.classList.toggle("active");
    });

    document.querySelectorAll("#modeOptions div").forEach(option => {
        option.addEventListener("click", () => {
            const selectedMode = option.getAttribute("data-mode");

            if (selectedMode === "dark") {
                document.body.classList.add("dark-mode");
                localStorage.setItem("darkMode", "true");
                if (mainLogo && darkLogoSrc) mainLogo.src = darkLogoSrc;
                applyThemeBackgrounds();
            } else {
                document.body.classList.remove("dark-mode");
                localStorage.setItem("darkMode", "false");
                if (mainLogo && lightLogoSrc) mainLogo.src = lightLogoSrc;
                applyThemeBackgrounds();
            }

            modeOptions.classList.remove("active");
        });
    });

    document.addEventListener("click", function (e) {
        if (!modeOptions.contains(e.target) && !toggleBtn.contains(e.target)) {
            modeOptions.classList.remove("active");
        }
    });
});