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

        #boardRe {
          color: rosybrown;
          text-align: center;
          border-radius: 10px;
          padding: 10px;
        }

        #boardTitle {
          color: black;
        }

        .checkout__input {
          margin-bottom: 20px;
        }

        .order-site-btn {
          width: 100%;
          border-radius: 10px;
          background-color: white;
          color: black;
          border: 3px solid black;
          border-radius: 10px;
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
                  <a href="<c:url value='#'/>">주문내역</a>
                  <span>주문상세조회</span>
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
                                <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>"><strong
                                        id="category">주문내역</strong></a></li>
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
                  <h4><strong>🔎 주문내역 상세보기</strong></h4>
                  <h6 class="checkout__title"></h6>
                  <h6 class="checkout__input"><strong>▪ 주문번호 :</strong> ${order.orderKey}</h6>
                  <h6 class="checkout__input"><strong>▪ 수령인 :</strong> ${order.recipientName}</h6>
                  <h6 class="checkout__input"><strong>▪ 수령인 전화번호 :</strong> ${order.recipientPhone}</h6>
                  <h6 class="checkout__input"><strong>▪ 주문일자 :</strong>
                    <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" />
                  </h6>
                  <h6 class="checkout__input"><strong>▪ 결제금액 :</strong> ${order.orderTotalPrice}원</h6>
                  <h6 class="checkout__input"><strong>▪ 배송지정보 :</strong> [${order.orderHomecode}] ${order.orderAddr}
                    ${order.orderAddrRef} ${order.orderAddrDetail}</h6>
                  <h6 class="checkout__input"><strong>▪ 주문상품</strong><span style="color: #e76f51">  [${order.orderStatus}]</span></h6>
                  <table class="table">
                    <thead>
                      <tr>
                        <th></th>
                        <th>상품</th>
                        <th>가격</th>
                        <th>개수</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="c" items="${orderDetails}">
                        <tr>
                          <td>
                            <img src="<c:url value='/img/product/${itemMap[c.itemKey].itemImg1}'/>" width="200" />
                          </td>
                          <td>
                            <p>${itemMap[c.itemKey].itemName}</p>
                            <p style="font-size:12px;">[옵션: ${optionMap[c.optionKey].optionName}]</p>
                          </td>
                          <td>${c.orderDetailPrice}</td>
                          <td>${c.orderDetailCount}</td>
                          <td><c:if test="${order.orderStatus eq '배송완료'}">
                            <button class="review-btn"
                                    onclick="location.href='<c:url value='/review/add'/>?itemKey=${c.itemKey}&orderKey=${c.orderKey}&orderDetailKey=${c.orderDetailKey}'">
                              <strong>리뷰쓰기</strong>
                            </button>
                          </c:if></td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                  <br /><br />
                  <div class="row">
                    <div class="col-lg-6">
                      <button class="site-btn order-site-btn" style="margin-bottom: 5px;"
                        onclick="location.href='<c:url value='/qnaboard/add'/>?id=${cust.custId}'">교환/환불 신청</button>
                    </div>
                    <div class="col-lg-6">
                      <button class="site-btn order-site-btn"
                              data-order-status="${order.orderStatus}"
                              onclick="order_detail.del(${order.orderKey}, event)">
                        주문 취소하기
                      </button>
                    </div>
                  </div>
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
