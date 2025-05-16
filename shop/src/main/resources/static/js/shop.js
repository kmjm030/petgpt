const shopPageData = document.getElementById("shop-page-data");

const shop = {
  _initialized: false,

  init: () => {
    if (shop._initialized) {
      console.log("shop.init() already called, skipping subsequent calls.");
      return;
    }
    shop._initialized = true;
    console.log("shop.init() called for the first time.");

    shop.filterDuplicateColors();
    console.log("Calling initializeLikeButtons from init...");
    shop.initializeLikeButtons();
  },
  filterDuplicateColors: () => {
    const processedColors = {};
    const colorMapping = {
      블랙: "#000",
      화이트: "#ffffff",
      아이보리: "#ffffff",
      레드: "#ff0000",
      레드체크: "#ff0000",
      블루: "#0000ff",
      블루체크: "#0000ff",
      네이비: "#0000ff",
      그레이: "#808080",
      라이트그레이: "#808080",
      차콜: "#808080",
      실버: "#808080",
      핑크: "#ffc0cb",
      라이트핑크: "#ffc0cb",
      분홍색: "#ffc0cb",
      민트: "#98ff98",
      베이지: "#f5f5dc",
      크림베이지: "#f5f5dc",
      옐로우: "#ffff00",
      그린: "#008000",
      브라운: "#a52a2a",
      카키: "#806b2a",
      오렌지: "#ffa500",
      퍼플: "#800080",
      골드: "#ffd700",
      내추럴우드: "#966F33",
      월넛: "#966F33",
      혼합색: "mixed",
    };

    const colorLabels = document.querySelectorAll(
      ".shop__sidebar__color label"
    );

    colorLabels.forEach((label) => {
      const colorInput = label.querySelector('input[type="radio"]');
      const colorName = colorInput.value;

      const colorNameDisplay = document.createElement("span");
      colorNameDisplay.className = "color-name-display";
      colorNameDisplay.textContent = colorName;
      label.appendChild(colorNameDisplay);

      label.addEventListener("click", function () {
        if (this.classList.contains("active")) {
          this.classList.remove("active");
          setTimeout(() => {
            this.classList.add("active");
          }, 10);
        }
      });

      const colorCode = colorMapping[colorName] || "#cccccc";

      if (processedColors[colorCode]) {
        if (colorInput.checked) {
          const existingLabel = processedColors[colorCode].label;
          const existingInput = existingLabel.querySelector(
            'input[type="radio"]'
          );
          existingLabel.classList.add("active");
          existingInput.checked = true;
          label.style.display = "none";
        } else {
          label.style.display = "none";
        }
      } else {
        processedColors[colorCode] = {
          label: label,
          name: colorName,
        };
      }
    });
  },
  initializeLikeButtons: () => {
    console.log("shop.initializeLikeButtons() called");
    const likeButtons = document.querySelectorAll(
      ".product__hover .like-button"
    );
    console.log("Found like buttons:", likeButtons.length);

    likeButtons.forEach((button) => {
      const itemKey = button.getAttribute("data-item-key");
      console.log(`[${itemKey}] Processing button.`);

      // --- dataset 플래그 로직 복구 ---
      if (button.dataset.listenerAttached === "true") {
        console.log(`[${itemKey}] Listener already attached, skipping.`); // 로그 레벨 변경 가능 (warn -> log)
        return; // 중복 방지
      }
      // --- dataset 플래그 로직 복구 ---

      const productItem = button.closest(".product__item");

      if (isLoggedIn) {
        console.log(
          `[${itemKey}] Checking initial liked status (isLoggedIn: ${isLoggedIn}).`
        );
        shop.checkLiked(itemKey, (isLiked) => {
          console.log(`[${itemKey}] checkLiked callback received: ${isLiked}`);
          if (isLiked) {
            button.classList.add("liked");
            if (productItem) productItem.classList.add("liked");
          }
        });
      } else {
        console.log(
          `[${itemKey}] Skipping initial liked status check (isLoggedIn: ${isLoggedIn}).`
        );
      }

      console.log(`[${itemKey}] Attempting to add click listener.`);
      button.addEventListener("click", function (e) {
        console.log(`[${itemKey}] Click listener fired! (from shop.js)`); // 로그에 출처 명시
        e.preventDefault();
        shop.toggleLike(itemKey, this);
      });

      // --- dataset 플래그 로직 복구 ---
      button.dataset.listenerAttached = "true"; // 리스너 추가됨 표시
      console.log(`[${itemKey}] Click listener added and marked as attached.`);
      // --- dataset 플래그 로직 복구 ---
    });
  },

  toggleLike: (itemKey, button) => {
    console.log("toggleLike called. isLoggedIn:", isLoggedIn);

    if (!isLoggedIn) {
      console.log("isLoggedIn is false, showing confirm dialog.");
      if (
        confirm(
          "로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?"
        )
      ) {
        const currentUrl = encodeURIComponent(
          location.pathname + location.search
        );
        window.location.href = loginUrl + "?redirectURL=" + currentUrl;
      }
      return;
    }

    $.ajax({
      url: likeToggleUrl,
      type: "POST",
      data: { itemKey: itemKey },
      success: function (response) {
        if (response.success) {
          const productItem = button.closest(".product__item");

          if (response.action === "added") {
            button.classList.add("liked");
            productItem.classList.add("liked");
            shop.showToast("상품이 찜 목록에 추가되었습니다.");
          } else {
            button.classList.remove("liked");
            productItem.classList.remove("liked");
            shop.showToast("상품이 찜 목록에서 제거되었습니다.");
          }
        } else {
          alert(response.message || "찜하기 처리 중 오류가 발생했습니다.");
        }
      },
      error: function () {
        alert("서버 통신 오류가 발생했습니다.");
      },
    });
  },

  checkLiked: (itemKey, callback) => {
    if (!isLoggedIn) {
      callback(false);
      return;
    }

    $.ajax({
      url: likeCheckUrl,
      type: "GET",
      data: { itemKey: itemKey },
      success: function (response) {
        if (response.success && response.isLiked) {
          callback(true);
        } else {
          callback(false);
        }
      },
      error: function () {
        callback(false);
      },
    });
  },

  showToast: (message) => {
    if (!document.getElementById("toast-container")) {
      const toastContainer = document.createElement("div");
      toastContainer.id = "toast-container";
      toastContainer.style.cssText = `
      position: fixed;
      bottom: 20px;
      right: 20px;
      z-index: 9999;
    `;
      document.body.appendChild(toastContainer);
    }

    const toast = document.createElement("div");
    toast.className = "toast-message";
    toast.innerHTML = message;
    toast.style.cssText = `
    background-color: rgba(0, 0, 0, 0.7);
    color: white;
    padding: 15px 25px;
    margin-top: 10px;
    border-radius: 4px;
    opacity: 0;
    transition: opacity 0.3s ease;
  `;

    document.getElementById("toast-container").appendChild(toast);

    setTimeout(() => {
      toast.style.opacity = "1";
    }, 10);

    setTimeout(() => {
      toast.style.opacity = "0";
      setTimeout(() => {
        toast.remove();
      }, 300);
    }, 3000);
  },
};

let likeToggleUrl, likeCheckUrl, loginUrl, keyword;

$(function () {
  loginUrl = document.body.dataset.loginUrl || "";

  const shopPageData = $("#shop-page-data");
  if (shopPageData.length > 0) {
    likeToggleUrl = shopPageData.data("like-toggle-url") || "";
    likeCheckUrl = shopPageData.data("like-check-url") || "";
    keyword = shopPageData.data("keyword") || "";

    shop.init();
  } else {
    console.log(
      "Not on the shop page, skipping shop-specific setup (#shop-page-data not found)."
    );
  }

  $(".set-bg").each(function () {
    var bg = $(this).data("setbg");
    if (bg) {
      $(this).css("background-image", "url(" + bg + ")");
    }
  });
});

function changeSortOrder(sortValue) {
  const currentUrl = new URL(window.location.href);
  const params = new URLSearchParams(currentUrl.search);

  params.set("sort", sortValue);

  if (
    currentUrl.pathname.includes("/shop/search") &&
    !params.has("keyword") &&
    keyword !== ""
  ) {
    params.set("keyword", keyword);
  }

  currentUrl.search = params.toString();
  window.location.href = currentUrl.toString();
}
