$(function () {
  let hotDealCountdownInterval = null;

  // 홈 페이지에서 사용할 전역 변수 추가
  let homeLikeToggleUrl, homeLikeCheckUrl, homeLoginUrl;
  let homeIsLoggedIn = false;

  // home-page-data에서 데이터 가져오기
  const homePageData = $("#home-page-data");
  if (homePageData.length > 0) {
    homeIsLoggedIn =
      homePageData.data("is-logged-in") === true ||
      homePageData.data("is-logged-in") === "true";
    homeLikeToggleUrl = homePageData.data("like-toggle-url") || "";
    homeLikeCheckUrl = homePageData.data("like-check-url") || "";
    homeLoginUrl = homePageData.data("login-url") || "";

    // 찜 버튼 초기화
    initializeHomeLikeButtons();
  }

  function initializeHomeLikeButtons() {
    console.log("home.js: initializeHomeLikeButtons() 호출됨");
    const likeButtons = document.querySelectorAll(
      ".product__hover .like-button"
    );
    console.log("home.js: 찜 버튼 개수:", likeButtons.length);

    likeButtons.forEach((button) => {
      const itemKey = button.getAttribute("data-item-key");
      console.log(`home.js: [${itemKey}] 버튼 처리 중`);

      if (button.dataset.listenerAttached === "true") {
        console.log(
          `home.js: [${itemKey}] 이미 리스너가 연결되어 있습니다. 건너뜁니다.`
        );
        return;
      }

      const productItem = button.closest(".product__item");

      if (homeIsLoggedIn) {
        console.log(
          `home.js: [${itemKey}] 초기 좋아요 상태 확인 (로그인: ${homeIsLoggedIn})`
        );
        checkHomeLiked(itemKey, (isLiked) => {
          console.log(`home.js: [${itemKey}] checkLiked 콜백 받음: ${isLiked}`);
          if (isLiked) {
            button.classList.add("liked");
            if (productItem) productItem.classList.add("liked");
          }
        });
      } else {
        console.log(
          `home.js: [${itemKey}] 초기 좋아요 상태 확인 안함 (로그인: ${homeIsLoggedIn})`
        );
      }

      console.log(`home.js: [${itemKey}] 클릭 리스너 추가 시도`);
      button.addEventListener("click", function (e) {
        console.log(`home.js: [${itemKey}] 클릭 리스너 실행!`);
        e.preventDefault();
        toggleHomeLike(itemKey, this);
      });

      button.dataset.listenerAttached = "true";
      console.log(`home.js: [${itemKey}] 클릭 리스너 추가 완료 및 표시됨`);
    });
  }

  function toggleHomeLike(itemKey, button) {
    console.log("home.js: toggleHomeLike 호출됨. 로그인 상태:", homeIsLoggedIn);

    if (!homeIsLoggedIn) {
      console.log("home.js: 로그인 안됨, 확인 다이얼로그 표시");
      if (
        confirm(
          "로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?"
        )
      ) {
        const currentUrl = encodeURIComponent(
          location.pathname + location.search
        );
        window.location.href = homeLoginUrl + "?redirectURL=" + currentUrl;
      }
      return;
    }

    $.ajax({
      url: homeLikeToggleUrl,
      type: "POST",
      data: { itemKey: itemKey },
      success: function (response) {
        if (response.success) {
          const productItem = button.closest(".product__item");

          if (response.action === "added") {
            button.classList.add("liked");
            productItem.classList.add("liked");
            showHomeToast("상품이 찜 목록에 추가되었습니다.");
          } else {
            button.classList.remove("liked");
            productItem.classList.remove("liked");
            showHomeToast("상품이 찜 목록에서 제거되었습니다.");
          }
        } else {
          alert(response.message || "찜하기 처리 중 오류가 발생했습니다.");
        }
      },
      error: function () {
        alert("서버 통신 오류가 발생했습니다.");
      },
    });
  }

  function checkHomeLiked(itemKey, callback) {
    if (!homeIsLoggedIn) {
      callback(false);
      return;
    }

    $.ajax({
      url: homeLikeCheckUrl,
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
  }

  function showHomeToast(message) {
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
  }

  function loadHotDeal() {
    $.ajax({
      url: contextPath + "/api/hotdeal/current",
      type: "GET",
      dataType: "json",
      success: function (hotDeal) {
        console.log("핫딜 데이터:", hotDeal);
        if (hotDeal && hotDeal.itemKey && hotDeal.expiryTime) {
          updateHotDealSection(hotDeal);
          startCountdown(hotDeal.expiryTime);
        } else {
          displayNoHotDeal();
          setTimeout(loadHotDeal, 10000); // 10초 후 재시도
        }
      },
      error: function (xhr, status, error) {
        console.error("핫딜 정보를 불러오는 중 오류 발생:", status, error);
        displayNoHotDeal("핫딜 정보를 불러오는 중 오류 발생");
        setTimeout(loadHotDeal, 10000); // 10초 후 재시도
      },
    });
  }

  function updateHotDealSection(deal) {
    const imgUrl =
      contextPath +
      "/img/product/" +
      (deal.itemImg1 || "default-placeholder.png");
    const detailUrl = contextPath + "/shop/details?itemKey=" + deal.itemKey;

    $("#hotdeal-img").attr("src", imgUrl);
    $("#hotdeal-name").text(deal.itemName);
    $("#hotdeal-price").text(deal.hotDealPrice.toLocaleString() + "원");
    $("#hotdeal-original-price").text(deal.itemPrice.toLocaleString() + "원");
    $("#hotdeal-link").attr("href", detailUrl);

    // 로딩 상태 제거 (만약 있다면)
    $(".categories__deal__countdown span:first-child").show(); // 타이머 문구 다시 보이게
  }

  function displayNoHotDeal(message = "진행 중인 핫딜이 없습니다.") {
    $("#hotdeal-img").attr("src", contextPath + "/img/product-sale.png");
    $("#hotdeal-name").text(message);
    $("#hotdeal-price").text("0원");
    $("#hotdeal-original-price").text("0원");
    $("#hotdeal-minutes").text("00");
    $("#hotdeal-seconds").text("00");
    $("#hotdeal-link").attr("href", "#").addClass("disabled"); // 링크 비활성화
    $(".categories__deal__countdown span:first-child").hide(); // 타이머 문구 숨김
    if (hotDealCountdownInterval) {
      clearInterval(hotDealCountdownInterval); // 기존 카운트다운 중지
    }
  }

  function startCountdown(expiryTimeString) {
    if (hotDealCountdownInterval) {
      clearInterval(hotDealCountdownInterval);
    }

    const expiryTime = new Date(expiryTimeString).getTime(); // 만료 시간을 밀리초로 변환

    hotDealCountdownInterval = setInterval(function () {
      const now = new Date().getTime();
      const distance = expiryTime - now;

      if (distance <= 0) {
        clearInterval(hotDealCountdownInterval);
        $("#hotdeal-minutes").text("00");
        $("#hotdeal-seconds").text("00");
        $("#hotdeal-name").text("다음 딜 준비 중...");
        setTimeout(loadHotDeal, 3000);
      } else {
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((distance % (1000 * 60)) / 1000);
        $("#hotdeal-minutes").text(minutes.toString().padStart(2, "0"));
        $("#hotdeal-seconds").text(seconds.toString().padStart(2, "0"));
      }
    }, 1000);
  }

  function createProductItemHtml(item) {
    const isSale =
      item.itemSprice != null &&
      item.itemSprice >= 0 &&
      item.itemSprice < item.itemPrice;
    const discountRate = isSale
      ? Math.round((1 - item.itemSprice / item.itemPrice) * 100)
      : 0;

    let priceHtml = "";
    if (isSale) {
      priceHtml =
        '<div class="price-container">' +
        '<span class="original-price">' +
        item.itemPrice.toLocaleString() +
        "원</span>" +
        '<div class="sale-info">' +
        '<span class="sale-price">' +
        item.itemSprice.toLocaleString() +
        "원</span>" +
        '<span class="discount-badge">' +
        discountRate +
        "%</span>" +
        "</div>" +
        "</div>";
    } else {
      priceHtml =
        '<div class="price-container">' +
        '<span class="sale-price">' +
        item.itemPrice.toLocaleString() +
        "원</span>" +
        "</div>";
    }

    const imgUrl =
      contextPath +
      "/img/product/" +
      (item.itemImg1 || "default-placeholder.png");
    const detailUrl = contextPath + "/shop/details?itemKey=" + item.itemKey;

    // 별점 HTML 생성
    const avgScore = item.avgScore || 0;
    const reviewCount = item.reviewCount || 0;
    let ratingHtml = '<div class="rating">';

    // 별점 표시 (1-5)
    for (let i = 1; i <= 5; i++) {
      if (i <= avgScore) {
        ratingHtml += '<i class="fa fa-star"></i>';
      } else if (i <= avgScore + 0.5 && i > avgScore) {
        ratingHtml += '<i class="fa fa-star-half-o"></i>';
      } else {
        ratingHtml += '<i class="fa fa-star-o"></i>';
      }
    }

    ratingHtml +=
      '<span class="review-count">(' + reviewCount + ")</span></div>";

    return (
      '<div class="col-lg-4 col-md-6 col-sm-6">' +
      '    <div class="product__item">' +
      '        <div class="product__item__pic set-bg" data-setbg="' +
      imgUrl +
      '">' +
      '            <ul class="product__hover">' +
      '                <li><a href="#" class="like-button" data-item-key="' +
      item.itemKey +
      '"><i class="fa fa-heart icon"></i></a></li>' +
      '                <li><a href="' +
      detailUrl +
      '" class="detail-button"><i class="fa fa-search icon"></i></a></li>' +
      "            </ul>" +
      "        </div>" +
      '        <div class="product__item__text">' +
      "            <h6>" +
      item.itemName +
      "</h6>" +
      ratingHtml +
      priceHtml +
      "        </div>" +
      "    </div>" +
      "</div>"
    );
  }

  $(".filter__controls li").on("click", function () {
    if ($(this).hasClass("active")) {
      return;
    }
    $(".filter__controls li").removeClass("active");
    $(this).addClass("active");

    const filterType = $(this).data("filter");
    const productContainer = $("#product-list-container");
    productContainer.html('<div class="col-12 loading-indicator"></div>');

    $.ajax({
      url: contextPath + "/api/items/" + filterType,
      type: "GET",
      dataType: "json",
      success: function (items) {
        productContainer.empty();
        if (items && items.length > 0) {
          items.forEach(function (item) {
            const itemHtml = createProductItemHtml(item);
            productContainer.append(itemHtml);
          });
          productContainer.find(".set-bg").each(function () {
            var bg = $(this).data("setbg");
            if (bg) {
              $(this).css("background-image", "url(" + bg + ")");
            }
          });
          // 새로운 상품 목록이 로드된 후 찜 버튼 초기화
          initializeHomeLikeButtons();
        } else {
          productContainer.html(
            '<div class="col-12 text-center">표시할 상품이 없습니다.</div>'
          );
        }
      },
      error: function (xhr, status, error) {
        console.error("Error fetching items:", status, error);
        productContainer.html(
          '<div class="col-12 text-center text-danger">상품을 불러오는 중 오류가 발생했습니다.</div>'
        );
      },
    });
  });

  $("#product-list-container .set-bg").each(function () {
    var bg = $(this).data("setbg");
    if (bg) {
      $(this).css("background-image", "url(" + bg + ")");
    }
  });

  loadHotDeal();
});
