<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

</style>

<script>
  const like = {
    init:function(){

    },
    del:function(boardKey){
      let c = confirm('문의글을 삭제하시겠습니까?');
      if(c == true){
        location.href = '<c:url value="/qnaboard/delimpl?boardKey="/>' + boardKey;
      }
    }
  }
  $(function(){
    like.init();
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
            <span>주문내역조회</span>
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
                        <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>"><strong id="category">주문내역</strong></a></li>
                        <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                        <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                        <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                        <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a></li>
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
      <div class="col-lg-9 container mt-3">
          <h6 class="checkout__title">🔎 주문내역 조회</h6>
          <table class="table">
            <thead>
            <tr>
              <th>주문번호</th>
              <th>대표상품</th>
              <th>주문일자</th>
              <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${orderList}">
              <tr>
                <td>${c.orderKey}</td>
                <td><strong>${itemNames[c.orderKey]}</strong></td>
                <td><fmt:formatDate value="${c.orderDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                <td>
                  <button id="order_detail_btn" onclick="location.href='<c:url value='/checkout/detail?orderKey='/>${c.orderKey}'">상세보기</button>
                </td>
              </tr>
            </c:forEach>
            </tbody>
          </table>
          <br/><br/>
        </div>
    </div>
  </div>
</section>
