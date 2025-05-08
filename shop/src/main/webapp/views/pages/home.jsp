<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                                            <span style="font-size: 40px; vertical-align: top; line-height: 1;">"
                                            </span>
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
                                                    <a href="#" class="add-cart add-to-cart-button"
                                                        data-item-key="${item.itemKey}">+ Add To Cart</a>
                                                    <div class="rating">
                                                        <c:set var="avgScore"
                                                            value="${item.avgScore != null ? item.avgScore : 0}" />
                                                        <c:set var="reviewCount"
                                                            value="${item.reviewCount != null ? item.reviewCount : 0}" />

                                                        <c:forEach var="i" begin="1" end="5">
                                                            <c:choose>
                                                                <c:when test="${i <= avgScore}">
                                                                    <i class="fa fa-star"></i>
                                                                </c:when>
                                                                <c:when test="${i <= avgScore + 0.5 && i > avgScore}">
                                                                    <i class="fa fa-star-half-o"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fa fa-star-o"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                        <span class="review-count">(${reviewCount})</span>
                                                    </div>
                                                    <div class="product__price">
                                                        <c:if
                                                            test="${item.itemSprice > 0 and item.itemSprice < item.itemPrice}">
                                                            <c:set var="discountRate"
                                                                value="${100 - (item.itemSprice * 100 / item.itemPrice)}" />
                                                            <div class="price-container">
                                                                <span class="original-price">
                                                                    <fmt:formatNumber value="${item.itemPrice}"
                                                                        pattern="#,###" />원
                                                                </span>
                                                                <div class="sale-info">
                                                                    <span class="sale-price">
                                                                        <fmt:formatNumber value="${item.itemSprice}"
                                                                            pattern="#,###" />원
                                                                    </span>
                                                                    <span class="discount-badge">
                                                                        <fmt:formatNumber value="${discountRate}"
                                                                            pattern="#" />%
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                        <c:if
                                                            test="${!(item.itemSprice > 0 and item.itemSprice < item.itemPrice)}">
                                                            <div class="price-container">
                                                                <span class="sale-price">
                                                                    <fmt:formatNumber value="${item.itemPrice}"
                                                                        pattern="#,###" />원
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                    </div>
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
                                <h2>
                                    오직 펫GPT에서만! <br><br>
                                    <span class="discount">1분 한정, 특별한 가격!</span> <br>
                                    지금 바로 행운을 잡으세요!
                                </h2>
                            </div>
                        </div>
                        <div class="col-lg-4 offset-lg-1">
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
                        <div class="col-lg-3 offset-lg-1">
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
                                <div class="instagram__pic__item set-bg insta-modal-trigger"
                                    data-setbg="<c:url value='/img/insta/post-image1.png'/>"></div>
                                <div class="instagram__pic__item set-bg insta-modal-trigger"
                                    data-setbg="<c:url value='/img/insta/post-image2.png'/>"></div>
                                <div class="instagram__pic__item set-bg insta-modal-trigger"
                                    data-setbg="<c:url value='/img/insta/post-image3.png'/>"></div>
                                <div class="instagram__pic__item set-bg insta-modal-trigger"
                                    data-setbg="<c:url value='/img/insta/post-image4.png'/>"></div>
                                <div class="instagram__pic__item set-bg insta-modal-trigger"
                                    data-setbg="<c:url value='/img/insta/post-image5.png'/>"></div>
                                <div class="instagram__pic__item set-bg insta-modal-trigger"
                                    data-setbg="<c:url value='/img/insta/post-image6.png'/>"></div>
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

            <!-- Instagram Modal -->
            <div id="instaModal" class="insta-modal">
                <div class="insta-modal-content">
                    <span class="insta-modal-close">&times;</span>
                    <iframe id="instaFrame" src="" width="100%" height="100%" frameborder="0"></iframe>
                </div>
            </div>

            <!-- Instagram Modal Style -->
            <style>
                /* 인스타그램 썸네일 호버 효과 */
                .instagram__pic {
                    position: relative;
                }

                .instagram__pic::after {
                    content: "";
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: rgba(0, 0, 0, 0);
                    pointer-events: none;
                    transition: background 0.3s ease;
                }

                .instagram__pic.hover::after {
                    background: rgba(0, 0, 0, 0.5);
                }

                .instagram__pic__item {
                    transition: transform 0.3s ease, filter 0.3s ease;
                    cursor: pointer;
                    z-index: 1;
                }

                .instagram__pic.hover .instagram__pic__item {
                    filter: blur(2px);
                }

                .instagram__pic.hover .instagram__pic__item.active {
                    transform: scale(1.05);
                    filter: blur(0);
                    z-index: 2;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
                }

                /* 모달 스타일 */
                .insta-modal {
                    display: none;
                    position: fixed;
                    z-index: 9999;
                    left: 0;
                    top: 0;
                    width: 100%;
                    height: 100%;
                    overflow: auto;
                    background-color: rgba(0, 0, 0, 0.9);
                }

                .insta-modal-content {
                    position: relative;
                    margin: 5% auto;
                    width: 90%;
                    max-width: 1000px;
                    height: 80%;
                    background: white;
                    border-radius: 8px;
                    overflow: hidden;
                }

                .insta-modal-close {
                    position: absolute;
                    top: 15px;
                    right: 20px;
                    color: white;
                    font-size: 28px;
                    font-weight: bold;
                    cursor: pointer;
                    z-index: 10001;
                }
            </style>

            <!-- Instagram Modal Script -->
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const instaItems = document.querySelectorAll('.insta-modal-trigger');
                    const instaContainer = document.querySelector('.instagram__pic');
                    const modal = document.getElementById('instaModal');
                    const modalFrame = document.getElementById('instaFrame');
                    const closeBtn = document.querySelector('.insta-modal-close');
                    
                    // 마우스 오버 효과
                    instaItems.forEach(item => {
                        item.addEventListener('mouseenter', function() {
                            instaContainer.classList.add('hover');
                            this.classList.add('active');
                        });
                        
                        item.addEventListener('mouseleave', function() {
                            instaContainer.classList.remove('hover');
                            this.classList.remove('active');
                        });
                        
                        // 클릭 이벤트
                        item.addEventListener('click', function() {
                            modalFrame.src = '<c:url value="/insta"/>';
                            modal.style.display = 'block';
                            document.body.style.overflow = 'hidden'; // 배경 스크롤 방지
                        });
                    });
                    
                    // 모달 닫기
                    closeBtn.addEventListener('click', function() {
                        modal.style.display = 'none';
                        modalFrame.src = '';
                        document.body.style.overflow = 'auto'; // 스크롤 복구
                    });
                    
                    // 모달 외부 클릭 시 닫기
                    window.addEventListener('click', function(event) {
                        if (event.target == modal) {
                            modal.style.display = 'none';
                            modalFrame.src = '';
                            document.body.style.overflow = 'auto';
                        }
                    });
                });
            </script>
            
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