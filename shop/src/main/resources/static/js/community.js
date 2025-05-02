// 전역 변수 선언 (init에서 값 할당)
let communityKeyword = '';
let communitySelectedCategory = '';
let communityCurrentPage = 1;
let communitySelectedSort = 'newest';

const community = {

    loadPosts: function (category = communitySelectedCategory, page = 1, sort = communitySelectedSort) {
        const postsContainer = $('#posts-container');
        const paginationContainer = $('#pagination-container');
        const loadingSpinner = $('#loading-spinner');
        const noPostsMessage = $('#no-posts-message');
        const searchNoResultMessage = $('#search-no-result-message');
        const resultCountSpan = $('#result-count'); // 검색 결과 개수 표시용 span

        postsContainer.html(''); // 기존 내용 비우기
        paginationContainer.html(''); // 기존 페이지네이션 비우기
        loadingSpinner.show();
        noPostsMessage.hide();
        searchNoResultMessage.text(''); // 검색 결과 메시지 초기화
        resultCountSpan.text(''); // 검색 결과 개수 초기화

        // contextPath는 index.jsp에서 전역으로 선언됨
        // 검색 결과 페이지(/community/search)에서도 API 경로는 /community/posts 사용
        const baseUrl = contextPath + '/community';
        let apiUrl = baseUrl + '/posts?page=' + page;
        if (category) apiUrl += '&category=' + category;
        if (sort) apiUrl += '&sort=' + sort;
        // 검색 키워드가 있다면 API URL에 추가 (communityKeyword 전역 변수 사용)
        if (communityKeyword) {
            apiUrl += '&keyword=' + encodeURIComponent(communityKeyword);
        }

        console.log('API 호출 URL:', apiUrl);

        $.ajax({
            url: apiUrl,
            type: 'GET',
            dataType: 'json',
            success: (data) => {
                console.log('API 응답 데이터:', data);
                loadingSpinner.hide();

                // 검색 결과 개수 업데이트 (API 응답에 totalElements 또는 유사한 필드가 있다고 가정)
                if (communityKeyword && data.totalElements !== undefined) {
                    resultCountSpan.text(data.totalElements);
                }

                if (!data || !data.posts || data.posts.length === 0) {
                    console.log("No posts found or empty data received.");
                    noPostsMessage.show();
                    if (communityKeyword) {
                        searchNoResultMessage.text(`"${communityKeyword}"에 대한 게시글을 찾을 수 없습니다.`);
                    } else {
                        searchNoResultMessage.text('');
                    }
                    paginationContainer.html(''); // 페이지네이션 비우기
                    return;
                }

                // 게시글 렌더링
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
                    const titleLink = $('<a>').attr('href', contextPath + '/community/detail?id=' + post.postId).text(post.title);
                    const meta = $('<div>').addClass('blog__post__meta');
                    const authorSpan = $('<span>').text('작성자: ' + (post.authorName || '익명')); // null 방지
                    const dateSpan = $('<span>').text('작성일: ' + formattedDate);
                    title.append(titleLink);
                    meta.append(authorSpan).append(dateSpan);
                    headerInnerDiv.append(title).append(meta);
                    header.append(headerInnerDiv);
                    postDiv.append(header);

                    if (post.image) {
                        const imageContainer = $('<div>').addClass('blog__post__image-container');
                        // 이미지 URL에 contextPath가 필요하다면 추가
                        const image = $('<img>').addClass('blog__post__image')
                            .attr('src', post.image) // 필요시 contextPath + post.image
                            .attr('alt', '게시글 이미지');
                        imageContainer.append(image);
                        postDiv.append(imageContainer);
                    }

                    const body = $('<div>').addClass('blog__post__body');
                    // summary가 HTML을 포함할 수 있으므로 .html() 사용, null 방지
                    const content = $('<p>').addClass('blog__post__content').html(post.summary || '');
                    body.append(content);
                    postDiv.append(body);

                    const footer = $('<div>').addClass('blog__post__footer');
                    const stats = $('<div>').addClass('blog__post__stats');
                    const viewStat = $('<div>').addClass('stats__item').append($('<i>').addClass('fa fa-eye')).append(' ' + (post.viewCount || 0));
                    const likeStat = $('<div>').addClass('stats__item').append($('<i>').addClass('fa fa-heart')).append(' ' + (post.likeCount || 0));
                    const commentStat = $('<div>').addClass('stats__item').append($('<i>').addClass('fa fa-comment')).append(' ' + (post.commentCount || 0));
                    const categoryDiv = $('<div>').addClass('blog__post__category');
                    const categorySpan = $('<span>').text('#' + (post.category || '미분류')); // null 방지
                    stats.append(viewStat).append(likeStat).append(commentStat);
                    categoryDiv.append(categorySpan);
                    footer.append(stats).append(categoryDiv);
                    postDiv.append(footer);

                    colDiv.append(postDiv);
                    postsContainer.append(colDiv);
                });

                // 페이지네이션 렌더링
                let paginationHtml = '';
                const totalPages = data.totalPages;
                const currentPage = data.currentPage; // API 응답의 현재 페이지 사용

                if (totalPages > 0) {
                    const maxVisiblePages = 5; // 한 번에 보여줄 최대 페이지 번호 수
                    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
                    let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

                    // endPage가 totalPages보다 작고 페이지 수가 maxVisiblePages보다 적을 때 startPage 조정
                    if (endPage < totalPages && (endPage - startPage + 1) < maxVisiblePages) {
                        startPage = Math.max(1, endPage - maxVisiblePages + 1);
                    }
                    // startPage가 1보다 크고 페이지 수가 maxVisiblePages보다 적을 때 endPage 조정
                    if (startPage > 1 && (endPage - startPage + 1) < maxVisiblePages) {
                        endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
                    }


                    // 첫 페이지 & 이전 페이지 링크
                    if (currentPage > 1) {
                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', 1, '${sort}')">&laquo;&laquo;</a>`;
                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${currentPage - 1}, '${sort}')">&laquo;</a>`;
                    } else {
                        paginationHtml += `<span class="disabled">&laquo;&laquo;</span>`;
                        paginationHtml += `<span class="disabled">&laquo;</span>`;
                    }

                    // 페이지 번호 링크
                    if (startPage > 1) {
                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', 1, '${sort}')">1</a>`;
                        if (startPage > 2) {
                            paginationHtml += `<span class="disabled">...</span>`; // 클릭 불가능한 ...
                        }
                    }

                    for (let i = startPage; i <= endPage; i++) {
                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${i}, '${sort}')" class="${i == currentPage ? 'active' : ''}">${i}</a>`;
                    }

                    if (endPage < totalPages) {
                        if (endPage < totalPages - 1) {
                            paginationHtml += `<span class="disabled">...</span>`; // 클릭 불가능한 ...
                        }
                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${totalPages}, '${sort}')">${totalPages}</a>`;
                    }

                    // 다음 페이지 & 마지막 페이지 링크
                    if (currentPage < totalPages) {
                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${currentPage + 1}, '${sort}')">&raquo;</a>`;
                        paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${totalPages}, '${sort}')">&raquo;&raquo;</a>`;
                    } else {
                        paginationHtml += `<span class="disabled">&raquo;</span>`;
                        paginationHtml += `<span class="disabled">&raquo;&raquo;</span>`;
                    }
                }
                paginationContainer.html(paginationHtml);

                // URL 업데이트 (선택 사항: 필요하다면 활성화)
                // const currentUrl = new URL(window.location.href);
                // const params = new URLSearchParams(currentUrl.search);
                // params.set('page', currentPage);
                // if (category) params.set('category', category); else params.delete('category');
                // if (sort) params.set('sort', sort); else params.delete('sort');
                // const basePath = window.location.pathname.includes('/community/search') ? contextPath + '/community/search' : contextPath + '/community';
                // const newUrl = basePath + '?' + params.toString();
                // window.history.pushState({ category, page, sort }, '', newUrl);

            },
            error: (xhr, status, error) => { // xhr, status, error 인자 추가
                console.error('데이터 로드 중 오류 발생:', status, error, xhr);
                loadingSpinner.hide();
                // 오류 메시지를 좀 더 상세하게 표시
                let errorMsg = `데이터를 불러오는 중 오류가 발생했습니다. (상태: ${xhr.status || status})`;
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg += `<br>서버 메시지: ${xhr.responseJSON.message}`;
                } else if (error) {
                    errorMsg += `<br>오류: ${error}`;
                }

                postsContainer.html(`
                    <div class="col-lg-12 text-center my-5 alert alert-danger">
                        <p>${errorMsg}</p>
                        <p>요청 URL: ${apiUrl}</p>
                        <button onclick="window.location.reload()" class="btn btn-primary mt-2">페이지 새로고침</button>
                    </div>
                `);
            }
        });
    },

    init: function () {
        console.log("Community init called.");
        // community-data 요소에서 데이터 읽기
        const communityDataElement = $('#community-data');
        if (communityDataElement.length > 0) {
            communityKeyword = communityDataElement.data('keyword') || '';
            communitySelectedCategory = communityDataElement.data('selected-category') || '';
            // currentPage는 항상 1로 시작하거나, 필요하다면 URL 파라미터에서 읽어와야 함. data-*는 초기값만 제공.
            communityCurrentPage = parseInt(communityDataElement.data('current-page') || '1', 10);
            communitySelectedSort = communityDataElement.data('selected-sort') || 'newest';
            console.log("Community data loaded from #community-data:", { communityKeyword, communitySelectedCategory, communityCurrentPage, communitySelectedSort });

            // URL 파라미터에서 실제 페이지 번호 읽기 (더 정확함)
            const urlParams = new URLSearchParams(window.location.search);
            const pageFromUrl = parseInt(urlParams.get('page') || '1', 10);
            if (!isNaN(pageFromUrl) && pageFromUrl > 0) {
                communityCurrentPage = pageFromUrl;
                console.log("Current page updated from URL:", communityCurrentPage);
            }

        } else {
            console.warn("#community-data element not found. Using default values.");
            // URL 파라미터에서 값 읽기 시도 (대안)
            const urlParams = new URLSearchParams(window.location.search);
            communityKeyword = urlParams.get('keyword') || '';
            communitySelectedCategory = urlParams.get('category') || '';
            communityCurrentPage = parseInt(urlParams.get('page') || '1', 10);
            communitySelectedSort = urlParams.get('sort') || 'newest';
            console.log("Community data loaded from URL params:", { communityKeyword, communitySelectedCategory, communityCurrentPage, communitySelectedSort });
        }

        // 정렬 변경 이벤트 리스너 설정
        $('#sortSelector').on('change', (e) => {
            const newSortValue = e.target.value;
            console.log("Sort changed to:", newSortValue);
            communitySelectedSort = newSortValue; // 전역 변수 업데이트
            communityCurrentPage = 1; // 정렬 변경 시 1페이지로 리셋
            this.loadPosts(communitySelectedCategory, communityCurrentPage, communitySelectedSort);

            // URL 업데이트 (정렬 변경 시)
            const currentUrl = new URL(window.location.href);
            const params = new URLSearchParams(currentUrl.search);
            params.set('sort', newSortValue);
            params.set('page', '1'); // 1페이지로 리셋
            const basePath = window.location.pathname.includes('/community/search') ? contextPath + '/community/search' : contextPath + '/community';
            const newUrl = basePath + '?' + params.toString();
            window.history.pushState({ category: communitySelectedCategory, page: 1, sort: newSortValue }, '', newUrl);
        });

        // 카테고리 클릭 이벤트 리스너 설정
        $('.shop__sidebar__categories ul li a').on('click', (e) => {
            e.preventDefault(); // 기본 링크 동작 방지
            console.log("Category link clicked:", e.target.href);

            // 모든 카테고리 링크에서 active 클래스 제거
            $('.shop__sidebar__categories ul li a').removeClass('category-active');
            // 클릭된 링크에 active 클래스 추가
            $(e.target).addClass('category-active');

            const href = $(e.target).attr('href');
            // href에서 category 파라미터 추출
            const url = new URL(window.location.origin + href); // 전체 URL로 만들어 파라미터 추출 용이하게 함
            const category = url.searchParams.get('category') || ''; // category 파라미터 없으면 빈 문자열 (전체)

            communitySelectedCategory = category; // 전역 변수 업데이트
            communityCurrentPage = 1; // 카테고리 변경 시 1페이지로 리셋
            communityKeyword = ''; // 카테고리 변경 시 검색어 초기화

            console.log("Loading posts for category:", category, "with sort:", communitySelectedSort);
            this.loadPosts(communitySelectedCategory, communityCurrentPage, communitySelectedSort);

            // URL 업데이트 (카테고리 변경 시) - 검색 상태 해제
            const params = new URLSearchParams(); // 새 파라미터 객체
            if (category) params.set('category', category);
            params.set('sort', communitySelectedSort); // 현재 정렬 유지
            params.set('page', '1'); // 1페이지로 리셋
            const newUrl = contextPath + '/community?' + params.toString(); // 기본 경로 사용
            window.history.pushState({ category, page: 1, sort: communitySelectedSort }, '', newUrl);

            // 검색 결과 표시 영역 초기화
            $('#result-count').text('');
            $('.blog-sort-bar .left p').text(
                category === 'popular' ? '인기글' :
                    category === 'notice' ? '공지사항' :
                        category === 'free' ? '자유게시판' :
                            category === 'show' ? '자랑게시판' : '전체 게시글'
            );
        });

        // 초기 게시글 로드 (init 마지막 단계)
        console.log("Initial loadPosts call with:", communitySelectedCategory, communityCurrentPage, communitySelectedSort);
        this.loadPosts(communitySelectedCategory, communityCurrentPage, communitySelectedSort);
    }
};

// DOM 준비 완료 후 community 객체 초기화
$(function () {
    // community 페이지인지 확인하는 더 확실한 방법 (예: body 태그에 data 속성 추가)
    // 또는 #community-data 요소 존재 여부로 판단
    if ($('#community-data').length > 0) {
        community.init();
    } else {
        console.log("Not on community page or #community-data missing, skipping community init.");
    }
});