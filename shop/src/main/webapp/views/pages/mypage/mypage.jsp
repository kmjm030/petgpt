<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  .site-btn > a{
    color:white;
  }
  #category {
    color: rosybrown;
  }
</style>



<script>
  const mypage = {
    init:function(){
      $('#cust_update_btn').click(()=>{
        this.check();
      });
    },
    check:function(){
      let pwd = $('#pwd').val();
      let new_pwd = $('#new_pwd').val();
      let new_pwd2 = $('#new_pwd2').val();
      let nick = $('#nick').val();
      let phone = $('#phone').val();
      let email = $('#email').val();

      if(pwd == '' || pwd == null){
        $('#msg').text('수정을 위해서는 비밀번호를 입력해야 합니다.');
        $('#pwd').focus();
        return;
      }
      if(nick == '' || phone == null){
        $('#msg').text('닉네임을 입력하세요.');
        $('#nick').focus();
        return;
      }
      if(phone == '' || phone == null){
        $('#msg').text('전화번호를 입력하세요.');
        $('#phone').focus();
        return;
      }
      if(email == '' || email == null){
        $('#msg').text('이메일을 입력하세요.');
        $('#email').focus();
        return;
      }
      if ((!new_pwd || new_pwd.trim() === '') && new_pwd2 && new_pwd2.trim() !== '') {
        $('#msg').text('새 비밀번호를 입력해주세요.');
        $('#new_pwd').focus();
        return;
      }
      if (new_pwd && new_pwd.trim() !== '' && (!new_pwd2 || new_pwd2.trim() === '')) {
        $('#msg').text('새 비밀번호를 확인해주세요.');
        $('#new_pwd2').focus();
        return;
      }
      if(new_pwd != new_pwd2){
        $('#msg').text('새 비밀번호를 확인해주세요.');
        $('#new_pwd2').focus();
        return;
      }
      let c = confirm('회원정보를 수정하시겠습니까?');
      if (c == true) {
        this.send();
      }
    },
    send:function(){
      $('#cust_update_form').attr('method','post');
      $('#cust_update_form').attr('action','<c:url value="/mypage/updateimpl"/>');
      $('#cust_update_form').submit();
    },
  }
  $(function(){
    mypage.init();
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
            <span>회원정보조회/수정</span>
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
                        <li><a href="<c:url value='/mypage?id=${cust.custId}'/>"><strong id="category">회원정보</strong></a></li>
                        <li><a href="<c:url value='#'/>">주문내역</a></li>
                        <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                        <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                        <li><a href="<c:url value='#'/>">보유 쿠폰</a></li>
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
        <h6 class="checkout__title">회원 정보</h6>
        <form id="cust_update_form">
          <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="id">ID</label>
                <input type="text" value="${cust.custId}" id="id" name="custId" readonly>
              </div>
            </div>
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="name">이름</label>
                <input type="text" value="${cust.custName}" id="name" name="custName" readonly>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="nick">닉네임</label>
                <input type="text" value="${cust.custNick}" id="nick" name="custNick">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="pwd">현재 비밀번호</label>
                <input type="password" placeholder="비밀번호를 입력하세요." id="pwd" name="custPwd">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="pwd">새 비밀번호</label>
                <input type="password" placeholder="새 비밀번호를 입력하세요." id="new_pwd" name="newPwd">
              </div>
            </div>
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="pwd">새 비밀번호 확인</label>
                <input type="password" placeholder="새 비밀번호를 확인하세요." id="new_pwd2" name="newPwd2">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="phone">전화번호</label>
                <input type="tel" value="${cust.custPhone}" id="phone" name="custPhone">
              </div>
            </div>
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="email">이메일</label>
                <input type="email" value="${cust.custEmail}" id="email" name="custEmail">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-md-6">
              <div class="checkout__input">
                <label for="point">포인트</label>
                <input type="number" value="${cust.custPoint}" id="point" name="custPoint" readonly>
              </div>
            </div>
          </div>
          <input type="hidden" value="${sessionScope.cust.custId}" id="sessionId" name="id">
        </form>
        <h6 id="msg">${msg}</h6>
        <br/><br/>
        <div class="checkout__order">
          <button class="site-btn" id="cust_update_btn">정보 수정하기</button>
        </div>
      </div>
    </div>
  </div>
</section>

