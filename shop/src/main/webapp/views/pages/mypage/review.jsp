<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">


      <style>
        .site-btn>a {
          color: white;
        }

        #category {
          color: rosybrown;
        }

        #like_img {
          width: 150px;
          height: 150px;
        }

        #like_del_icon {
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
      </style>

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

      <!-- Data for JS -->
      <div id="review-data" style="display: none;" data-context-path="${pageContext.request.contextPath}">
      </div>

      <section class="shop spad">
        <div class="container">
          <div class="row">
            <%-- 옆 사이드 바(마이페이지 카테고리) --%>
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
                                <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a></li>
                                <li><a href="<c:url value='/review?id=${cust.custId}'/>"><strong id="category">내가 작성한
                                      리뷰</strong></a></li>
                              </ul>
                              <br /><br />
                              <button class="site-btn" id="logout_btn"><a href="<c:url value="
                                  /logout" />">로그아웃</a></button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <%-- 회원 정보 --%>
                <div class="col-lg-9 container mt-3">
                  <h6 class="checkout__title">📝 내가 작성한 리뷰</h6>
                  <c:forEach var="c" items="${reviews}">
                    <div>
                      <div class="row">
                        <div class="col-lg-2">
                          <img src="<c:url value=" /img/product/${c.item.itemImg1}" />" width="100"
                          style="border-radius:10px";>
                        </div>
                        <div class="col-lg-10">
                          <h5><strong>[${c.item.itemName}]</strong></h5>
                          <div>
                            <fmt:formatDate value="${c.boardRdate}" pattern="yyyy-MM-dd HH:mm" />
                          </div>
                          <!-- 별점 표시 추가 -->
                          <div class="star-rating mb-2">
                            <c:forEach var="i" begin="1" end="5">
                              <c:choose>
                                <c:when test="${i <= c.boardScore}">
                                  <i class="bi bi-star-fill text-warning"></i>
                                </c:when>
                                <c:otherwise>
                                  <i class="bi bi-star"></i>
                                </c:otherwise>
                              </c:choose>
                            </c:forEach>
                          </div>
                          <div class="review-content-box">
                            "${c.boardContent}"<br /><br />
                            <c:if test="${not empty c.boardImg}">
                              <img src="<c:url value='${c.boardImg}'/>" alt="현재 첨부파일" width="200">
                            </c:if>
                          </div>

                        </div>
                      </div>
                      <div class="row">
                        <div class="col-lg-6">
                          <div><button class="site-btn review-site-btn"
                              onclick="location.href='<c:url value='/review/detail?boardKey='/>${c.boardKey}'">수정하기</button>
                          </div>
                        </div>
                        <div class="col-lg-6">
                          <div><button class="site-btn review-site-btn"
                              onclick="review.del(${c.boardKey})">삭제하기</button></div>
                        </div>
                      </div>

                    </div>
                    <hr>
                  </c:forEach>
                </div>
          </div>
        </div>
      </section>