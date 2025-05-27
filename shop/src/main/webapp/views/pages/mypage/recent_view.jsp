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
        width: 100%;
        height: auto;
        max-width: 120px;
        object-fit: cover;
        border-radius: 5%;
        transition: transform 0.3s ease;
      }

      #like_img:hover {
        transform: scale(1.05);
      }

      .view-item {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        margin-bottom: 1.5rem;
      }

      .view-img {
        flex: 0 0 120px;
        margin-right: 1rem;
      }

      .view-content {
        flex: 1;
      }

      .view-delete {
        flex: 0 0 auto;
        margin-left: auto;
        padding-left: 1rem;
      }

      .discount-badge {
        background-color: darkred;
        color: white;
        padding: 2px 6px;
        font-size: 14px;
        border-radius: 4px;
        margin-left: 5px;
        width: 50px;
        text-align: center;
      }

      .original-price {
        text-decoration: line-through;
        color: gray;
        font-size: 14px;
      }

      .sale-price {
        font-weight: bold;
        font-size: 16px;
      }

      @media (max-width: 576px) {
        .view-item {
          flex-direction: column;
          align-items: flex-start;
        }

        .view-img {
          margin-bottom: 0.5rem;
        }

        .view-delete {
          align-self: flex-end;
          margin-top: 0.5rem;
        }
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
                              <li><a href="<c:url value='/mypage/view?id=${cust.custId}'/>"><strong
                                      id="category">최근 본 상품</strong></a></li>
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
            <div class="col-lg-9 container mt-3">
              <h4><strong>👀 최근 본 상품 </strong></h4>
              <p style="color:lightgray"><br>최대 50개까지 저장됩니다.<br><br></p>
              <hr>
              <c:forEach var="c" items="${views}">
                <div class="view-item">
                  <div class="view-img">
                    <a href="<c:url value='/shop/details?itemKey=${c.itemKey}'/>">
                      <img id="like_img" src="<c:url value='/img/product/${c.item.itemImg1}' />" />
                    </a>
                  </div>
                  <div class="view-content">
                    <h6>${c.item.itemName}</h6>
                    <div class="product__price">
                      <c:choose>
                        <c:when test="${c.item.itemSprice > 0 and c.item.itemSprice < c.item.itemPrice}">
                          <c:set var="discountRate" value="${100 - (c.item.itemSprice * 100 / c.item.itemPrice)}" />
                          <span class="original-price">
                <fmt:formatNumber value="${c.item.itemPrice}" pattern="#,###" />원
              </span>
                          <span class="sale-price">
                <fmt:formatNumber value="${c.item.itemSprice}" pattern="#,###" />원
              </span>
                          <span class="discount-badge">
                <fmt:formatNumber value="${discountRate}" pattern="#" />%
              </span>
                        </c:when>
                        <c:otherwise>
              <span class="sale-price">
                <fmt:formatNumber value="${c.item.itemPrice}" pattern="#,###" />원
              </span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                  <div class="view-delete">
                    <a href="#" onclick="recent_view.del(${c.viewKey})">
                      <i class="fa fa-close" style="color:black;"></i>
                    </a>
                  </div>
                </div>
                <hr>
              </c:forEach>
            </div>
<%--              <div class="col-lg-9 container mt-3">--%>
<%--                <h4><strong>👀 최근 본 상품 </strong></h4>--%>
<%--                <p style="color:lightgray"><br>최대 50개까지 저장됩니다.<br><br></p><hr>--%>
<%--                  <c:forEach var="c" items="${views}">--%>
<%--                    <div class="row">--%>
<%--                      <div class="col-sm-2 img-box" >--%>
<%--                        <a href="<c:url value='/shop/details?itemKey=${c.itemKey}'/>">--%>
<%--                          <img src="<c:url value='/img/product/${c.item.itemImg1}' />"/></a>--%>
<%--                      </div>--%>
<%--                      <div class="col-sm-9">--%>
<%--                        <h6>${c.item.itemName}</h6>--%>
<%--                        <div class="product__price">--%>
<%--                          <c:if test="${c.item.itemSprice > 0 and c.item.itemSprice < c.item.itemPrice}">--%>
<%--                            <c:set var="discountRate" value="${100 - (c.item.itemSprice * 100 / c.item.itemPrice)}" />--%>
<%--                              <div class="price-container">--%>
<%--                                <span class="original-price" style="text-decoration: line-through;">--%>
<%--                                  <fmt:formatNumber value="${c.item.itemPrice}" pattern="#,###" />원--%>
<%--                                </span>--%>
<%--                                <div class="sale-info">--%>
<%--                                  <span class="sale-price">--%>
<%--                                    <fmt:formatNumber value="${c.item.itemSprice}" pattern="#,###" />원--%>
<%--                                  </span>--%>
<%--                                  <span class="discount-badge">--%>
<%--                                    <fmt:formatNumber value="${discountRate}" pattern="#" />%--%>
<%--                                  </span>--%>
<%--                                </div>--%>
<%--                              </div>--%>
<%--                          </c:if>--%>
<%--                          <c:if test="${!(c.item.itemSprice > 0 and c.item.itemSprice < c.item.itemPrice)}">--%>
<%--                            <div class="price-container">--%>
<%--                              <span class="sale-price">--%>
<%--                                <fmt:formatNumber value="${c.item.itemPrice}" pattern="#,###" />원--%>
<%--                              </span>--%>
<%--                            </div>--%>
<%--                          </c:if>--%>
<%--                        </div>--%>
<%--                      </div>--%>
<%--                      <div class="col-sm-1">--%>
<%--                        <a href="#" onclick="recent_view.del(${c.viewKey})">--%>
<%--                          <i id="view_del_icon" class="fa fa-close" style="color:black;"></i>--%>
<%--                        </a>--%>
<%--                      </div>--%>
<%--                    </div>--%>
<%--                    <hr>--%>
<%--                  </c:forEach>--%>
<%--              </div>--%>

        </div>
      </div>
    </section>
