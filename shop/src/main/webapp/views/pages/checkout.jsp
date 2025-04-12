<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--결제 아임포트 로드--%>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script>
          // 아임포트 초기화
  IMP.init('imp15570454'); // "가맹점 식별코드"를 실제 코드로 대체하세요
    function requestPay() {
    IMP.request_pay({
      pg: "html5_inicis", // 결제사 선택
      pay_method: "card", // 결제 방법
      merchant_uid: "order_" + new Date().getTime(), // 고유 주문 번호
      name: "주문명: 상품 이름",
      amount: 10000, // 결제 금액 ( total )값 참조
      buyer_email: "test@example.com", // 구매자 이메일
      buyer_name: "홍길동", // 구매자 이름
      buyer_tel: "010-1234-5678", // 구매자 전화번호
      buyer_addr: "서울특별시 강남구 삼성동", // 구매자 주소
      buyer_postcode: "123-456" // 구매자 우편번호
    }, function (rsp) {
      if (rsp.success) {
        alert("결제가 완료되었습니다.");
        // 결제 성공 처리 로직
      } else {
        alert("결제에 실패하였습니다: " + rsp.error_msg);
        // 결제 실패 처리 로직
      }
    });
  }
</script>
<%-- 혹시 몰라서 페이지 자체는 삭제 안 하고 살려두겠습니다! --%>

<!-- Breadcrumb Section Begin -->
<section class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__text">
                    <h4>Check Out</h4>
                    <div class="breadcrumb__links">
                        <a href="<c:url value='/'/>">Home</a>
                        <a href="<c:url value='/shop'/>">Shop</a>
                        <span>Check Out</span>
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
            <%-- 실제 주문 처리 로직 필요 --%>
<form action="#">
  <div class="row">
    <div class="col-lg-8 col-md-6">
      <h6 class="coupon__code"><span class="icon_tag_alt"></span> 쿠폰 적용이 완료되었습니다.</h6> <%-- 쿠폰 입력 필드 표시 로직 필요 --%>
      <h6 class="checkout__title">주문자 정보</h6>
      <div class="row">
        <div class="col-lg-6">
          <div class="checkout__input">
            <p>이름<span>*</span></p>
            <input type="text" name="firstName" required>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-lg-6">
          <div class="checkout__input">
            <p>전화번호<span>*</span></p>
            <input type="text" name="phone" required>
          </div>
        </div>
        <div class="col-lg-6">
          <div class="checkout__input">
            <p>이메일<span>*</span></p>
            <input type="email" name="email" required>
          </div>
        </div>
      </div>
      <br/>
      <h6 class="checkout__title">수령인 정보</h6>
      <div class="row">
        <div class="col-lg-6">
          <div class="checkout__input">
            <p>받는 분 성함<span>*</span></p>
            <input type="text" name="firstName" required>
          </div>
        </div>
      </div>
      <div class="checkout__input">
        <input type="text" id="sample6_postcode" placeholder="우편번호">
        <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
        <input type="text" id="sample6_address" placeholder="주소"><br>
        <input type="text" id="sample6_detailAddress" placeholder="상세주소">
        <input type="text" id="sample6_extraAddress" placeholder="참고항목">

        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        <script>
          function sample6_execDaumPostcode() {
            new daum.Postcode({
              oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                  addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                  addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                  // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                  // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                  if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                  }
                  // 건물명이 있고, 공동주택일 경우 추가한다.
                  if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                  }
                  // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                  if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                  }
                  // 조합된 참고항목을 해당 필드에 넣는다.
                  document.getElementById("sample6_extraAddress").value = extraAddr;

                } else {
                  document.getElementById("sample6_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample6_postcode').value = data.zonecode;
                document.getElementById("sample6_address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("sample6_detailAddress").focus();
              }
            }).open();
          }
        </script>
      </div>

      <div class="row">
        <div class="col-lg-6">
          <div class="checkout__input">
            <p>Phone<span>*</span></p>
            <input type="text" name="phone" required>
          </div>
        </div>
        <div class="col-lg-6">
          <div class="checkout__input">
            <p>전화번호<span>*</span></p>
            <input type="text" name="phone" required>
          </div>
        </div>
      </div>

      <div class="checkout__input">
        <p>배송메모<span>*</span></p>
        <input type="text"
               placeholder="배송시 요청사항을 입력하세요." name="orderNote">
      </div>
    </div>
    <div class="col-lg-4 col-md-6">
      <div class="checkout__order">
        <h4 class="order__title">Your order</h4>
        <div class="checkout__order__products">Product <span>Total</span></div>
        <ul class="checkout__total__products">
          <li>01. Vanilla salted caramel <span>$ 300.0</span></li>
          <li>02. German chocolate <span>$ 170.0</span></li>
          <li>03. Sweet autumn <span>$ 170.0</span></li>
          <li>04. Gluten free mini dozen <span>$ 110.0</span></li>
        </ul>
        <%-- 소계, 총계 동적 계산 필요 --%>
        <ul class="checkout__total__all">
          <li>Subtotal <span>$750.99</span></li>
          <li>Total <span>$750.99</span></li>
        </ul>
        <%-- 결제 --%>
       <div>
        <button type="button" class="site-btn" onclick="requestPay()">결제하기</button>
      </div>
    </div>
  </div>
</form>
</div>
</div>
</section>
<!-- Checkout Section End -->