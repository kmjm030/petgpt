<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
    let home = {
        init: function () {

        }
    }
    $(function () {
        home.init();
    });

    // 장바구니 추가 함수
    function addToCart(itemKey) {
        console.log("Adding item to cart:", itemKey);

        // 옵션 키는 현재 없으므로 null
        const requestData = {
            itemKey: itemKey,
            cartCnt: 1 
            // optionKey: null
        };

        $.ajax({
            url: '<c:url value="/cart/add/ajax"/>',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(requestData),
            success: function(response) {
                console.log("Add to cart response:", response);
                if (response.success) {
                    alert('상품이 장바구니에 추가되었습니다.');          
                } else {
                    alert(response.message || '장바구니 추가 중 오류가 발생했습니다.');

                    if (response.redirectUrl) {
                         window.location.href = response.redirectUrl;
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error("Add to cart Ajax error:", status, error, xhr.responseText);
                alert('장바구니 추가 중 서버 통신 오류가 발생했습니다.');
            }
        });
    }
</script>

<!-- Hero Section Begin -->
<section class="hero">
    <div class="hero__slider owl-carousel">
        <div class="hero__items set-bg" data-setbg="<c:url value='/img/hero/hero-1.png'/>">
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
        <div class="hero__items set-bg" data-setbg="<c:url value='/img/hero/hero-2.png'/>">
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
                    <li class="active" data-filter="*">Best Sellers</li>
                    <li data-filter=".new-arrivals">New Arrivals</li>
                    <li data-filter=".hot-sales">Hot Sales</li>
                </ul>
            </div>
        </div>
        <div class="row product__filter">

            <c:forEach items="${itemList}" var="item">
                <c:set var="isNew" value="true"/>
                <c:set var="filterClasses" value=""/>
                <c:if test="${isNew}">
                    <c:set var="filterClasses" value="${filterClasses} new-arrivals"/>
                </c:if>
                <c:if test="${item.itemSprice > 0 and item.itemSprice < item.itemPrice}">
                    <c:set var="filterClasses" value="${filterClasses} hot-sales"/>
                </c:if>
                <c:set var="filterClasses" value="${filterClasses} category-${item.categoryKey}"/>
                <div class="col-lg-3 col-md-6 col-sm-6 mix ${filterClass}">
                    <div class="product__item">
                        <div class="product__item__pic set-bg"
                             data-setbg="<c:url value='/img/product/${item.itemImg1}'/>">
                            <c:if test="${isNew}">
                                <span class="label">New</span>
                            </c:if>
                            <c:if test="${item.itemSprice > 0 and item.itemSprice < item.itemPrice}">
                                <span class="label sale">Sale</span>
                            </c:if>
                            <ul class="product__hover">
                                <li><a href="#"><img src="<c:url value='/img/icon/heart.png'/>" alt="">
                                    <span>Wish</span></a></li>
                                <li><a href="#"><img src="<c:url value='/img/icon/compare.png'/>" alt="">
                                    <span>Compare</span></a></li>
                                <li><a href="<c:url value='/shop-details?itemKey=${item.itemKey}'/>"><img
                                        src="<c:url value='/img/icon/search.png'/>" alt=""> <span>Search</span></a></li>
                            </ul>
                        </div>
                        <div class="product__item__text">
                            <h6>${item.itemName}</h6>
                            <a href="#" class="add-cart" onclick="addToCart(${item.itemKey}); return false;">+ Add To
                                Cart</a>
                            <div class="rating">
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                                <i class="fa fa-star-o"></i>
                            </div>
                            <c:choose>
                                <c:when test="${item.itemSprice > 0 and item.itemSprice < item.itemPrice}">
                                    <h5>
                                        <span style="text-decoration: line-through; color: #b2b2b2;">
                                            <fmt:formatNumber value="${item.itemPrice}" type="currency"
                                                              currencySymbol="₩" groupingUsed="true"
                                                              maxFractionDigits="0"/>
                                        </span>
                                        <fmt:formatNumber value="${item.itemSprice}" type="currency" currencySymbol="$"
                                                          groupingUsed="true" maxFractionDigits="0"/>
                                    </h5>
                                </c:when>
                                <c:otherwise>
                                    <h5><fmt:formatNumber value="${item.itemPrice}" type="currency" currencySymbol="$"
                                                          groupingUsed="true" maxFractionDigits="0"/></h5>
                                </c:otherwise>
                            </c:choose>
<%--                            <div class="product__color__select">--%>
<%--                                <c:if test="${item.optionKey > 0 and not empty item.optionName}">--%>
<%--                                    <span style="font-size: 12px; color: #888;">옵션: ${item.optionName}</span>--%>
<%--                                </c:if>--%>
<%--                            </div>--%>
                        </div>
                    </div>
                </div>
            </c:forEach>

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
                    <h2>강아지 옷장<br/><span>산책 필수템</span><br/>간식&장난감</h2>
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
                    <div class="blog__item__pic set-bg" data-setbg="<c:url value='/img/blog/blog-1.jpg'/>"></div>
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
