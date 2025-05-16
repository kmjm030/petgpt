<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <style>
            .site-btn>a {
                color: white;
            }

            #category {
                color: rosybrown;
            }

            #msg {
                color: darkred;
            }
        </style>

        <!-- Breadcrumb Section Begin -->
        <section class="breadcrumb-option">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="breadcrumb__text">
                            <h4>Mypage</h4>
                            <div class="breadcrumb__links">
                                <a href="<c:url value='/'/>">Home</a>
                                <a href="<c:url value='#'/>">마이페이지</a>
                                <a href="<c:url value='/address'/>">배송지 목록</a>
                                <span>새로운 배송지 등록</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Breadcrumb Section End -->


        <section class="shop spad">
            <div class="container">
                <div class="row">
                    <%-- 옆 사이드 바(마이페이지 카테고리) --%>
                        <div class="col-lg-3">
                            <div class="shop__sidebar">
                                <div class="shop__sidebar__accordion">
                                    <div class="accordion" id="accordionExample">
                                        <div class="card">
                                            <div class="card-heading">
                                                <a data-toggle="collapse">나의 정보</a>
                                            </div>
                                            <div id="collapseOne" class="collapse show" data-parent="#accordionExample">
                                                <div class="card-body">
                                                    <div class="shop__sidebar__categories">
                                                        <ul style="height:auto;">
                                                            <li><a href="<c:url value='/mypage?id=${cust.custId}'/>">회원정보</a></li>
                                                            <li><a href="<c:url value='/pet?id=#${cust.custId}'/>">나의 펫 정보</a></li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card">
                                            <div class="card-heading">
                                                <a data-toggle="collapse">나의 쇼핑 정보</a>
                                            </div>
                                            <div id="collapseTwo" class="collapse show" data-parent="#accordionExample">
                                                <div class="card-body">
                                                    <div class="shop__sidebar__categories">
                                                        <ul style="height: auto;">
                                                            <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>">주문내역</a></li>
                                                            <li><a href="<c:url value='/address?id=${cust.custId}'/>"><strong id="category">배송지 목록</strong></a></li>
                                                            <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card">
                                            <div class="card-heading">
                                                <a data-toggle="collapse">나의 활동</a>
                                            </div>
                                            <div id="collapseThree" class="collapse show" data-parent="#accordionExample">
                                                <div class="card-body">
                                                    <div class="shop__sidebar__categories">
                                                        <ul style="height:auto;">
                                                            <li><a href="<c:url value='/mypage/view?id=${cust.custId}'/>">최근 본 상품</a></li>
                                                            <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                                                            <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a></li>
                                                            <li><a href="<c:url value='/review?id=${cust.custId}'/>">내가 작성한 리뷰</a></li>
                                                        </ul>
                                                        <br /><br />
                                                        <button class="site-btn" id="logout_btn"><a href="<c:url value="
                                    /logout" />">로그아웃</a></button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <%-- 회원 정보 --%>
                            <div class="col-lg-9">
                                <h4><strong>📦 배송지 등록</strong><br></h4>
                                <h6 class="checkout__title"></h6>
                                <form id="addr_add_form">
                                    <div class="row"><br>
                                        <div class="form-group col-md-6">
                                            <div class="checkout__input">
                                                <label for="addrName">▪ 배송지 이름</label>
                                                <input type="text" placeholder="배송지 이름을 입력하세요." id="addrName"
                                                    name="addrName">
                                                <input type="hidden" value="${sessionScope.cust.custId}" id="sessionId"
                                                    name="custId">
                                            </div>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <div class="checkout__input">
                                                <label for="addrTel">▪ 수령인 전화번호</label>
                                                <input type="tel" placeholder="전화번호를 입력하세요." id="addrTel"
                                                    name="addrTel">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="checkout__input">
                                            <label for="sample6_address">▪ 주소 입력</label><br />
                                            <div class="checkout__input">
                                                <input type="text" id="sample6_postcode" placeholder="우편번호"
                                                    name="addrHomecode">
                                                <input type="button" onclick="sample6_execDaumPostcode()"
                                                    value="우편번호 찾기"><br>
                                                <input type="text" id="sample6_address" placeholder="주소"
                                                    name="addrAddress"><br>
                                                <input type="text" id="sample6_detailAddress" placeholder="상세주소"
                                                    name="addrDetail">
                                                <input type="text" id="sample6_extraAddress" placeholder="참고항목"
                                                    name="addrRef">
                                                <script
                                                    src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="form-group col-md-12">
                                            <select class="form-select" id="optionSelect" name="addrReq">
                                                <option value="문앞">문앞에 두고 연락 남겨주세요.</option>
                                                <option value="경비실">경비실 앞에 놔주세요.</option>
                                                <option value="우편함">우편함 앞에 놔주세요.</option>
                                                <option value="연락">배송 전 연락 바랍니다.</option>
                                            </select>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="form-check form-switch form-group">
                                        <input class="form-check-input" type="checkbox" id="addrDef" name="addrDef"
                                            value="Y">
                                        <label class="form-check-label" for="addrDef">이 배송지를 기본 배송지로 저장합니다.</label>
                                        <%-- checkbox에 체크를 하면, isDefault가 yes의 값으로 보내짐 --%>
                                    </div>

                                </form>
                                <h6 id="msg">${msg}</h6>
                                <br /><br />
                                <div class="checkout__order">
                                    <button class="site-btn" id="addr_add_btn">등록하기</button>
                                </div>
                            </div>
                </div>
            </div>
        </section>