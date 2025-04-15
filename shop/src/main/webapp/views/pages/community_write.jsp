<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Popper.js CDN 추가 -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!-- Summernote 에디터 관련 파일 -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>

<script>
  const community_write = {
    initSummernote: function() {
      $('#summernote').summernote({
        lang: 'ko-KR',
        height: 350,
        placeholder: '내용을 입력하세요.',
        toolbar: [
          ['style', ['style']],
          ['font', ['bold', 'underline', 'clear']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture']],
          ['view', ['fullscreen', 'codeview', 'help']]
        ],
        callbacks: {
          onImageUpload: function(files) {
            for(let i = 0; i < files.length; i++) {
              community_write.uploadImage(files[i]);
            }
          }
        }
      });
    },
    
    uploadImage: function(file) {
      const formData = new FormData();
      formData.append('file', file);
      
      $.ajax({
        url: '<c:url value="/community/upload/image"/>',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
          $('#summernote').summernote('insertImage', response.imageUrl);
        },
        error: function(xhr) {
          console.error('이미지 업로드 실패:', xhr);
          alert('이미지 업로드에 실패했습니다.');
        }
      });
    },
    
    setupImageUpload: function() {
      $('#imageUpload').change(function() {
        community_write.updatePreview();
      });
      
      $(document).on('click', '.remove-btn', function() {
        const index = $(this).data('index');
        $(this).closest('.image-preview-item').remove();
        
        const fileInput = document.getElementById('imageUpload');
        const files = fileInput.files;
        
        const dataTransfer = new DataTransfer();
        
        Array.from(files).forEach((file, i) => {
          if (i !== index) {
            dataTransfer.items.add(file);
          }
        });
        
        fileInput.files = dataTransfer.files;
      });
    },
    
    updatePreview: function() {
      $('#imagePreview').html('');
      const files = document.getElementById('imageUpload').files;
      
      if(files && files.length > 0) {
        for(let i = 0; i < files.length; i++) {
          const file = files[i];
          const reader = new FileReader();
          
          reader.onload = function(e) {
            $('#imagePreview').append(`
              <div class="image-preview-item">
                <img src="${e.target.result}" alt="미리보기">
                <button type="button" class="remove-btn" data-index="${i}">×</button>
              </div>
            `);
          }
          
          reader.readAsDataURL(file);
        }
      }
    },
    
    setupFormSubmit: function() {
      $('#postForm').submit(function(e) {
        e.preventDefault();

        const formData = new FormData();
        formData.append('title', $('input[name="title"]').val());
        formData.append('category', $('#category').val());
        formData.append('content', $('#summernote').summernote('code'));
        
        const thumbnailFile = document.getElementById('imageUpload').files[0];
        if (thumbnailFile) {
            formData.append('thumbnailImage', thumbnailFile);
        }
        
        $.ajax({
            url: '<c:url value="/community/write/submit"/>', 
            type: 'POST',
            data: formData, 
            processData: false, 
            contentType: false, 
            success: function(response) {
                alert('게시글이 등록되었습니다.');
                window.location.href = '<c:url value="/community"/>'; 
            },
            error: function(xhr, status, error) {
                console.error('게시글 등록 실패:', status, error, xhr);
                let errorMessage = '게시글 등록 중 오류가 발생했습니다.';
                if (xhr.responseText) {
 
                }
                alert(errorMessage);
            }
        });
      });
    },
    
    init: function() {
      this.initSummernote();
      this.setupImageUpload();
      this.setupFormSubmit();
    }
  };
  
  $(document).ready(function() {
    community_write.init();
  });
</script>

<style>
  .community-write-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 30px 20px;
  }
  
  /* 전체 섹션 패딩 조정 */
  .community-write.spad {
    padding-top: 50px;  /* 기본 패딩보다 작은 값으로 설정 */
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
  
  .image-preview-item .remove-btn {
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
          <div id="imagePreview" class="image-preview-container"></div>
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
