function requestPay() {

    console.log('🔥 최종 제출 데이터 확인 🔥');
    console.log($('#orderForm').serialize());

    let name = $('#recipientName').val();
    let phone = $('#recipientPhone').val();
    let address = $('#sample6_detailAddress').val();
    let address2 = $('#sample6_address').val();
    let finalAmount = parseInt($('#finalAmount').val(), 10);

    if (name == '' || name == null) {
        $('#msg').text('수령인 이름을 입력하세요.');
        $('#recipientName').focus();
        return;
    }
    if (phone == '' || phone == null) {
        $('#msg').text('수령인 전화번호를 입력하세요.');
        $('#recipientPhone').focus();
        return;
    }
    if (address2 == '' || address2 == null) {
        $('#msg').text('주소를 입력해주세요.');
        $('#sample6_address').focus();
        return;
    }
    if (address == '' || address == null) {
        $('#msg').text('상세주소를 입력해주세요.');
        $('#sample6_detailAddress').focus();
        return;
    }

    IMP.request_pay({
        pg: "html5_inicis", // 결제사 선택
        pay_method: "card", // 결제 방법
        merchant_uid: "order_" + new Date().getTime(), // 고유 주문 번호
        name: "주문명: 상품 이름",
        // amount: parseInt($('#discounted_price').text().replace(/[^\d]/g, ''), 10),
        amount: 1,
        buyer_email: "test@example.com", // 구매자 이메일
        buyer_name: "홍길동", // 구매자 이름
        buyer_tel: "010-1234-5678", // 구매자 전화번호
        buyer_addr: "서울특별시 강남구 삼성동", // 구매자 주소
        buyer_postcode: "123-456" // 구매자 우편번호
    }, function (rsp) {
        if (rsp.success) {
            alert("결제가 완료되었습니다.");
            document.getElementById("orderForm").submit();
            // 결제 성공 처리 로직
        } else {
            alert("결제에 실패하였습니다: " + rsp.error_msg);
            // 결제 실패 처리 로직
        }
    });
}

function sample6_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function (data) {
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
            if (data.userSelectedType === 'R') {
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraAddr !== '') {
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

$(document).ready(function () {
    // 아임포트 초기화 (가장 먼저 실행되도록 추가)
    IMP.init('imp15570454'); // "가맹점 식별코드" 확인 필요
    console.log("✅ 아임포트 SDK 초기화 시도");
    console.log("✅ checkout.js document ready!!");

    // #checkout-data 요소에서 데이터 읽기
    const checkoutData = $('#checkout-data');
    const custName = checkoutData.data('cust-name') || '';
    const custPhone = checkoutData.data('cust-phone') || '';
    const defAddrHomecode = checkoutData.data('def-addr-homecode') || '';
    const defAddrAddress = checkoutData.data('def-addr-address') || '';
    const defAddrDetail = checkoutData.data('def-addr-detail') || '';
    const defAddrRef = checkoutData.data('def-addr-ref') || '';
    const totalCartPrice = parseInt(checkoutData.data('total-cart-price'), 10) || 0;
    const contextPath = checkoutData.data('context-path') || ''; // contextPath 읽기

    // 배송지 옵션 변경 이벤트
    $(document).on("change", "#optionSelect", function () {
        const selectedOption = this.options[this.selectedIndex];
        const homecode = selectedOption.getAttribute("data-homecode");
        const address = selectedOption.getAttribute("data-address");
        const detail = selectedOption.getAttribute("data-detail");
        const ref = selectedOption.getAttribute("data-ref");

        document.getElementById("sample6_postcode").value = homecode || '';
        document.getElementById("sample6_address").value = address || '';
        document.getElementById("sample6_detailAddress").value = detail || '';
        document.getElementById("sample6_extraAddress").value = ref || '';
    });

    // 주문자 정보와 동일 체크박스 이벤트
    const isSameCheckbox = document.getElementById("isSame");
    const recipientNameInput = document.querySelector("input[name='recipientName']");
    const recipientPhoneInput = document.querySelector("input[name='recipientPhone']");
    const addrHomecodeInput = document.querySelector("input[name='addrHomecode']"); // name='addrHomecode' 요소 확인 필요
    const addrAddressInput = document.querySelector("input[name='addrAddress']");   // name='addrAddress' 요소 확인 필요
    const addrDetailInput = document.querySelector("input[name='addrDetail']");     // name='addrDetail' 요소 확인 필요
    const addrRefInput = document.querySelector("input[name='addrRef']");

    if (isSameCheckbox) {
        isSameCheckbox.addEventListener("change", function () {
            if (this.checked) {
                recipientNameInput.value = custName;
                recipientPhoneInput.value = custPhone;
                // 기본 배송지 정보로 채우기
                if (addrHomecodeInput) addrHomecodeInput.value = defAddrHomecode;
                if (addrAddressInput) addrAddressInput.value = defAddrAddress;
                if (addrDetailInput) addrDetailInput.value = defAddrDetail;
                if (addrRefInput) addrRefInput.value = defAddrRef;
            } else {
                // 입력 필드 비우기
                recipientNameInput.value = "";
                recipientPhoneInput.value = "";
                if (addrHomecodeInput) addrHomecodeInput.value = "";
                if (addrAddressInput) addrAddressInput.value = "";
                if (addrDetailInput) addrDetailInput.value = "";
                if (addrRefInput) addrRefInput.value = "";
            }
        });
    }

    $("#couponSelect").on("change", function () {
        const couponId = $(this).val();
        if (couponId) {
            $.ajax({
                url: contextPath + "/checkcoupon",
                data: {
                    couponId: couponId,
                    price: totalCartPrice
                },
                success: function (discountedPriceStr) { // 서버에서 문자열로 반환될 수 있음
                    const discountedPrice = parseInt(discountedPriceStr, 10);
                    const discount = totalCartPrice - discountedPrice;

                    if (!isNaN(discount) && !isNaN(discountedPrice)) {
                        $("#discount_price").text("-" + discount.toLocaleString() + "원"); // 천단위 콤마 추가
                        $("#discounted_price").text(discountedPrice.toLocaleString() + "원"); // 천단위 콤마 추가
                        $("#finalAmount").val(discountedPrice); // 최종 결제 금액 hidden input 업데이트
                    } else {
                        console.warn("❗ 계산된 금액이 NaN입니다", { discountedPriceStr, totalCartPrice });
                        // 오류 처리: 할인 정보 초기화 또는 사용자 알림
                        $("#discount_price").text("-0원");
                        $("#discounted_price").text(totalCartPrice.toLocaleString() + "원");
                        $("#finalAmount").val(totalCartPrice);
                        alert("쿠폰 적용 중 금액 계산 오류가 발생했습니다.");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Coupon check error:", status, error, xhr);
                    alert("쿠폰 적용 중 오류 발생!");
                    // 오류 발생 시 할인 정보 초기화
                    $("#discount_price").text("-0원");
                    $("#discounted_price").text(totalCartPrice.toLocaleString() + "원");
                    $("#finalAmount").val(totalCartPrice);
                }
            });
        } else {
            // 쿠폰 선택 해제 시 원상 복구
            $("#discount_price").text("-0원");
            $("#discounted_price").text(totalCartPrice.toLocaleString() + "원");
            $("#finalAmount").val(totalCartPrice);
        }
    });

    // 적립금 사용
    document.getElementById("apply-point-btn").addEventListener("click", function () {
        const input = document.getElementById("point-use");
        const pointText = document.getElementById("availablePointText");
        const pointPriceSpan = document.getElementById("point_price");
        const finalPriceSpan = document.getElementById("discounted_price");
        const finalAmountInput = document.getElementById("finalAmount");
        const orderPoint = document.getElementById("orderPoint");

        const checkoutData = document.getElementById("checkout-data");
        const custPoint = parseInt(checkoutData.dataset.custPoint, 10) || 0;
        const totalPrice = parseInt(checkoutData.dataset.totalCartPrice, 10) || 0;

        const entered = parseInt(input.value, 10) || 0;


        // 유효성 검사
        if (entered % 100 !== 0) {
            alert("포인트는 100원 단위로 사용 가능합니다.");
            input.value = "";
            return;
        }

        if (entered > custPoint) {
            alert("보유 포인트를 초과할 수 없습니다.");
            input.value = "";
            return;
        }

        if (entered > totalPrice) {
            alert("주문 금액을 초과할 수 없습니다.");
            input.value = "";
            return;
        }

        // 적용 성공
        const appliedPoint = entered;

        // 포인트 사용 표시 업데이트
        pointPriceSpan.textContent = `-${appliedPoint.toLocaleString()}원`;

        console.log("orderPoint:", orderPoint);
        console.log("appliedPoint:", appliedPoint);


        // 최종 결제 금액 계산
        const finalAmount = totalPrice - appliedPoint;
        finalPriceSpan.textContent = `${finalAmount.toLocaleString()}원`;
        finalAmountInput.value = finalAmount;
        orderPoint.value = appliedPoint;


        // 사용 가능한 포인트 표시 업데이트
        const leftPoint = custPoint - appliedPoint;
        pointText.textContent = `(사용가능한 포인트: ${leftPoint.toLocaleString()}p)`;
    });

});