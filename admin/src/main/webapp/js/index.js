document.addEventListener("DOMContentLoaded", () => {
    const sidebar = document.getElementById("hover-sidebar");
    document.addEventListener("mousemove", (e) => {
        if (e.clientX < 20) {
            sidebar.style.transform = "translateX(0)";
        } else if (!sidebar.matches(":hover")) {
            sidebar.style.transform = "translateX(-100%)";
        }
    });
    sidebar.addEventListener("mouseleave", () => {
        sidebar.style.transform = "translateX(-100%)";
    });

    const overlay = document.getElementById("welcome-overlay");
    if (overlay) {
        const hasShown = sessionStorage.getItem("welcomeShown");
        if (hasShown) {
            overlay.style.display = "none";
        } else {
            sessionStorage.setItem("welcomeShown", "true");
            setTimeout(() => {
                overlay.style.display = "none";
            }, 7000);
        }
    }

    const toggle = document.getElementById("darkModeToggle");
    const isDark = localStorage.getItem("dark-mode") === "true";
    if (isDark) {
        document.body.classList.add("dark-mode");
        if (toggle) toggle.textContent = "☀️";
    }

    if (toggle) {
        toggle.addEventListener("click", () => {
            const enabled = document.body.classList.toggle("dark-mode");
            toggle.textContent = enabled ? "☀️" : "🌙";
            localStorage.setItem("dark-mode", enabled);
        });
    }
});
