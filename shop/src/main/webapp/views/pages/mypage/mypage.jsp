<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
      <% request.setAttribute("now", System.currentTimeMillis()); %>

        <style>
          .site-btn>a {
            color: white;
          }

          #category {
            color: rosybrown;
          }

          #profile-img {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            transition: transform 0.3s ease;
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
                    <span>회원정보조회/수정</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
        <!-- Breadcrumb Section End -->

        <!-- Data for JS -->
        <div id="mypage-data" style="display: none;"
          data-is-kakao-user="${not empty cust.custId and fn:startsWith(cust.custId, 'kakao_')}"
          data-context-path="${pageContext.request.contextPath}"
          data-default-profile-img="<c:url value='/img/clients/profile.png'/>">
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
                            <a data-toggle="collapse" data-target="#collapseOne">마이페이지</a>
                          </div>
                          <div id="collapseOne" class="collapse show" data-parent="#accordionExample">
                            <div class="card-body">
                              <div class="shop__sidebar__categories">
                                <ul>
                                  <li><a href="<c:url value='/mypage?id=${cust.custId}'/>"><strong
                                        id="category">회원정보</strong></a></li>
                                  <li><a href="<c:url value='/pet?id=#${cust.custId}'/>">나의 펫 정보</a></li>
                                  <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>">주문내역</a></li>
                                  <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                                  <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                                  <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
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
                    <h6 class="checkout__title">📌 회원 정보 조회</h6>
                    <form id="cust_update_form" enctype="multipart/form-data">
                      <div class="row">
                        <div class="form-group col-md-12" style="text-align:center; margin:10px;">
                          <c:choose>
                            <c:when test="${not empty cust.custImg}">
                              <img id="profile-img" src="<c:url value='${cust.custImg}'/>?t=${now}" alt="현재 첨부파일"
                                width="200">
                            </c:when>
                            <c:otherwise>
                              <img id="profile-img" src="<c:url value='/img/user/${cust.custName}.png'/>"
                                onerror="this.onerror=null; this.src='<c:url value='/img/clients/profile.png'/>'" />
                            </c:otherwise>
                          </c:choose>
                          <br /><br />
                          <%-- 사진 받기 --%>
                            <input type="file" id="uploadFile" name="img" hidden>
                            <label for="uploadFile" class="btn btn-light">📁 이미지 찾기</label>
                            <button id="img_del_btn" type="button" class="btn btn-light" onclick="mypage.imgDelete()">❌
                              삭제</button>
                            <input type="hidden" id="imgDeleteFlag" name="imgDelete" value="false">

                        </div>
                      </div>
                      <hr><br />
                      <div class="row">
                        <div class="form-group col-md-6">
                          <div class="checkout__input">
                            <label for="id">▪ ID</label>
                            <input type="text" value="${cust.custId}" id="id" name="custId" readonly>
                          </div>
                        </div>
                        <div class="form-group col-md-6">
                          <div class="checkout__input">
                            <label for="name"> 이름</label>
                            <input type="text" value="${cust.custName}" id="name" name="custName" readonly>
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="form-group col-md-6">
                          <div class="checkout__input">
                            <label for="nick">▪ 닉네임</label>
                            <input type="text" value="${cust.custNick}" id="nick" name="custNick">
                          </div>
                        </div>
                      </div>
                      <%-- 카카오 로그인 사용자가 아닐 경우에만 비밀번호 관련 필드 표시 --%>
                        <c:if test="${not fn:startsWith(cust.custId, 'kakao_')}">
                          <div class="row">
                            <div class="form-group col-md-6">
                              <div class="checkout__input">
                                <label for="pwd">▪ 현재 비밀번호</label>
                                <input type="password" placeholder="비밀번호를 입력하세요." id="pwd" name="custPwd">
                              </div>
                            </div>
                          </div>
                          <div class="row">
                            <div class="form-group col-md-6">
                              <div class="checkout__input">
                                <label for="new_pwd">▪ 새 비밀번호</label>
                                <input type="password" placeholder="새 비밀번호를 입력하세요." id="new_pwd" name="newPwd">
                              </div>
                            </div>
                            <div class="form-group col-md-6">
                              <div class="checkout__input">
                                <label for="new_pwd2">▪ 새 비밀번호 확인</label>
                                <input type="password" placeholder="새 비밀번호를 확인하세요." id="new_pwd2" name="newPwd2">
                              </div>
                            </div>
                          </div>
                        </c:if>
                        <div class="row">
                          <div class="form-group col-md-6">
                            <div class="checkout__input">
                              <label for="phone">▪ 전화번호</label>
                              <input type="tel" value="${cust.custPhone}" id="phone" name="custPhone">
                            </div>
                          </div>
                          <div class="form-group col-md-6">
                            <div class="checkout__input">
                              <label for="email">▪ 이메일</label>
                              <input type="email" value="${cust.custEmail}" id="email" name="custEmail">
                            </div>
                          </div>
                        </div>
                        <div class="row">
                          <div class="form-group col-md-6">
                            <div class="checkout__input">
                              <label for="point">▪ 포인트</label>
                              <input type="number" value="${cust.custPoint}" id="point" name="custPoint" readonly>
                            </div>
                          </div>
                        </div>
                        <input type="hidden" value="${sessionScope.cust.custId}" id="sessionId" name="id">
                    </form>
                    <h6 id="msg">${msg}</h6>
                    <br /><br />
                    <div class="checkout__order">
                      <button class="site-btn" id="cust_update_btn">정보 수정하기</button>
                    </div>
                  </div>
            </div>
          </div>
        </section>