<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!-- Blog Details Hero Begin -->
<section class="blog-hero spad">
    <div class="container">
        <div class="row d-flex justify-content-center">
            <div class="col-lg-9 text-center">
                <div class="blog__hero__text">
                  <h2>막내사진 자랑해요!!!</h2>
                  <ul>
                    <li>2025-04-05</li>
                    <li>발자국🐾 8개</li>
                    <li>조회수</li>
                  </ul>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Blog Details Hero End -->

<!-- Blog Details Section Begin -->
<section class="blog-details spad">
  <div class="container">
    <div class="row d-flex justify-content-center">
      <div class="col-lg-8">
        <div class="blog__details__pic">
          <img src="<c:url value='/img/blog/details/blog-details.jpg'/>" alt="">
        </div>
        <div class="blog__details__content">
          <div class="blog__details__share">
            <span>공유하기</span>
            <ul>
              <li><a href="#" class="instagram"><i class="fa fa-instagram"></i></a></li>
              <li><a href="#" class="twitter"><i class="fa fa-twitter"></i></a></li>
              <li><a href="#" class="youtube"><i class="fa fa-youtube-play"></i></a></li>
            </ul>
          </div>
          <div class="blog__details__text">
            <p>대충 자랑글...이라고 침 테스트용 텍스트!!</p>
          </div>
<%--          어떻게 활용하면 될지는 잘 모르겠지만 일단 디자인이 예뻐서 주석처리로 남겨둔 인용박스--%>
<%--          <div class="blog__details__quote">--%>
<%--            <i class="fa fa-quote-left"></i>--%>
<%--            <p>“When designing an advertisement for a particular product many things should be--%>
<%--              researched like where it should be displayed.”</p>--%>
<%--            <h6>_ John Smith _</h6>--%>
<%--          </div>--%>
          <div class="blog__details__option">
            <div class="row">
              <div class="col-lg-6 col-md-6 col-sm-6">
                <div class="blog__details__author">
                  <div class="blog__details__author__pic">
                    <img src="<c:url value='/img/blog/details/blog-author.jpg'/>" alt="">
                  </div>
                  <div class="blog__details__author__text">
                    <h5>김초롱</h5>
                  </div>
                </div>
              </div>
<%--              <div class="col-lg-6 col-md-6 col-sm-6">--%>
<%--                <div class="blog__details__tags">--%>
<%--                  <a href="#">#강아지</a>--%>
<%--                  <a href="#">#산책</a>--%>
<%--                  <a href="#">#2025</a>--%>
<%--                </div>--%>
<%--              </div>--%>
            </div>
          </div>
          <div class="blog__details__btns">
            <div class="row">
              <div class="col-lg-6 col-md-6 col-sm-6">
                <a href="" class="blog__details__btns__item">
                  <p><span class="arrow_left"></span>이전글</p>
                  <h5>캣타워 사봤는데 어떤가요?</h5>
                </a>
              </div>
              <div class="col-lg-6 col-md-6 col-sm-6">
                <a href="" class="blog__details__btns__item blog__details__btns__item--next">
                  <p>다음글<span class="arrow_right"></span></p>
                  <h5>6개월된 강아지 사료 추천해주세요..!</h5>
                </a>
              </div>
            </div>
          </div>
          <div class="blog__details__comment">
            <h4>🐶 다른 집사님의 귀여운 반려동물에게 코멘트를 남겨주세요! 🐱</h4>
            <%-- 댓글 작성 기능 필요 --%>
            <%-- name에 닉네임 자동적으로 들어가게 value기능 사용하기 --%>
            <form action="#">
              <div class="row">
                <div class="col-lg-4 col-md-4">
                  <input type="text" placeholder="Name" name="commentName" required>
                </div>
                <div class="col-lg-12 text-center">
                  <textarea placeholder="Comment" name="commentMessage" required></textarea>
                  <button type="submit" class="site-btn">발자국 남기기🐾</button>
                </div>
              </div>
            </form>
          </div>
          <%-- 기존 댓글 목록 표시 로직 필요 --%>
        </div>
      </div>
    </div>
  </div>
</section>
<!-- Blog Details Section End -->
