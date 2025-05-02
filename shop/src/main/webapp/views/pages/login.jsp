<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <style>
            #msg {
                color: darkred;
            }
        </style>
        <script>
            const login = {
                init: function () {

                },
                send: function () {
                    $('#login_form').attr('method', 'post');
                    $('#login_form').attr('action', '<c:url value="/loginimpl"/>');
                    $('#login_form').submit();
                },
                // 카카오 로그인 요청 함수 추가
                kakaoLogin: function () {
                    const REST_API_KEY = '0404d3d84de08ad89ff1804757d2047a'; // 발급받은 REST API 키 입력
                    const REDIRECT_URI = 'http://localhost/auth/kakao/callback'; // 등록한 Redirect URI 입력
                    const kakaoAuthUrl = 'https://kauth.kakao.com/oauth/authorize?client_id=' + REST_API_KEY + '&redirect_uri=' + REDIRECT_URI + '&response_type=code';
                    window.location.href = kakaoAuthUrl; // 카카오 인증 페이지로 이동
                }
            }
            $(function () {
                login.init();
            })
        </script>

        <!-- Breadcrumb Section Begin -->
        <section class="breadcrumb-option">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="breadcrumb__text">
                            <h4>Log In</h4>
                            <div class="breadcrumb__links">
                                <a href="<c:url value='/'/>">Home</a>
                                <span>Log in</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Breadcrumb Section End -->



        <!-- Checkout Section Begin -->
        <section class="checkout spad">
            <div class="container">
                <div class="checkout__form">
                    <div class="row">
                        <div class="col-lg-6">
                            <form id="login_form">
                                <div class="form-group">
                                    <div class="checkout__input">
                                        <label for="id">ID</label>
                                        <input type="text" placeholder="아이디를 입력하세요." id="id" name="id">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="checkout__input">
                                        <label for="pwd">비밀번호</label>
                                        <input type="password" placeholder="비밀번호를 입력하세요." id="pwd" name="pwd">
                                    </div>
                                </div>
                            </form>
                            <c:choose>
                                <c:when test="${msg != null}">
                                    <h6 id="msg">${msg}</h6>
                                    <br /><br />
                                </c:when>
                                <c:otherwise>
                                    <h6></h6>
                                </c:otherwise>
                            </c:choose>

                            <div style="display: flex; align-items: center; gap: 10px; margin-top: 20px;">
                                <button class="site-btn" id="login_btn" onclick="login.send()"
                                    style="flex: 1; text-align: center;">로그인</button>
                                <a href="javascript:login.kakaoLogin()" style="flex: 1; display: block;">
                                    <img src="<c:url value='/img/kakao/kakao_login_large_narrow.png'/>" alt="카카오 로그인"
                                        style="cursor: pointer; width: 100%; height: 100%; object-fit: contain; vertical-align: middle;">
                                <a href="<c:url value='/auth/google'/>" class="btn google">
                                    Google 로그인</a>
                            </div>


                        </div>
                    </div>
                </div>
            </div>
        </section>