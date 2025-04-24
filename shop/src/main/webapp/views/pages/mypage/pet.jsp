<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">


<style>
  .btn-check:checked + .btn-outline-primary {
    background-color: #0d6efd;
    color: white;
  }

  .btn-check:checked + .btn-outline-pink {
    background-color: #e83e8c;
    color: white;
  }

  .btn-outline-pink {
    border: 1px solid #e83e8c;
    color: #e83e8c;
  }
  .site-btn > a{
    color:white;
  }
  #category {
    color: rosybrown;
  }
  #like_img {
    width: 150px;
    height: 150px;
  }
  #like_del_icon{
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
  .review-site-btn {
    width: 100%;
    border-radius: 10px;
    background-color: white;
    color: black;
    border: 3px solid black;
    border-radius: 20px;
  }
  .review-content-box {
    margin: 10px 0 20px 0;
    padding: 20px;
    border: solid 1px lightgray;
  }
  .pet-box {
    margin: 10px;
    padding: 15px;
    background-color: white;
    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
    border-radius: 10px;
  }
  .pet-name-box {
    margin-top: 10px;
    padding:10px;
  }
  .pet-img-box {
    margin: 10px;
    width: 100%;

  }
  .modal-content {
    background-color: #fff;
    position: relative;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%); /* 중앙 정렬 핵심! */
    width: 600px; /* 너비 조절 (원하는 값으로) */
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    max-height: 80vh;
    overflow-y: auto;
  }

  .modal-input-box {
    margin: 10px;
  }


</style>

<script>
  function openModal() {
    document.getElementById("petModal").style.display = "block";
    pet.info();
  }

  function closeModal() {
    document.getElementById("petModal").style.display = "none";
  }

  // 바깥 클릭 시 닫기
  window.onclick = function(event) {
    const modal = document.getElementById("petModal");
    if (event.target === modal) {
      modal.style.display = "none";
    }
  }
</script>

<script>
  const pet = {
    init:function(){
      $('#uploadFile').change(function(e) {
        const file = e.target.files[0];
        if (file) {
          const reader = new FileReader();
          reader.onload = function(e) {
            $('#profile-img').attr('src', e.target.result);  // 이미지 미리보기 변경
          };
          reader.readAsDataURL(file);
        }
      });

      $('#cust_update_btn').click(()=>{
        this.check();
      });
    },
    info:function(){
      console.log("pet.info() 호출됨");
      $('#petName').on('input', function () {
        const name = $(this).val();
        $('#modal-pet-name').text(name || '');
      });
      $('#petType').on('change', function () {
        let type = $(this).val();
        if(type == 'dog'){
          type = "🐶"
        }else if(type == 'cat'){
          type = "🐱"
        }
        $('#modal-pet-type').text(type);
      });
      $('#petBreed').on('input', function () {
        const breed = $(this).val();
        $('#modal-pet-breed').text('▪ 종: ' + breed || '');
      });
      $('#petGender').on('input', function () {
        let gender = $(this).val();
        if(gender == 'F'){
          gender = "여자"
        }else if(gender == 'M'){
          gender = "남자"
        }
        $('#modal-pet-gender').text('▪ 성별: ' + gender || '');
      });

      $('#petBirthdate').on('input', function () {
        const birth = $(this).val();
        if (birth) {
          $('#modal-pet-birthdate').text('▪ 생년월일: ' + birth);
        } else {
          $('#modal-pet-birthdate').text('▪ 생년월일: ');
        }
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
    imgDelete:function(){
      $('#imgDeleteFlag').val('true');
      $('#profile-img').attr('src', '<c:url value="/img/clients/profile.png"/>');


    },
    send:function(){
      $('#cust_update_form').attr('method','post');
      $('#cust_update_form').attr('action','<c:url value="/mypage/updateimpl"/>');
      $('#cust_update_form').submit();
    },
  }
  $(function(){
    pet.init();
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
            <span>나의 펫 정보</span>
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
                      <ul>
                        <li><a href="<c:url value='/mypage?id=${cust.custId}'/>">회원정보</a></li>
                        <li><a href="<c:url value='/pet?id=#${cust.custId}'/>"><strong id="category">나의 펫 정보</strong></a></li>
                        <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>">주문내역</a></li>
                        <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                        <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                        <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                        <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a></li>
                        <li><a href="<c:url value='/review?id=${cust.custId}'/>">내가 작성한 리뷰</a></li>
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
      <div class="col-lg-9 container mt-3">
        <h6 class="checkout__title">🐶 나의 펫 정보'

        </h6>
        <div class="row">
          <div class="col-md-6">
            <div class="pet-box">
              <div class="row">
                <div class="col-md-6">
                  <div class="pet-img-box">
                    <img src="<c:url value='/img/clients/profile.png'/>">
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="pet-name-box"><h5>🐶 <strong>강아지 이름</strong></h5></div>
                  <hr>
                  <div class="pet-desc-box">
                    <div>▪ 생일: 2022.01.12</div>
                    <div>▪ 성별: 여자</div>
                    <div>▪ 종류: 푸들</div>
                  </div>
                </div>
              </div>
          </div>
        </div>
      </div>
        <hr>
        <div class="checkout__order">
          <button class="site-btn" id="pet_add_btn" onclick="openModal()">반려동물 등록하기</button>
        </div>
    </div>
  </div>
  </div>
</section>

<%--모달창--%>
<div id="petModal" class="modal" style="display: none;">
  <div class="modal-content" style="background-color:#edede9">
    <span class="close-btn" onclick="closeModal()">&times;</span>
    <h4 style="text-align:center">반려동물 등록카드 만들기🐾</h4>
    <hr>
    <!-- 내용시작 -->
    <div class="row">
      <div class="col-md-12">
        <div class="pet-box">
          <div class="row">
            <div class="col-md-6">
              <div class="pet-img-box">
                <img id="profile-img" src="<c:url value='/img/clients/profile.png'/>">
              </div>
            </div>
            <div class="col-md-6">
              <div class="pet-name-box"><strong id="modal-pet-type"></strong>  <strong id="modal-pet-name">이름</strong></div>
              <hr>
              <div class="pet-desc-box">
                <div id="modal-pet-birthdate">▪ 생년월일:</div>
                <div id="modal-pet-gender">▪ 성별:</div>
                <div id="modal-pet-breed">▪ 종:</div>
                <input type="file" id="uploadFile" name="img" hidden><br><br>
                <label for="uploadFile" class="btn btn-light">📁 이미지 찾기</label>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div><hr>
    <div class="row">
      <div class="form-group col-md-6">
        <div class="checkout__input">
          <label for="petName">✔ 이름</label>
          <input type="text" placeholder="이름을 입력하세요." id="petName" name="petName">
          <input type="hidden" value="${sessionScope.cust.custId}" id="custId" name="custId">
        </div>
      </div>
      <div class="form-group col-md-6">
        <div class="checkout__input">
          <label for="petType">✔ 강아지?고양이?</label><br/>
          <select id="petType" class="form-select" name="petType">
            <option value="">선택하세요!</option>
            <option value="dog">🐶 강아지</option>
            <option value="cat">🐱 고양이</option>
          </select>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="form-group col-md-6">
        <div class="checkout__input">
          <label for="petBreed">✔ 종</label>
          <input type="text" placeholder="종을 입력하세요." id="petBreed" name="petBreed">
        </div>
      </div>
      <div class="form-group col-md-6">
        <div class="checkout__input">
          <label for="petBirthdate">✔ 생일</label>
          <input type="date" id="petBirthdate" name="petBirthdate">
        </div>
      </div>
    </div>
    <!-- 성별 라디오 버튼 추가 -->
    <!-- ... -->
</div>
</div>
