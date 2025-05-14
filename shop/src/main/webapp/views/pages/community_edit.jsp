<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <link rel="stylesheet" href="<c:url value='/css/community_edit.jsp'/>" type="text/css">
      <section class="breadcrumb-option">
        <div class="container">
          <div class="row">
            <div class="col-lg-12">
              <div class="breadcrumb__text">
                <h4>게시글 수정</h4>
                <div class="breadcrumb__links">
                  <a href="<c:url value='/'/>">Home</a>
                  <a href="<c:url value='/community'/>">커뮤니티</a>
                  <span>게시글 수정</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Data for JS -->
      <div id="community-edit-data" style="display: none;" data-context-path="${pageContext.request.contextPath}"
        data-board-key="${board.boardKey}" data-initial-content="${board.boardContent}"
        data-initial-image-url="${board.boardImg}">
      </div>

      <section class="community-write spad">
        <div class="container">
          <div class="community-write-container">
            <form id="editPostForm" enctype="multipart/form-data">
              <input type="hidden" name="boardKey" value="${board.boardKey}">
              <div class="form-group">
                <input type="text" class="form-title" name="boardTitle" placeholder="제목을 입력해 주세요."
                  value="${board.boardTitle}" required>
              </div>

              <div class="form-group category-group">
                <select class="form-select" name="category" id="boardCategory" required>
                  <option value="" disabled ${board.category==null ? 'selected' : '' }>카테고리를 선택해주세요
                  </option>
                  <option value="notice" ${board.category=='notice' ? 'selected' : '' }>공지사항
                  </option>
                  <option value="free" ${board.category=='free' ? 'selected' : '' }>자유게시판
                  </option>
                  <option value="show" ${board.category=='show' ? 'selected' : '' }>펫자랑게시판
                  </option>
                </select>
              </div>

              <div style="height: 15px; clear: both;"></div>

              <div class="form-group">
                <textarea class="form-content" name="boardContent" id="summernote" placeholder="내용을 입력하세요."></textarea>
              </div>

              <div class="form-group">
                <label for="thumbnailImage">대표 이미지 첨부 (선택)</label>
                <input type="file" class="form-control-file" id="thumbnailImage" name="thumbnailImage" accept="image/*">
                <div id="thumbnailPreview" class="image-preview-container">
                  <div class="image-preview-item" style="display: none;">
                    <img id="thumbnailImagePreview" src="" alt="썸네일 미리보기">
                    <button type="button" class="remove-thumbnail-btn">×</button>
                  </div>
                </div>
                <input type="hidden" id="boardImgHidden" name="boardImg">
                <small class="text-muted">* 기존 이미지를 유지하려면 새 이미지를 선택하지 마세요. 이미지를 삭제하려면 미리보기의 'X' 버튼을
                  누르세요.</small>
              </div>

              <div class="btn-wrapper">
                <button type="submit" class="btn-submit">수정 완료</button>
                <a href="${pageContext.request.contextPath}/community/detail?id=${board.boardKey}"
                  class="btn-cancel">취소</a>
              </div>
            </form>
          </div>
        </div>
      </section>