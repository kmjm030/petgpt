<%@ page pageEncoding="UTF-8" %>
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

                .blog__post__image-container {
                    padding: 0 20px;
                    margin-top: 15px;
                    margin-bottom: 15px;
                }

                .blog__post__image {
                    display: block;
                    width: 100%;
                    max-height: 400px;
                    object-fit: cover;
                    border-radius: 4px;
                }
            </style>

            <script>
                const community = {
                    changeSortOrder: function (sortValue) {
                        const currentUrl = new URL(window.location.href);
                        const params = new URLSearchParams(currentUrl.search);

                        params.set('sort', sortValue);

                        if (currentUrl.pathname.includes('/community/search') && !params.has('keyword') && "${keyword}" !== "") {
                            params.set('keyword', "${keyword}");
                        }

                        this.loadPosts(params.get('category'), 1, params.get('sort'));

                        const newUrl = currentUrl.pathname + '?' + params.toString();
                        window.history.pushState({}, '', newUrl);
                    },

                    loadPosts: function (category = "${selectedCategory}", page = 1, sort = $('#sortSelector').val()) {
                        const postsContainer = $('#posts-container');
                        const paginationContainer = $('#pagination-container');
                        const loadingSpinner = $('#loading-spinner');
                        const noPostsMessage = $('#no-posts-message');
                        const searchNoResultMessage = $('#search-no-result-message');

                        postsContainer.html('');
                        paginationContainer.html('');
                        loadingSpinner.show();
                        noPostsMessage.hide();

                        const baseUrl = window.location.pathname.includes('/community/search') ?
                            window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/search')) :
                            '/community';
                        let apiUrl = baseUrl + '/posts?page=' + page;
                        if (category) apiUrl += '&category=' + category;
                        if (sort) apiUrl += '&sort=' + sort;

                        console.log('API 호출 URL:', apiUrl);

                        $.ajax({
                            url: apiUrl,
                            type: 'GET',
                            dataType: 'json',
                            success: (data) => {
                                console.log('API 응답 데이터:', data);

                                loadingSpinner.hide();

                                if (data.posts.length === 0) {
                                    noPostsMessage.show();
                                    if ("${keyword}" !== "") {
                                        searchNoResultMessage.text('"${keyword}"에 대한 게시글을 찾을 수 없습니다.');
                                    } else {
                                        searchNoResultMessage.text('');
                                    }
                                    return;
                                }

                                let postsHtml = '';
                                $.each(data.posts, (i, post) => {
                                    const postDate = new Date(post.createdAt);
                                    const formattedDate = postDate.getFullYear() + '.' +
                                        (postDate.getMonth() + 1).toString().padStart(2, '0') + '.' +
                                        postDate.getDate().toString().padStart(2, '0');

                                    const colDiv = $('<div>').addClass('col-lg-12');
                                    const postDiv = $('<div>').addClass('blog__post');

                                    const header = $('<div>').addClass('blog__post__header');
                                    const headerInnerDiv = $('<div>');
                                    const title = $('<h3>').addClass('blog__post__title');
                                    const titleLink = $('<a>').attr('href', '/community/detail?id=' + post.postId).text(post.title);
                                    const meta = $('<div>').addClass('blog__post__meta');
                                    const authorSpan = $('<span>').text('작성자: ' + post.authorName);
                                    const dateSpan = $('<span>').text('작성일: ' + formattedDate);
                                    title.append(titleLink);
                                    meta.append(authorSpan).append(dateSpan);
                                    headerInnerDiv.append(title).append(meta);
                                    header.append(headerInnerDiv);
                                    postDiv.append(header);

                                    if (post.image) {
                                        const imageContainer = $('<div>').addClass('blog__post__image-container');
                                        const image = $('<img>').addClass('blog__post__image')
                                            .attr('src', post.image)
                                            .attr('alt', '게시글 이미지');
                                        imageContainer.append(image);
                                        postDiv.append(imageContainer);
                                    }

                                    const body = $('<div>').addClass('blog__post__body');
                                    const content = $('<p>').addClass('blog__post__content').html(post.summary);
                                    body.append(content);
                                    postDiv.append(body);

                                    const footer = $('<div>').addClass('blog__post__footer');
                                    const stats = $('<div>').addClass('blog__post__stats');
                                    const viewStat = $('<div>').addClass('stats__item').append($('<i>').addClass('fa fa-eye')).append(' ' + (post.viewCount || 0));
                                    const likeStat = $('<div>').addClass('stats__item').append($('<i>').addClass('fa fa-heart')).append(' ' + (post.likeCount || 0));
                                    const commentStat = $('<div>').addClass('stats__item').append($('<i>').addClass('fa fa-comment')).append(' ' + (post.commentCount || 0));
                                    const categoryDiv = $('<div>').addClass('blog__post__category');
                                    const categorySpan = $('<span>').text('#' + post.category);
                                    stats.append(viewStat).append(likeStat).append(commentStat);
                                    categoryDiv.append(categorySpan);
                                    footer.append(stats).append(categoryDiv);
                                    postDiv.append(footer);

                                    colDiv.append(postDiv);
                                    postsContainer.append(colDiv);
                                });

                                // postsContainer.html(postsHtml); // 이 라인 제거

                                let paginationHtml = '';
                                const totalPages = data.totalPages;
                                const currentPage = data.currentPage;

                                if (totalPages > 0) {

                                    if (currentPage > 1) {
                                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${currentPage - 1}, '${sort}')">&laquo;</a>`;
                                    }

                                    for (let i = 1; i <= totalPages; i++) {
                                        if (i === 1 || i === totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                                            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${i}, '${sort}')" class="${i == currentPage ? 'active' : ''}">${i}</a>`;
                                        } else if (i === currentPage - 3 || i === currentPage + 3) {
                                            paginationHtml += '<span>...</span>';
                                        }
                                    }

                                    if (currentPage < totalPages) {
                                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${currentPage + 1}, '${sort}')">&raquo;</a>`;
                                    }
                                }

                                paginationContainer.html(paginationHtml);
                            },
                            error: (error) => {
                                console.error('데이터 로드 중 오류 발생:', error);
                                loadingSpinner.hide();
                                postsContainer.html(`
                                    <div class="col-lg-12 text-center my-5">
                                        <p>데이터를 불러오는 중 오류가 발생했습니다.</p>
                                        <p class="text-danger">오류 메시지: \${error.statusText || '알 수 없는 오류'}</p>
                                        <p>API URL: \${apiUrl}</p>
                                        <button onclick="window.location.reload()" class="primary-btn">페이지 새로고침</button>
                                    </div>
                                `);
                            }
                        });
                    },

                    init: function () {

                        $('#sortSelector').on('change', (e) => {
                            this.changeSortOrder(e.target.value);
                        });


                        $('.shop__sidebar__categories ul li a').on('click', (e) => {
                            e.preventDefault();


                            $('.shop__sidebar__categories ul li a').removeClass('category-active');


                            $(e.target).addClass('category-active');

                            const href = $(e.target).attr('href');
                            const url = new URL(window.location.origin + href);
                            const category = url.searchParams.get('category') || '';
                            const sort = $('#sortSelector').val();

                            this.loadPosts(category, 1, sort);

                            window.history.pushState({}, '', href);
                        });

                        let initialPage = 1;
                        <c:if test="${not empty currentPage}">
                            <c:catch var="typeError">
                                initialPage = ${currentPage};
                            </c:catch>
                        </c:if>
                        this.loadPosts("${selectedCategory}", initialPage, "${selectedSort || 'newest'}");
                    }
                };

                $(document).ready(function () {
                    community.init();
                });
            </script>


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
                                        <input type="text" name="keyword" placeholder="검색어를 입력하세요..."
                                            value="${keyword}">
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