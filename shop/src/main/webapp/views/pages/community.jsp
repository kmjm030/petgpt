<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .blog__sidebar__categories ul li a.category-active {
    color: #000 !important;
    font-weight: bold !important;
    background-color: #f5f5f5 !important;
    display: block;
    padding: 2px 5px;
    border-radius: 4px;
  }
  
  .blog__post {
    margin-bottom: 30px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    border-radius: 4px;
    overflow: hidden;
    transition: transform 0.3s ease;
  }
  
  .blog__post:hover {
    transform: translateY(-5px);
  }
  
  .blog__post__header {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .blog__post__title {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 5px;
    color: #333;
  }
  
  .blog__post__title a {
    color: inherit;
    text-decoration: none;
  }
  
  .blog__post__title a:hover {
    color: #111;
  }
  
  .blog__post__meta {
    font-size: 13px;
    color: #888;
    display: flex;
    gap: 15px;
  }
  
  .blog__post__body {
    padding: 20px;
    background-color: #fff;
  }
  
  .blog__post__content {
    margin-bottom: 15px;
    color: #666;
    line-height: 1.6;
  }
  
  .blog__post__footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 20px;
    background-color: #fafafa;
    border-top: 1px solid #eee;
  }
  
  .blog__post__stats {
    display: flex;
    gap: 15px;
    color: #888;
    font-size: 13px;
  }
  
  .stats__item {
    display: flex;
    align-items: center;
    gap: 5px;
  }
  
  .write-btn {
    display: block;
    width: 100%;
    padding: 10px;
    text-align: center;
    background-color: #111;
    color: #fff;
    border: none;
    font-weight: 600;
    margin-bottom: 20px;
    transition: background-color 0.3s;
  }
  
  .write-btn:hover {
    background-color: #333;
    color: #fff;
  }

  .blog-sort-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid #eee;
  }
  
  .blog-sort-bar select {
    padding: 8px 12px;
    border-radius: 4px;
    border: 1px solid #ddd;
  }
</style>

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
                              class="${empty selectedCategory ? 'category-active' : ''}"
                              >전체글 보기</a></li>
                        <li><a href="<c:url value='/community?category=popular'/>" 
                              class="${selectedCategory == 'popular' ? 'category-active' : ''}"
                              >인기글</a></li>
                        <li><a href="<c:url value='/community?category=notice'/>" 
                              class="${selectedCategory == 'notice' ? 'category-active' : ''}"
                              >공지사항</a></li>
                        <li><a href="<c:url value='/community?category=free'/>" 
                              class="${selectedCategory == 'free' ? 'category-active' : ''}"
                              >자유게시판</a></li>
                        <li><a href="<c:url value='/community?category=show'/>" 
                              class="${selectedCategory == 'show' ? 'category-active' : ''}"
                              >자랑게시판</a></li>
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
              <option value="newest" ${selectedSort eq 'newest' ? 'selected' : ''}>최신순</option>
              <option value="oldest" ${selectedSort eq 'oldest' ? 'selected' : ''}>오래된순</option>
              <option value="views" ${selectedSort eq 'views' ? 'selected' : ''}>조회수순</option>
              <option value="likes" ${selectedSort eq 'likes' ? 'selected' : ''}>좋아요순</option>
              <option value="comments" ${selectedSort eq 'comments' ? 'selected' : ''}>댓글많은순</option>
            </select>
          </div>
        </div>
        
        <div class="row">
          <c:if test="${empty postList}">
            <div class="col-lg-12 text-center my-5">
              <h4>게시글이 없습니다.</h4>
              <c:if test="${not empty keyword}">
                <p>"${keyword}"에 대한 게시글을 찾을 수 없습니다.</p>
              </c:if>
              <a href="<c:url value='/community'/>" class="primary-btn mt-3">전체 게시글 보기</a>
            </div>
          </c:if>
          
          <%-- 블로그 샘플 아이템 (주석 처리) --%>
          <%--
          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="blog__item">
              <div class="blog__item__pic set-bg" data-setbg="<c:url value='/img/blog/blog-1.jpg'/>"></div>
              <div class="blog__item__text">
                <span><img src="<c:url value='/img/icon/calendar.png'/>" alt=""> 16 February 2020</span>
                <h5>What Curling Irons Are The Best Ones</h5>
                <a href="<c:url value='/community/detail?id=1'/>">Read More</a>
              </div>
            </div>
          </div>
          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="blog__item">
              <div class="blog__item__pic set-bg" data-setbg="<c:url value='/img/blog/blog-2.jpg'/>"></div>
              <div class="blog__item__text">
                <span><img src="<c:url value='/img/icon/calendar.png'/>" alt=""> 21 February 2020</span>
                <h5>Eternity Bands Do Last Forever</h5>
                <a href="<c:url value='/community/detail?id=2'/>">Read More</a>
              </div>
            </div>
          </div>
          <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="blog__item">
              <div class="blog__item__pic set-bg" data-setbg="<c:url value='/img/blog/blog-3.jpg'/>"></div>
              <div class="blog__item__text">
                <span><img src="<c:url value='/img/icon/calendar.png'/>" alt=""> 28 February 2020</span>
                <h5>The Health Benefits Of Sunglasses</h5>
                <a href="<c:url value='/community/detail?id=3'/>">Read More</a>
              </div>
            </div>
          </div>
          --%>
        </div>
        
        <div class="row">
          <div class="col-lg-12">
            <div class="product__pagination">
              <c:if test="${totalPages > 0}">
                <c:if test="${currentPage > 1}">
                  <a href="<c:url value='/community'>
                    <c:param name='page' value='${currentPage - 1}'/>
                    <c:if test='${not empty selectedCategory}'><c:param name='category' value='${selectedCategory}'/></c:if>
                    <c:if test='${not empty param.sort}'><c:param name='sort' value='${param.sort}'/></c:if>
                  </c:url>">&laquo;</a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                  <c:if test="${pageNum == 1 || pageNum == totalPages || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)}">
                    <a href="<c:url value='/community'>
                      <c:param name='page' value='${pageNum}'/>
                      <c:if test='${not empty selectedCategory}'><c:param name='category' value='${selectedCategory}'/></c:if>
                      <c:if test='${not empty param.sort}'><c:param name='sort' value='${param.sort}'/></c:if>
                    </c:url>" 
                    class="${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
                  </c:if>
                  <c:if test="${pageNum == currentPage - 3 || pageNum == currentPage + 3}">
                    <span>...</span>
                  </c:if>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                  <a href="<c:url value='/community'>
                    <c:param name='page' value='${currentPage + 1}'/>
                    <c:if test='${not empty selectedCategory}'><c:param name='category' value='${selectedCategory}'/></c:if>
                    <c:if test='${not empty param.sort}'><c:param name='sort' value='${param.sort}'/></c:if>
                  </c:url>">&raquo;</a>
                </c:if>
              </c:if>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<script>
  function changeSortOrder(sortValue) {
    const currentUrl = new URL(window.location.href);
    const params = new URLSearchParams(currentUrl.search);
    
    params.set('sort', sortValue);
    
    if (currentUrl.pathname.includes('/community/search') && !params.has('keyword') && "${keyword}" !== "") {
      params.set('keyword', "${keyword}");
    }
    
    currentUrl.search = params.toString();
    window.location.href = currentUrl.toString();
  }
</script> 