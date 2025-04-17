<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #orderlist_btn {
    margin-top: 50px;
  }
</style>


<!-- Checkout Section Begin -->
<section class="checkout spad">
  <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div>
               <h3 class="checkout__title" style="text-align:center;">주문 완료</h3>
            </div><br/>
            <h6 style="text-align:center;"> 주문이 완료되었습니다. 꼼꼼히 포장해서 보내드릴게요!📦</h6>
          </div>
          <div class="col-lg-12" style="text-align: center;">
              <button type="button" id="orderlist_btn" class="site-btn"
                      onclick="location.href='<c:url value='/checkout/orderlist?id=${sessionScope.cust.custId}'/>'">
                  주문내역 확인하러 가기🐾
              </button>
          </div>
          <div class="col-lg-12">
            <br/>
        </div>
        </div>
  </div>
</section>
<!-- Checkout Section End -->