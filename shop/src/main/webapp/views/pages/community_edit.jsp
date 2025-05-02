<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!-- Popper.js CDN 추가 -->
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
            <!-- Summernote 에디터 관련 파일 -->
            <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

            <style>
                .community-write-container {
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 30px 20px;
                }

                .community-write.spad {
                    padding-top: 50px;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                .form-title {
                    width: 100%;
                    padding: 12px 15px;
                    border: 1px solid #e1e1e1;
                    border-radius: 4px;
                    font-size: 16px;
                }

                .form-content {
                    width: 100%;
                    padding: 15px;
                    border: 1px solid #e1e1e1;
                    border-radius: 4px;
                    min-height: 350px;
                    resize: vertical;
                    font-size: 15px;
                    line-height: 1.6;
                }

                .btn-wrapper {
                    display: flex;
                    justify-content: center;
                    gap: 10px;
                    margin-top: 30px;
                }

                .btn-submit {
                    background-color: #111111;
                    color: #ffffff;
                    padding: 12px 30px;
                    border: none;
                    font-weight: 600;
                    cursor: pointer;
                    transition: background-color 0.3s;
                }

                .btn-submit:hover {
                    background-color: #333333;
                }

                .btn-cancel {
                    background-color: #f0f0f0;
                    color: #333333;
                    padding: 12px 30px;
                    border: 1px solid #e1e1e1;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s;
                }

                .btn-cancel:hover {
                    background-color: #e0e0e0;
                }

                .form-select {
                    width: 100%;
                    padding: 8px 15px;
                    border: 1px solid #e1e1e1;
                    border-radius: 4px;
                    font-size: 16px;
                    appearance: none;
                    background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24'%3E%3Cpath fill='%23333' d='M7 10l5 5 5-5H7z'/%3E%3C/svg%3E");
                    background-repeat: no-repeat;
                    background-position: right 15px center;
                    position: relative;
                    z-index: 150;
                    line-height: 1.5;
                    display: flex;
                    align-items: center;
                    height: 42px;
                }

                .image-preview-container {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 10px;
                    margin-top: 10px;
                }

                .image-preview-item {
                    position: relative;
                    width: 100px;
                    height: 100px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    overflow: hidden;
                }

                .image-preview-item img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                }

                .image-preview-item .remove-thumbnail-btn {
                    position: absolute;
                    top: 5px;
                    right: 5px;
                    width: 20px;
                    height: 20px;
                    background-color: rgba(0, 0, 0, 0.5);
                    color: white;
                    border: none;
                    border-radius: 50%;
                    cursor: pointer;
                    font-size: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .note-editor {
                    margin-top: 20px !important;
                }

                .note-editor.note-frame {
                    position: relative;
                    z-index: 10;
                }

                .category-group {
                    margin-bottom: 30px !important;
                }
            </style>

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
                                <textarea class="form-content" name="boardContent" id="summernote"
                                    placeholder="내용을 입력하세요."></textarea>
                            </div>

                            <div class="form-group">
                                <label for="thumbnailImage">대표 이미지 첨부 (선택)</label>
                                <input type="file" class="form-control-file" id="thumbnailImage" name="thumbnailImage"
                                    accept="image/*">
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