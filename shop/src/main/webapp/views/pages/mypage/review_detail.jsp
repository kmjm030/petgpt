<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">


<style>
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

  #boardContent{
    height: 300px;
    width: 100%;
    border: 1px solid #e1e1e1;
    font-size: 14px;
    color: gray;
    padding: 20px;
    margin-bottom: 20px;
  }
  textarea::placeholder, input::placeholder {
    color: #b7b7b7;
  }
  .star-rating i {
    font-size: 2rem;
    color: lightgray;
    cursor: pointer;
    transition: color 0.2s;
  }
  .review-box {
    text-align: center;
  }


</style>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const stars = document.querySelectorAll('.star-rating i');
    const ratingInput = document.getElementById('rating');

    const initialRating = parseInt(ratingInput.value);
    stars.forEach((s, i) => {
      if (i < initialRating) {
        s.classList.remove('bi-star');
        s.classList.add('bi-star-fill');
        s.classList.add('text-warning');
      } else {
        s.classList.remove('bi-star-fill');
        s.classList.add('bi-star');
        s.classList.remove('text-warning');
      }
    });

    stars.forEach((star, idx) => {
      star.addEventListener('click', () => {
        const rating = parseInt(star.getAttribute('data-value'));
        ratingInput.value = rating;

        stars.forEach((s, i) => {
          if (i < rating) {
            s.classList.remove('bi-star');
            s.classList.add('bi-star-fill');
            s.classList.add('text-warning');
          } else {
            s.classList.remove('bi-star-fill');
            s.classList.add('bi-star');
            s.classList.remove('text-warning');
          }
        });
      });
    });
  });
</script>

<script>
  const review_detail = {
    init:function(){
      $('#review_update_btn').click(()=>{
        this.check();
      });
    },
    check:function(){
      let content = $('#boardContent').val();
      let score = $('#rating').val();

      if(content == '' || content == null){
        $('#msg').text('리뷰를 작성해주세요.');
        $('#boardContent').focus();
        return;
      }
      if(score == null || score == 0){
        $('#msg').text('별점을 선택해주세요.');
        $('#boardContent').focus();
        return;
      }
      let c = confirm('후기를 수정하시겠습니까?');
      if (c == true) {
        this.send();
      }
    },
    send:function(){
      $('#review_update_form').attr('method','post');
      $('#review_update_form').attr('action','<c:url value="/review/updateimpl"/>');
      $('#review_update_form').submit();
    },
  }
  $(function(){
    review_detail.init();
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
            <span>내가 작성한 리뷰</span>
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
                        <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>">주문내역</a></li>
                        <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                        <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                        <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                        <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a></li>
                        <li><a href="<c:url value='/review?id=${cust.custId}'/>"><strong id="category">내가 작성한 리뷰</strong></a></li>
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
      <div class="col-lg-9 container mt-3 review-box">
        <h6 class="checkout__title">📝 리뷰 상세페이지</h6>
        <form id="review_update_form" enctype="multipart/form-data">
          <%-- 문의종류 --%>
          <div class="row">
            <div class="col-lg-12">
            <img src="<c:url value='/img/product/${board.item.itemImg1}'/>" width="300" style="border-radius:20px; display: block; margin: 0 auto;"/>
            </div>
          </div>
            <div style="margin:20px;">
              <h4><strong>${item.itemName}</strong></h4>
              <p>${option.optionName}</p>
            </div>
            <div style="margin: 40px;">
              받아보신 상품은 어떠셨나요? 후기를 남겨주세요!<br>
              매달 베스트리뷰어를 선정해 3000포인트를 선물로 드려요✨
            </div>
          <div class="row">
            <div class="form-group col-md-12">
              <div class="checkout__input">
                <div class="star-rating mb-3">
                  <input type="hidden" name="boardScore" id="rating" value="${board.boardScore}">
                  <i class="bi bi-star" data-value="1"></i>
                  <i class="bi bi-star" data-value="2"></i>
                  <i class="bi bi-star" data-value="3"></i>
                  <i class="bi bi-star" data-value="4"></i>
                  <i class="bi bi-star" data-value="5"></i>
                </div>
                <textarea placeholder="리뷰를 작성하세요." id="boardContent" name="boardContent">${board.boardContent}</textarea>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="form-group col-md-6">
              <input type="file" class="form-control" name="img">
              <input type="hidden" value="${sessionScope.cust.custId}" id="sessionId" name="custId">
              <input type="hidden" name="boardKey" value="${board.boardKey}" />
              <input type="hidden" name="boardTitle" value="리뷰" />
            </div>
            <c:if test="${not empty board.boardImg}">
              <div class="row">
                <div class="form-group col-md-6">
                  <img src="<c:url value='${board.boardImg}'/>" alt="현재 첨부파일" width="400">
                </div>
              </div>
            </c:if>
          </div>
          <br/>
        </form>
        <h6 id="msg"></h6>
        <br/><br/>
        <div class="checkout__order">
          <button class="site-btn" id="review_update_btn">수정하기</button>
        </div>
      </div>
    </div>
  </div>
</section>
