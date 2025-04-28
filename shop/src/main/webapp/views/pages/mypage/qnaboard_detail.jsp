<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
  .nice-select.select2 {
    display: none !important;
  }
  #msg{
    color: darkred;
  }

</style>

<script>
  const qnaboard_detail = {
    init:function(){
      $('#qna_update_btn').click(()=>{
        this.check();
      });
    },
    check:function(){
      let title = $('#boardTitle').val();
      let content = $('#boardContent').val();

      if(title == '' || title == null){
        $('#msg').text('제목을 입력하세요.');
        $('#boardTitle').focus();
        return;
      }
      if(content == '' || content == null){
        $('#msg').text('문의 내용을 작성하세요.');
        $('#boardContent').focus();
        return;
      }
      let c = confirm('문의글을 수정하시겠습니까?');
      if (c == true) {
        this.send();
      }
    },
    send:function(){
      $('#qna_update_form').attr('method','post');
      $('#qna_update_form').attr('action','<c:url value="/qnaboard/updateimpl"/>');
      $('#qna_update_form').submit();
    },
  }
  $(function(){
    qnaboard_detail.init();
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
            <a href="<c:url value='/mypage'/>">마이페이지</a>
            <a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a>
            <span>문의 상세정보</span>
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
                        <li><a href="<c:url value='/pet?id=#${cust.custId}'/>">나의 펫 정보</a></li>
                        <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>">주문내역</a></li>
                        <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                        <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                        <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                        <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>"><strong id="category">1:1문의</strong></a></li>
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
        <div class="col-lg-9">
          <h6 class="checkout__title">❓ 1:1 문의 상세정보</h6>
          <form id="qna_update_form" enctype="multipart/form-data">
            <%-- 문의종류 --%>
            <div class="row">
              <div class="form-group col-md-12">
                <div class="checkout__input">
                  <label for="boardTitle">▪ 제목</label>
                  <input type="text" placeholder="제목을 입력하세요." value="${board.boardTitle}" id="boardTitle" name="boardTitle">
                  <input type="hidden" value="${sessionScope.cust.custId}" id="sessionId" name="custId">
                  <input type="hidden" name="boardKey" value="${board.boardKey}" />
                </div>
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-12">
                <div class="checkout__input">
                  <label for="boardContent">▪ 내용</label><br/>
                  <textarea placeholder="문의내용을 작성하세요." id="boardContent" name="boardContent">${board.boardContent}</textarea>
                </div>
              </div>
            </div>
              <c:if test="${not empty board.boardImg}">
                <div class="row">
                  <div class="form-group col-md-6">
                    <label>▪ 현재 이미지파일 </label>
                    <img src="<c:url value='${board.boardImg}'/>" alt="현재 첨부파일">
                  </div>
                </div>
              </c:if>
            <div class="row">
                <div class="form-group col-md-6">
                  <label>▪ 이미지 첨부</label>
                  <input type="file" class="form-control" name="img">
                </div>
              </div>
            <br/>
          </form>
          <h6 id="msg"></h6>
          <br/>
          <div class="checkout__order">
            <button class="site-btn" id="qna_update_btn">수정하기</button>
          </div>
        </div>
    </div>
  </div>
</section>
