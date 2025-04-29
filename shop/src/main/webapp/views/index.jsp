<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
            <link rel="stylesheet" href="<c:url value='/css/dark-mode.css' />">


            <style>
                .mode-options {
                    /* display: none; 제거 -> opacity/visibility로 제어 */
                    position: absolute;
                    top: 100%;
                    /* 부모 요소 바로 아래 */
                    right: 0;
                    /* 오른쪽 정렬 유지 */
                    background-color: #ffffff;
                    /* 배경색 */
                    min-width: 120px;
                    /* 최소 너비 */
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    /* 그림자 */
                    z-index: 1000;
                    /* z-index */
                    border: 1px solid #eee;
                    /* 테두리 */
                    border-radius: 10px;
                    overflow: hidden;
                    /* 둥근 모서리 */
                    margin-top: 5px;
                    /* 부모 요소와의 간격 (필요시 조정) */
                    padding-left: 0;
                    /* ul 스타일 초기화 */
                    list-style: none;
                    /* ul 스타일 초기화 */
                    text-align: left;
                    /* 텍스트 왼쪽 정렬 */

                    /* 나타나는 효과 */
                    opacity: 0;
                    visibility: hidden;
                    transform: translateY(-10px);
                    transition: opacity 0.1s ease, visibility 0s 0.1s, transform 0.1s ease;
                }

                /* JS로 제어할 때 표시 상태 클래스 (선택 사항) */
                .mode-options.active {
                    opacity: 1;
                    visibility: visible;
                    transform: translateY(0);
                    transition: opacity 0.1s ease, visibility 0s 0s, transform 0.1s ease;
                }


                /* 모드 선택 드롭다운 항목 스타일 (고객지원 드롭다운 항목과 유사하게) */
                .mode-options div {
                    display: flex;
                    /* 아이콘 중앙 정렬을 위해 flex 사용 */
                    align-items: center;
                    justify-content: center;
                    padding: 10px;
                    /* 패딩 조정 (상하좌우 동일하게) */
                    color: #333;
                    cursor: pointer;
                    transition: background-color 0.1s ease;
                    /* transform 제거 */
                    /* white-space: nowrap; 제거 */
                    /* transform-origin: left center; 제거 */
                    font-size: 16px;
                    /* 아이콘 크기 조절 (필요시) */
                }

                .mode-options div:hover {
                    background-color: #f5f5f5;
                    /* transform: scale(1.05); 제거 */
                }

                #modeToggleBtn {
                    color: #ffffff;
                }

                #fab-container {
                    position: fixed;
                    bottom: 30px;
                    right: 30px;
                    z-index: 1000;
                    display: flex;
                    align-items: flex-end;
                }

                .fab-button {
                    background-color: #1a73e8;
                    color: white;
                    border: none;
                    border-radius: 50%;
                    width: 60px;
                    height: 60px;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: transform 0.1s ease-in-out, opacity 0.3s ease, visibility 0.3s ease;
                    margin-left: 10px;
                }

                .fab-button img {
                    height: 24px;
                    width: 24px;
                }

                #fab-open {
                    width: auto;
                    border-radius: 30px;
                    padding: 0 20px 0 15px;
                    background-color: white;
                    color: #333;
                    border: 1px solid #eee;
                }

                #fab-open img {
                    margin-right: 8px;
                }

                #fab-open span {
                    font-size: 14px;
                    font-weight: 600;
                }


                #fab-open:active {
                    transform: scale(0.95);
                }

                #fab-close {
                    background-color: white;
                    border: 1px solid #eee;
                }

                #fab-close img {
                    filter: invert(40%) sepia(0%) saturate(1%) hue-rotate(169deg) brightness(96%) contrast(90%);
                }


                #chat-modal {
                    position: absolute;
                    bottom: 80px;
                    right: 0;
                    width: 350px;
                    max-height: 500px;
                    background-color: white;
                    border-radius: 15px;
                    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
                    display: flex;
                    flex-direction: column;
                    overflow: hidden;
                    opacity: 0;
                    visibility: hidden;
                    transform: translateY(20px);
                    transition: opacity 0.3s ease, transform 0.3s ease, visibility 0s 0.3s;
                    z-index: 999;
                }

                #chat-modal.active {
                    opacity: 1;
                    visibility: visible;
                    transform: translateY(0);
                    transition: opacity 0.3s ease, transform 0.3s ease, visibility 0s 0s;
                }

                .chat-modal-header {
                    padding: 15px 20px;
                    border-bottom: 1px solid #eee;
                    display: flex;
                    align-items: center;
                }

                .modal-logo {
                    height: 30px;
                    margin-right: 10px;
                }

                .modal-title {
                    font-size: 16px;
                    font-weight: 700;
                    color: #333;
                }

                .chat-modal-body {
                    padding: 20px;
                    flex-grow: 1;
                    overflow-y: auto;
                    font-size: 14px;
                    line-height: 1.6;
                    color: #555;
                }

                .chat-modal-body p {
                    margin-bottom: 0;
                }

                .chat-modal-footer {
                    padding: 15px 20px;
                    border-top: 1px solid #eee;
                    display: flex;
                    justify-content: space-around;
                }

                .chat-modal-footer button {
                    background: none;
                    border: none;
                    padding: 8px 15px;
                    cursor: pointer;
                    font-size: 14px;
                    color: #555;
                    font-weight: 600;
                    border-radius: 5px;
                    transition: background-color 0.2s ease;
                }

                .chat-modal-footer button:hover {
                    background-color: #f5f5f5;
                }

                #chat-messages {
                    height: 300px;
                    overflow-y: auto;
                    border: 1px solid #eee;
                    margin-bottom: 10px;
                    padding: 10px;
                    background-color: #f9f9f9;
                    border-radius: 5px;
                }

                #chat-messages p.initial-message {
                    color: #888;
                    text-align: center;
                    margin-top: 10px;
                }

                .chat-input-area {
                    display: flex;
                }

                #chat-input {
                    flex-grow: 1;
                    padding: 8px;
                    border: 1px solid #ccc;
                    border-radius: 5px 0 0 5px;
                    border-right: none;
                }

                #send-button {
                    padding: 8px 15px;
                    border: 1px solid #ccc;
                    background-color: #eee;
                    border-radius: 0 5px 5px 0;
                    cursor: pointer;
                    transition: background-color 0.2s ease;
                }

                #send-button:hover {
                    background-color: #ddd;
                }



                .fab-hidden {
                    opacity: 0;
                    visibility: hidden;
                    transform: scale(0.5);
                    transition: opacity 0.2s ease, transform 0.2s ease, visibility 0s 0.2s;
                }

                .fab-visible {
                    opacity: 1;
                    visibility: visible;
                    transform: scale(1);
                    transition: opacity 0.2s ease 0.1s, transform 0.2s ease 0.1s, visibility 0s 0.1s;
                }

                .header__search {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    height: 100%;
                    margin-left: -30px;
                }

                .header__search form {
                    display: flex;
                    width: 100%;
                    max-width: 400px;
                    position: relative;
                    border: 1px solid #ddd;
                    border-radius: 25px;
                    overflow: hidden;
                    background-color: #f9f9f9;
                    transition: border-color 0.3s ease;
                }

                .header__search form:hover {
                    border-color: #000000;
                }

                .search-input {
                    flex-grow: 1;
                    border: none;
                    padding: 10px 15px;
                    font-size: 14px;
                    border-radius: 25px 0 0 25px;
                    outline: none;
                    background-color: transparent;
                }

                .search-input::placeholder {
                    color: #aaa;
                }

                .search-btn {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 0 20px;
                    font-size: 14px;
                    font-weight: bold;
                    color: white;
                    background-color: #2b2b2b;
                    border: none;
                    border-radius: 0 25px 25px 0;
                    cursor: pointer;
                    transition: background-color 0.3s ease;
                }

                .search-btn i {
                    margin-right: 5px;
                }

                .search-btn:hover {
                    background-color: #000000;
                }

                .header__top__right {
                    display: flex;
                    align-items: center;
                    justify-content: flex-end;
                    /* padding-right: 5px; */
                    flex-wrap: nowrap;
                    /* 자식 요소 줄바꿈 방지 */
                }

                .header__top__links {
                    /* 링크들을 담는 컨테이너 */
                    display: flex;
                    /* 내부 링크들도 flex로 정렬 (선택 사항) */
                    align-items: center;
                    /* flex-wrap: nowrap; */
                    /* 링크 자체는 a 태그에서 nowrap 처리 */
                }

                .header__top__links a {
                    font-size: 14px;
                    color: #ffffff;
                    margin-left: 15px;
                    display: inline-block;
                    white-space: nowrap;
                    transition: transform 0.1s ease;
                    transform-origin: center center;
                }

                .header__top__links a:hover {
                    transform: scale(1.05);

                }

                .header__top__links a:first-child {
                    margin-left: 0;
                }

                #mode-select-wrapper {
                    position: relative;
                    margin-left: 15px;
                    white-space: nowrap;
                }

                .header__menu {
                    text-align: right;
                }

                .header__menu ul li {
                    display: inline-block;
                    margin-left: 10px;
                    float: none;
                    position: relative;
                }

                .header__menu ul li:first-child {
                    margin-left: 0;
                }

                .header__menu ul .dropdown {
                    padding-left: 0;
                    list-style: none;
                    text-align: left;
                    position: absolute;
                    top: 100%;
                    left: 0;
                    background-color: #ffffff;
                    min-width: 160px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    z-index: 1000;
                    border-radius: 7px;
                    margin-top: 25px;
                    opacity: 0;
                    visibility: hidden;
                    transform: translateY(-10px);
                    transition: opacity 0.1s ease, visibility 0s 0.1s, transform 0.1s ease;
                }

                .header__menu ul li:hover>.dropdown {
                    opacity: 1;
                    visibility: visible;
                    transform: translateY(0);
                    transition: opacity 0.1s ease, visibility 0s 0s, transform 0.1s ease;
                }

                .header__menu ul .dropdown li {
                    display: block;
                    margin-left: 0;
                    width: 100%;
                }

                .header__menu ul .dropdown li a {
                    display: block;
                    padding: 10px 15px;
                    white-space: nowrap;
                    color: #333;
                    transition: background-color 0.1s ease, transform 0.1s ease;
                    transform-origin: left center;
                }

                .header__menu ul .dropdown li a:hover {
                    transform: scale(1.05);
                }
            </style>
        </head>

        <!-- Js Plugins -->
        <script src="<c:url value='/js/jquery-3.3.1.min.js'/>"></script>

        <!-- Web Socket Lib -->
        <script src="<c:url value=" /webjars/sockjs-client/sockjs.min.js" /> "></script>
        <script src="<c:url value=" /webjars/stomp-websocket/stomp.min.js" /> "></script>

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
                    <a href="#" class="search-switch"><img src="<c:url value='/img/icon/search.png'/>" alt=""></a>
                    <a href="#"><img src="<c:url value='/img/icon/heart.png'/>" alt=""></a>
                    <a href="#"><img src="<c:url value='/img/icon/cart.png'/>" alt=""> <span>0</span></a>
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
                                                <a href="<c:url value=" /login" />">로그인</a>
                                                <a href="<c:url value=" /signup" />">회원가입</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="header__top__links">
                                                <a href="<c:url value=" #" />">${sessionScope.cust.custId}님, 안녕하세요!</a>
                                                <a href="<c:url value="
                                                    /mypage?id=${sessionScope.cust.custId}" />">마이페이지</a>
                                                <a
                                                    href="<c:url value='/mypage/like?id=${sessionScope.cust.custId}'/>">찜</a>
                                                <a href="<c:url value=" /cart" />">장바구니</a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div id="mode-select-wrapper" style="position: relative; margin-left: 20px;">
                                        <span id="modeToggleBtn"
                                            style="cursor: pointer; font-size: 14px; color: #ffffff; white-space: nowrap;">모드
                                            선택 ▾</span>
                                        <div id="modeOptions" class="mode-options">
                                            <div data-mode="light" title="라이트 모드"><i class="fa fa-sun-o"></i></div>
                                            <div data-mode="dark" title="다크 모드"><i class="fa fa-moon-o"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container">
                    <div class="row">
                        <div class="col-lg-2 col-md-2">
                            <div class="header__logo">
                                <a href="/"><img id="main-logo" src=<c:url value="/img/logo/logo.png" /> alt=""></a>
                            </div>
                        </div>

                        <div class="col-lg-4 col-md-4">
                            <div class="header__search">
                                <form action="<c:url value='/shop/search'/>" method="get">
                                    <input type="text" name="keyword" placeholder="검색어를 입력하세요..."
                                        class="form-control search-input">
                                    <button type="submit" class="search-btn">
                                        <i class="fa fa-search"></i>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <div class="col-lg-6 col-md-6">
                            <nav class="header__menu mobile-menu">
                                <ul>
                                    <li><a href="/">홈</a></li>
                                    <li><a href="<c:url value=" /shop" />">카테고리</a></li>
                                    <li><a href="<c:url value=" /community" />">커뮤니티</a></li>
                                    <li><a href="#">고객지원</a>
                                        <ul class="dropdown">
                                            <li><a href="<c:url value="
                                                    /qnaboard/add?id=${sessionScope.cust.custId}" />">1:1 문의하기</a></li>
                                            <li><a href="<c:url value='/ai-analysis'/>">AI 품종 분석</a></li>
                                            <li><a href="<c:url value=" /about" />">about us</a></li>
                                        </ul>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                        <%-- <div class="col-lg-3 col-md-3">--%>
                            <%-- <div class="header__nav__option">--%>
                                <%-- --%>
                                    <%-- </div>--%>
                                        <%-- </div>--%>
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
                                    <a href="#"><img src="<c:url value='/img/logo/logo-dark.png'/>" alt=""></a>
                                </div>
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
                                        aria-hidden="true"></i> by <a href="https://colorlib.com"
                                        target="_blank">Colorlib</a>
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

            <!-- Floating Action Button & Chat Modal -->
            <div id="fab-container">
                <!-- Initial FAB (Chat Bubble) -->
                <button type="button" id="fab-open" class="fab-button">
                    <img src="<c:url value='/img/chat.png'/>" alt="문의/상담">
                    <span>문의/상담은 여기로!</span>
                </button>
                <!-- Close FAB (X Mark) - Initially Hidden -->
                <button type="button" id="fab-close" class="fab-button" style="display: none;">
                    <img src="<c:url value='/img/close.png'/>" alt="닫기">
                </button>

                <!-- Chat Modal - Initially Hidden -->
                <div id="chat-modal" style="display: none;">
                    <div class="chat-modal-header">
                        <img src="<c:url value='/img/logo/logo2.png'/>" alt="PetGPT Logo" class="modal-logo">
                        <span class="modal-title">PetGPT 실시간 상담</span>
                    </div>
                    <div class="chat-modal-body">

                        <div id="chat-messages">
                            <p class="initial-message">상담원 연결 중...</p>
                        </div>
                        <div class="chat-input-area">
                            <input type="text" id="chat-input" placeholder="메시지를 입력하세요...">
                            <button type="button" id="send-button">전송</button>
                        </div>
                    </div>
                    <div class="chat-modal-footer">
                        <button type="button" id="modal-chatbot-btn">챗봇</button>
                        <button type="button" id="modal-livechat-btn">실시간 상담</button>
                    </div>
                </div>
            </div>
            <!-- End Floating Action Button & Chat Modal -->

            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
            <script src="<c:url value='/js/bootstrap.min.js'/>"></script>
            <script src="<c:url value='/js/jquery.nice-select.min.js'/>"></script>
            <script src="<c:url value='/js/jquery.nicescroll.min.js'/>"></script>
            <script src="<c:url value='/js/jquery.magnific-popup.min.js'/>"></script>
            <script src="<c:url value='/js/jquery.countdown.min.js'/>"></script>
            <script src="<c:url value='/js/jquery.slicknav.js'/>"></script>
            <script src="<c:url value='/js/owl.carousel.min.js'/>"></script>
            <script src="<c:url value='/js/main.js'/>"></script>

            <script>
                $(document).ready(function () {
                    const fabOpenBtn = $('#fab-open');
                    const fabCloseBtn = $('#fab-close');
                    const chatModal = $('#chat-modal');
                    const chatMessages = $('#chat-messages');
                    const chatInput = $('#chat-input');
                    const sendButton = $('#send-button');

                    let stompClient = null;
                    let subscription = null;
                    let username = "User_${sessionScope.cust != null ? sessionScope.cust.custId : 'Guest'}";

                    function connectChat() {

                        if (stompClient && stompClient.connected) {
                            console.log('Already connected.');
                            return;
                        }

                        const socket = new SockJS('http://127.0.0.1:8088/ws');
                        stompClient = Stomp.over(socket);

                        stompClient.connect({}, function (frame) {
                            console.log('Connected: ' + frame);
                            chatMessages.html('<p style="color: green; text-align: center;">연결되었습니다.</p>');

                            subscription = stompClient.subscribe('/livechat/public', function (messageOutput) {
                                showMessageOutput(JSON.parse(messageOutput.body));
                            });

                            stompClient.subscribe('/send/to/' + username, function (messageOutput) {
                                const message = JSON.parse(messageOutput.body);
                                message.sendid = "[Admin] " + message.sendid;
                                showMessageOutput(message);
                            });

                            // 서버에 사용자 입장 메시지 전송 -> 아직 구현안함
                            // stompClient.send("/app/livechat.addUser", {}, JSON.stringify({sender: username, type: 'JOIN'}));

                        }, function (error) {
                            console.error('STOMP connection error: ' + error);
                            chatMessages.html('<p style="color: red; text-align: center;">연결에 실패했습니다. 새로고침 후 다시 시도해주세요.</p>');
                        });
                    }

                    function disconnectChat() {
                        if (stompClient !== null && stompClient.connected) {
                            // 서버에 사용자 퇴장 메시지 전송 -> 아직 구현안함 
                            // stompClient.send("/app/livechat.sendMessage", {}, JSON.stringify({sender: username, type: 'LEAVE', content:''}));

                            if (subscription) {
                                subscription.unsubscribe();
                                subscription = null;
                            }
                            stompClient.disconnect(function () {
                                console.log("Disconnected");
                                chatMessages.html('<p style="color: #888; text-align: center;">연결이 종료되었습니다.</p>');
                            });
                            stompClient = null;
                        }
                    }

                    function sendMessage() {
                        const messageContent = chatInput.val().trim();
                        if (messageContent && stompClient && stompClient.connected) {
                            const chatMessage = {
                                sendid: username,
                                content1: messageContent
                            };

                            stompClient.send("/app/livechat.sendMessage", {}, JSON.stringify(chatMessage));
                            chatInput.val('');
                        } else if (!stompClient || !stompClient.connected) {
                            alert("서버에 연결되지 않았습니다.");
                        }
                    }

                    function showMessageOutput(messageOutput) {
                        const messageElement = $('<p></p>');

                        if (messageOutput.sendid === username) {
                            messageElement.css({ 'text-align': 'right', 'margin-bottom': '5px' });
                            messageElement.html('<strong>나:</strong> ' + messageOutput.content1);
                        } else {
                            messageElement.css({ 'text-align': 'left', 'margin-bottom': '5px' });
                            messageElement.html('<strong>' + (messageOutput.sendid || '상담원') + ':</strong> ' + messageOutput.content1);
                        }

                        if (chatMessages.find('p.initial-message').length > 0 || chatMessages.find('p:contains("연결되었습니다.")').length > 0) {
                            chatMessages.empty();
                        }
                        chatMessages.append(messageElement);

                        chatMessages.scrollTop(chatMessages[0].scrollHeight);
                    }

                    fabOpenBtn.on('click', function () {
                        fabOpenBtn.addClass('fab-hidden').removeClass('fab-visible');
                        setTimeout(function () {
                            fabCloseBtn.show().addClass('fab-visible').removeClass('fab-hidden');
                        }, 200);

                        chatModal.show().addClass('active');
                        connectChat();
                    });

                    fabCloseBtn.on('click', function () {
                        chatModal.removeClass('active');
                        fabCloseBtn.addClass('fab-hidden').removeClass('fab-visible');
                        disconnectChat();

                        setTimeout(function () {
                            chatModal.hide();
                            fabCloseBtn.hide();
                            fabOpenBtn.addClass('fab-visible').removeClass('fab-hidden');
                        }, 300);
                    });

                    sendButton.on('click', function () {
                        sendMessage();
                    });

                    chatInput.on('keypress', function (e) {
                        if (e.key === 'Enter' || e.keyCode === 13) {
                            sendMessage();
                        }
                    });

                    $('#modal-chatbot-btn').on('click', function () {
                        alert('챗봇 기능은 준비 중입니다.');
                    });

                    $('#modal-livechat-btn').on('click', function () {

                    });

                    fabOpenBtn.addClass('fab-visible').removeClass('fab-hidden');

                });
            </script>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const toggleBtn = document.getElementById("modeToggleBtn");
                    const modeOptions = document.getElementById("modeOptions");
                    const mainLogo = document.getElementById("main-logo"); // 로고 요소 가져오기
                    const lightLogoSrc = '<c:url value="/img/logo/logo.png"/>'; // 라이트 모드 로고 경로
                    const darkLogoSrc = '<c:url value="/img/logo/logo-dark.png"/>'; // 다크 모드 로고 경로 (준비 필요)

                    function applyThemeBackgrounds() {
                        const isDarkMode = document.body.classList.contains('dark-mode');
                        // console.log("Applying theme backgrounds. Dark mode:", isDarkMode); // 디버깅 필요시 주석 해제

                        // jQuery가 로드되었는지 확인하고 실행
                        if (typeof $ === 'function') {
                            $('.set-bg').each(function () {
                                const $this = $(this);
                                const lightBg = $this.data('setbg');
                                const darkBg = $this.data('setbg-dark'); // 다크 모드용 경로 읽기
                                let targetBg = lightBg; // 기본값: 라이트 모드

                                // 다크 모드이고, 다크 모드 경로가 있으면 해당 경로 사용
                                if (isDarkMode && darkBg) {
                                    targetBg = darkBg;
                                }

                                // 적용할 경로가 있으면 배경 설정
                                if (targetBg) {
                                    const currentBg = $this.css('background-image');
                                    const targetUrl = 'url("' + targetBg + '")';

                                    // 현재 배경과 다를 경우에만 업데이트 (깜빡임 방지)
                                    if (currentBg !== targetUrl) {
                                        $this.css('background-image', 'url(' + targetBg + ')');
                                    }
                                }
                            });
                        } else {
                            console.warn("jQuery not loaded when applyThemeBackgrounds was called.");
                        }
                    }

                    // 초기 로드 시 테마 적용 및 배경 업데이트
                    const savedMode = localStorage.getItem("darkMode");
                    if (savedMode === "true") {
                        document.body.classList.add("dark-mode");
                        if (mainLogo && darkLogoSrc) mainLogo.src = darkLogoSrc; // 다크 로고 적용
                        applyThemeBackgrounds(); // 초기 다크 모드 배경 적용
                    } else {
                        // 라이트 모드가 기본값이지만 명시적으로 클래스 제거 및 로고/배경 설정
                        document.body.classList.remove("dark-mode");
                        if (mainLogo && lightLogoSrc) mainLogo.src = lightLogoSrc; // 라이트 로고 적용
                        applyThemeBackgrounds(); // 초기 라이트 모드 배경 적용
                    }

                    // FAB 버튼 클릭 시 드롭다운 토글
                    toggleBtn.addEventListener("click", function (event) {
                        event.stopPropagation(); // 이벤트 전파 중단
                        modeOptions.classList.toggle("active");
                    });

                    // 드롭다운 옵션(라이트/다크) 클릭 시 모드 변경
                    document.querySelectorAll("#modeOptions div").forEach(option => {
                        option.addEventListener("click", () => {
                            const selectedMode = option.getAttribute("data-mode"); // 'light' 또는 'dark'

                            if (selectedMode === "dark") {
                                document.body.classList.add("dark-mode");
                                localStorage.setItem("darkMode", "true");
                                if (mainLogo && darkLogoSrc) mainLogo.src = darkLogoSrc; // 다크 로고 적용
                                applyThemeBackgrounds(); // 다크 모드 배경 적용
                            } else { // selectedMode === "light"
                                document.body.classList.remove("dark-mode");
                                localStorage.setItem("darkMode", "false");
                                if (mainLogo && lightLogoSrc) mainLogo.src = lightLogoSrc; // 라이트 로고 적용
                                applyThemeBackgrounds(); // 라이트 모드 배경 적용
                            }
                            // 옵션 선택 후 드롭다운 닫기
                            modeOptions.classList.remove("active");
                        });
                    });

                    // 페이지의 다른 영역 클릭 시 드롭다운 닫기
                    document.addEventListener("click", function (e) {
                        // 클릭된 요소가 드롭다운 메뉴나 토글 버튼이 아니면 닫기
                        if (!modeOptions.contains(e.target) && !toggleBtn.contains(e.target)) {
                            modeOptions.classList.remove("active");
                        }
                    });
                });
            </script>

        </body>

        </html>