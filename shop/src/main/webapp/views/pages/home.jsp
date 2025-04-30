<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <style>
                .set-bg {
                    background-size: cover;
                    background-position: center 30%;
                    background-repeat: no-repeat;
                }

                .loading-indicator {
                    text-align: center;
                    padding: 40px 15px;
                    font-size: 1.1em;
                    color: #555;
                    min-height: 200px;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    width: 100%;
                }

                .loading-indicator::after {
                    content: ' .';
                    animation: dots 1.4s linear infinite;
                    display: inline-block;
                    width: 1em;
                    text-align: left;
                }

                @keyframes dots {

                    0%,
                    20% {
                        content: ' .';
                    }

                    40% {
                        content: ' ..';
                    }

                    60% {
                        content: ' ...';
                    }

                    80%,
                    100% {
                        content: '.';
                    }
                }

                .product__item__pic {
                    height: 260px;
                    position: relative;
                    overflow: hidden;
                }

                .product__hover .like-button,
                .product__hover .detail-button {
                    display: inline-block;
                    transition: all 0.3s ease;
                    background-color: rgba(255, 255, 255, 0.8);
                    border-radius: 50%;
                    width: 40px;
                    height: 40px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    text-decoration: none;
                }

                .product__hover .like-button:hover,
                .product__hover .detail-button:hover {
                    transform: scale(1.2);
                    background-color: rgba(255, 255, 255, 0.9);
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }

                .product__hover .like-button.liked {
                    background-color: #ff6b6b;
                }

                .product__hover .like-button.liked .icon {
                    color: white;
                }

                .product__hover .icon {
                    font-size: 18px;
                    color: #333;
                    line-height: 1;
                }

                .product__item.liked .product__hover .like-button {
                    background-color: #ff6b6b;
                }

                .product__item.liked .product__hover .like-button .icon {
                    color: white;
                }

                .product__item__text h6 {
                    font-size: 15px;
                    color: #252525;
                    font-weight: 600;
                    margin-bottom: 5px;
                    overflow: hidden;
                    white-space: nowrap;
                    text-overflow: ellipsis;
                }

                .product__item__text .rating {
                    margin-bottom: 5px;
                    line-height: 1;
                }

                .product__item__text .rating i {
                    font-size: 13px;
                    color: #e3e3e3;
                    margin-right: 1px;
                }

                .product__item__text .rating i.fa-star {
                    color: #f7941d;
                }

                .product__item__text h5 {
                    color: #0d0d0d;
                    font-weight: 700;
                    font-size: 16px;
                    margin-bottom: 0;
                }

                .product__item__pic {
                    aspect-ratio: 1 / 1;
                    height: auto;
                    position: relative;
                    overflow: hidden;
                    margin-bottom: 20px;
                    background-position: center;
                    background-size: cover;
                }

                .product__item__pic .label {
                    position: absolute;
                    top: 10px;
                    left: 10px;
                    font-size: 12px;
                    color: #ffffff;
                    font-weight: 700;
                    padding: 2px 8px;
                    text-transform: uppercase;
                    background: #ca1515;
                    z-index: 9;
                }

                .categories__text h2 {
                    margin-bottom: 5px;
                }

                .categories__text .discount {
                    display: block;
                    font-weight: bold;
                }

                .categories__deal__countdown .deal-title {
                    font-size: 1.5em;
                    font-weight: bold;
                    display: block;
                    margin-bottom: 15px;
                }

                .categories__deal__timer .cd-item span {
                    font-size: 25px;
                    font-weight: 700;
                }
            </style>

            <script>
                var contextPath = "${pageContext.request.contextPath}";

                const shop = {

                    addToCart: (itemKey) => {
                        console.log("Adding item to cart from home page:", itemKey);
                        const requestData = { itemKey: itemKey, cartCnt: 1 };
                        $.ajax({
                            url: contextPath + '/cart/add/ajax', // contextPath 사용 확인
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify(requestData),
                            success: function (response) {
                                console.log("Add to cart response:", response);
                                if (response.success) {
                                    // shop.showToast('상품이 장바구니에 추가되었습니다.'); // 토스트 메시지로 변경 가능
                                    alert('상품이 장바구니에 추가되었습니다.');
                                } else {
                                    alert(response.message || '장바구니 추가 중 오류가 발생했습니다.');
                                    if (response.redirectUrl) {
                                        window.location.href = contextPath + response.redirectUrl; // contextPath 추가
                                    }
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("Add to cart Ajax error:", status, error, xhr.responseText);
                                alert('장바구니 추가 중 서버 통신 오류가 발생했습니다.');
                            }
                        });
                    },

                    // 찜하기 버튼 초기화 함수 (shop.jsp와 동일)
                    initializeLikeButtons: () => {
                        // AJAX로 로드된 상품 포함하여 모든 like-button에 이벤트 리스너 추가
                        document.querySelectorAll('#product-list-container .product__hover .like-button').forEach(button => {
                            // 이미 이벤트 리스너가 있는지 확인 (중복 방지)
                            if (button.dataset.listenerAttached === 'true') return;

                            const itemKey = button.getAttribute('data-item-key');
                            const productItem = button.closest('.product__item');

                            if (shop.isLoggedIn) {
                                shop.checkLiked(itemKey, (isLiked) => {
                                    if (isLiked) {
                                        button.classList.add('liked');
                                        if (productItem) productItem.classList.add('liked');
                                    } else {
                                        button.classList.remove('liked');
                                        if (productItem) productItem.classList.remove('liked');
                                    }
                                });
                            }

                            button.addEventListener('click', function (e) {
                                e.preventDefault();
                                shop.toggleLike(itemKey, this);
                            });
                            button.dataset.listenerAttached = 'true'; // 리스너 추가됨 표시
                        });
                    },

                    // 찜하기 토글 함수 (shop.jsp와 동일)
                    toggleLike: (itemKey, button) => {
                        if (!shop.isLoggedIn) {
                            if (confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) {
                                window.location.href = contextPath + '/login';
                            }
                            return;
                        }

                        $.ajax({
                            url: contextPath + '/shop/like/toggle',
                            type: 'POST',
                            data: { itemKey: itemKey },
                            success: function (response) {
                                if (response.success) {
                                    const productItem = button.closest('.product__item');

                                    if (response.action === 'added') {
                                        button.classList.add('liked');
                                        if (productItem) productItem.classList.add('liked');
                                        shop.showToast('상품이 찜 목록에 추가되었습니다.');
                                    } else {
                                        button.classList.remove('liked');
                                        if (productItem) productItem.classList.remove('liked');
                                        shop.showToast('상품이 찜 목록에서 제거되었습니다.');
                                    }
                                } else {
                                    alert(response.message || '찜하기 처리 중 오류가 발생했습니다.');
                                    if (response.redirectUrl) {
                                        window.location.href = contextPath + response.redirectUrl;
                                    }
                                }
                            },
                            error: function () {
                                alert('서버 통신 오류가 발생했습니다.');
                            }
                        });
                    },

                    // 찜 상태 확인 함수 (shop.jsp와 동일)
                    checkLiked: (itemKey, callback) => {
                        // 로그인 상태가 아니면 바로 false 반환
                        if (!shop.isLoggedIn) {
                            callback(false);
                            return;
                        }
                        $.ajax({
                            url: contextPath + '/shop/like/check',
                            type: 'GET',
                            data: { itemKey: itemKey },
                            success: function (response) {
                                if (response.success && response.isLiked) {
                                    callback(true);
                                } else {
                                    callback(false);
                                }
                            },
                            error: function () {
                                callback(false); // 에러 시에도 false 처리
                            }
                        });
                    },

                    // 토스트 메시지 표시 함수 (shop.jsp와 동일)
                    showToast: (message) => {
                        // ... (shop.jsp의 showToast 함수 내용 그대로 복사) ...
                        if (!document.getElementById('toast-container')) {
                            const toastContainer = document.createElement('div');
                            toastContainer.id = 'toast-container';
                            toastContainer.style.cssText = `
                  position: fixed;
                  bottom: 20px;
                  right: 20px;
                  z-index: 9999;
                `;
                            document.body.appendChild(toastContainer);
                        }

                        const toast = document.createElement('div');
                        toast.className = 'toast-message';
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

                        document.getElementById('toast-container').appendChild(toast);

                        setTimeout(() => {
                            toast.style.opacity = '1';
                        }, 10);

                        setTimeout(() => {
                            toast.style.opacity = '0';
                            setTimeout(() => {
                                toast.remove();
                            }, 300);
                        }, 3000);
                    }
                };

                shop.isLoggedIn = ${ isLoggedIn != null && isLoggedIn ? 'true' : 'false' };
                shop.customerId = '${custId}';
                let hotDealCountdownInterval = null;

                function loadHotDeal() {
                    $.ajax({
                        url: contextPath + '/api/hotdeal/current',
                        type: 'GET',
                        dataType: 'json',
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
                        }
                    });
                }

                function updateHotDealSection(deal) {
                    const imgUrl = contextPath + '/img/product/' + (deal.itemImg1 || 'default-placeholder.png');
                    const detailUrl = contextPath + '/shop/details?itemKey=' + deal.itemKey;

                    $('#hotdeal-img').attr('src', imgUrl);
                    $('#hotdeal-name').text(deal.itemName);
                    $('#hotdeal-price').text(deal.hotDealPrice.toLocaleString() + '원');
                    $('#hotdeal-original-price').text(deal.itemPrice.toLocaleString() + '원');
                    $('#hotdeal-link').attr('href', detailUrl);

                    // 로딩 상태 제거 (만약 있다면)
                    $('.categories__deal__countdown span:first-child').show(); // 타이머 문구 다시 보이게
                }

                function displayNoHotDeal(message = "진행 중인 핫딜이 없습니다.") {
                    $('#hotdeal-img').attr('src', contextPath + '/img/product-sale.png');
                    $('#hotdeal-name').text(message);
                    $('#hotdeal-price').text('0원');
                    $('#hotdeal-original-price').text('0원');
                    $('#hotdeal-minutes').text('00');
                    $('#hotdeal-seconds').text('00');
                    $('#hotdeal-link').attr('href', '#').addClass('disabled'); // 링크 비활성화
                    $('.categories__deal__countdown span:first-child').hide(); // 타이머 문구 숨김
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
                            $('#hotdeal-minutes').text('00');
                            $('#hotdeal-seconds').text('00');
                            $('#hotdeal-name').text('다음 딜 준비 중...');
                            setTimeout(loadHotDeal, 3000);
                        } else {
                            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                            const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                            $('#hotdeal-minutes').text(minutes.toString().padStart(2, '0'));
                            $('#hotdeal-seconds').text(seconds.toString().padStart(2, '0'));
                        }
                    }, 1000);
                }

                function createProductItemHtml(item) {
                    const priceHtml = '<h5>' + item.itemPrice.toLocaleString() + '원</h5>';

                    const imgUrl = contextPath + '/img/product/' + (item.itemImg1 || 'default-placeholder.png');
                    const detailUrl = contextPath + '/shop/details?itemKey=' + item.itemKey;

                    const isSale = (item.itemSprice != null && item.itemSprice >= 0 && item.itemSprice < item.itemPrice);
                    const saleLabelHtml = isSale ? '<span class="label sale">Sale</span>' : '';

                    return (
                        '<div class="col-lg-4 col-md-6 col-sm-6">' +
                        '    <div class="product__item">' +
                        '        <div class="product__item__pic set-bg" data-setbg="' + imgUrl + '">' +
                        saleLabelHtml +
                        '            <ul class="product__hover">' +
                        '                <li><a href="#" class="like-button" data-item-key="' + item.itemKey + '"><i class="fa fa-heart icon"></i></a></li>' +
                        '                <li><a href="' + detailUrl + '" class="detail-button"><i class="fa fa-search icon"></i></a></li>' +
                        '            </ul>' +
                        '        </div>' +
                        '        <div class="product__item__text">' +
                        '            <h6>' + item.itemName + '</h6>' +
                        '            <a href="#" class="add-cart" onclick="shop.addToCart(' + item.itemKey + '); return false;">+ Add To Cart</a>' +
                        '            <div class="rating">' +
                        '                <i class="fa fa-star-o"></i>' +
                        '                <i class="fa fa-star-o"></i>' +
                        '                <i class="fa fa-star-o"></i>' +
                        '                <i class="fa fa-star-o"></i>' +
                        '                <i class="fa fa-star-o"></i>' +
                        '            </div>' +
                        priceHtml +
                        '        </div>' +
                        '    </div>' +
                        '</div>'
                    );
                }

                $(function () {
                    shop.initializeLikeButtons();

                    $('.filter__controls li').on('click', function () {
                        if ($(this).hasClass('active')) { return; }
                        $('.filter__controls li').removeClass('active');
                        $(this).addClass('active');

                        const filterType = $(this).data('filter');
                        const productContainer = $('#product-list-container');
                        productContainer.html('<div class="col-12 loading-indicator">상품을 불러오는 중...</div>');

                        $.ajax({
                            url: contextPath + '/api/items/' + filterType,
                            type: 'GET',
                            dataType: 'json',
                            success: function (items) {
                                productContainer.empty();
                                if (items && items.length > 0) {
                                    items.forEach(function (item) {
                                        const itemHtml = createProductItemHtml(item); // 수정된 함수 사용
                                        productContainer.append(itemHtml);
                                    });
                                    // 배경 이미지 설정
                                    productContainer.find('.set-bg').each(function () {
                                        var bg = $(this).data('setbg');
                                        if (bg) { $(this).css('background-image', 'url(' + bg + ')'); }
                                    });
                                    // AJAX 로드 후 찜하기 버튼 초기화
                                    shop.initializeLikeButtons();
                                } else {
                                    productContainer.html('<div class="col-12 text-center">표시할 상품이 없습니다.</div>');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("Error fetching items:", status, error);
                                productContainer.html('<div class="col-12 text-center text-danger">상품을 불러오는 중 오류가 발생했습니다.</div>');
                            }
                        });
                    });

                    $('#product-list-container .set-bg').each(function () {
                        var bg = $(this).data('setbg');
                        if (bg) { $(this).css('background-image', 'url(' + bg + ')'); }
                    });

                    loadHotDeal();
                });
            </script>

            <!-- Hero Section Begin -->
            <section class="hero">
                <div class="hero__slider owl-carousel">
                    <div class="hero__items set-bg" data-setbg="<c:url value='/img/hero/hero-1.png'/>"
                        data-setbg-dark="<c:url value='/img/hero/dark-hero-1.png'/>">
                        <div class="container">
                            <div class="row">
                                <div class="col-xl-5 col-lg-7 col-md-8">
                                    <div class="hero__text">
                                        <h6>오늘도 함께 걷는 소중한 하루</h6>
                                        <h2>우리 강아지를 위한<br> 따뜻한 선택</h2>
                                        <p>간식부터 산책용품, 옷까지<br>
                                            사랑스러운 순간을 펫GPT와 함께하세요.</p>
                                        <a href="<c:url value='/shop'/>" class="primary-btn">Shop now <span
                                                class="arrow_right"></span></a>
                                        <div class="hero__social">
                                            <a href="#"><i class="fa fa-facebook"></i></a>
                                            <a href="#"><i class="fa fa-twitter"></i></a>
                                            <a href="#"><i class="fa fa-pinterest"></i></a>
                                            <a href="#"><i class="fa fa-instagram"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hero__items set-bg" data-setbg="<c:url value='/img/hero/hero-2.png'/>"
                        data-setbg-dark="<c:url value='/img/hero/dark-hero-2.png'/>">
                        <div class="container">
                            <div class="row">
                                <div class="col-xl-5 col-lg-7 col-md-8">
                                    <div class="hero__text">
                                        <h6>조용한 하루를 더 포근하게</h6>
                                        <h2>우리 고양이를 위한<br> 세심한 선택</h2>
                                        <p>장난감, 캣타워, 식기까지<br>
                                            고양이의 취향을 담은 제품을 준비했어요.</p>
                                        <a href="<c:url value='/shop'/>" class="primary-btn">Shop now <span
                                                class="arrow_right"></span></a>
                                        <div class="hero__social">
                                            <a href="#"><i class="fa fa-facebook"></i></a>
                                            <a href="#"><i class="fa fa-twitter"></i></a>
                                            <a href="#"><i class="fa fa-pinterest"></i></a>
                                            <a href="#"><i class="fa fa-instagram"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hero__items set-bg" data-setbg="<c:url value='/img/hero/hero-3.png'/>"
                        data-setbg-dark="<c:url value='/img/hero/dark-hero-3.png'/>">
                        <div class="container">
                            <div class="row">
                                <div class="col-xl-5 col-lg-7 col-md-8">
                                    <div class="hero__text">
                                        <h6 style="font-size: 24px; font-weight: bold; margin-bottom: 15px;">
                                            <span style="font-size: 40px; vertical-align: top; line-height: 1;">“</span>
                                            음! 맛있다~ 꿀잠꿀잠
                                        </h6>
                                        <h2>내새꾸<br> 꿀잠맛집 방석<span style="color: #007bff; font-weight: bold;">zzz</span>
                                        </h2>
                                        <p>하루의 피로를 싹 풀어주는 마약 방석!<br>
                                            포근함에 한번 누우면 헤어나올 수 없어요.</p>
                                        <a href="<c:url value='/shop'/>" class="primary-btn">Shop now <span
                                                class="arrow_right"></span></a>
                                        <div class="hero__social">
                                            <a href="#"><i class="fa fa-facebook"></i></a>
                                            <a href="#"><i class="fa fa-twitter"></i></a>
                                            <a href="#"><i class="fa fa-pinterest"></i></a>
                                            <a href="#"><i class="fa fa-instagram"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Hero Section End -->

            <!-- Banner Section Begin -->
            <section class="banner spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-7 offset-lg-4">
                            <div class="banner__item">
                                <div class="banner__item__pic">
                                    <img src="<c:url value='/img/banner/banner-fashion.jpg'/>" alt="">
                                </div>
                                <div class="banner__item__text">
                                    <h2>Fashion/Accessory</h2>
                                    <a href="<c:url value='/shop?category=clothing'/>">Shop now</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5">
                            <div class="banner__item banner__item--middle">
                                <div class="banner__item__pic">
                                    <img src="<c:url value='/img/banner/banner-toy.jpg'/>" alt="">
                                </div>
                                <div class="banner__item__text">
                                    <h2>Toy</h2>
                                    <a href="<c:url value='/shop?category=accessories'/>">Shop now</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <div class="banner__item banner__item--last">
                                <div class="banner__item__pic">
                                    <img src="<c:url value='/img/banner/banner-food.jpeg'/>" alt="">
                                </div>
                                <div class="banner__item__text">
                                    <h2>Food/Desert</h2>
                                    <a href="<c:url value='/shop?category=shoes'/>">Shop now</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Banner Section End -->

            <!-- Product Section Begin -->
            <section class="product spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <ul class="filter__controls">
                                <li class="active" data-filter="bestsellers">베스트셀러</li>
                                <li data-filter="newarrivals">신상품</li>
                                <li data-filter="hotsales">할인 상품</li>
                            </ul>
                        </div>
                    </div>
                    <div class="row product__filter" id="product-list-container">

                        <%-- 초기 로드 시 베스트셀러 목록 표시 --%>
                            <c:choose>
                                <c:when test="${not empty bestSellerList}">
                                    <c:forEach items="${bestSellerList}" var="item">
                                        <div class="col-lg-4 col-md-6 col-sm-6">
                                            <div class="product__item">
                                                <div class="product__item__pic set-bg"
                                                    data-setbg="<c:url value='/img/product/${item.itemImg1}'/>">
                                                    <c:if
                                                        test="${item.itemSprice > 0 and item.itemSprice < item.itemPrice}">
                                                        <span class="label sale">Sale</span>
                                                    </c:if>
                                                    <ul class="product__hover">
                                                        <li><a href="#" class="like-button"
                                                                data-item-key="${item.itemKey}">
                                                                <i class="fa fa-heart icon"></i>
                                                            </a></li>
                                                        <li><a href="<c:url value='/shop/details?itemKey=${item.itemKey}'/>"
                                                                class="detail-button">
                                                                <i class="fa fa-search icon"></i>
                                                            </a></li>
                                                    </ul>
                                                </div>
                                                <div class="product__item__text">
                                                    <h6>${item.itemName}</h6>
                                                    <a href="#" class="add-cart"
                                                        onclick="shop.addToCart(${item.itemKey}); return false;">+
                                                        Add To Cart</a>
                                                    <div class="rating">
                                                        <i class="fa fa-star-o"></i>
                                                        <i class="fa fa-star-o"></i>
                                                        <i class="fa fa-star-o"></i>
                                                        <i class="fa fa-star-o"></i>
                                                        <i class="fa fa-star-o"></i>
                                                    </div>
                                                    <h5>${item.itemPrice}원</h5>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-12 text-center">표시할 상품이 없습니다.</div>
                                </c:otherwise>
                            </c:choose>

                    </div>
                </div>
            </section>
            <!-- Product Section End -->

            <!-- Hot Deal Section Begin -->
            <section class="categories spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="categories__text">
                                <h2>Hot Deal <br><span class="discount">1분 특가!</span></h2>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="categories__hot__deal">
                                <img id="hotdeal-img" src="<c:url value='/img/product-sale.png'/>"
                                    alt="Hot Deal Product">
                                <div class="hot__deal__sticker">
                                    <span>Sale Of</span>
                                    <h5 id="hotdeal-price">0원</h5>
                                    <del id="hotdeal-original-price">0원</del>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 offset-lg-1">
                            <div class="categories__deal__countdown">
                                <span class="deal-title">⏰ 1분 타임딜 ⏰</span>
                                <h2 id="hotdeal-name">상품 로딩 중...</h2>
                                <div class="categories__deal__timer">
                                    <div class="cd-item">
                                        <span id="hotdeal-minutes">00</span>
                                        <p>Minutes</p>
                                    </div>
                                    <div class="cd-item">
                                        <span id="hotdeal-seconds">00</span>
                                        <p>Seconds</p>
                                    </div>
                                </div>
                                <a id="hotdeal-link" href="#" class="primary-btn">지금 보러 가기</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Hot Deal Section End -->

            <!-- Instagram Section Begin -->
            <section class="instagram spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="instagram__pic">
                                <div class="instagram__pic__item set-bg"
                                    data-setbg="<c:url value='/img/instagram/instagram-1.jpg'/>"></div>
                                <div class="instagram__pic__item set-bg"
                                    data-setbg="<c:url value='/img/instagram/instagram-2.jpg'/>"></div>
                                <div class="instagram__pic__item set-bg"
                                    data-setbg="<c:url value='/img/instagram/instagram-3.jpg'/>"></div>
                                <div class="instagram__pic__item set-bg"
                                    data-setbg="<c:url value='/img/instagram/instagram-4.jpg'/>"></div>
                                <div class="instagram__pic__item set-bg"
                                    data-setbg="<c:url value='/img/instagram/instagram-5.jpg'/>"></div>
                                <div class="instagram__pic__item set-bg"
                                    data-setbg="<c:url value='/img/instagram/instagram-6.jpg'/>"></div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="instagram__text">
                                <h2>Instagram</h2>
                                <p>우리 아이의 귀여운 순간들,
                                    펫GPT와 함께한 일상을 공유해보세요 🐾
                                    매주 베스트샷 선정도 진행 중!</p>
                                <h3>#펫GPT #댕냥스타그램</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Instagram Section End -->

            <!-- Latest Blog Section Begin -->
            <section class="latest spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="section-title">
                                <span>펫 라이프 꿀팁</span>
                                <h2>우리 아이를 위한 트렌드 소식</h2>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="blog__item">
                                <div class="blog__item__pic set-bg" data-setbg="<c:url value='/img/blog/blog-1.jpg'/>">
                                </div>
                                <div class="blog__item__text">
                                    <span><img src="<c:url value='/img/icon/calendar.png'/>" alt=""> 5 April 2025</span>
                                    <h5>초보 집사를 위한 강아지 산책 체크리스트</h5>
                                    <a href="<c:url value='/blog-details'/>">자세히 보기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Latest Blog Section End -->