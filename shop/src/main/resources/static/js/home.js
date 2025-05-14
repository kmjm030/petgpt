const home = {
  init:function(){
    let loc = "1835847";
    this.getData(loc);
  },
  getData:function(loc){
    $.ajax({
      url:'<c:url value="/getwinfo"/>',
      data:{loc:loc},
      success:(result)=>{
        this.display(result);
      },
      error:()=>{}
    });
  },
  display:function(result){
    let temp = result.main.temp;
    let desc = result.weather[0].description;
    let icon = result.weather[0].icon;
    let txt = '';
    // txt += '<img width="50px" src="https://openweathermap.org/img/wn/'+result.weather[0].icon+'@2x.png">';

    let message = '';

    if (icon.startsWith('01')) {
      if (temp < 0) {
        message = '☀️ 영하 날씨엔 산책 대신 따뜻한 집에서 터그놀이 어떨까요?';
      } else if (temp >= 0 && temp < 15) {
        message = '☀️ 쌀쌀한 날이에요. 따뜻한 낮에 산책시켜주세요!';
      } else if (temp >= 15 && temp < 25) {
        message = '☀️ 산책하기 딱 좋은 날! 강아지랑 발맞춰 걷기🐕‍';
      } else {
        message = '☀️ 너무 더워요! 선선한 아침이나 저녁에 산책시켜주기!';
      }
    } else if (icon.startsWith('09') || icon.startsWith('10')) {
      message = '🌧️ 비가 오니 산책 대신 집에서 터그놀이 한 판 어떨까요?';
    } else if (icon.startsWith('13')) {
      message = '❄️ 눈이 와요! 산책 대신 집에서 강아지와 눈구경 어떨까요?';
    } else if (icon.startsWith('11')) {
      message = '⚡ 천둥번개! 오늘은 산책을 피해주세요!';
    } else if (icon.startsWith('50')) {
      if (temp < 0) {
        message = '🌫️ 영하 날씨엔 산책 대신 따뜻한 집에서 터그놀이 어떨까요?';
      } else if (temp >= 0 && temp < 15) {
        message = '🌫️ 쌀쌀한 날이에요. 따뜻한 낮에 산책시켜주세요!';
      } else if (temp >= 15 && temp < 25) {
        message = '🌫️ 안개가 꼈어요. 산책시 조심히 다녀오기!';
      } else {
        message = '🌫️ 너무 더워요! 선선한 아침이나 저녁에 산책시켜주기!';
      }

    } else {
      if (temp < 0) {
        message = '🌤️ 영하 날씨엔 산책 대신 따뜻한 집에서 터그놀이 어떨까요?';
      } else if (temp >= 0 && temp < 15) {
        message = '🌤️ 쌀쌀한 날이에요. 따뜻한 낮에 산책시켜주세요!';
      } else if (temp >= 15 && temp < 25) {
        message = '🌤️ 살짝 흐리지만 강아지와 산책하기 딱 좋은 날씨예요!';
      } else {
        message = '🌤️ 너무 더워요! 선선한 아침이나 저녁에 산책시켜주기!';
      }
    }

    const weatherText = '<p>' + message + '<span><strong>   [' + temp + '℃]</strong></span></p>';
    const defaultText = '<p>반려동물 용품 전문 쇼핑몰🐶🐱</p>';

    let showingWeather = false;
    $('#winfo').html(defaultText);

    setInterval(() => {
      $('#winfo').fadeOut(500, function() {
        if (showingWeather) {
          $(this).html(defaultText).fadeIn(500);
        } else {
          $(this).html(weatherText).fadeIn(500);
        }
        showingWeather = !showingWeather;
      });
    }, 3000);
  }
}
$(function(){
  home.init();
});


$(function () {

  home.init();
  let hotDealCountdownInterval = null;
  let homeLikeToggleUrl, homeLikeCheckUrl, homeLoginUrl;
  let homeIsLoggedIn = false;

  let popularPostsPage = 1;
  let loadingMorePosts = false;
  let noMorePopularPosts = false;

  const homePageData = $("#home-page-data");
  if (homePageData.length > 0) {
    homeIsLoggedIn =
      homePageData.data("is-logged-in") === true ||
      homePageData.data("is-logged-in") === "true";
    homeLikeToggleUrl = homePageData.data("like-toggle-url") || "";
    homeLikeCheckUrl = homePageData.data("like-check-url") || "";
    homeLoginUrl = homePageData.data("login-url") || "";

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
          setTimeout(loadHotDeal, 10000);
        }
      },
      error: function (xhr, status, error) {
        console.error("핫딜 정보를 불러오는 중 오류 발생:", status, error);
        displayNoHotDeal("핫딜 정보를 불러오는 중 오류 발생");
        setTimeout(loadHotDeal, 10000);
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
    $(".categories__deal__countdown span:first-child").show();
  }

  function displayNoHotDeal(message = "진행 중인 핫딜이 없습니다.") {
    $("#hotdeal-img").attr("src", contextPath + "/img/product-sale.png");
    $("#hotdeal-name").text(message);
    $("#hotdeal-price").text("0원");
    $("#hotdeal-original-price").text("0원");
    $("#hotdeal-minutes").text("00");
    $("#hotdeal-seconds").text("00");
    $("#hotdeal-link").attr("href", "#").addClass("disabled");
    $(".categories__deal__countdown span:first-child").hide();
    if (hotDealCountdownInterval) {
      clearInterval(hotDealCountdownInterval);
    }
  }

  function startCountdown(expiryTimeString) {
    if (hotDealCountdownInterval) {
      clearInterval(hotDealCountdownInterval);
    }

    const expiryTime = new Date(expiryTimeString).getTime();

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

  function loadMorePopularPosts() {
    if (loadingMorePosts || noMorePopularPosts) return;

    loadingMorePosts = true;
    const postsContainer = document.querySelector(".latest .row:nth-child(3)");
    const loadingIndicator = document.createElement("div");
    loadingIndicator.className = "col-lg-12 text-center my-3 loading-indicator";
    loadingIndicator.innerHTML =
      '<i class="fa fa-spinner fa-spin"></i> 로딩 중...';
    postsContainer.appendChild(loadingIndicator);

    $.ajax({
      url: contextPath + "/community/popular-posts",
      type: "GET",
      data: {
        page: popularPostsPage + 1,
        limit: 5,
      },
      success: function (response) {
        const indicator = document.querySelector(".loading-indicator");
        if (indicator) indicator.remove();

        loadingMorePosts = false;

        if (!response || !response.posts || response.posts.length === 0) {
          noMorePopularPosts = true;
          const noMorePostsDiv = document.createElement("div");
          noMorePostsDiv.className = "col-lg-12 text-center my-3";
          noMorePostsDiv.innerHTML = "<p>더 이상 게시글이 없습니다.</p>";
          postsContainer.appendChild(noMorePostsDiv);

          const moreButton = document.getElementById("more-popular-posts");
          if (moreButton) moreButton.style.display = "none";

          return;
        }

        popularPostsPage++;

        response.posts.forEach(function (post) {
          const postHtml = createPopularPostHtml(post);
          postsContainer.insertAdjacentHTML("beforeend", postHtml);
        });
      },
      error: function (xhr, status, error) {
        console.error("인기글 로드 중 오류 발생:", error);
        loadingMorePosts = false;

        const indicator = document.querySelector(".loading-indicator");
        if (indicator) indicator.remove();

        const errorDiv = document.createElement("div");
        errorDiv.className = "col-lg-12 text-center my-3 error-message";
        errorDiv.innerHTML =
          '<p>게시글을 불러오는 중 오류가 발생했습니다.</p><button onclick="loadMorePopularPosts()" class="btn btn-primary">다시 시도</button>';
        postsContainer.appendChild(errorDiv);
      },
    });
  }

  function createPopularPostHtml(post) {
    const createdAt = new Date(post.regDate);
    const year = createdAt.getFullYear();
    const month = String(createdAt.getMonth() + 1).padStart(2, "0");
    const day = String(createdAt.getDate()).padStart(2, "0");
    const formattedDate = `${year}.${month}.${day}`;

    let categoryText = "일반글";
    switch (post.category) {
      case "notice":
        categoryText = "공지사항";
        break;
      case "free":
        categoryText = "자유게시판";
        break;
      case "show":
        categoryText = "펫자랑게시판";
        break;
    }

    return `
      <div class="col-lg-12">
        <div class="blog__post">
          <div class="blog__post__header">
            <div>
              <h3 class="blog__post__title">
                <a href="${contextPath}/community/detail?id=${post.boardKey}">${post.boardTitle}</a>
              </h3>
              <div class="blog__post__meta">
                <span>작성자: ${post.custId || "익명"}</span>
                <span>작성일: ${formattedDate}</span>
              </div>
            </div>
          </div>

          ${
            post.boardImg
              ? `
          <div class="blog__post__image-container">
            <img class="blog__post__image" src="${post.boardImg}" alt="게시글 이미지">
          </div>
          `
              : ""
          }

          <div class="blog__post__body">
            <p class="blog__post__content">${
              post.boardContent
                ? post.boardContent.substring(0, 150) + "..."
                : ""
            }</p>
          </div>

          <div class="blog__post__footer">
            <div class="blog__post__stats">
              <div class="stats__item"><i class="fa fa-eye"></i> ${
                post.viewCount
              }</div>
              <div class="stats__item"><i class="fa fa-heart"></i> ${
                post.likeCount
              }</div>
              <div class="stats__item"><i class="fa fa-comment"></i> ${
                post.commentCount
              }</div>
            </div>
            <div class="blog__post__category">
              <span>#${categoryText}</span>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  $(document).ready(function () {
    const morePopularPostsBtn = document.getElementById("more-popular-posts");
    if (morePopularPostsBtn) {
      morePopularPostsBtn.addEventListener("click", function (e) {
        e.preventDefault();
        loadMorePopularPosts();
      });
    }
  });
});
