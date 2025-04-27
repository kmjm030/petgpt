<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <%-- 페이지 타이틀 설정 --%>

            <head>
                <!-- Bootstrap CSS CDN -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
                    crossorigin="anonymous">

                <!-- Bootstrap Icons CDN -->
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

                <!-- Font Awesome CDN -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                    integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

                <link rel="stylesheet" href="<c:url value='/css/style.css'/>" type="text/css">
            </head>

            <c:set var="pageTitle" value="AI 반려동물 품종 분석" scope="request" />

            <style>
                .analysis-container {
                    transition: box-shadow 0.3s ease;
                }

                .analysis-container:hover {
                    box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12) !important;
                }

                #analyzeButton {
                    transition: background-color 0.2s ease, transform 0.1s ease;
                }

                .image-preview-container img {
                    max-width: 100%;
                    max-height: 350px;
                }

                #analysisResult li {
                    position: relative;
                    padding-left: 25px;
                    list-style: none;
                }

                #analysisResult li::before {
                    content: '🐾';
                    position: absolute;
                    left: 0;
                    top: 1px;
                    color: var(--bs-primary);
                    font-size: 0.9em;
                }

                #petImage:focus,
                .form-control[type="file"]:focus {
                    box-shadow: none;
                    border-color: #ced4da;
                }

                .breadcrumb__links a.btn-link {
                    text-decoration: none;
                    transition: transform 0.1s ease;
                    display: inline-block;
                    color: inherit;
                }

                .breadcrumb__links a.btn-link:hover {
                    transform: scale(1.05);
                    color: inherit;
                }
            </style>

            <!-- Breadcrumb Section Begin -->
            <section class="breadcrumb-option">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="breadcrumb__text">
                                <h4>AI가 알려주는 우리 아이 품종은?</h4>
                                <div class="breadcrumb__links">
                                    <a href="/" class="btn btn-link p-0">Home</a>
                                    <span class="mx-1">/</span>
                                    <span>AI 품종 분석</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Breadcrumb Section End -->

            <!-- AI Analysis Section Begin -->
            <section class="ai-analysis spad">
                <div class="container">
                    <div class="card analysis-container shadow-sm border-0 rounded-lg mx-auto"
                        style="max-width: 800px;">
                        <div class="card-body p-lg-5 p-md-4 p-3">
                            <h5 class="card-title text-center fw-semibold mb-4">반려동물 사진으로 품종을 분석해보세요!</h5>

                            <div class="mb-4">
                                <label for="petImage" class="form-label fw-medium mb-2">분석할 이미지 선택 (JPEG, PNG)</label>
                                <div class="input-group">
                                    <input type="file" class="form-control" id="petImage" name="petImage"
                                        accept="image/jpeg, image/png">
                                    <button type="button" class="btn btn-dark fw-medium" id="analyzeButton" disabled>분석
                                        시작</button>
                                </div>
                            </div>

                            <div id="imagePreview"
                                class="text-center p-3 p-md-4 bg-light border border-dashed rounded mb-4"
                                style="display: none;">
                                <img id="previewImage" src="#" alt="이미지 미리보기" class="rounded shadow-sm" />
                            </div>

                            <div id="analysisLoading"
                                class="d-none p-3 text-center bg-secondary bg-opacity-10 rounded mb-4">
                                <div class="spinner-border spinner-border-sm text-primary me-2" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <span class="text-secondary fw-medium">AI가 이미지를 분석하고 있습니다... 잠시만 기다려주세요.</span>
                            </div>

                            <div id="analysisResult" class="border-top pt-4">
                                <%-- 분석 결과가 여기에 표시됩니다 --%>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- AI Analysis Section End -->

            <!-- Script Begin -->
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const petImageInput = document.getElementById('petImage');
                    const analyzeButton = document.getElementById('analyzeButton');
                    const analysisResultDiv = document.getElementById('analysisResult');
                    const analysisLoadingDiv = document.getElementById('analysisLoading');
                    const imagePreviewDiv = document.getElementById('imagePreview');
                    const previewImage = document.getElementById('previewImage');

                    petImageInput.addEventListener('change', function () {
                        const file = this.files[0];
                        analysisResultDiv.innerHTML = '';
                        imagePreviewDiv.style.display = 'none';

                        if (file && (file.type === "image/jpeg" || file.type === "image/png")) {
                            analyzeButton.disabled = false;

                            // 이미지 미리보기
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                previewImage.src = e.target.result;
                                imagePreviewDiv.style.display = 'block';
                            }
                            reader.readAsDataURL(file);

                        } else {
                            analyzeButton.disabled = true;
                            if (file) {
                                alert('JPEG 또는 PNG 이미지만 선택 가능합니다.');
                                petImageInput.value = '';
                            }
                        }
                    });

                    analyzeButton.addEventListener('click', function () {
                        const file = petImageInput.files[0];
                        if (!file) {
                            alert('분석할 이미지 파일을 선택해주세요.');
                            return;
                        }

                        analysisResultDiv.innerHTML = '';
                        analysisLoadingDiv.classList.remove('d-none');
                        analysisLoadingDiv.style.display = 'block';
                        analyzeButton.disabled = true;
                        analyzeButton.innerHTML = `<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span> 분석 중...`; // 버튼 텍스트 변경 (로딩 스피너 추가)

                        const formData = new FormData();
                        formData.append('image', file);

                        fetch('/api/pets/analyze-breed', {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => {
                                if (!response.ok) {
                                    return response.text().then(text => {
                                        throw new Error(text || `이미지 분석 요청 실패 (Status: ${response.status})`);
                                    });
                                }
                                return response.json();
                            })
                            .then(results => {
                                analysisLoadingDiv.classList.add('d-none');
                                analysisLoadingDiv.style.display = 'none';
                                analyzeButton.disabled = false;
                                analyzeButton.innerHTML = '분석 시작';

                                if (results && results.length > 0) {
                                    let resultHTML = '<h5 class="text-primary fw-semibold mb-3"><i class="fas fa-paw me-2"></i>AI 분석 결과</h5><ul class="list-unstyled">';
                                    results.slice(0, 5).forEach(result => {
                                        resultHTML += '<li class="mb-2 fs-6 fw-medium text-dark">' + result.breedName + ' <span class="text-muted">(' + result.scorePercent + '%)</span></li>';
                                    });
                                    resultHTML += '</ul>';
                                    analysisResultDiv.innerHTML = resultHTML;
                                } else {
                                    analysisResultDiv.innerHTML = '<p class="text-muted text-center fst-italic mt-3">관련 품종 정보를 찾을 수 없거나, 분석에 실패했습니다.</p>';
                                }
                            })
                            .catch(error => {
                                console.error('Error during analysis:', error);
                                analysisLoadingDiv.classList.add('d-none');
                                analysisLoadingDiv.style.display = 'none';
                                analyzeButton.disabled = false;
                                analyzeButton.innerHTML = '분석 시작';
                                analysisResultDiv.innerHTML = `<p class="text-danger text-center fw-medium mt-3"><strong>분석 오류:</strong> ${error.message}</p>`;
                            });
                    });
                });
            </script>
            <!-- Script End -->