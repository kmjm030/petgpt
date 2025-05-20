<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

    <style>
      .site-btn>a {
        color: white;
      }

      #category {
        color: rosybrown;
      }

      #like_img {
        width: 150px;
        height: 150px;
      }

      #like_del_icon {
        color: black;
      }

      .discount-badge {
        color: white;
        background-color: darkred;
      }

      .img-box img {
        transition: transform 0.3s ease;
        width: 100%;
        height: 100%;
        border-radius: 5%;
      }

      .img-box img:hover {
        transform: scale(1.05);
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
                <span>찜 목록</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Breadcrumb Section End -->

    <!-- Data for JS -->
    <div id="like-data" style="display: none;" data-context-path="${pageContext.request.contextPath}">
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
                              <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
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
                              <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>"><strong
                                      id="category">찜 목록</strong></a></li>
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
              <div class="col-lg-9 container mt-3">
                <h4><strong>💟 내가 찜한 상품 </strong></h4>
                <p style="color:lightgray"><br>최근 1년간 찜한 내역이 유지됩니다.<br><br></p><hr>
                <c:forEach var="c" items="${items}">
                  <div class="row">
                    <div class="col-md-2 img-box">
                      <a href="<c:url value='/shop/details?itemKey=${c.itemKey}'/>">
                      <img src="<c:url value='/img/product/${c.itemImg1}'/>"/></a>
                    </div>
                    <div class="col-md-9">
                      <h6>${c.itemName}</h6>
                      <div class="product__price">
                        <c:if test="${c.itemSprice > 0 and c.itemSprice < c.itemPrice}">
                          <c:set var="discountRate" value="${100 - (c.itemSprice * 100 / c.itemPrice)}" />
                          <div class="price-container">
                                <span class="original-price" style="text-decoration: line-through;">
                                  <fmt:formatNumber value="${c.itemPrice}" pattern="#,###" />원
                                </span>
                            <div class="sale-info">
                                  <span class="sale-price">
                                    <fmt:formatNumber value="${c.itemSprice}" pattern="#,###" />원
                                  </span>
                              <span class="discount-badge">
                                    <fmt:formatNumber value="${discountRate}" pattern="#" />%
                                  </span>
                            </div>
                          </div>
                        </c:if>
                        <c:if test="${!(c.itemSprice > 0 and c.itemSprice < c.itemPrice)}">
                          <div class="price-container">
                              <span class="sale-price">
                                <fmt:formatNumber value="${c.itemPrice}" pattern="#,###" />원
                              </span>
                          </div>
                        </c:if>
                      </div>
                    </div>
                    <div class="col-md-1">
                      <a href="#" onclick="like.del(${c.itemKey}, '${sessionScope.cust.custId}')">
                        <i id="view_del_icon" class="fa fa-close" style="color:black;"></i>
                      </a>
                    </div>
                  </div>
                  <hr>
                </c:forEach>
<%--                <table class="table">--%>
<%--                  <thead>--%>
<%--                    <tr>--%>
<%--                      <th>이미지</th>--%>
<%--                      <th>상품이름</th>--%>
<%--                      <th>가격</th>--%>
<%--                      <th></th>--%>
<%--                    </tr>--%>
<%--                  </thead>--%>
<%--                  <tbody>--%>
<%--                    <c:forEach var="c" items="${items}">--%>
<%--                      <tr>--%>
<%--                        <td><img id="like_img" src="<c:url value='/img/product/'/>${c.itemImg1}" /></td>--%>
<%--                        <td>${c.itemName}</td>--%>
<%--                        <td>${c.itemPrice}원</td>--%>
<%--                        <td class="cart__close">--%>
<%--                          <a href="#" onclick="like.del(${c.itemKey}, '${sessionScope.cust.custId}')">--%>
<%--                            <i id="like_del_icon" class="fa fa-close"></i>--%>
<%--                          </a>--%>
<%--                        </td>--%>
<%--                      </tr>--%>
<%--                    </c:forEach>--%>
<%--                  </tbody>--%>
<%--                </table>--%>
                <br /><br />
              </div>
        </div>
      </div>
    </section>
