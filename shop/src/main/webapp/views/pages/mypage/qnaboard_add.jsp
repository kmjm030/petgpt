<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Select2 CSS -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

<!-- jQuery + Select2 JS -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

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
  const qna_add = {
    init:function(){
      // Select2 초기화
      $('#itemSelect').addClass('select2');
      $('#itemSelect').select2({
        placeholder: "상품을 선택하세요",
        allowClear: true,
        minimumResultsForSearch: 0
      });

      // niceSelect는 select2 제외하고 적용
      $('select').not('.select2').niceSelect();

      // 초기상태가 '상품문의'이면 select2보이도록
      if ($('#optionSelect').val() === '상품문의') {
        $('#itemSelectWrapper').show();
      }

      // 문의 종류 변경 이벤트
      $('#optionSelect').on('change', function () {
        const selectedOption = $(this).val();

        if (selectedOption === '상품문의') {
          $('#itemSelectWrapper').show();
        } else {
          $('#itemSelectWrapper').hide();
          $('#itemSelect').val(null).trigger('change'); // 아이템 선택값 초기화
        }
      });

      $('#qna_add_btn').click(()=>{
        this.check();
      });
    },
    check:function(){
      let title = $('#boardTitle').val();
      let content = $('#boardContent').val();
      let option = $('#optionSelect').val();
      let item = $('#itemSelect').val();

      if(title == '' || title == null){
        $('#msg').text('제목을 입력하세요.');
        $('#boardTitle').focus();
        return;
      }
      if(content == '' || content == null){
        $('#msg').text('문의 내용을 입력하세요');
        $('#boardContent').focus();
        return;
      }
      if(option == '상품문의'){
        if(item == '' || item == null){
          $('#msg').text('문의하실 상품을 선택하세요.');
          $('#itemSelect').focus();
          return;
        }
      }
      let c = confirm('문의글을 등록하시겠습니까?');
      if (c == true) {
        this.send();
      }
    },
    send:function(){
      $('#qna_add_form').attr('method','post');
      $('#qna_add_form').attr('action','<c:url value="/qnaboard/addimpl"/>');
      $('#qna_add_form').submit();
    },
  }
  $(function(){
    qna_add.init();
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
            <a href="<c:url value='/qnaboard'/>">1:1문의</a>
            <span>문의 등록</span>
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
                        <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                        <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                        <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                        <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>"><strong id="category">1:1문의</strong></a></li>
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
          <h6 class="checkout__title">❓ 1:1 문의 등록하기</h6>
          <form id="qna_add_form">
            <%-- 문의종류 --%>
            <div class="row">
              <div class="form-group col-md-12">
                <h6>▪ 문의 종류 </h6><br/>
                <select class="form-select" id="optionSelect" name="boardOption">
                  <option value="상품문의">상품문의</option>
                  <option value="배송문의">배송문의</option>
                  <option value="교환/환불문의">교환/환불문의</option>
                  <option value="기타문의">기타문의</option>
                </select>
              </div>
            </div><br>
              <div class="row" id="itemSelectWrapper" style="display:none;">
                <div class="form-group col-md-12">
                  <h6>▪ 상품 선택 </h6><br/>
                  <select class="select2" id="itemSelect" name="itemKey">
                    <option disabled selected hidden>상품을 선택하세요</option>
                    <c:forEach var="c" items="${items}">
                      <option value="${c.itemKey}">${c.itemName}</option>
                    </c:forEach>
                  </select>
                </div>
              </div><br>
            <div class="row">
              <div class="form-group col-md-12">
                <div class="checkout__input">
                  <label for="boardTitle">▪ 제목</label>
                  <input type="text" placeholder="제목을 입력하세요." id="boardTitle" name="boardTitle">
                  <input type="hidden" value="${sessionScope.cust.custId}" id="sessionId" name="custId">
                </div>
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-12">
                <div class="checkout__input">
                  <label for="boardContent">▪ 내용</label><br/>
                  <textarea placeholder="문의내용을 작성하세요." id="boardContent" name="boardContent"></textarea>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-6">
                <label>▪ 대표 이미지</label>
                <input type="file" class="form-control" name="img1">
              </div>
            </div>
            <br/>
          </form>
          <h6 id="msg"></h6>
          <br/><br/>
          <div class="checkout__order">
            <button class="site-btn" id="qna_add_btn">등록하기</button>
          </div>
        </div>
    </div>
  </div>
</section>
