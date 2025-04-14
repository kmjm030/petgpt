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
    const address = {
        init:function(){

        },
        del:function(addrKey){
            console.log("Deleting address with addrKey: " + addrKey);
            let c = confirm('배송지를 삭제 하시겠습니까 ?');
            if(c == true){
                location.href='<c:url value="/address/delimpl?addrKey='+addrKey+'"/>';
            }
        }
    }
    $(function(){
        address.init();
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
                        <a href="<c:url value='#'/>">mypage</a>
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
                                                <li><a href="<c:url value='/mypage?id=${cust.custId}'/>">회원정보</a></li>
                                                <li><a href="<c:url value='#'/>">주문내역</a></li>
                                                <li><a href="<c:url value='/address?id=${cust.custId}'/>"><strong id="category">배송지 목록</strong></a></li>
                                                <li><a href="<c:url value='#'/>">찜 목록</a></li>
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
                <h6 class="checkout__title">배송지 목록</h6>
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>배송지 이름</th>
                        <th>우편번호</th>
                        <th>주소</th>
                        <th></th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="c" items="${address}">
                        <tr>
                            <td>${c.addrName}</td>
                            <td>${c.addrHomecode}</td>
                            <td>${c.addrAddress}</td>
                            <td>${c.addrDetail}</td>
                            <td>
                                <button id="addr_mod_btn" onclick="location.href='<c:url value='/address/mod?addrKey='/>${c.addrKey}'">수정</button>
                            </td>
                            <td>
                                <button id="addr_del_btn" onclick="address.del(${c.addrKey})">삭제</button>
                            </td>
<%--                            <td class="cart__close">--%>
<%--                                <i class="fa fa-close"></i>--%>
<%--                            </td>--%>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <br/><br/>
                <div class="checkout__order">
                    <button class="site-btn" id="addr_add_btn"
                            onclick="location.href='<c:url value='/address/add'/>'">
                        주소 추가하기
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>
