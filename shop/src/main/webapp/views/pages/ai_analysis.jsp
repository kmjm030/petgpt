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
                    console.log("DOM 로드 완료됨"); // DOM 로딩 확인

                    const petImageInput = document.getElementById('petImage');
                    const analyzeButton = document.getElementById('analyzeButton');
                    const analysisResultDiv = document.getElementById('analysisResult');
                    const analysisLoadingDiv = document.getElementById('analysisLoading');
                    const imagePreviewDiv = document.getElementById('imagePreview');
                    const previewImage = document.getElementById('previewImage');

                    // 각 요소가 제대로 찾아졌는지 확인
                    if (!petImageInput) console.error("오류: 'petImage' ID를 가진 요소를 찾을 수 없습니다.");
                    if (!analyzeButton) console.error("오류: 'analyzeButton' ID를 가진 요소를 찾을 수 없습니다.");
                    if (!imagePreviewDiv) console.error("오류: 'imagePreview' ID를 가진 요소를 찾을 수 없습니다.");
                    if (!previewImage) console.error("오류: 'previewImage' ID를 가진 요소를 찾을 수 없습니다.");

                    petImageInput.addEventListener('change', function () {
                        console.log("파일 입력 변경 감지됨"); // change 이벤트 발생 확인
                        analysisResultDiv.innerHTML = ''; // 이전 결과 초기화
                        imagePreviewDiv.style.display = 'none'; // 미리보기 일단 숨김

                        // 파일이 선택되었는지 확인
                        if (this.files && this.files.length > 0) {
                            const file = this.files[0];
                            console.log("선택된 파일:", file.name, "| 타입:", file.type); // 파일 정보 로깅

                            // 파일 타입 확인 (JPEG 또는 PNG)
                            if (file.type === "image/jpeg" || file.type === "image/png") {
                                console.log("파일 타입 유효함 (JPEG 또는 PNG)");
                                analyzeButton.disabled = false; // 버튼 활성화
                                console.log("분석 시작 버튼 활성화됨");

                                // --- 이미지 미리보기 로직 ---
                                const reader = new FileReader();

                                reader.onload = function (e) {
                                    console.log("FileReader 로드 완료 (onload 이벤트 발생)"); // onload 이벤트 확인
                                    if (previewImage) {
                                        previewImage.src = e.target.result; // 이미지 소스 설정
                                        console.log("미리보기 이미지 src 설정 완료");
                                    } else {
                                        console.error("오류: previewImage 요소를 찾을 수 없음 (onload 내부)");
                                    }
                                    if (imagePreviewDiv) {
                                        imagePreviewDiv.style.display = 'block'; // 미리보기 컨테이너 표시
                                        console.log("미리보기 컨테이너 표시됨");
                                    } else {
                                        console.error("오류: imagePreviewDiv 요소를 찾을 수 없음 (onload 내부)");
                                    }
                                }

                                reader.onerror = function (e) {
                                    console.error("FileReader 오류 발생:", e); // FileReader 오류 로깅
                                }

                                reader.readAsDataURL(file); // 파일 읽기 시작
                                console.log("FileReader readAsDataURL 호출됨");
                                // --- 이미지 미리보기 로직 끝 ---

                            } else {
                                // 유효하지 않은 파일 타입 처리
                                console.log("유효하지 않은 파일 타입:", file.type);
                                analyzeButton.disabled = true; // 버튼 비활성화
                                alert('JPEG 또는 PNG 이미지만 선택 가능합니다.');
                                petImageInput.value = ''; // 파일 입력 초기화
                                console.log("분석 시작 버튼 비활성화됨, 파일 입력 초기화됨");
                            }
                        } else {
                            // 파일이 선택되지 않은 경우
                            console.log("파일이 선택되지 않았거나 files 배열이 비어있음");
                            analyzeButton.disabled = true; // 버튼 비활성화
                        }
                    });

                    // --- 분석 시작 버튼 클릭 이벤트 리스너 (기존 코드 유지) ---
                    analyzeButton.addEventListener('click', function () {
                        const file = petImageInput.files[0];
                        if (!file) {
                            alert('분석할 이미지 파일을 선택해주세요.');
                            return;
                        }

                        // 로딩 UI 표시 및 버튼 비활성화
                        analysisResultDiv.innerHTML = '';
                        analysisLoadingDiv.classList.remove('d-none');
                        analysisLoadingDiv.style.display = 'block';
                        analyzeButton.disabled = true;
                        analyzeButton.innerHTML = '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span> 분석 중...';

                        const formData = new FormData();
                        formData.append('image', file);

                        // API 호출
                        fetch('/api/pets/analyze-breed', {
                            method: 'POST',
                            body: formData
                        })
                            .then(response => {
                                if (!response.ok) {
                                    return response.text().then(text => {
                                        throw new Error(text || '이미지 분석 요청 실패 (Status: ' + response.status + ')');
                                    });
                                }
                                return response.json();
                            })
                            .then(results => {
                                // 로딩 UI 숨김 및 버튼 활성화
                                analysisLoadingDiv.classList.add('d-none');
                                analysisLoadingDiv.style.display = 'none';
                                analyzeButton.disabled = false;
                                analyzeButton.innerHTML = '분석 시작';

                                // 결과 표시 로직
                                if (results && results.length > 0) {
                                    let resultHTML = '<h5 class="text-primary fw-semibold mb-3"><i class="fas fa-paw me-2"></i>AI 분석 결과</h5>';
                                    results.slice(0, 5).forEach(result => {
                                        resultHTML += '<div class="result-item mb-3 p-3 border rounded bg-light shadow-sm">';
                                        resultHTML += '<div class="d-flex justify-content-between align-items-center mb-2">';
                                        resultHTML += '<span class="breed-name fs-6 fw-bold text-dark">' + result.breedName + '</span>';
                                        resultHTML += '<span class="score badge bg-primary rounded-pill">' + result.scorePercent + '%</span>';
                                        resultHTML += '</div>';

                                        if (result.characteristics && Object.keys(result.characteristics).length > 0) {
                                            resultHTML += '<div class="characteristics mt-2 pt-2 border-top">';
                                            resultHTML += '<small class="text-muted d-block mb-1">주요 특징:</small>';
                                            resultHTML += '<ul class="list-unstyled mb-0" style="font-size: 0.9em;">';
                                            for (const [key, value] of Object.entries(result.characteristics)) {
                                                let koreanKey = key;
                                                if (key === 'size') koreanKey = '크기';
                                                else if (key === 'activityLevel') koreanKey = '활동량';
                                                else if (key === 'groomingNeeds') koreanKey = '털 관리';
                                                else if (key === 'temperament') koreanKey = '성격';
                                                resultHTML += '<li class="mb-1"><span class="fw-medium">' + koreanKey + ':</span> ' + value + '</li>';
                                            }
                                            resultHTML += '</ul>';
                                            resultHTML += '</div>';
                                        } else {
                                            resultHTML += '<p class="text-muted fst-italic mt-2 mb-0" style="font-size: 0.9em;">추가 특징 정보 없음</p>';
                                        }
                                        resultHTML += '</div>';
                                    });
                                    analysisResultDiv.innerHTML = resultHTML;
                                } else {
                                    analysisResultDiv.innerHTML = '<p class="text-muted text-center fst-italic mt-3">관련 품종 정보를 찾을 수 없거나, 분석에 실패했습니다.</p>';
                                }
                            })
                            .catch(error => {
                                // 오류 처리
                                console.error('분석 중 오류 발생:', error);
                                analysisLoadingDiv.classList.add('d-none');
                                analysisLoadingDiv.style.display = 'none';
                                analyzeButton.disabled = false;
                                analyzeButton.innerHTML = '분석 시작';
                                analysisResultDiv.innerHTML = '<p class="text-danger text-center fw-medium mt-3"><strong>분석 오류:</strong> ' + error.message + '</p>';
                            });
                    });
                    // --- 분석 시작 버튼 클릭 이벤트 리스너 끝 ---
                });
            </script>
            <!-- Script End -->