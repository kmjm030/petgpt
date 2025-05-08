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

        .pet-box {
          margin: 10px;
          padding: 15px;
          background-color: white;
          box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
          border-radius: 10px;
          transition: transform 0.3s ease
        }

        .pet-box:hover {
          transform: translateY(-8px) scale(1.02) rotateZ(0.3deg);
          box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }

        .pet-name-box {
          margin-top: 10px;
          padding: 10px;
        }

        .pet-img-box img {
          margin: 10px;
          width: 100%;
          aspect-ratio: 1 / 1;
        }

        .modal-content {
          background-color: #fff;
          position: relative;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          /* 중앙 정렬 핵심! */
          width: 600px;
          /* 너비 조절 (원하는 값으로) */
          padding: 20px;
          border-radius: 10px;
          box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
          max-height: 95vh;
          overflow-y: auto;
        }

        .modal-input-box {
          margin: 10px;
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
                  <span>나의 펫 정보</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- Breadcrumb Section End -->

      <!-- Data for JS -->
      <div id="pet-data" style="display: none;" data-context-path="${pageContext.request.contextPath}"
        data-default-profile-img="<c:url value='/img/clients/profile.png'/>">
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
                          <a data-toggle="collapse">나의 정보</a>
                        </div>
                        <div id="collapseOne" class="collapse show" data-parent="#accordionExample">
                          <div class="card-body">
                            <div class="shop__sidebar__categories">
                              <ul style="height:auto;">
                                <li><a href="<c:url value='/mypage?id=${cust.custId}'/>">회원정보</a></li>
                                <li><a href="<c:url value='/pet?id=#${cust.custId}'/>"><strong
                                        id="category">나의 펫 정보</strong></a></li>
                              </ul>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="card">
                        <div class="card-heading">
                          <a data-toggle="collapse">나의 쇼핑 정보</a>
                        </div>
                        <div id="collapseTwo" class="collapse show" data-parent="#accordionExample">
                          <div class="card-body">
                            <div class="shop__sidebar__categories">
                              <ul style="height: auto;">
                                <li><a href="<c:url value='/checkout/orderlist?id=${cust.custId}'/>">주문내역</a></li>
                                <li><a href="<c:url value='/address?id=${cust.custId}'/>">배송지 목록</a></li>
                                <li><a href="<c:url value='/coupon?id=${cust.custId}'/>">보유 쿠폰</a></li>
                              </ul>
                            </div>
                          </div>
                        </div>
                      </div>
                      <div class="card">
                        <div class="card-heading">
                          <a data-toggle="collapse">나의 활동</a>
                        </div>
                        <div id="collapseThree" class="collapse show" data-parent="#accordionExample">
                          <div class="card-body">
                            <div class="shop__sidebar__categories">
                              <ul style="height:auto;">
                                <li><a href="<c:url value='/mypage/view?id=${cust.custId}'/>">최근 본 상품</a></li>
                                <li><a href="<c:url value='/mypage/like?id=${cust.custId}'/>">찜 목록</a></li>
                                <li><a href="<c:url value='/qnaboard?id=${cust.custId}'/>">1:1문의</a></li>
                                <li><a href="<c:url value='/review?id=${cust.custId}'/>">내가 작성한 리뷰</a></li>
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
                  <h4><strong>🐶 나의 펫 정보</strong></h4>
                  <h6 class="checkout__title"></h6>
                  <h6 class="coupon__code"><span class="icon_tag_alt"></span> 이미지를 클릭하면 수정할 수 있어요!</h6>
                  <div class="row">
                    <c:forEach var="p" items="${pets}">
                      <div class="col-md-6">
                        <div class="pet-box">
                          <div style="display: flex; justify-content: space-between; align-items: center;">
                            <h5 style="margin: 10px auto; color:lightgray">반려동물 등록증</h5>
                            <p style="text-align:right; cursor: pointer;" onclick="pet.del(${p.petKey})">&times;</p>
                          </div>
                          <div class="row">
                            <div class="col-md-6">
                              <form id="pet_update_form" action="${pageContext.request.contextPath}/pet/petimgupdate"
                                method="post" enctype="multipart/form-data">
                                <input type="file" id="fileInput" name="petImg" style="display: none;"
                                  onchange="pet.submitForm()" />
                                <input type="hidden" value="${p.custId}" name="custId">
                                <input type="hidden" value="${p.petKey}" name="petKey">

                              </form>
                              <div class="pet-img-box">
                                <img src="<c:url value='${p.petImg}'/>" alt="현재 첨부파일"
                                  onclick="document.getElementById('fileInput').click();" style="cursor: pointer;">
                              </div>
                            </div>
                            <div class="col-md-6">
                              <div class="pet-name-box">
                                <h5>
                                  <c:choose>
                                    <c:when test="${p.petType eq 'cat'}">
                                      🐱
                                    </c:when>
                                    <c:otherwise>
                                      🐶
                                    </c:otherwise>
                                  </c:choose>
                                  <strong>${p.petName}</strong>
                              </div>
                              <hr>
                              <div class="pet-desc-box">
                                <div>▪ 생일:
                                  <fmt:formatDate value="${p.petBirthdate}" pattern="yyyy.MM.dd" />
                                </div>
                                <div>▪ 성별:
                                  <c:choose>
                                    <c:when test="${p.petGender eq 'M'}">
                                      남자
                                    </c:when>
                                    <c:otherwise>
                                      여자
                                    </c:otherwise>
                                  </c:choose>
                                </div>
                                <div>▪ 종류: ${p.petBreed}</div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
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
            <form id="pet_add_form" enctype="multipart/form-data">
              <hr>
              <!-- 내용시작 -->
              <div class="row">
                <div class="col-md-12">
                  <div class="pet-box">
                    <div class="row">
                      <div class="col-md-6">
                        <div class="pet-img-box">
                          <img id="profile-img" name="img" src="<c:url value='/img/clients/profile.png'/>">
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="pet-name-box"><strong id="modal-pet-type"></strong> <strong
                            id="modal-pet-name">이름</strong></div>
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
              </div>
              <hr>
              <div class="row">
                <div class="form-group col-md-4">
                  <div class="checkout__input">
                    <label for="petName">✔ 이름</label>
                    <input type="text" placeholder="이름을 입력하세요." id="petName" name="petName">
                    <input type="hidden" value="${sessionScope.cust.custId}" id="custId" name="custId">
                  </div>
                </div>
                <div class="form-group col-md-4">
                  <div class="checkout__input">
                    <label for="petType">✔ 타입</label><br />
                    <select id="petType" class="form-select" name="petType">
                      <option value="">강아지?고양이?</option>
                      <option value="dog">🐶 강아지</option>
                      <option value="cat">🐱 고양이</option>
                    </select>
                  </div>
                </div>
                <div class="form-group col-md-4">
                  <div class="checkout__input">
                    <label for="petGender">✔ 성별</label><br />
                    <select id="petGender" class="form-select" name="petGender">
                      <option value="">선택하세요!</option>
                      <option value="M"> 남자</option>
                      <option value="F"> 여자</option>
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
            </form>
            <div id="msg" style="color:darkred; margin-bottom:20px;"></div>
            <button class="site-btn" id="modal_pet_add_btn">등록하기</button>
          </div>
        </div>