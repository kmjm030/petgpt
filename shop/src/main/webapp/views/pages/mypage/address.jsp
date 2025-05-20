<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <style>
            .site-btn>a {
                color: white;
            }

            #category {
                color: rosybrown;
            }

            .address-btn {
                width: 100%;
                border-radius: 10px;
                background-color: white;
                color: black;
                border: 3px solid black;
                border-radius: 10px;
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
                                <span>배송지 목록</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Breadcrumb Section End -->

        <!-- Data for JS -->
        <div id="address-data" style="display: none;" data-context-path="${pageContext.request.contextPath}">
        </div>


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
                                                            <li><a href="<c:url value='/address?id=${cust.custId}'/>"><strong
                                                                    id="category">배송지 목록</strong></a></li>
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
                                                            <li><a href="<c:url value='/review/rest?id=${cust.custId}'/>">작성 가능한 리뷰</a></li>
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
                                <h4><strong>📦 배송지 </strong></h4>
                                <p style="color:lightgray"><br>어디로 보내드릴까요? 이곳에서 배송지를 한번에 관리하세요!.<br></p>
                                <h6 class="checkout__title"></h6>
                                <c:forEach var="c" items="${address}">
                                    <c:if test="${c.addrDef eq 'Y'}">
                                        <h6>- 현재 기본배송지는 <strong id="addr_def">${c.addrName}</strong>🏠입니다.</h6>
                                        <br /><br />
                                    </c:if>
                                </c:forEach>
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>배송지 이름</th>
                                            <th>우편번호</th>
                                            <th>주소</th>
                                            <th></th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="c" items="${address}">
                                            <tr>
                                                <td>${c.addrName}</td>
                                                <td>${c.addrHomecode}</td>
                                                <td>${c.addrAddress}</td>
                                                <td>${c.addrDetail}</td>
                                                <td>
                                                    <button class="address-btn" id="addr_mod_btn"
                                                        onclick="location.href='<c:url value='/address/mod?addrKey='/>${c.addrKey}'">수정</button>
                                                </td>
                                                <td>
                                                    <button class="address-btn" id="addr_del_btn"
                                                        onclick="address.del(${c.addrKey})">삭제</button>
                                                </td>
                                                <%-- <td class="cart__close">--%>
                                                    <%-- <i class="fa fa-close"></i>--%>
                                                        <%-- </td>--%>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <br /><br />
                                <div class="checkout__order">
                                    <button class="site-btn" id="addr_add_btn"
                                        onclick="location.href='<c:url value='/address/add'/>'">
                                        주소 추가하기
                                    </button>
                                </div>
                            </div>
                </div>
            </div>
        </section>
