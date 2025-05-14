<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <%--결제 아임포트 로드--%>
      <script src="https://cdn.iamport.kr/v1/iamport.js"></script>

      <!-- Breadcrumb Section Begin -->
      <section class="breadcrumb-option">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <div class="breadcrumb__text">
                <h4>📝 주문서 작성</h4>
                <div class="breadcrumb__links">
                  <a href="<c:url value='/'/>">Home</a>
                  <a href="<c:url value='/shop'/>">카테고리</a>
                  <span>주문서 작성</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- Breadcrumb Section End -->

      <!-- Checkout Data for JS -->
      <div id="checkout-data" style="display: none;" data-cust-name="${cust.custName}"
        data-cust-phone="${cust.custPhone}" data-def-addr-homecode="${defAddress.addrHomecode}"
        data-def-addr-address="${defAddress.addrAddress}" data-def-addr-detail="${defAddress.addrDetail}"
        data-def-addr-ref="${defAddress.addrRef}" data-total-cart-price="${totalCartPrice}"
        data-context-path="${pageContext.request.contextPath}" <%-- contextPath 추가 --%>
        >
      </div>

      <!-- Checkout Section Begin -->
      <section class="checkout spad">
        <div class="container">
          <div class="checkout__form">
            <%-- 실제 주문 처리 로직 필요 --%>
              <form id="orderForm" action="/checkout/orderimpl" method="post">
                <div class="row">
                  <div class="col-lg-8 col-md-6">
                    <%-- <h6 class="coupon__code"><span class="icon_tag_alt"></span> 쿠폰 적용이 완료되었습니다.</h6> &lt;%&ndash;
                      쿠폰 입력 필드 표시 로직 필요 &ndash;%&gt;--%>
                      <h6 class="checkout__title">🐶 주문자 정보</h6>
                      <div class="row">
                        <div class="col-lg-6">
                          <div class="checkout__input">
                            <p>▪ 이름</p>
                            <input type="text" value="${cust.custName}" name="custName" readonly>
                            <input type="hidden" id="finalAmount" name="orderTotalPrice" value="${totalCartPrice}">
                            <input type="hidden" value="${cust.custId}" id="custId" name="custId">
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-lg-6">
                          <div class="checkout__input">
                            <p>▪ 전화번호</p>
                            <input type="text" value="${cust.custPhone}" name="custPhone" readonly>
                          </div>
                        </div>
                      </div>
                      <br />
                      <h6 class="checkout__title">🐱 수령인 정보</h6>
                      <div class="form-check form-switch form-group">
                        <input class="form-check-input" type="checkbox" id="isSame" value="Y">
                        <label class="form-check-label" for="isSame">주문자 정보와 일치합니다.</label>
                      </div><br />
                      <div class="row">
                        <div class="col-lg-6">
                          <div class="checkout__input">
                            <p>▪ 받는 분 성함<span>*</span></p>
                            <input type="text" id="recipientName" name="recipientName" placeholder="이름을 입력하세요."
                              required>
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-lg-12">
                          <div class="checkout__input">
                            <p>▪ 받는 분 주소<span>*</span></p>
                            <div>
                              <select class="form-select" id="optionSelect" name="boardOption">
                                <option value="" disabled selected>🏠 저장된 배송지 중 선택할 수 있어요!</option>
                                <c:forEach var="c" items="${addrList}">
                                  <option value="${c.addrName}" data-homecode="${c.addrHomecode}"
                                    data-address="${c.addrAddress}" data-detail="${c.addrDetail}"
                                    data-ref="${c.addrRef}">
                                    ${c.addrName}
                                  </option>
                                </c:forEach>
                              </select>
                            </div><br /><br /><br />
                            <input type="text" id="sample6_postcode" placeholder="우편번호" name="addrHomecode" readonly>
                            <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
                            <input type="text" id="sample6_address" placeholder="주소" name="addrAddress" readonly><br>
                            <input type="text" id="sample6_detailAddress" placeholder="상세주소" name="addrDetail">
                            <input type="text" id="sample6_extraAddress" placeholder="참고항목" name="addrRef">
                            <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
                          </div>
                        </div>
                      </div>
                      <div class="row">
                        <div class="col-lg-6">
                          <div class="checkout__input">
                            <p>▪ 전화번호<span>*</span></p>
                            <input type="tel" id="recipientPhone" name="recipientPhone" placeholder="전화번호를 입력하세요."
                              required>
                          </div>
                        </div>
                      </div>

                      <div class="checkout__input">
                        <p>▪ 배송메모</p>
                        <input type="text" placeholder="배송시 요청사항을 입력하세요." name="orderReq">
                      </div>
                      <div class="form-check form-switch form-group">
                        <input class="form-check-input" type="checkbox" id="addrSave" name="addrSave" value="Y">
                        <label class="form-check-label" for="isSame">위 주소를 배송지목록에 저장합니다.</label>
                      </div><br />
                  </div>
                  <div class="col-lg-4 col-md-6">
                    <div class="checkout__order">
                      <h4 class="order__title">📝 주문 금액 확인</h4>
                      <div>
                        <select class="form-select" id="couponSelect" name="couponId">
                          <option value="" disabled selected>💌 보유하고 있는 쿠폰을 확인하세요!</option>
                          <c:forEach var="c" items="${coupons}">
                            <option value="${c.couponId}">💌 ${c.couponName}</option>
                          </c:forEach>
                        </select>
                      </div><br /><br /><br>
                      <hr>
                      <div class="checkout__order__products"><strong>상품</strong> <span style="float:right;"><strong>총액</strong></span></div>
                      <ul class="checkout__total__products">
                        <c:forEach var="c" items="${cartItems}">
                          <li>
                            ▪ ${c.item_name}
                            <em style="font-size: 12px; color: gray;">[${c.option.optionName}]</em>
                            <span>${c.item_price * c.cart_cnt}원</span>
                          </li>
                        </c:forEach>
                      </ul>
                      <%-- 소계, 총계 동적 계산 필요 --%>
                        <ul class="checkout__total__all">
                          <li>상품 금액 <span>${totalCartPrice}원</span></li>
                          <li>할인 가격 <span id="discount_price">-0원</span></li>
                          <li>최종 결제금액 <span id="discounted_price">${totalCartPrice}원</span></li>
                        </ul>
                        <%-- 결제 --%>
                          <div id="msg"></div><br />
                          <div>
                            <button type="button" class="site-btn" onclick="requestPay()">결제하기</button>
                          </div>
                    </div>
                  </div>
                </div>
              </form>
          </div>
        </div>
      </section>
      <!-- Checkout Section End -->
