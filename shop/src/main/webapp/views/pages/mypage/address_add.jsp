<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .site-btn > a{
        color:white;
    }
    #category {
        color: rosybrown;
    }
    #msg{
        color:darkred;
    }
</style>

<script>
    const addr_add = {
        init:function(){
            $('#addr_add_btn').click(()=>{
                this.check();
            });
        },
        check:function(){
            let name = $('#addrName').val();
            let phone = $('#addrTel').val();
            let address = $('#sample6_detailAddress').val();

            if(name == '' || name == null){
                $('#msg').text('배송지 이름을 입력하세요.');
                $('#name').focus();
                return;
            }
            if(phone == '' || phone == null){
                $('#msg').text('수령인 전화번호를 입력하세요');
                $('#phone').focus();
                return;
            }
            if(address == '' || address == null){
                $('#msg').text('배송지를 입력하세요');
                $('#sample6_detailAddress').focus();
                return;
            }
            let c = confirm('배송지를 등록하시겠습니까?');
            if (c == true) {
                this.send();
            }
        },
        send:function(){
            $('#addr_add_form').attr('method','post');
            $('#addr_add_form').attr('action','<c:url value="/address/addimpl"/>');
            $('#addr_add_form').submit();
        },
    }
    $(function(){
        addr_add.init();
    });
</script>


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
            <%--      옆 사이드 바(마이페이지 카테고리) --%>
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
                                            <ul class="nice-scroll">
                                                <li><a href="<c:url value='/mypage?id=${cust.custId}'/>">회원정보</a></li>
                                                <li><a href="<c:url value='#'/>">주문내역</a></li>
                                                <li><a href="<c:url value='/address?id=${cust.custId}'/>"><strong id="category">배송지 목록</strong></a></li>
                                                <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                                                <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                                                <li><a href="<c:url value='#'/>">1:1문의</a></li>
                                                <li><a href="<c:url value='#'/>">내가 작성한 리뷰</a></li>
                                            </ul>
                                            <br/><br/>
                                            <button class="site-btn" id="logout_btn"><a href="<c:url value="/logout"/>">로그아웃</a></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <%--    회원 정보 --%>
            <div class="col-lg-9">
                    <h6 class="checkout__title">배송지 등록</h6>
                    <form id="addr_add_form">
                        <div class="row">
                            <div class="form-group col-md-6">
                                <div class="checkout__input">
                                    <label for="addrName">배송지 이름</label>
                                    <input type="text" placeholder="배송지 이름을 입력하세요." id="addrName" name="addrName">
                                    <input type="hidden" value="${sessionScope.cust.custId}" id="sessionId" name="custId">
                                </div>
                            </div>
                            <div class="form-group col-md-6">
                                <div class="checkout__input">
                                    <label for="addrTel">수령인 전화번호</label>
                                    <input type="tel" placeholder="전화번호를 입력하세요." id="addrTel" name="addrTel">
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="checkout__input">
                                <label for="sample6_address">주소 입력</label><br/>
                                <div class="checkout__input">
                                    <input type="text" id="sample6_postcode" placeholder="우편번호" name="addrHomecode">
                                    <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
                                    <input type="text" id="sample6_address" placeholder="주소" name="addrAddress"><br>
                                    <input type="text" id="sample6_detailAddress" placeholder="상세주소" name="addrDetail">
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
                        <br/>
                        <div class="form-check form-switch form-group">
                            <input class="form-check-input" type="checkbox" id="addrDef" name="addrDef" value="Y">
                            <label class="form-check-label" for="addrDef">이 배송지를 기본 배송지로 저장합니다.</label>
                            <%-- checkbox에 체크를 하면, isDefault가 yes의 값으로 보내짐 --%>
                        </div>

                    </form>
                    <h6 id="msg">${msg}</h6>
                    <br/><br/>
                    <div class="checkout__order">
                        <button class="site-btn" id="addr_add_btn">등록하기</button>
                    </div>
                </div>
        </div>
    </div>
</section>
