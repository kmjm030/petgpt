<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <link rel="stylesheet" href="<c:url value='/css/community_write.css'/>" type="text/css">

    <!-- Breadcrumb Section Begin -->
    <section class="breadcrumb-option">
      <div class="container">
        <div class="row">
          <div class="col-lg-12">
            <div class="breadcrumb__text">
              <h4>게시글 작성</h4>
              <div class="breadcrumb__links">
                <a href="<c:url value='/'/>">Home</a>
                <a href="<c:url value='/community'/>">커뮤니티</a>
                <span>게시글 작성</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Breadcrumb Section End -->

    <!-- Data for JS -->
    <div id="community-write-data" style="display: none;" data-context-path="${pageContext.request.contextPath}">
    </div>

    <section class="community-write spad">
      <div class="container">
        <div class="community-write-container">
          <form id="postForm" enctype="multipart/form-data">
            <div class="form-group">
              <input type="text" class="form-title" name="title" placeholder="제목을 입력해 주세요." required>
            </div>

            <div class="form-group category-group">
              <!-- <label for="category">카테고리</label> -->
              <select class="form-select" name="category" id="category" required>
                <option value="" disabled selected>카테고리를 선택해주세요</option>
                <option value="notice">공지사항</option>
                <option value="free">자유게시판</option>
                <option value="show">펫자랑게시판</option>
              </select>
            </div>

            <!-- 카테고리와 에디터 사이 공간 분리 -->
            <div style="height: 15px; clear: both;"></div>

            <div class="form-group">
              <textarea class="form-content" name="content" id="summernote" placeholder="내용을 입력하세요."></textarea>
            </div>

            <div class="form-group">
              <label for="imageUpload">대표 이미지 첨부</label>
              <input type="file" class="form-control" id="imageUpload" name="thumbnailImage" accept="image/*">
              <div id="imagePreview" class="image-preview-container">
                <div class="image-preview-item" style="display: none;">
                  <img id="thumbnailImagePreviewWrite" src="" alt="썸네일 미리보기">
                  <button type="button" class="remove-btn">×</button>
                </div>
              </div>
              <small class="text-muted">* 에디터 내부에서도 이미지를 첨부할 수 있습니다.</small>
            </div>

            <div class="btn-wrapper">
              <button type="submit" class="btn-submit">등록</button>
              <a href="<c:url value='/community'/>" class="btn-cancel">취소</a>
            </div>
          </form>
        </div>
      </div>
    </section>