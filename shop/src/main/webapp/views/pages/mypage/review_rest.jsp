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

        .review-btn {
          width: 100%;
          color: black;
          border: 2px solid white;
          border-radius: 10px;
          padding: 10px;
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
                  <span>작성 가능한 리뷰</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- Breadcrumb Section End -->

      <!-- Data for JS -->
      <div id="order-detail-data" style="display: none;" data-context-path="${pageContext.request.contextPath}">
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
                                <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                                <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a></li>
                                <li><a href="<c:url value='/review?id=${cust.custId}'/>">내가 작성한 리뷰</a></li>
                                <li><a href="<c:url value='/review/rest?id=${cust.custId}'/>"><strong
                                  id="category">작성 가능한 리뷰</strong></a></li>
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
                  <h4><strong>📝 작성 가능한 리뷰</strong></h4>
                  <h6 class="checkout__title"></h6>
                  <c:forEach var="c" items="${orderDetails}">
                    <div>
                      <span style="font-size: 12px; color:lightgray;">(주문번호: ${c.orderKey})</span>
<%--                      <span style="float:right"><fmt:formatDate value="${orderMap[c.orderKey].orderDate}" pattern="yyyy-MM-dd"/></span>--%>
                    </div>
                    <hr>
                    <div class="row">
                      <div class="col-md-2 img-box">
                        <a href="<c:url value='/shop/details?itemKey=${c.itemKey}'/>">
                          <img src="<c:url value='/img/product/${itemMap[c.itemKey].itemImg1}'/>" width="200" style="border-radius:10%"/></a>
                      </div>
                      <div class="col-md-7" style="padding: 20px;">
                        <h6 style="padding-bottom:5px;"><strong>${itemMap[c.itemKey].itemName}</strong></h6>
                        <p>옵션: ${optionMap[c.optionKey].optionName}<br>
                           구매일자: <fmt:formatDate value="${orderMap[c.orderKey].orderDate}" pattern="yyyy-MM-dd"/></p>
                      </div>
                      <div class="col-md-3">
                        <button class="review-btn"
                            onclick="location.href='<c:url value='/review/add'/>?itemKey=${c.itemKey}&orderKey=${c.orderKey}&orderDetailKey=${c.orderDetailKey}'">
                             <strong>리뷰쓰기</strong></button>
                      </div>
                    </div>
                    <hr>
                  </c:forEach>
                </div>
          </div>
        </div>
        </div>
      </section>
      <c:if test="${not empty msg}">
        <script>
          alert("${msg}");
        </script>
      </c:if>
