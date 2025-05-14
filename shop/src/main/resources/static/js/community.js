let communityKeyword = "";
let communitySelectedCategory = "";
let communityCurrentPage = 1;
let communitySelectedSort = "comments";

const community = {
  loadPosts: function (
    category = communitySelectedCategory,
    page = 1,
    sort = communitySelectedSort
  ) {
    const postsContainer = $("#posts-container");
    const paginationContainer = $("#pagination-container");
    const loadingSpinner = $("#loading-spinner");
    const noPostsMessage = $("#no-posts-message");
    const searchNoResultMessage = $("#search-no-result-message");
    const resultCountSpan = $("#result-count");

    postsContainer.html("");
    paginationContainer.html("");
    loadingSpinner.show();
    noPostsMessage.hide();
    searchNoResultMessage.text("");
    resultCountSpan.text("");

    const baseUrl = contextPath + "/community";
    let apiUrl = baseUrl + "/posts?page=" + page;
    if (category) apiUrl += "&category=" + category;
    if (sort) apiUrl += "&sort=" + sort;
    if (communityKeyword) {
      apiUrl += "&keyword=" + encodeURIComponent(communityKeyword);
    }

    console.log("API 호출 URL:", apiUrl);

    $.ajax({
      url: apiUrl,
      type: "GET",
      dataType: "json",
      success: (data) => {
        console.log("API 응답 데이터:", data);
        loadingSpinner.hide();

        if (communityKeyword && data.totalElements !== undefined) {
          resultCountSpan.text(data.totalElements);
        }

        if (!data || !data.posts || data.posts.length === 0) {
          console.log("No posts found or empty data received.");
          noPostsMessage.show();
          if (communityKeyword) {
            searchNoResultMessage.text(
              `"${communityKeyword}"에 대한 게시글을 찾을 수 없습니다.`
            );
          } else {
            searchNoResultMessage.text("");
          }
          paginationContainer.html("");
          return;
        }

        $.each(data.posts, (i, post) => {
          const postDate = new Date(post.createdAt);
          const formattedDate =
            postDate.getFullYear() +
            "." +
            (postDate.getMonth() + 1).toString().padStart(2, "0") +
            "." +
            postDate.getDate().toString().padStart(2, "0");

          const colDiv = $("<div>").addClass("col-lg-12");
          const postDiv = $("<div>").addClass("blog__post");

          const header = $("<div>").addClass("blog__post__header");
          const headerInnerDiv = $("<div>");
          const title = $("<h3>").addClass("blog__post__title");
          const titleLink = $("<a>")
            .attr("href", contextPath + "/community/detail?id=" + post.postId)
            .text(post.title);
          const meta = $("<div>").addClass("blog__post__meta");
          const authorSpan = $("<span>").text(
            "작성자: " + (post.authorName || "익명")
          ); // null 방지
          const dateSpan = $("<span>").text("작성일: " + formattedDate);
          title.append(titleLink);
          meta.append(authorSpan).append(dateSpan);
          headerInnerDiv.append(title).append(meta);
          header.append(headerInnerDiv);
          postDiv.append(header);

          if (post.image) {
            const imageContainer = $("<div>").addClass(
              "blog__post__image-container"
            );

            const image = $("<img>")
              .addClass("blog__post__image")
              .attr("src", post.image)
              .attr("alt", "게시글 이미지");
            imageContainer.append(image);
            postDiv.append(imageContainer);
          }

          const body = $("<div>").addClass("blog__post__body");
          const content = $("<p>")
            .addClass("blog__post__content")
            .html(post.summary || "");
          body.append(content);
          postDiv.append(body);

          const footer = $("<div>").addClass("blog__post__footer");
          const stats = $("<div>").addClass("blog__post__stats");
          const viewStat = $("<div>")
            .addClass("stats__item")
            .append($("<i>").addClass("fa fa-eye"))
            .append(" " + (post.viewCount || 0));
          const likeStat = $("<div>")
            .addClass("stats__item")
            .append($("<i>").addClass("fa fa-heart"))
            .append(" " + (post.likeCount || 0));
          const commentStat = $("<div>")
            .addClass("stats__item")
            .append($("<i>").addClass("fa fa-comment"))
            .append(" " + (post.commentCount || 0));
          const categoryDiv = $("<div>").addClass("blog__post__category");
          const categorySpan = $("<span>").text(
            "#" + (post.category || "미분류")
          );
          stats.append(viewStat).append(likeStat).append(commentStat);
          categoryDiv.append(categorySpan);
          footer.append(stats).append(categoryDiv);
          postDiv.append(footer);

          colDiv.append(postDiv);
          postsContainer.append(colDiv);
        });

        let paginationHtml = "";
        const totalPages = data.totalPages;
        const currentPage = data.currentPage;

        if (totalPages > 0) {
          const maxVisiblePages = 5;
          let startPage = Math.max(
            1,
            currentPage - Math.floor(maxVisiblePages / 2)
          );
          let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

          if (
            endPage < totalPages &&
            endPage - startPage + 1 < maxVisiblePages
          ) {
            startPage = Math.max(1, endPage - maxVisiblePages + 1);
          }

          if (startPage > 1 && endPage - startPage + 1 < maxVisiblePages) {
            endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
          }

          if (currentPage > 1) {
            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', 1, '${sort}')">&laquo;&laquo;</a>`;
            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${
              currentPage - 1
            }, '${sort}')">&laquo;</a>`;
          } else {
            paginationHtml += `<span class="disabled">&laquo;&laquo;</span>`;
            paginationHtml += `<span class="disabled">&laquo;</span>`;
          }

          if (startPage > 1) {
            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', 1, '${sort}')">1</a>`;
            if (startPage > 2) {
              paginationHtml += `<span class="disabled">...</span>`; // 클릭 불가능한 ...
            }
          }

          for (let i = startPage; i <= endPage; i++) {
            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${i}, '${sort}')" class="${
              i == currentPage ? "active" : ""
            }">${i}</a>`;
          }

          if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
              paginationHtml += `<span class="disabled">...</span>`; // 클릭 불가능한 ...
            }
            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${totalPages}, '${sort}')">${totalPages}</a>`;
          }

          if (currentPage < totalPages) {
            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${
              currentPage + 1
            }, '${sort}')">&raquo;</a>`;
            paginationHtml += `<a href="javascript:void(0)" onclick="community.loadPosts('${category}', ${totalPages}, '${sort}')">&raquo;&raquo;</a>`;
          } else {
            paginationHtml += `<span class="disabled">&raquo;</span>`;
            paginationHtml += `<span class="disabled">&raquo;&raquo;</span>`;
          }
        }
        paginationContainer.html(paginationHtml);
      },
      error: (xhr, status, error) => {
        console.error("데이터 로드 중 오류 발생:", status, error, xhr);
        loadingSpinner.hide();
        let errorMsg = `데이터를 불러오는 중 오류가 발생했습니다. (상태: ${
          xhr.status || status
        })`;
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
      },
    });
  },

  init: function () {
    console.log("Community init called.");
    const communityDataElement = $("#community-data");
    if (communityDataElement.length > 0) {
      communityKeyword = communityDataElement.data("keyword") || "";
      communitySelectedCategory =
        communityDataElement.data("selected-category") || "";
      communityCurrentPage = parseInt(
        communityDataElement.data("current-page") || "1",
        10
      );
      communitySelectedSort =
        communityDataElement.data("selected-sort") || "comments";
      console.log("Community data loaded from #community-data:", {
        communityKeyword,
        communitySelectedCategory,
        communityCurrentPage,
        communitySelectedSort,
      });

      const urlParams = new URLSearchParams(window.location.search);
      const pageFromUrl = parseInt(urlParams.get("page") || "1", 10);
      if (!isNaN(pageFromUrl) && pageFromUrl > 0) {
        communityCurrentPage = pageFromUrl;
        console.log("Current page updated from URL:", communityCurrentPage);
      }
    } else {
      console.warn("#community-data element not found. Using default values.");
      const urlParams = new URLSearchParams(window.location.search);
      communityKeyword = urlParams.get("keyword") || "";
      communitySelectedCategory = urlParams.get("category") || "";
      communityCurrentPage = parseInt(urlParams.get("page") || "1", 10);
      communitySelectedSort = urlParams.get("sort") || "comments";
      console.log("Community data loaded from URL params:", {
        communityKeyword,
        communitySelectedCategory,
        communityCurrentPage,
        communitySelectedSort,
      });
    }

    $("#sortSelector").on("change", (e) => {
      const newSortValue = e.target.value;
      console.log("Sort changed to:", newSortValue);
      communitySelectedSort = newSortValue;
      communityCurrentPage = 1;
      this.loadPosts(
        communitySelectedCategory,
        communityCurrentPage,
        communitySelectedSort
      );

      const currentUrl = new URL(window.location.href);
      const params = new URLSearchParams(currentUrl.search);
      params.set("sort", newSortValue);
      params.set("page", "1");
      const basePath = window.location.pathname.includes("/community/search")
        ? contextPath + "/community/search"
        : contextPath + "/community";
      const newUrl = basePath + "?" + params.toString();
      window.history.pushState(
        { category: communitySelectedCategory, page: 1, sort: newSortValue },
        "",
        newUrl
      );
    });

    $(".shop__sidebar__categories ul li a").on("click", (e) => {
      e.preventDefault();
      console.log("Category link clicked:", e.target.href);

      $(".shop__sidebar__categories ul li a").removeClass("category-active");
      $(e.target).addClass("category-active");

      const href = $(e.target).attr("href");
      const url = new URL(window.location.origin + href);
      const category = url.searchParams.get("category") || "";

      communitySelectedCategory = category;
      communityCurrentPage = 1;
      communityKeyword = "";

      console.log(
        "Loading posts for category:",
        category,
        "with sort:",
        communitySelectedSort
      );
      this.loadPosts(
        communitySelectedCategory,
        communityCurrentPage,
        communitySelectedSort
      );

      const params = new URLSearchParams();
      if (category) params.set("category", category);
      params.set("sort", communitySelectedSort);
      params.set("page", "1");
      const newUrl = contextPath + "/community?" + params.toString();
      window.history.pushState(
        { category, page: 1, sort: communitySelectedSort },
        "",
        newUrl
      );

      $("#result-count").text("");
      $(".blog-sort-bar .left p").text(
        category === "popular"
          ? "인기글"
          : category === "notice"
          ? "공지사항"
          : category === "free"
          ? "자유게시판"
          : category === "show"
          ? "자랑게시판"
          : "전체 게시글"
      );
    });

    console.log(
      "Initial loadPosts call with:",
      communitySelectedCategory,
      communityCurrentPage,
      communitySelectedSort
    );
    this.loadPosts(
      communitySelectedCategory,
      communityCurrentPage,
      communitySelectedSort
    );
  },
};

$(function () {
  if ($("#community-data").length > 0) {
    community.init();
  } else {
    console.log(
      "Not on community page or #community-data missing, skipping community init."
    );
  }
});
