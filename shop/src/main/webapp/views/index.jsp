<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <link rel="stylesheet" href="<c:url value='/css/header-custom.css'/>" type="text/css">
        <link rel="stylesheet" href="<c:url value='/css/chat.css'/>" type="text/css">
        <link rel="stylesheet" href="<c:url value='/css/home.css'/>" type="text/css">
        <link rel="stylesheet" href="<c:url value='/css/shop_details.css'/>" type="text/css">
        <link rel="stylesheet" href="<c:url value='/css/shop.css'/>" type="text/css">
        <link rel="stylesheet" href="<c:url value='/css/search-form.css'/>" type="text/css">

        <style>
          .theme-toggle-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            position: relative;
            border-radius: 0;
            font-size: 0.875rem;
            font-weight: 500;
            outline-offset: 0;
            transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, opacity 0.15s ease-in-out;
            cursor: pointer;
            user-select: none;
            border: none;
            background-color: #000000;
            width: 36px;
            height: 36px;
            padding-top: 2px;
            box-shadow: none;
          }

          .theme-toggle-button:not(:disabled):hover {
            background-color: #000000;
            color: #ffffff;
          }

          .theme-toggle-button .icon {
            width: 16px;
            height: 16px;
            stroke-width: 2;
            flex-shrink: 0;
            transition: transform 0.2s ease-in-out, opacity 0.2s ease-in-out;
            color: #ffffff;
            border: none;
          }

          .theme-toggle-button .icon-moon {
            transform: scale(0);
            opacity: 0;
          }

          .theme-toggle-button .icon-sun {
            position: absolute;
            transform: scale(1);
            opacity: 1;
          }

          .theme-toggle-button[data-state="on"] .icon-moon {
            transform: scale(1);
            opacity: 1;
            color: #ffffff;
          }

          .theme-toggle-button[data-state="on"] .icon-sun {
            transform: scale(0);
            opacity: 0;
          }

          body[data-theme="dark"] {
            --color-background: #000000;
            --color-text: #ffffff;
          }

          .theme-toggle-button:focus-visible {
            outline: none;
            box-shadow: none;
          }

          .theme-toggle-button[data-state="on"] {
            background-color: #000000;
          }

          .back-to-top {
            position: fixed;
            bottom: 120px;
            /* 챗봇 버튼 위에 위치하도록 조정 */
            right: 30px;
            width: 50px;
            height: 50px;
            background-color: #000;
            color: #fff;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: 0.3s all ease;
            z-index: 9999;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
          }

          .back-to-top.active {
            opacity: 1;
            visibility: visible;
          }

          .back-to-top.chat-open {
            bottom: 650px;
          }

          body[data-theme="dark"] .back-to-top {
            background-color: #333;
            color: #fff;
          }

          body[data-theme="dark"] .back-to-top:hover {
            background-color: #444;
          }

          .wishlist-preview {
            position: fixed;
            bottom: 200px;
            right: 50px;
            width: 150px;
            padding: 16px;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            z-index: 999;
            text-align: center;
            animation: float 1.5s ease-in-out infinite;
            transition: transform 1s ease, box-shadow 0.3s ease;
          }

          .wishlist-preview img {
            max-width: 100%;
            border-radius: 12px;
            margin: 10px 0;
          }

          .wishlist-preview:hover {
            transform: scale(1.05);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            animation: none;
            /* hover하면 둥둥 애니메이션 멈춤 */
          }

          @keyframes float {
            0% {
              transform: translateY(0px);
            }

            50% {
              transform: translateY(-8px);
            }

            100% {
              transform: translateY(0px);
            }
          }

          @font-face {
            font-family: 'Paperlogy-8ExtraBold';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/2408-3@1.0/Paperlogy-8ExtraBold.woff2') format('woff2');
            font-weight: 800;
            font-style: normal;
          }
        </style>

      </head>

      <body data-context-path="${pageContext.request.contextPath}"
        data-is-logged-in="${sessionScope.cust != null ? 'true' : 'false'}"
        data-cust-id="${sessionScope.cust != null ? sessionScope.cust.custId : ''}"
        data-cart-add-url="<c:url value='/cart/add/ajax'/>" data-login-url="<c:url value='/signin'/>">
        <!-- Page Preloder -->
        <div id="preloder">
          <div class="loader"></div>
        </div>

        <!-- Offcanvas Menu Begin -->
        <div class="offcanvas-menu-overlay"></div>
        <div class="offcanvas-menu-wrapper">
          <div class="offcanvas__option">
            <div class="offcanvas__links">
              <a href="<c:url value='/signin'/>">로그인</a>
              <a href="<c:url value='/signup'/>">회원가입</a>
            </div>
            <div class="offcanvas__top__hover">
              <span>모드 선택 <i class="arrow_carrot-down"></i></span>
              <ul>
                <li data-mode="light"><i class="fa fa-sun-o"></i> Light</li>
                <li data-mode="dark"><i class="fa fa-moon-o"></i> Dark</li>
              </ul>
            </div>
          </div>
          <div class="offcanvas__nav__option">
            <a href="#" class="search-switch"><img src="<c:url value='/img/icon/search.png'/>" alt=""></a>
            <a href="#"><img src="<c:url value='/img/icon/heart.png'/>" alt=""></a>
            <a href="#"><img src="<c:url value='/img/icon/cart.png'/>" alt=""> <span>0</span></a>
            <div class="price">0원</div>
          </div>
          <div id="mobile-menu-wrap"></div>

          <div class="offcanvas__search">
            <form action="<c:url value='/shop/search'/>" method="get">
              <input type="text" name="keyword" placeholder="검색어를 입력하세요..." class="search-input">
              <button type="submit" class="search-btn">
                <i class="fa fa-search"></i> 검색
              </button>
            </form>
          </div>

          <div class="offcanvas__text">
            <p>반려동물 용품 전문 쇼핑몰🐶🐱</p>
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
                    <p id="winfo"></p>
                  </div>
                </div>
                <div class="col-lg-6 col-md-5">
                  <div class="header__top__right">
                    <c:choose>
                      <c:when test="${sessionScope.cust.custId == null}">
                        <div class="header__top__links">
                          <a href="<c:url value='/signin'/>">로그인</a>
                          <a href="<c:url value='/signup'/>">회원가입</a>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="header__top__links">
                          <a href="<c:url value='#'/>">${sessionScope.cust.custId}님, 안녕하세요!</a>
                          <a href="<c:url value='/mypage?id=${sessionScope.cust.custId}'/>">마이페이지</a>
                          <a href="<c:url value='/mypage/like?id=${sessionScope.cust.custId}'/>">찜</a>
                          <a href="<c:url value='/cart'/>">장바구니</a>
                        </div>
                      </c:otherwise>
                    </c:choose>
                    <div id="mode-select-wrapper" style="position: relative; margin-left: 20px;">
                      <button type="button" id="themeToggleButton" class="theme-toggle-button" aria-pressed="false"
                        aria-label="Switch to dark mode">
                        <!-- Moon Icon (Lucide Moon) -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                          class="icon icon-moon" aria-hidden="true">
                          <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"></path>
                        </svg>
                        <!-- Sun Icon (Lucide Sun) -->
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                          class="icon icon-sun" aria-hidden="true">
                          <circle cx="12" cy="12" r="4"></circle>
                          <path d="M12 2v2"></path>
                          <path d="M12 20v2"></path>
                          <path d="m4.93 4.93 1.41 1.41"></path>
                          <path d="m17.66 17.66 1.41 1.41"></path>
                          <path d="M2 12h2"></path>
                          <path d="M20 12h2"></path>
                          <path d="m6.34 17.66-1.41 1.41"></path>
                          <path d="m19.07 4.93-1.41 1.41"></path>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="container">
            <div class="row align-items-center">
              <div class="col-lg-2 col-md-3 col-sm-4">
                <div class="header__logo">
                  <a href="/">
                    <img id="main-logo" src="<c:url value='/img/logo/logo.png'/>"
                      data-light-src="<c:url value='/img/logo/logo.png'/>"
                      data-dark-src="<c:url value='/img/logo/logo-dark.png'/>" alt="PetGPT Logo">
                  </a>
                </div>
              </div>

              <div class="col-lg-4 col-md-8 col-sm-8">
                <div class="header__search">
                  <form id="animatedSearchForm" class="search-form" action="<c:url value='/shop/search'/>" method="get">
                    <div class="input-wrapper">
                      <input type="text" id="searchInput" name="keyword" class="search-input" autocomplete="off" />
                      <div id="placeholderTextContainer" class="placeholder-text-container">
                        <p id="currentPlaceholder" class="placeholder-text"></p>
                      </div>
                    </div>
                    <button type="submit" id="submitSearchButton" class="submit-button" disabled>
                      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                        stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                        class="submit-icon" aria-hidden="true">
                        <path stroke="none" d="M0 0h24v24H0z" fill="none" />
                        <path id="arrowLine" d="M5 12l14 0" />
                        <path d="M13 18l6 -6" />
                        <path d="M13 6l6 6" />
                      </svg>
                    </button>
                  </form>
                </div>
              </div>

              <div class="col-lg-6 col-md-12 col-sm-12">
                <nav class="header__menu mobile-menu">
                  <ul>
                    <li><a href="/">홈</a></li>
                    <li><a href="<c:url value='/shop'/>">카테고리</a></li>
                    <li><a href="<c:url value='/community'/>">커뮤니티</a></li>
                    <li><a href="#">고객지원</a>
                      <ul class="dropdown">
                        <li><a href="<c:url value='/qnaboard/add?id=${sessionScope.cust.custId}'/>">1:1 문의하기</a></li>
                        <li><a href="<c:url value='/ai-analysis'/>">AI 품종 분석</a></li>
                        <li><a href="<c:url value='/about'/>">about us</a></li>
                        <li><a href="<c:url value='/ai'/>">PetGPT</a></li>
                      </ul>
                    </li>
                  </ul>
                </nav>
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
                    <a href="#"><img src="<c:url value='/img/logo/logo-dark.png'/>" alt=""></a>
                  </div>
                </div>
              </div>
              <div class="col-lg-4 offset-lg-1 col-md-6 col-sm-6" style="color: #b7b7b7;">
                <div class="footer__widget">
                  <h6>Information</h6>
                  <ul>
                    <li><strong>상호명</strong>⠀⠀(주)펫지피티</li>
                    <li><strong>사업장 주소</strong>⠀⠀서울특별시 강남구 테헤란로 213, 501</li>
                    <li><strong>대표전화</strong>⠀⠀00-987-6543</li>
                    <li><strong>사업자 등록번호</strong>⠀⠀123-45-67890</li>
                  </ul>
                  <div class="footer__newslatter">
                    <p>⠀⠀</p>
                    <p> ▼ 전국에 있는 펫지피티 매장을 찾아보세요!</p>
                    <form action="${pageContext.request.contextPath}/about" method="get">
                      <input type="text" name="location" placeholder="지역을 입력하세요">
                      <button type="submit"><span class="icon_search"></span></button>
                    </form>
                  </div>
                </div>
              </div>
              <div class="col-lg-3 offset-lg-1 col-md-3 col-sm-6">
                <div class="footer__widget">
                  <h6>Customer Service</h6>
                  <ul>
                    <li><a href="#"><strong>상담/주문전화</strong>⠀⠀02-123-4567</a></li>
                    <li><a href="#"><strong>상담/주문 이메일</strong>⠀⠀contact@petgpt.com</a></li>
                    <li><a href="#"><strong>CS운영시간</strong>
                        <ul>
                          <li>⠀⠀평일 10시 ~ 17시</li>
                          <li>⠀⠀(점심시간 12 ~ 13시)</li>
                        </ul>
                      </a></li>
                    <li>⠀⠀</li>
                    <li><a href="#"><strong>주말 및 공휴일</strong>은 <strong>휴무</strong>입니다.</a></li>
                  </ul>
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
                    All rights reserved | This template is made with <i class="fa fa-heart-o" aria-hidden="true"></i> by
                    <a href="https://colorlib.com" target="_blank">Colorlib</a>
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

        <!-- 상품 띄우기 -->
        <c:if test="${not empty hotDealItem}">
          <div class="wishlist-preview">
            <p style="font-family:'Paperlogy-8ExtraBold'">${sessionScope.cust.custNick}님, <br>찜하셨던 상품이 <span
                style="color:red">🔥핫딜🔥</span>중!</p>
            <a href="<c:url value=" /shop/details?itemKey=${hotDealItem.itemKey}" />"><img
              src="<c:url value='/img/product/${hotDealItem.itemImg1}'/>" alt="찜한 상품" /></a>
            <p style="font-family:'Paperlogy-8ExtraBold'">${hotDealItem.itemName}</p>
            <div class="price-container" style="margin-top:0px;">
              <span class="original-price" style="text-decoration: line-through;">
                <fmt:formatNumber value="${hotDealItem.itemPrice}" pattern="#,###" />원
              </span><span class="discount-badge" style="background-color:red; color:white;">50%</span>
              <div class="sale-info">
                <span class="sale-price"><strong>
                    <fmt:formatNumber value="${hotDealItem.itemPrice * 0.5}" pattern="#,###" />원
                  </strong></span>
              </div>
            </div>
          </div>
        </c:if>


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

        <!-- Js Plugins -->
        <script src="<c:url value='/js/jquery-3.3.1.min.js'/>"></script>

        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
        <script src="<c:url value='/js/bootstrap.min.js'/>"></script>
        <script src="<c:url value='/js/jquery.nice-select.min.js'/>"></script>
        <script src="<c:url value='/js/jquery.nicescroll.min.js'/>"></script>
        <script src="<c:url value='/js/jquery.magnific-popup.min.js'/>"></script>
        <script src="<c:url value='/js/jquery.countdown.min.js'/>"></script>
        <script src="<c:url value='/js/jquery.slicknav.js'/>"></script>
        <script src="<c:url value='/js/owl.carousel.min.js'/>"></script>
        <script src="<c:url value='/js/main.js'/>"></script>

        <!-- Web Socket Lib -->
        <script src="<c:url value=" /webjars/sockjs-client/sockjs.min.js" /> "></script>
        <script src="<c:url value=" /webjars/stomp-websocket/stomp.min.js" /> "></script>

        <!-- Global Variables & Config -->
        <script>
          // 전역 변수 선언 (모든 페이지 JS에서 접근 가능)
          const contextPath = document.body.dataset.contextPath || '';
          const isLoggedIn = document.body.dataset.isLoggedIn === 'true';
          const custId = document.body.dataset.custId || '';
          const globalCartAddUrl = document.body.dataset.cartAddUrl || '';
          const globalLoginUrl = document.body.dataset.loginUrl || '';

          // 채팅 관련 설정 (chat.js에서 사용)
          var chatUsername = "User_${sessionScope.cust != null ? sessionScope.cust.custId : 'Guest'}";
          var websocketUrl = 'http://127.0.0.1:8088/ws';
          var chatbotApiUrl = contextPath + '/api/chatbot/ask';

          // 디버깅 로그
          console.log("Global data from index.jsp:", { contextPath, isLoggedIn, custId, globalCartAddUrl, globalLoginUrl });
        </script>

        <!-- 공통 로직 JS -->
        <script src="<c:url value='/js/chat.js'/>"></script>
        <script src="<c:url value='/js/dark-mode.js'/>"></script>
        <script src="<c:url value='/js/shop.js'/>"></script>
        <script src="<c:url value='/js/home.js'/>"></script>
        <script src="<c:url value='/js/search-form.js'/>"></script>

        <script> const getWinfoUrl = '<c:url value="/getwinfo"/>';</script>

        <!-- 페이지별 JS 로드 (jQuery 및 공통 스크립트 로드 후) -->
        <c:choose>
          <c:when test="${viewName == 'login'}">
            <script src="<c:url value='/js/login.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'shop-details'}">
            <script src="<c:url value='/js/shop_details.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'shopping-cart'}">
            <script src="<c:url value='/js/shopping_cart.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'signup'}">
            <script src="<c:url value='/js/signup.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'community'}">
            <script src="<c:url value='/js/community.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'community_write'}">
            <!-- Summernote CSS -->
            <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
            <!-- Popper.js -->
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
            <!-- Summernote JS -->
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
            <!-- 페이지별 JS -->
            <script src="<c:url value='/js/community_write.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'community_edit'}">
            <!-- Summernote CSS -->
            <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
            <!-- Popper.js -->
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
            <!-- Summernote JS -->
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
            <!-- 페이지별 JS -->
            <script src="<c:url value='/js/community_edit.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'checkout'}">
            <script src="<c:url value='/js/checkout.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'mypage'}">
            <script src="<c:url value='/js/mypage.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'address'}">
            <script src="<c:url value='/js/address.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'address_add'}">
            <script src="<c:url value='/js/address_add.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'address_detail'}">
            <script src="<c:url value='/js/address_detail.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'coupon'}">
            <script src="<c:url value='/js/coupon.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'like'}">
            <script src="<c:url value='/js/like.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'order_detail'}">
            <script src="<c:url value='/js/order_detail.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'order'}">
            <script src="<c:url value='/js/order.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'pet'}">
            <script src="<c:url value='/js/pet.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'qnaboard'}">
            <script src="<c:url value='/js/qnaboard.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'recent_view'}">
            <script src="<c:url value='/js/recent_view.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'qnaboard_add'}">
            <script src="<c:url value='/js/qnaboard_add.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'qnaboard_detail'}">
            <script src="<c:url value='/js/qnaboard_detail.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'review'}">
            <script src="<c:url value='/js/review.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'review_add'}">
            <script src="<c:url value='/js/review_add.js'/>"></script>
          </c:when>
          <c:when test="${viewName == 'review_detail'}">
            <script src="<c:url value='/js/review_detail.js'/>"></script>
          </c:when>
        </c:choose>

        <script src="<c:url value='/js/search.js'/>"></script>
        <script src="<c:url value='/js/dark-mode.js'/>"></script>

        <script>
          document.addEventListener("DOMContentLoaded", () => {
            const themeToggleButton = document.getElementById("themeToggleButton");
            if (!themeToggleButton) return;

            const bodyElement = document.body;

            function getInitialTheme() {
              const savedTheme = localStorage.getItem("theme");

              if (savedTheme) {
                return savedTheme;
              }

              if (
                window.matchMedia &&
                window.matchMedia("(prefers-color-scheme: dark)").matches
              ) {
                return "dark";
              }

              return "light";
            }

            let currentTheme = getInitialTheme();

            function applyTheme(theme) {
              bodyElement.dataset.theme = theme;
              themeToggleButton.dataset.state = theme === "dark" ? "on" : "off";
              themeToggleButton.setAttribute(
                "aria-pressed",
                (theme === "dark").toString()
              );
              themeToggleButton.setAttribute(
                "aria-label",
                "Switch to " + (theme === "dark" ? "light" : "dark") + " mode"
              );

              localStorage.setItem("theme", theme);
              console.log("Theme set to:", theme);
            }

            themeToggleButton.addEventListener("click", () => {
              currentTheme = currentTheme === "dark" ? "light" : "dark";
              applyTheme(currentTheme);
            });

            applyTheme(currentTheme);
          });
        </script>

        <!-- 맨 위로 버튼 스크립트 -->
        <div id="back-to-top" class="back-to-top">
          <i class="fa fa-arrow-up"></i>
        </div>

        <script>
          // 맨 위로 버튼 스크립트
          document.addEventListener('DOMContentLoaded', function () {
            const backToTopButton = document.getElementById('back-to-top');
            const fabOpen = document.getElementById('fab-open');
            const fabClose = document.getElementById('fab-close');
            const chatModal = document.getElementById('chat-modal');

            // 스크롤 이벤트 리스너
            window.addEventListener('scroll', function () {
              if (window.pageYOffset > 300) {
                backToTopButton.classList.add('active');
              } else {
                backToTopButton.classList.remove('active');
              }
            });

            // 버튼 클릭 이벤트
            backToTopButton.addEventListener('click', function () {
              window.scrollTo({
                top: 0,
                behavior: 'smooth'
              });
            });

            // 챗봇 모달 열기 버튼 클릭 시
            fabOpen.addEventListener('click', function () {
              backToTopButton.classList.add('chat-open');
            });

            // 챗봇 모달 닫기 버튼 클릭 시
            fabClose.addEventListener('click', function () {
              backToTopButton.classList.remove('chat-open');
            });

            // 챗봇 모달 상태 초기화
            if (chatModal.style.display !== 'none') {
              backToTopButton.classList.add('chat-open');
            }
          });
        </script>

      </body>

      </html>