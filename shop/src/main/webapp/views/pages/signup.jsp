
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #msg, #id_msg, #nick_msg{
    color: darkred;
  }
</style>

<script>
  const register = {
    init:function() {
      $('#register_btn').click(() => {
        this.check();
      });
      $('#id').keyup(() => {
        let id = $('#id').val();
        if (id.length >= 2) {
          $('#id_msg').text(id);
          this.checkId(id);
        }
      });
      $('#nick').keyup(() => {
        let nick = $('#nick').val();
        if (nick.length >= 2) {
          $('#nick_msg').text(nick);
          this.checkNick(nick);
        }
      });
    },
    check:function(){
      let id = $('#id').val();
      let pwd = $('#pwd').val();
      let pwd2 = $('#pwd2').val();
      let name = $('#name').val();
      let nick = $('#nick').val();
      let phone = $('#phone').val();
      let email = $('#email').val();
      let address = $('#sample6_detailAddress').val();

      console.log('ID: %s, PWD: %s, NAME: %s',id,pwd, name);
      if(id == '' || id == null){
        $('#msg').text('ID를 입력하세요.');
        $('#id').focus();
        return;
      }
      if(pwd == '' || pwd == null){
        $('#msg').text('비밀번호를 입력하세요.');
        $('#pwd').focus();
        return;
      }
      if(name == '' || name == null){
        $('#msg').text('이름을 입력하세요.');
        $('#name').focus();
        return;
      }
      if(pwd2 == '' || pwd2 == null){
        $('#msg').text('비밀번호를 확인해주세요.');
        $('#pwd2').focus();
        return;
      }
      if(pwd != pwd2){
        $('#msg').text('패스워드가 틀립니다.다시 입력하세요');
        $('#pwd2').focus();
        return;
      }
      if(phone == '' || phone == null){
        $('#msg').text('전화번호를 입력하세요');
        $('#phone').focus();
        return;
      }
      if(email == '' || email == null){
        $('#msg').text('이메일을 입력하세요');
        $('#email').focus();
        return;
      }
      if(address == '' || address == null){
        $('#msg').text('기본 배송지를 입력하세요');
        $('#sample6_detailAddress').focus();
        return;
      }
      let c = confirm('회원가입 하시겠습니까?');
      if (c == true) {

        this.send();
      }
    },
    checkId:function(id){
      $.ajax({
        url:'<c:url value="/checkid"/>',
        data:{cid:id},
        success:(result)=>{
          //alert(result);
          if(result == 1){
            $('#id_msg').text('사용 가능한 아이디입니다.');
            $('#id').off('blur');
          }else{
            $('#id_msg').text('이미 존재하는 아이디입니다.');
            $('#id').blur(()=>{
              $('#id').focus();
            });
          }
        },
        error:()=>{}
      });
    },
    checkNick:function(nick){
      $.ajax({
        url:'<c:url value="/checknick"/>',
        data:{nick:nick},
        success:(result)=>{
          //alert(result);
          if(result == 1){
            $('#nick_msg').text('사용 가능한 닉네임입니다.');
            $('#nick').off('blur');
          }else{
            $('#nick_msg').text('이미 존재하는 닉네임입니다.');
            $('#id').blur(()=>{
              $('#nick').focus();
            });
          }
        },
        error:()=>{}
      });
    },
    send:function(){
      $('#register_form').attr('method','post');
      $('#register_form').attr('action','<c:url value="/goregister"/>');
      $('#register_form').submit();
    }
  }
  $(function(){
    register.init();
  });
</script>




<!-- Breadcrumb Section Begin -->
<section class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__text">
                    <h4>Sign Up</h4>
                    <div class="breadcrumb__links">
                        <a href="<c:url value='/'/>">Home</a>
                        <span>Sign up</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Breadcrumb Section End -->

<section class="checkout spad">
  <div class="container">
    <div class="checkout__form">
      <h6 class="checkout__title">회원 정보 기입</h6>
      <div class="row">
        <div class="col-lg-12">
          <form id="register_form">
            <%-- 아이디 입력 --%>
            <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="id">ID <h6 id="id_msg"></h6></label>
                <input type="text" placeholder="아이디를 입력하세요." id="id" name="custId">
              </div>
            </div>
            </div>
            <%-- 비밀번호 입력 --%>
            <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="pwd">비밀번호</label>
                <input type="password" placeholder="비밀번호를 입력하세요." id="pwd" name="custPwd">
              </div>
            </div>
              <%-- 비밀번호 확인--%>
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="pwd">비밀번호 확인</label>
                <input type="password" placeholder="비밀번호를 확인하세요." id="pwd2">
              </div>
            </div>
            </div>
            <%-- 이름 입력 --%>
            <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="name">이름</label>
                <input type="text" placeholder="이름을 입력하세요." id="name" name="custName">
              </div>
            </div>
            </div>
            <%-- 닉네임 입력 --%>
            <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="nick">닉네임 <h6 id="nick_msg"></h6></label>
                <input type="text" placeholder="닉네임을 입력하세요." id="nick" name="custNick">
              </div>
            </div>
            </div>
            <%-- 전화번호/이메일 입력 --%>
            <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="phone">전화번호</label>
                <input type="tel" placeholder="예) 010-1234-5678" id="phone" name="custPhone">
              </div>
            </div>
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="email">이메일</label>
                <input type="email" placeholder="예) petgpt@naver.com" id="email" name="custEmail">
              </div>
            </div>
            </div>
            <%-- 배송지 입력 --%>
            <div class="form-group">
              <div class="checkout__input">
                <label for="sample6_address">기본배송지입력</label>
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
          </form>
<%--          <c:choose>--%>
<%--            <c:when test="${msg != null}">--%>
<%--              <h6 id="msg">${msg}</h6>--%>
<%--              <br/><br/>--%>
<%--            </c:when>--%>
<%--            <c:otherwise>--%>
<%--              <h6></h6>--%>
<%--            </c:otherwise>--%>
<%--          </c:choose>--%>
          <h6 id="msg"></h6>
          <br/><br/>
          <div class="checkout__order">
            <button class="site-btn" id="register_btn">가입하기</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>


