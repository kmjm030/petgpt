<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <link rel="stylesheet" href="<c:url value='/css/community.css'/>" type="text/css">

      <section class="breadcrumb-option">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <div class="breadcrumb__text">
                <h4>커뮤니티</h4>
                <div class="breadcrumb__links">
                  <a href="<c:url value='/'/>">Home</a>
                  <span>커뮤니티</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <div id="community-data" data-keyword="${keyword}" data-selected-category="${selectedCategory}"
        data-current-page="${currentPage}" data-selected-sort="${selectedSort}" style="display: none;">
      </div>

      <section class="blog spad">
        <div class="container">
          <div class="row">
            <div class="col-lg-3">
              <div class="shop__sidebar">
                <a href="<c:url value='/community/write'/>" class="write-btn">게시글 작성</a>

                <div class="shop__sidebar__search">
                  <form action="<c:url value='/community/search'/>" method="GET">
                    <input type="text" name="keyword" placeholder="검색어를 입력하세요..." value="${keyword}">
                    <button type="submit"><span class="icon_search"></span></button>
                  </form>
                </div>

                <div class="shop__sidebar__accordion">
                  <div class="accordion" id="accordionExample">
                    <div class="card">
                      <div class="card-heading">
                        <a data-toggle="collapse" data-target="#collapseOne">게시판</a>
                      </div>
                      <div id="collapseOne" class="collapse show" data-parent="#accordionExample">
                        <div class="card-body">
                          <div class="shop__sidebar__categories">
                            <ul class="nice-scroll">
                              <li><a href="<c:url value='/community'/>"
                                  class="${empty selectedCategory ? 'category-active' : ''}">전체글
                                  보기</a></li>
                              <li><a href="<c:url value='/community?category=popular'/>"
                                  class="${selectedCategory == 'popular' ? 'category-active' : ''}">인기글</a>
                              </li>
                              <li><a href="<c:url value='/community?category=notice'/>"
                                  class="${selectedCategory == 'notice' ? 'category-active' : ''}">공지사항</a>
                              </li>
                              <li><a href="<c:url value='/community?category=free'/>"
                                  class="${selectedCategory == 'free' ? 'category-active' : ''}">자유게시판</a>
                              </li>
                              <li><a href="<c:url value='/community?category=show'/>"
                                  class="${selectedCategory == 'show' ? 'category-active' : ''}">펫자랑게시판</a>
                              </li>
                            </ul>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="col-lg-9">
              <div class="blog-sort-bar">
                <div class="left">
                  <c:choose>
                    <c:when test="${not empty keyword}">
                      <p>"${keyword}" 검색 결과 ${resultCount}개의 게시글</p>
                    </c:when>
                    <c:when test="${not empty selectedCategory}">
                      <p>
                        <c:choose>
                          <c:when test="${selectedCategory == 'popular'}">인기글</c:when>
                          <c:when test="${selectedCategory == 'notice'}">공지사항</c:when>
                          <c:when test="${selectedCategory == 'free'}">자유게시판</c:when>
                          <c:when test="${selectedCategory == 'show'}">자랑게시판</c:when>
                        </c:choose>
                      </p>
                    </c:when>
                    <c:otherwise>
                      <p>전체 게시글</p>
                    </c:otherwise>
                  </c:choose>
                </div>
                <div class="right">
                  <select id="sortSelector" onchange="changeSortOrder(this.value)">
                    <option value="newest" ${selectedSort eq 'newest' ? 'selected' : '' }>최신순
                    </option>
                    <option value="oldest" ${selectedSort eq 'oldest' ? 'selected' : '' }>오래된순
                    </option>
                    <option value="views" ${selectedSort eq 'views' ? 'selected' : '' }>조회수순
                    </option>
                    <option value="likes" ${selectedSort eq 'likes' ? 'selected' : '' }>좋아요순
                    </option>
                    <option value="comments" ${selectedSort eq 'comments' ? 'selected' : '' }>댓글많은순
                    </option>
                  </select>
                </div>
              </div>

              <div class="row">
                <div class="col-lg-12">
                  <div id="posts-container">
                    <!-- 게시글이 여기에 비동기로 로드됩니다 -->
                  </div>
                  <div id="loading-spinner" class="text-center my-4" style="display:none;">
                    <div class="spinner-grow text-primary" role="status">
                      <span class="visually-hidden">로딩중...</span>
                    </div>
                  </div>
                  <div id="no-posts-message" class="col-lg-12 text-center my-5" style="display:none;">
                    <h4>게시글이 없습니다.</h4>
                    <p id="search-no-result-message"></p>
                    <a href="<c:url value='/community'/>" class="primary-btn mt-3">전체 게시글 보기</a>
                  </div>
                </div>
              </div>
              <div class="row">
                <div class="col-lg-12">
                  <div class="product__pagination" id="pagination-container">
                    <!-- 페이지네이션이 여기에 비동기로 로드됩니다 -->
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <script>
        $(document).ready(function () {
          const urlParams = new URLSearchParams(window.location.search);
          const infiniteScroll = urlParams.get('infiniteScroll');

          if (infiniteScroll === 'true') {
            const category = urlParams.get('category') || '';
            const sort = urlParams.get('sort') || 'views';

            $('#pagination-container').hide();
            $('#posts-container').after('<div class="infinite-scroll-notice text-center mt-3 mb-4"><p><i class="fa fa-refresh fa-spin"></i> 스크롤하여 더 많은 게시글을 확인하세요</p></div>');

            if (typeof community !== 'undefined') {
              setTimeout(() => {
                community.startInfiniteScroll(category, sort);
              }, 300);
            }
          }
        });
      </script>