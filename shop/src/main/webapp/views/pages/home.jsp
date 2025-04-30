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

                /* .product__item {
                    margin-bottom: 35px;
                    /* shop.jsp 기본 간격 */
                position: relative;
                /* 찜하기 상태 표시용 */
                overflow: visible;
                /* 호버 시 그림자 보이도록 */
                }

                */ .product__item__pic {
                    height: 260px;
                    /* shop.jsp 기본 높이 */
                    position: relative;
                    overflow: hidden;
                    /* 내부 요소 넘침 방지 */

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
                    /* 아이콘 중앙 정렬 */
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
                    /* shop.jsp의 liked 버튼 스타일 */
                    background-color: #ff6b6b;
                }

                .product__hover .like-button.liked .icon {
                    /* shop.jsp의 liked 아이콘 스타일 */
                    color: white;
                }

                .product__hover .icon {
                    /* shop.jsp의 아이콘 스타일 */
                    font-size: 18px;
                    color: #333;
                    line-height: 1;
                    /* 아이콘 세로 정렬 */
                }

                /* 상품 자체에 liked 클래스 적용 시 (shop.jsp 참고) */
                .product__item.liked .product__hover .like-button {
                    background-color: #ff6b6b;
                }

                .product__item.liked .product__hover .like-button .icon {
                    color: white;
                }

                .product__item__text h6 {
                    /* 상품명 */
                    font-size: 15px;
                    color: #252525;
                    font-weight: 600;
                    margin-bottom: 5px;
                    /* 이름과 다음 요소 간격 */
                    overflow: hidden;
                    /* shop.jsp에는 없었지만, 길 경우 대비 */
                    white-space: nowrap;
                    text-overflow: ellipsis;
                }

                .product__item__text .rating {
                    /* 별점 */
                    margin-bottom: 5px;
                    /* 별점과 가격 간격 */
                    line-height: 1;
                }

                .product__item__text .rating i {
                    font-size: 13px;
                    color: #e3e3e3;
                    /* 빈 별 색상 */
                    margin-right: 1px;
                }

                .product__item__text .rating i.fa-star {
                    /* 채워진 별 색상 */
                    color: #f7941d;
                }

                .product__item__text h5 {
                    /* 가격 */
                    color: #0d0d0d;
                    font-weight: 700;
                    font-size: 16px;
                    /* 이미지 참고 크기 */
                    margin-bottom: 0;
                }

                .product__item__pic {
                    /* height: 260px; */
                    /* 고정 높이 제거 */
                    aspect-ratio: 1 / 1;
                    /* 정사각형 비율 */
                    height: auto;
                    /* 높이 자동 조정 */
                    position: relative;
                    overflow: hidden;
                    margin-bottom: 20px;
                    background-position: center;
                    /* 이미지 중앙 정렬 */
                    background-size: cover;
                    /* 이미지 꽉 채우기 */
                }

                /* Sale 라벨 스타일 (필요시 유지) */
                .product__item__pic .label {
                    position: absolute;
                    top: 10px;
                    left: 10px;
                    /* 왼쪽 상단 */
                    font-size: 12px;
                    color: #ffffff;
                    font-weight: 700;
                    padding: 2px 8px;
                    text-transform: uppercase;
                    background: #ca1515;
                    /* 빨간색 배경 */
                    z-index: 9;
                }
            </style>

            <script>
                var contextPath = "${pageContext.request.contextPath}";

                const shop = {
                    // shop.jsp의 init 함수는 home.jsp에서는 필터링 기능이 없으므로 제거
                    // filterDuplicateColors 함수 제거

                    // 장바구니 추가 함수 (shop.jsp와 동일)
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

                // 로그인 상태 및 사용자 ID 변수 (shop.jsp에서 가져옴, 서버에서 전달된 값 사용)
                shop.isLoggedIn = ${ isLoggedIn != null && isLoggedIn ? 'true' : 'false' };
                shop.customerId = '${custId}'; // custId가 서버에서 전달된다고 가정

                // 기존 addToCart 함수 제거

                $(function () { // DOM 로드 후 실행

                    // 초기 로드된 상품들에 대해 찜하기 버튼 초기화
                    shop.initializeLikeButtons();

                    // 필터 클릭 이벤트 처리
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

                    // 상품 아이템 HTML 생성 함수 (shop.jsp 스타일 적용)
                    function createProductItemHtml(item) {
                        const priceHtml = '<h5>' + item.itemPrice.toLocaleString() + '원</h5>';

                        const imgUrl = contextPath + '/img/product/' + (item.itemImg1 || 'default-placeholder.png');
                        const detailUrl = contextPath + '/shop/details?itemKey=' + item.itemKey; // shop.jsp와 동일한 URL 구조

                        const isSale = (item.itemSprice != null && item.itemSprice >= 0 && item.itemSprice < item.itemPrice);
                        const saleLabelHtml = isSale ? '<span class="label sale">Sale</span>' : '';

                        // shop.jsp와 동일한 HTML 구조 반환
                        return (
                            '<div class="col-lg-4 col-md-6 col-sm-6">' +
                            '    <div class="product__item">' + // 찜 상태 클래스는 JS로 관리
                            '        <div class="product__item__pic set-bg" data-setbg="' + imgUrl + '">' +
                            saleLabelHtml + // Sale 라벨
                            '            <ul class="product__hover">' + // 호버 아이콘
                            '                <li><a href="#" class="like-button" data-item-key="' + item.itemKey + '"><i class="fa fa-heart icon"></i></a></li>' +
                            '                <li><a href="' + detailUrl + '" class="detail-button"><i class="fa fa-search icon"></i></a></li>' +
                            '            </ul>' +
                            '        </div>' +
                            '        <div class="product__item__text">' + // 텍스트 영역 (shop.jsp 구조)
                            '            <h6>' + item.itemName + '</h6>' + // 상품명
                            // 장바구니 버튼 (shop.jsp와 동일)
                            '            <a href="#" class="add-cart" onclick="shop.addToCart(' + item.itemKey + '); return false;">+ Add To Cart</a>' +
                            '            <div class="rating">' + // 별점
                            '                <i class="fa fa-star-o"></i>' +
                            '                <i class="fa fa-star-o"></i>' +
                            '                <i class="fa fa-star-o"></i>' +
                            '                <i class="fa fa-star-o"></i>' +
                            '                <i class="fa fa-star-o"></i>' +
                            '            </div>' +
                            priceHtml + // 가격
                            '        </div>' +
                            '    </div>' +
                            '</div>'
                        );
                    }

                    // 페이지 로드 시 배경 이미지 설정 (초기 로드된 상품들 - 유지)
                    $('#product-list-container .set-bg').each(function () {
                        var bg = $(this).data('setbg');
                        if (bg) { $(this).css('background-image', 'url(' + bg + ')'); }
                    });

                }); // End of $(function() {})
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
                                                <div class="product__item__text"> <%-- 텍스트 영역 (shop.jsp 구조) --%>
                                                        <h6>${item.itemName}</h6> <%-- 상품명 --%>
                                                            <%-- 장바구니 버튼 (shop.jsp와 동일) --%>
                                                                <a href="#" class="add-cart"
                                                                    onclick="shop.addToCart(${item.itemKey}); return false;">+
                                                                    Add To Cart</a>
                                                                <div class="rating"> <%-- 별점 --%>
                                                                        <i class="fa fa-star-o"></i>
                                                                        <i class="fa fa-star-o"></i>
                                                                        <i class="fa fa-star-o"></i>
                                                                        <i class="fa fa-star-o"></i>
                                                                        <i class="fa fa-star-o"></i>
                                                                </div>
                                                                <%-- 가격 (shop.jsp와 동일하게 표시) --%>
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

            <!-- Categories Section Begin -->
            <section class="categories spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="categories__text">
                                <h2>강아지 옷장<br /><span>산책 필수템</span><br />간식&장난감</h2>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="categories__hot__deal">
                                <img src="<c:url value='/img/product-sale.png'/>" alt="핫딜상품">
                                <div class="hot__deal__sticker">
                                    <span>지금 특가</span>
                                    <h5>₩15,900</h5>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 offset-lg-1">
                            <div class="categories__deal__countdown">
                                <span>이번 주 펫딜 🐾</span>
                                <h2>강아지 이동식 포근백</h2>
                                <div class="categories__deal__countdown__timer" id="countdown">
                                    <div class="cd-item">
                                        <span>3</span>
                                        <p>일</p>
                                    </div>
                                    <div class="cd-item">
                                        <span>1</span>
                                        <p>시간</p>
                                    </div>
                                    <div class="cd-item">
                                        <span>50</span>
                                        <p>분</p>
                                    </div>
                                    <div class="cd-item">
                                        <span>18</span>
                                        <p>초</p>
                                    </div>
                                </div>
                                <a href="<c:url value='/shop'/>" class="primary-btn">지금 담으러 가기</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Categories Section End -->

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