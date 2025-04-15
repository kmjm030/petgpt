<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="펫GPT - 반려동물 용품 전문 쇼핑몰🐶🐱">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>펫GPT | ${!empty pageTitle ? pageTitle : '반려동물 용품 전문 쇼핑몰🐶🐱'}</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@300;400;600;700;800;900&display=swap"
          rel="stylesheet">

    <!-- Css Styles -->
    <link rel="stylesheet" href="<c:url value='/css/bootstrap.min.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/font-awesome.min.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/elegant-icons.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/magnific-popup.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/nice-select.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/owl.carousel.min.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/slicknav.min.css'/>" type="text/css">
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
</head>

<!-- Js Plugins -->
<script src="<c:url value='/js/jquery-3.3.1.min.js'/>"></script>

<body>
<!-- Page Preloder -->
<div id="preloder">
    <div class="loader"></div>
</div>

<!-- Offcanvas Menu Begin -->
<div class="offcanvas-menu-overlay"></div>
<div class="offcanvas-menu-wrapper">
    <div class="offcanvas__option">
        <div class="offcanvas__links">
            <a href="#">Sign in</a>
            <a href="#">FAQs</a>
        </div>
        <div class="offcanvas__top__hover">
            <span>Usd <i class="arrow_carrot-down"></i></span>
            <ul>
                <li>USD</li>
                <li>EUR</li>
                <li>USD</li>
            </ul>
        </div>
    </div>
    <div class="offcanvas__nav__option">
        <a href="#" class="search-switch"><img src="img/icon/search.png" alt=""></a>
        <a href="#"><img src="img/icon/heart.png" alt=""></a>
        <a href="#"><img src="img/icon/cart.png" alt=""> <span>0</span></a>
        <div class="price">$0.00</div>
    </div>
    <div id="mobile-menu-wrap"></div>
    <div class="offcanvas__text">
        <p>Free shipping, 30-day return or refund guarantee.</p>
    </div>
</div>
<!-- Offcanvas Menu End -->

<!-- Header Section Begin -->
<header class="header">
    <div class="header__top">
        <div class="container">
            <div class="row">
                <div class="col-lg-6 col-md-7">
                    <div class="header__top__left">
                        <p>반려동물 용품 전문 쇼핑몰🐶🐱</p>
                    </div>
                </div>
                <div class="col-lg-6 col-md-5">
                    <div class="header__top__right">
                        <c:choose>
                            <c:when test="${sessionScope.cust.custId == null}">
                                <div class="header__top__links">
                                    <a href="<c:url value="/login"/>">로그인</a>
                                    <a href="<c:url value="/signup"/>">회원가입</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="header__top__links">
                                    <a href="<c:url value="#"/>">${sessionScope.cust.custId}님, 안녕하세요!</a>
                                    <a href="<c:url value="/mypage?id=${sessionScope.cust.custId}"/>">마이페이지</a>
                                </div>

                            </c:otherwise>
                        </c:choose>
                        <div class="header__top__hover">
                            <span>🐶 강아지 <i class="arrow_carrot-down"></i></span>
                            <ul>
                                <li>🐶 강아지</li>
                                <li>🐱 고양이</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-3">
                <div class="header__logo">
                    <a href="/"><img id="main-logo" src="/img/logo.png" alt=""></a>
                </div>
            </div>
            <div class="col-lg-6 col-md-6">
                <nav class="header__menu mobile-menu">
                    <ul>
                        <li class="active"><a href="/">홈</a></li>
                        <li><a href="<c:url value="/shop"/>">카테고리</a></li>
                        <li><a href="<c:url value="/petboard"/>">펫자랑</a></li>
                        <li><a href="<c:url value="/qboard"/>">고객지원</a>
                            <ul class="dropdown">
                                <li><a href="<c:url value="/qnaboard/add?id=${sessionScope.cust.custId}"/>">1:1 문의하기</a></li>
                                <li><a href="<c:url value="/about"/>">about us</a></li>
                            </ul>
                        </li>

<%--                        <li><a href="#">Pages</a>--%>
<%--                            <ul class="dropdown">--%>
<%--                                <li><a href="/about">About Us</a></li>--%>
<%--                                <li><a href="/shop-details">Shop Details</a></li>--%>
<%--                                <li><a href="/shopping-cart">Shopping Cart</a></li>--%>
<%--                                <li><a href="/checkout">Check Out</a></li>--%>
<%--                                <li><a href="/blog-details">Blog Details</a></li>--%>
<%--                            </ul>--%>
<%--                        </li>--%>
<%--                        <li><a href="/blog">Blog</a></li>--%>
                    </ul>
                </nav>
            </div>
            <div class="col-lg-3 col-md-3">
                <div class="header__nav__option">
                    <a href="#" class="search-switch"><img src="img/icon/search.png" alt=""></a>
                    <a href="<c:url value='/mypage/like?id=${sessionScope.cust.custId}'/>"><img src="/img/icon/heart.png" alt=""></a>
                    <a href="<c:url value="/cart"/>"><img src="/img/icon/cart.png" alt=""> <span>0</span></a> <!-- 아이콘 링크도 수정 -->
                    <div class="price"><a href="<c:url value="/cart"/>">장바구니</a></div> <!-- 텍스트 링크 수정 -->
                </div>
            </div>
        </div>
        <div class="canvas__open"><i class="fa fa-bars"></i></div>
    </div>
</header>
<!-- Header Section End -->

<!-- ========= Center Content Start ========= -->
<main id="main-content">
    <c:choose>
        <c:when test="${!empty centerPage}">
            <jsp:include page="${centerPage}" />
        </c:when>
        <c:otherwise>
            <div style="text-align: center; padding: 50px; min-height: 400px;">
                <h2>페이지 내용을 준비 중입니다.</h2>
                <p>잠시만 기다려 주세요.</p>
                <a href="<c:url value='/'/>">홈으로 돌아가기</a>
            </div>
        </c:otherwise>
    </c:choose>
</main>
<!-- ========= Center Content End ========= -->

<!-- Footer Section Begin -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 col-sm-6">
                <div class="footer__about">
                    <div class="footer__logo">
                        <a href="#"><img src="img/footer-logo.png" alt=""></a>
                    </div>
                    <p>The customer is at the heart of our unique business model, which includes design.</p>
                    <a href="#"><img src="img/payment.png" alt=""></a>
                </div>
            </div>
            <div class="col-lg-2 offset-lg-1 col-md-3 col-sm-6">
                <div class="footer__widget">
                    <h6>Shopping</h6>
                    <ul>
                        <li><a href="#">Clothing Store</a></li>
                        <li><a href="#">Trending Shoes</a></li>
                        <li><a href="#">Accessories</a></li>
                        <li><a href="#">Sale</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-lg-2 col-md-3 col-sm-6">
                <div class="footer__widget">
                    <h6>Shopping</h6>
                    <ul>
                        <li><a href="#">Contact Us</a></li>
                        <li><a href="#">Payment Methods</a></li>
                        <li><a href="#">Delivary</a></li>
                        <li><a href="#">Return & Exchanges</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-lg-3 offset-lg-1 col-md-6 col-sm-6">
                <div class="footer__widget">
                    <h6>NewLetter</h6>
                    <div class="footer__newslatter">
                        <p>Be the first to know about new arrivals, look books, sales & promos!</p>
                        <form action="#">
                            <input type="text" placeholder="Your email">
                            <button type="submit"><span class="icon_mail_alt"></span></button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <div class="footer__copyright__text">
                    <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                    <p>Copyright ©
                        <script>
                            document.write(new Date().getFullYear());
                        </script>2020
                        All rights reserved | This template is made with <i class="fa fa-heart-o"
                                                                            aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                    </p>
                    <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- Footer Section End -->

<!-- Search Begin -->
<div class="search-model">
    <div class="h-100 d-flex align-items-center justify-content-center">
        <div class="search-close-switch">+</div>
        <form class="search-model-form">
            <input type="text" id="search-input" placeholder="Search here.....">
        </form>
    </div>
</div>
<!-- Search End -->
<script src="<c:url value='/js/bootstrap.min.js'/>"></script>
<script src="<c:url value='/js/jquery.nice-select.min.js'/>"></script>
<script src="<c:url value='/js/jquery.nicescroll.min.js'/>"></script>
<script src="<c:url value='/js/jquery.magnific-popup.min.js'/>"></script>
<script src="<c:url value='/js/jquery.countdown.min.js'/>"></script>
<script src="<c:url value='/js/jquery.slicknav.js'/>"></script>
<script src="<c:url value='/js/mixitup.min.js'/>"></script>
<script src="<c:url value='/js/owl.carousel.min.js'/>"></script>
<script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>
