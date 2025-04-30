<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">

                <style>
                    .quantity-controls .btn:hover {
                        background-color: #000 !important;
                        border-color: #000 !important;
                        color: #fff !important;
                    }

                    .quantity-controls>* {
                        vertical-align: middle;
                    }

                    .option-group {
                        margin-bottom: 20px;
                    }

                    .option-group span {
                        display: block;
                        margin-bottom: 10px;
                        font-weight: bold;
                    }

                    .option-group label {
                        display: inline-block;
                        padding: 8px 15px;
                        border: 1px solid #e1e1e1;
                        border-radius: 4px;
                        margin-right: 10px;
                        margin-bottom: 10px;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        font-size: 14px;
                        background-color: #fff;
                        color: #666;
                        white-space: nowrap;
                        display: inline-flex;
                        align-items: center;
                        vertical-align: top;
                    }

                    .option-group label:not(.disabled):hover {
                        border-color: #111;
                        color: #111;
                    }

                    .option-group label.active {
                        border-color: #ca1515;
                        background-color: #ca1515;
                        color: #fff;
                        font-weight: bold;
                    }

                    .option-group label.disabled {
                        background-color: #f5f5f5;
                        color: #aaa;
                        cursor: not-allowed;
                        border-color: #e1e1e1;
                        text-decoration: line-through;
                    }

                    .option-group label.disabled:hover {
                        border-color: #e1e1e1;
                    }

                    .option-group input[type="radio"] {
                        display: none;
                    }

                    .product__details__option select {
                        width: calc(50% - 10px);
                        padding: 10px;
                        margin-bottom: 15px;
                        border: 1px solid #e1e1e1;
                        border-radius: 4px;
                        font-size: 14px;
                        color: #666;
                        background-color: #fff;
                        margin-right: 15px;
                        display: inline-block;
                        vertical-align: top;
                    }

                    .product__details__option select:last-child {
                        margin-right: 0;
                    }

                    .option-info {
                        margin-top: 10px;
                        padding: 10px;
                        background-color: #f9f9f9;
                        border: 1px solid #eee;
                        border-radius: 4px;
                        font-size: 14px;
                        min-height: 50px;
                        padding: 15px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .option-info .price-change {
                        font-weight: bold;
                        color: #ca1515;
                        margin-right: 15px;
                    }

                    .option-info .stock-status {
                        font-weight: bold;
                    }

                    .option-info .stock-status.out-of-stock {
                        color: #dc3545;
                    }

                    .option-info .stock-status.in-stock {
                        color: #28a745;
                    }

                    .shop-detail-board {
                        padding: 50px;
                    }

                    #boardRe {
                        color: rosybrown;
                    }

                    /* --- Sticky Footer --- */
                    .sticky-footer-buttons {
                        position: fixed;
                        bottom: 0;
                        left: 50%;
                        transform: translateX(-50%);
                        width: 60%;
                        display: flex;
                        padding: 15px;
                        background-color: #fff;
                        box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.1);
                        z-index: 1000;
                        gap: 10px;
                    }

                    .sticky-footer-buttons button {
                        flex-grow: 1;
                        padding: 5px 15px;
                        /* 위아래 padding 더 줄임 */
                        font-size: 16px;
                        border-radius: 5px;
                        cursor: pointer;
                    }

                    #add-to-wishlist-btn {
                        background-color: #eee;
                        border: 1px solid #ddd;
                        color: #333;
                        flex-grow: 0;
                        padding: 5px 20px;
                        /* 위아래 padding 더 줄임 */
                    }

                    #open-main-modal-btn {
                        background-color: #000;
                        border: none;
                        color: #fff;
                        font-weight: bold;
                    }

                    /* --- Modal Overlay --- */
                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background-color: rgba(0, 0, 0, 0.5);
                        z-index: 1010;
                        display: none;
                        opacity: 0;
                        transition: opacity 0.3s ease-in-out;
                    }

                    .modal-overlay.active {
                        display: block;
                        opacity: 1;
                    }

                    /* --- Bottom Sheet Modal --- */
                    #options-bottom-sheet {
                        position: fixed;
                        bottom: 0;
                        left: 0;
                        width: 100%;
                        max-height: 70vh;
                        background-color: #fff;
                        border-top-left-radius: 15px;
                        border-top-right-radius: 15px;
                        box-shadow: 0 -5px 15px rgba(0, 0, 0, 0.15);
                        z-index: 1020;
                        transform: translateY(100%);
                        transition: transform 0.3s ease-in-out;
                        display: flex;
                        flex-direction: column;
                        padding: 20px;
                        padding-bottom: 90px;
                        box-sizing: border-box;
                    }

                    #options-bottom-sheet.active {
                        transform: translateY(0);
                    }

                    .modal-handle {
                        width: 50px;
                        height: 5px;
                        background-color: #ccc;
                        border-radius: 3px;
                        margin: -10px auto 15px;
                        cursor: grab;
                    }

                    #selected-options-container {
                        overflow-y: auto;
                        margin-bottom: 15px;
                        flex-grow: 1;
                        min-height: 50px;
                    }

                    .option-trigger-buttons button {
                        display: block;
                        width: 100%;
                        padding: 12px 15px;
                        margin-bottom: 10px;
                        border: 1px solid #eee;
                        background-color: #f9f9f9;
                        border-radius: 5px;
                        text-align: left;
                        font-size: 15px;
                        color: #555;
                        cursor: pointer;
                        position: relative;
                    }

                    .option-trigger-buttons button:disabled {
                        background-color: #f0f0f0;
                        color: #aaa;
                        cursor: not-allowed;
                    }

                    .option-trigger-buttons button .arrow {
                        position: absolute;
                        right: 15px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: #888;
                    }

                    .total-summary {
                        border-top: 1px solid #eee;
                        padding-top: 15px;
                        margin-top: auto;
                        text-align: right;
                        font-size: 16px;
                        font-weight: bold;
                    }

                    .total-summary span {
                        color: #ca1515;
                    }

                    #final-add-all-to-cart-btn {
                        display: block;
                        width: 100%;
                        padding: 15px;
                        margin-top: 15px;
                        background-color: #000;
                        color: #fff;
                        border: none;
                        border-radius: 5px;
                        font-size: 16px;
                        font-weight: bold;
                        cursor: pointer;
                    }

                    #final-add-all-to-cart-btn:disabled {
                        background-color: #ccc;
                        cursor: not-allowed;
                    }


                    /* --- Center Modals (Color/Size) --- */
                    .center-modal {
                        position: fixed;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%) scale(0.8);
                        background-color: #fff;
                        border-radius: 10px;
                        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
                        z-index: 1030;
                        padding: 25px;
                        width: 50%;
                        opacity: 0;
                        visibility: hidden;
                        transition: opacity 0.3s ease, transform 0.3s ease, visibility 0s 0.3s;
                        box-sizing: border-box;
                    }

                    .center-modal.active {
                        opacity: 1;
                        transform: translate(-50%, -50%) scale(1);
                        visibility: visible;
                        transition: opacity 0.3s ease, transform 0.3s ease, visibility 0s 0s;
                    }

                    .center-modal h5 {
                        margin-top: 0;
                        margin-bottom: 20px;
                        font-size: 18px;
                        text-align: center;
                        position: relative;
                    }

                    .center-modal .close-modal-btn {
                        position: absolute;
                        top: -10px;
                        right: -5px;
                        background: none;
                        border: none;
                        font-size: 24px;
                        color: #888;
                        cursor: pointer;
                        padding: 5px;
                        line-height: 1;
                    }

                    .modal-options-list {
                        max-height: 40vh;
                        overflow-y: auto;
                        margin-top: 15px;
                    }

                    .modal-options-list button {
                        display: block;
                        width: 100%;
                        padding: 10px 15px;
                        margin-bottom: 8px;
                        border: 1px solid #eee;
                        background-color: #fff;
                        border-radius: 5px;
                        text-align: center;
                        font-size: 15px;
                        cursor: pointer;
                        transition: background-color 0.2s, border-color 0.2s;
                    }

                    .modal-options-list button:hover:not(:disabled) {
                        background-color: #f5f5f5;
                        border-color: #ddd;
                    }

                    .modal-options-list button:disabled {
                        background-color: #f8f8f8;
                        color: #aaa;
                        cursor: not-allowed;
                        text-decoration: line-through;
                    }

                    #size-select-modal .selected-color-info {
                        text-align: center;
                        margin-bottom: 15px;
                        font-size: 14px;
                        color: #777;
                    }

                    /* --- Selected Option Item --- */
                    .selected-option-item {
                        background-color: #f9f9f9;
                        border: 1px solid #eee;
                        border-radius: 5px;
                        padding: 15px;
                        margin-bottom: 10px;
                        position: relative;
                    }

                    .selected-option-item .option-name {
                        font-size: 15px;
                        margin-bottom: 10px;
                        display: block;
                        padding-right: 25px;
                    }

                    .selected-option-item .option-controls {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .selected-option-item .quantity-control {
                        display: flex;
                        align-items: center;
                    }

                    .selected-option-item .quantity-control button {
                        background-color: #fff;
                        border: 1px solid #ccc;
                        color: #555;
                        width: 30px;
                        height: 30px;
                        font-size: 16px;
                        cursor: pointer;
                        border-radius: 3px;
                        line-height: 28px;
                        padding: 0;
                    }

                    .selected-option-item .quantity-control input {
                        width: 40px;
                        height: 30px;
                        text-align: center;
                        border: 1px solid #ccc;
                        margin: 0 5px;
                        font-size: 14px;
                        border-radius: 3px;
                        -moz-appearance: textfield;
                    }

                    .selected-option-item .quantity-control input::-webkit-outer-spin-button,
                    .selected-option-item .quantity-control input::-webkit-inner-spin-button {
                        -webkit-appearance: none;
                        margin: 0;
                    }

                    .selected-option-item .stock-info {
                        font-size: 12px;
                        color: #888;
                        margin-left: 10px;
                    }

                    .selected-option-item .item-price {
                        font-size: 15px;
                        font-weight: bold;
                    }

                    .selected-option-item .remove-item-btn {
                        position: absolute;
                        top: 10px;
                        right: 10px;
                        background: none;
                        border: none;
                        font-size: 18px;
                        color: #aaa;
                        cursor: pointer;
                        padding: 5px;
                        line-height: 1;
                    }

                    .selected-option-item .remove-item-btn:hover {
                        color: #555;
                    }

                    .fade-in {
                        animation: fadeIn 0.3s ease-in-out;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(-10px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .product__details__tab__content a {
                        color: black;
                    }

                    /* 상세설명 탭 내용 스타일링 */
                    #tabs-5 .product__details__tab__content {
                        max-width: 1050px;
                        margin: 0 auto;
                        padding: 40px 20px;
                        background-color: #f9f9f9;
                        font-size: 20px;
                        line-height: 2.5;
                        color: #333;
                        overflow: hidden;
                    }

                    /* 상세설명 내 애니메이션 대상 요소 (span.desc-line) 초기 상태 */
                    #tabs-5 .product__details__tab__content span.desc-line {
                        display: block;
                        opacity: 0;
                        transform: translateY(20px);
                        transition: opacity 1.3s ease-out, transform 1.3s ease-out;
                        margin-bottom: 0.5em;
                    }

                    /* 애니메이션 활성화 클래스 */
                    #tabs-5 .product__details__tab__content span.desc-line.reveal-line {
                        opacity: 1;
                        transform: translateY(0);
                    }

                    #tabs-5 .product__details__tab__content span.desc-line strong {
                        font-weight: bold;
                    }

                    #tabs-5 .product__details__tab__content p {
                        text-align: left;
                        margin-bottom: 1.5em;
                    }

                    .product__details__price {
                        margin-bottom: 15px;
                    }

                    .hot-deal-price {
                        color: #ca1515;
                        font-size: 28px;
                        font-weight: bold;
                        margin-right: 10px;
                    }

                    .discount-badge {
                        background-color: #ffc107;
                        color: #333;
                        padding: 3px 8px;
                        border-radius: 4px;
                        font-size: 14px;
                        font-weight: normal;
                        margin-left: 5px;
                        vertical-align: middle;
                    }

                    .product__details__price del {
                        font-size: 18px;
                        color: #b7b7b7;
                    }

                    .product__details__price h3 {
                        font-size: 28px;
                        color: #111111;
                        font-weight: 600;
                        margin-bottom: 0;
                    }
                </style>

                <script>
                    function toggleContent(id) {
                        var contentRow = document.getElementById(id);
                        if (contentRow.style.display === "none" || contentRow.style.display === "") {
                            contentRow.style.display = "table-row";
                            contentRow.classList.add('fade-in');
                        } else {
                            contentRow.style.display = "none";
                            contentRow.classList.remove('fade-in');
                        }
                    }

                    function animateDescription() {
                        const descriptionContent = document.querySelector('#tabs-5 .product__details__tab__content');
                        if (!descriptionContent || descriptionContent.dataset.animated === 'true') {
                            return;
                        }

                        const originalHtml = descriptionContent.innerHTML.trim();
                        if (!originalHtml) {
                            console.warn("Original HTML content is empty.");
                            return;
                        }

                        const linesArray = originalHtml.split(/<br\s*\/?>/i)
                            .map(line => line.trim()) // 각 줄 앞뒤 공백 제거
                            .filter(line => line.length > 0); // 빈 줄 제거

                        let newHtml = '';
                        if (linesArray.length > 0) {
                            newHtml = linesArray.map(line => '<span class="desc-line">' + line + '</span>').join('');
                        } else if (originalHtml.length > 0 && !originalHtml.includes('<br')) {
                            newHtml = '<span class="desc-line">' + originalHtml + '</span>';
                        } else {
                            console.warn("Content processing failed, keeping original.");

                            return;
                        }

                        if (newHtml.length > 0) {
                            descriptionContent.innerHTML = newHtml; // 가공된 HTML로 교체
                        } else {
                            console.warn("Generated new HTML is empty, keeping original content.");
                            return;
                        }

                        const linesToAnimate = descriptionContent.querySelectorAll('span.desc-line');
                        if (linesToAnimate.length === 0) {
                            console.warn("No span.desc-line elements found to animate after update.");
                            return;
                        }

                        let delay = 0;
                        const delayIncrement = 250; // 애니메이션 간격 (ms)

                        linesToAnimate.forEach(function (line, index) {
                            setTimeout(function () {
                                line.classList.add('reveal-line');
                            }, delay);
                            delay += delayIncrement;
                        });

                        descriptionContent.dataset.animated = 'true'; // 애니메이션 실행됨 표시
                        console.log("Animation triggered and marked as executed.");
                    }

                    // --- DOM 로드 후 실행될 코드 ---
                    $(function () {
                        // --- 전역 변수 및 상수 선언 ---
                        const itemKey = $('#product-details-data').data('item-key');
                        const isHotDealActive = <c:out value="${isHotDealActive}" />; // 핫딜 상태 (boolean)
                        const originalBasePrice = parseFloat('${item.itemPrice}') || 0; // 상품 원가
                        const rawOptionsJson = '${optionsJson}';

                        // --- 디버깅 로그 추가 ---
                        console.log("--- Debug Start ---");
                        console.log("Item Key:", itemKey);
                        console.log("Is Hot Deal Active:", isHotDealActive);
                        console.log("Raw Options JSON String:", rawOptionsJson);
                        // --- 디버깅 로그 끝 ---

                        const modalOverlay = $('.modal-overlay');
                        const mainBottomSheet = $('#options-bottom-sheet');
                        const colorSelectModal = $('#color-select-modal');
                        const sizeSelectModal = $('#size-select-modal');
                        const selectedOptionsContainer = $('#selected-options-container');
                        const triggerColorBtn = $('#trigger-color-modal');
                        const triggerSizeBtn = $('#trigger-size-modal');
                        const finalAddToCartBtn = $('#final-add-all-to-cart-btn');
                        const totalQuantitySpan = $('#total-quantity');
                        const totalPriceSpan = $('#total-price');
                        const sizeOptionsList = $('#size-options-list');
                        const sizeModalSelectedColorSpan = $('#size-modal-selected-color');

                        let selectedColor = null;
                        let availableColors = [];
                        let allOptionsData = [];

                        try {
                            allOptionsData = JSON.parse(rawOptionsJson || '[]');
                            if (!Array.isArray(allOptionsData)) {
                                console.error("Parsed optionsJson is not an array:", allOptionsData);
                                allOptionsData = [];
                            }
                            // --- 디버깅 로그 추가 ---
                            console.log("Parsed allOptionsData:", JSON.stringify(allOptionsData)); // 파싱된 데이터 확인 (문자열로 변환하여 출력)
                            // --- 디버깅 로그 끝 ---
                        } catch (e) {
                            console.error("Error parsing optionsJson:", e, "Raw JSON:", rawOptionsJson);
                            allOptionsData = [];
                            // --- 디버깅 로그 추가 ---
                            console.log("Parsed allOptionsData (after error):", allOptionsData);
                            // --- 디버깅 로그 끝 ---
                        }

                        // --- 사용 가능한 색상 추출 및 버튼 활성화 ---
                        if (allOptionsData.length > 0) {
                            availableColors = [...new Set(allOptionsData.map(opt => opt.color))].sort();
                            // --- 디버깅 로그 추가 ---
                            console.log("Available Colors:", availableColors);
                            // --- 디버깅 로그 끝 ---
                            triggerColorBtn.prop('disabled', false); // 옵션 있으면 색상 버튼 활성화
                        } else {
                            console.error("allOptionsData is empty or invalid.");
                            triggerColorBtn.prop('disabled', true); // 옵션 없으면 비활성화
                            triggerSizeBtn.prop('disabled', true); // 사이즈 버튼도 비활성화
                        }
                        // --- 디버깅 로그 추가 ---
                        console.log("Trigger Color Button Disabled:", triggerColorBtn.prop('disabled'));
                        console.log("--- Debug End ---");
                        // --- 디버깅 로그 끝 ---

                        // --- 모달 관련 함수 ---
                        function showModal(modal) {
                            modalOverlay.addClass('active');
                            modal.addClass('active');
                            $('body').css('overflow', 'hidden');
                        }

                        function hideModal(modal) {
                            modal.removeClass('active');
                            // 모든 모달이 닫혔는지 확인 후 오버레이 제거
                            if ($('.center-modal.active, #options-bottom-sheet.active').length === 0) {
                                modalOverlay.removeClass('active');
                                $('body').css('overflow', '');
                            }
                        }

                        function hideAllModals() {
                            modalOverlay.removeClass('active');
                            mainBottomSheet.removeClass('active');
                            colorSelectModal.removeClass('active');
                            sizeSelectModal.removeClass('active');
                            $('body').css('overflow', '');
                        }

                        // --- 옵션 선택 상태 초기화 함수 ---
                        function resetOptionSelectionTriggers() {
                            selectedColor = null;
                            triggerColorBtn.html('색상 옵션을 선택해주세요 <span class="arrow">▼</span>');
                            triggerSizeBtn.prop('disabled', true).html('사이즈 옵션을 선택해주세요 <span class="arrow">▼</span>');
                            sizeOptionsList.empty();
                            sizeModalSelectedColorSpan.text('');
                        }

                        // --- 색상 옵션 모달 채우기 함수 ---
                        function populateColorOptions() {
                            const list = $('#color-options-list');
                            list.empty();
                            if (availableColors.length === 0) {
                                list.append('<p>사용 가능한 색상이 없습니다.</p>');
                                return;
                            }
                            availableColors.forEach(color => {
                                const btn = $('<button type="button"></button>').text(color);
                                btn.on('click', function () {
                                    selectedColor = color;
                                    triggerSizeBtn.prop('disabled', false); // 사이즈 버튼 활성화
                                    triggerColorBtn.html(color + ' 선택됨 <span class="arrow">▼</span>');
                                    hideModal(colorSelectModal);
                                });
                                list.append(btn);
                            });
                        }

                        // --- 사이즈 옵션 모달 채우기 함수 ---
                        function populateSizeOptions() {
                            if (!selectedColor || allOptionsData.length === 0) {
                                console.error("Cannot populate sizes: Color not selected or no options data.");
                                return;
                            }

                            sizeOptionsList.empty();
                            sizeModalSelectedColorSpan.text('선택된 색상: ' + selectedColor);

                            const sizesForColor = allOptionsData
                                .filter(opt => opt.color === selectedColor)
                                .sort((a, b) => (a.size || '').localeCompare(b.size || '')); // 사이즈 정렬

                            if (sizesForColor.length === 0) {
                                sizeOptionsList.append('<p>해당 색상의 사이즈 옵션이 없습니다.</p>');
                                return;
                            }

                            // 이미 메인 모달에 추가된 옵션 키 목록 가져오기
                            const addedOptionKeys = selectedOptionsContainer.find('.selected-option-item')
                                .map(function () { return $(this).data('option-key'); })
                                .get();

                            sizesForColor.forEach(option => {
                                const btn = $('<button type="button"></button>');
                                let buttonText = option.size || '단일 사이즈';
                                const priceDifference = option.additionalPrice || 0;
                                const isOutOfStock = option.stock <= 0;
                                const isAlreadyAdded = addedOptionKeys.includes(option.optionKey);

                                // 가격 변동 표시
                                if (priceDifference > 0) {
                                    buttonText += ' (+' + priceDifference.toLocaleString('ko-KR') + '원)';
                                } else if (priceDifference < 0) {
                                    buttonText += ' (' + priceDifference.toLocaleString('ko-KR') + '원)';
                                }

                                // 품절 표시
                                if (isOutOfStock) {
                                    buttonText += ' (품절)';
                                }

                                btn.text(buttonText);
                                btn.prop('disabled', isOutOfStock || isAlreadyAdded); // 품절 또는 이미 추가된 옵션 비활성화

                                // 클릭 이벤트 (품절 아니고, 이미 추가되지 않은 경우)
                                if (!isOutOfStock && !isAlreadyAdded) {
                                    btn.on('click', function () {
                                        addSelectedOption(option); // 메인 모달에 옵션 추가
                                        hideModal(sizeSelectModal); // 사이즈 모달 닫기
                                        resetOptionSelectionTriggers(); // 색상/사이즈 선택 버튼 초기화
                                    });
                                }
                                sizeOptionsList.append(btn);
                            });
                        }

                        // --- 선택된 옵션 항목 추가 함수 ---
                        function addSelectedOption(optionData) {
                            const optionKey = optionData.optionKey;

                            // 이미 추가된 옵션인지 확인
                            if (selectedOptionsContainer.find('.selected-option-item[data-option-key="' + optionKey + '"]').length > 0) {
                                alert("이미 추가된 옵션입니다.");
                                return;
                            }

                            // 가격 계산 (원가 + 추가금)
                            const optionBasePrice = originalBasePrice + (optionData.additionalPrice || 0);
                            // 최종 가격 (핫딜 적용)
                            const finalItemPrice = isHotDealActive ? Math.floor(optionBasePrice * 0.5) : optionBasePrice; // 소수점 버림 예시
                            const optionName = (optionData.color || '') + ' / ' + (optionData.size || '단일 사이즈');

                            // 추가될 HTML 생성
                            const newItemHtml =
                                '<div class="selected-option-item" ' +
                                'data-option-key="' + optionKey + '" ' +
                                'data-stock="' + optionData.stock + '" ' +
                                'data-price="' + finalItemPrice + '">' +
                                '<button type="button" class="remove-item-btn">×</button>' +
                                '<span class="option-name">' + optionName + '</span>' +
                                '<div class="option-controls">' +
                                '<div class="quantity-control">' +
                                '<button type="button" class="quantity-decrease">-</button>' +
                                '<input type="number" value="1" min="1" max="' + optionData.stock + '" aria-label="수량">' +
                                '<button type="button" class="quantity-increase">+</button>' +
                                '<span class="stock-info">(재고: ' + optionData.stock + ')</span>' +
                                '</div>' +
                                '<span class="item-price">' + finalItemPrice.toLocaleString('ko-KR') + '원</span>' +
                                '</div>' +
                                '</div>';

                            const newItemElement = $(newItemHtml);
                            selectedOptionsContainer.append(newItemElement);
                            attachOptionItemListeners(newItemElement); // 이벤트 리스너 연결
                            updateTotals(); // 합계 업데이트
                        }

                        // --- 옵션 항목 이벤트 리스너 연결 함수 ---
                        function attachOptionItemListeners(itemElement) {
                            const quantityInput = itemElement.find('.quantity-control input');
                            const decreaseBtn = itemElement.find('.quantity-decrease');
                            const increaseBtn = itemElement.find('.quantity-increase');
                            const removeBtn = itemElement.find('.remove-item-btn');
                            const maxStock = parseInt(itemElement.data('stock'), 10);

                            decreaseBtn.on('click', function () {
                                let currentVal = parseInt(quantityInput.val(), 10);
                                if (currentVal > 1) {
                                    quantityInput.val(currentVal - 1).trigger('change'); // 값 변경 후 change 이벤트 트리거
                                }
                            });

                            increaseBtn.on('click', function () {
                                let currentVal = parseInt(quantityInput.val(), 10);
                                if (currentVal < maxStock) {
                                    quantityInput.val(currentVal + 1).trigger('change');
                                } else {
                                    alert('최대 ' + maxStock + '개까지만 구매 가능합니다.');
                                }
                            });

                            // 수량 직접 입력 시 유효성 검사 및 합계 업데이트
                            quantityInput.on('change blur', function () {
                                let currentVal = parseInt($(this).val(), 10);
                                if (isNaN(currentVal) || currentVal < 1) {
                                    $(this).val(1); // 최소값 1로 설정
                                    alert("수량은 1개 이상이어야 합니다.");
                                } else if (currentVal > maxStock) {
                                    $(this).val(maxStock); // 최대 재고 수량으로 설정
                                    alert('최대 ' + maxStock + '개까지만 구매 가능합니다.');
                                }
                                // 유효성 검사 후 합계 업데이트
                                updateTotals();
                            });

                            // 삭제 버튼 클릭 시
                            removeBtn.on('click', function () {
                                itemElement.remove(); // 항목 제거
                                updateTotals(); // 합계 업데이트
                            });
                        }

                        // --- 총 수량 및 가격 업데이트 함수 ---
                        function updateTotals() {
                            let totalQuantity = 0;
                            let totalPrice = 0;

                            selectedOptionsContainer.find('.selected-option-item').each(function () {
                                const item = $(this);
                                const quantity = parseInt(item.find('.quantity-control input').val(), 10) || 0;
                                const price = parseFloat(item.data('price')) || 0; // data-price에서 핫딜 반영된 가격 읽기

                                if (!isNaN(quantity) && !isNaN(price)) {
                                    totalQuantity += quantity;
                                    totalPrice += price * quantity;
                                    // 각 항목별 합계 가격 업데이트 (수량 * 단가)
                                    item.find('.item-price').text((price * quantity).toLocaleString('ko-KR') + '원');
                                } else {
                                    console.warn("Invalid quantity or price found for item:", item.data('option-key'));
                                    item.find('.item-price').text('가격 오류'); // 오류 표시
                                }
                            });

                            // 최종 합계 업데이트
                            totalQuantitySpan.text(totalQuantity);
                            totalPriceSpan.text(totalPrice.toLocaleString('ko-KR'));

                            // 장바구니 담기 버튼 활성화/비활성화
                            finalAddToCartBtn.prop('disabled', totalQuantity <= 0);
                        }

                        // --- 이벤트 리스너 연결 ---

                        // 메인 모달 열기 버튼
                        $('#open-main-modal-btn').on('click', function () {
                            resetOptionSelectionTriggers(); // 옵션 선택 상태 초기화
                            // selectedOptionsContainer.empty(); // 기존 선택 항목 유지할 경우 주석 처리
                            updateTotals(); // 합계 초기화 (또는 기존 항목 기준 업데이트)
                            showModal(mainBottomSheet);
                        });

                        // 모달 오버레이 클릭 시 닫기
                        modalOverlay.on('click', function (e) {
                            if ($(e.target).is(modalOverlay)) {
                                hideAllModals();
                            }
                        });

                        // 모달 닫기 버튼 (X)
                        $('.close-modal-btn').on('click', function () {
                            const targetModalId = $(this).data('target');
                            hideModal($('#' + targetModalId));
                        });

                        // 바텀 시트 핸들 클릭 시 닫기 (선택적)
                        $('.modal-handle').on('click', function () {
                            hideModal(mainBottomSheet);
                        });

                        // 색상 선택 버튼 (바텀 시트 내)
                        triggerColorBtn.on('click', function () {
                            if ($(this).prop('disabled')) return;
                            populateColorOptions(); // 색상 옵션 채우기
                            showModal(colorSelectModal); // 색상 모달 열기
                        });

                        // 사이즈 선택 버튼 (바텀 시트 내)
                        triggerSizeBtn.on('click', function () {
                            if ($(this).prop('disabled')) return;
                            if (!selectedColor) {
                                alert('색상을 먼저 선택해주세요.');
                                return;
                            }
                            populateSizeOptions(); // 사이즈 옵션 채우기
                            showModal(sizeSelectModal); // 사이즈 모달 열기
                        });

                        // 최종 장바구니 담기 버튼 (바텀 시트 내)
                        finalAddToCartBtn.on('click', function () {
                            if ($(this).prop('disabled')) {
                                return;
                            }

                            const itemsToCart = [];
                            selectedOptionsContainer.find('.selected-option-item').each(function () {
                                const item = $(this);
                                const optionKey = item.data('option-key');
                                const quantity = parseInt(item.find('.quantity-control input').val(), 10);

                                if (optionKey && quantity > 0) {
                                    itemsToCart.push({
                                        itemKey: itemKey, // 상품 키
                                        optionKey: optionKey, // 옵션 키
                                        cartCnt: quantity // 수량
                                    });
                                }
                            });

                            if (itemsToCart.length === 0) {
                                alert("장바구니에 담을 상품이 없습니다. 옵션을 선택하고 수량을 확인해주세요.");
                                return;
                            }

                            console.log("Adding batch to cart via AJAX POST:", itemsToCart);

                            // AJAX 요청
                            $.ajax({
                                url: '<c:url value="/cart/add/batch/ajax"/>', // 장바구니 일괄 추가 API 엔드포인트
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify(itemsToCart),
                                beforeSend: function () {
                                    finalAddToCartBtn.prop('disabled', true).text('처리중...'); // 버튼 비활성화 및 텍스트 변경
                                },
                                success: function (response) {
                                    if (response.success) {
                                        console.log("Successfully added batch to cart.");
                                        selectedOptionsContainer.empty(); // 성공 시 선택 목록 비우기
                                        updateTotals(); // 합계 초기화
                                        hideAllModals(); // 모든 모달 닫기

                                        // 장바구니 이동 여부 확인
                                        if (confirm("상품을 장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")) {
                                            location.href = '<c:url value="/cart"/>';
                                        }
                                    } else { // API 응답이 success: false 인 경우
                                        console.error("Failed to add batch to cart:", response.message);
                                        // 로그인 리다이렉션 URL이 있는지 확인
                                        if (response.redirectUrl) {
                                            alert(response.message || '로그인이 필요합니다. 로그인 페이지로 이동합니다.');
                                            const currentUrl = encodeURIComponent(location.pathname + location.search);
                                            location.href = response.redirectUrl + '?redirectURL=' + currentUrl;
                                        } else {
                                            // 기타 실패 사유
                                            alert(response.message || '장바구니 추가에 실패했습니다. 잠시 후 다시 시도해주세요.');
                                        }
                                        // 실패 시 버튼 다시 활성화
                                        finalAddToCartBtn.prop('disabled', false).text('장바구니 담기');
                                    }
                                },
                                error: function (xhr, status, error) { // AJAX 통신 자체 실패
                                    console.error("AJAX Error adding batch to cart:", status, error);
                                    alert('장바구니 추가 중 오류가 발생했습니다. 서버 상태를 확인하거나 관리자에게 문의하세요.');
                                    finalAddToCartBtn.prop('disabled', false).text('장바구니 담기');
                                }
                            });
                        });

                        // --- 초기 설정 ---
                        updateTotals(); // 페이지 로드 시 초기 합계 계산

                        // 배경 이미지 설정 (썸네일 등)
                        $('.product__thumb__pic.set-bg, .product__item__pic.set-bg').each(function () {
                            let bg = $(this).data('setbg');
                            if (bg) {
                                $(this).css('background-image', 'url(' + bg + ')');
                            }
                        });

                        // 상세 설명 애니메이션 Intersection Observer 설정은 외부 document.addEventListener 사용

                    }); // End of $(function() {})

                    // Intersection Observer 설정 (jQuery 외부 또는 DOMContentLoaded 내부에 유지)
                    document.addEventListener('DOMContentLoaded', function () {
                        const descriptionContent = document.querySelector('#tabs-5 .product__details__tab__content');
                        if (!descriptionContent) {
                            console.error("Cannot set up IntersectionObserver: Description content container not found!");
                            return;
                        }

                        const observerCallback = (entries, observer) => {
                            entries.forEach(entry => {
                                if (entry.isIntersecting && entry.target.dataset.animated !== 'true') {
                                    animateDescription();
                                    observer.unobserve(entry.target);
                                }
                            });
                        };

                        const observerOptions = {
                            root: null, // null이면 뷰포트 기준
                            rootMargin: '0px',
                            threshold: 0.1 // 요소가 10% 보일 때 콜백 실행
                        };

                        const observer = new IntersectionObserver(observerCallback, observerOptions);
                        observer.observe(descriptionContent);
                        console.log("IntersectionObserver set up for description content.");
                    });

                </script>

                <!-- Shop Details Section Begin -->
                <section class="shop-details">
                    <div id="product-details-data" data-item-key="${item.itemKey}" style="display: none;"></div> <%--
                        Moved itemKey div here for cleaner structure --%>

                        <div class="product__details__pic">
                            <div class="container">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="product__details__breadcrumb">
                                            <a href="<c:url value='/'/>">Home</a>
                                            <a href="<c:url value='/shop'/>">Shop</a>
                                            <span>
                                                <c:out value="${item.itemName}" />
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-3 col-md-3">
                                        <ul class="nav nav-tabs" role="tablist">

                                            <c:if test="${not empty item.itemImg1}">
                                                <li class="nav-item">
                                                    <a class="nav-link active" data-toggle="tab" href="#tabs-1"
                                                        role="tab">
                                                        <div class="product__thumb__pic set-bg"
                                                            data-setbg="<c:url value='/img/product/${item.itemImg1}'/>">
                                                        </div>
                                                    </a>
                                                </li>
                                            </c:if>
                                            <c:if test="${not empty item.itemImg2}">
                                                <li class="nav-item">
                                                    <a class="nav-link" data-toggle="tab" href="#tabs-2" role="tab">
                                                        <div class="product__thumb__pic set-bg"
                                                            data-setbg="<c:url value='/img/product/${item.itemImg2}'/>">
                                                        </div>
                                                    </a>
                                                </li>
                                            </c:if>

                                        </ul>
                                    </div>
                                    <div class="col-lg-6 col-md-9">
                                        <div class="tab-content">

                                            <c:if test="${not empty item.itemImg1}">
                                                <div class="tab-pane active" id="tabs-1" role="tabpanel">
                                                    <div class="product__details__pic__item">
                                                        <img src="<c:url value='/img/product/${item.itemImg1}'/>"
                                                            alt="${item.itemName}">
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty item.itemImg2}">
                                                <div class="tab-pane <c:if test='${empty item.itemImg1}'>active</c:if>"
                                                    id="tabs-2" role="tabpanel">
                                                    <div class="product__details__pic__item">
                                                        <img src="<c:url value='/img/product/${item.itemImg2}'/>"
                                                            alt="${item.itemName}">
                                                    </div>
                                                </div>
                                            </c:if>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="product__details__content">
                            <div class="container">
                                <div class="row d-flex justify-content-center">
                                    <div class="col-lg-8">
                                        <div class="product__details__text">
                                            <h4>
                                                <c:out value="${item.itemName}" />
                                            </h4>
                                            <div class="product__details__price">
                                                <c:choose>
                                                    <c:when test="${isHotDealActive}">
                                                        <span class="hot-deal-price">
                                                            <fmt:formatNumber value="${hotDealPrice}" pattern="#,##0" />
                                                            원
                                                            <span class="discount-badge">🔥핫딜 50%</span>
                                                        </span>
                                                        <del>
                                                            <fmt:formatNumber value="${item.itemPrice}"
                                                                pattern="#,##0" />원
                                                        </del>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <h3>
                                                            <fmt:formatNumber value="${item.itemPrice}"
                                                                pattern="#,##0" />원
                                                        </h3>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <p>
                                                <c:out value="${item.itemContent}" />
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="product__details__tab">
                                            <ul class="nav nav-tabs" role="tablist">
                                                <li class="nav-item">
                                                    <a class="nav-link active" data-toggle="tab" href="#tabs-5"
                                                        role="tab">상세설명</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-toggle="tab" href="#tabs-6"
                                                        role="tab">상품후기</a> <%-- 리뷰 개수 동적 표시 --%>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-toggle="tab" href="#tabs-7" role="tab">Q &
                                                        A</a> <%-- 리뷰 개수 동적 표시 --%>
                                                </li>
                                            </ul>
                                            <div class="tab-content">
                                                <div class="tab-pane active" id="tabs-5" role="tabpanel">
                                                    <div class="product__details__tab__content">
                                                        ${item.itemDetail}
                                                    </div>
                                                </div>
                                                <div class="tab-pane shop-detail-board" id="tabs-6" role="tabpanel">
                                                    <div class="product__details__tab__content">
                                                        <%-- 고객 리뷰 동적 표시 필요 --%>
                                                            <c:forEach var="c" items="${reviews}">
                                                                <div class="container mt-4">
                                                                    <div class="card mb-3 p-3">
                                                                        <div class="d-flex">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty c.customer.custImg}">
                                                                                    <img src="<c:url value="
                                                                                        ${c.customer.custImg}" />"
                                                                                    class="rounded-circle me-3"
                                                                                    alt="user"
                                                                                    style="width:60px;
                                                                                    height:60px;
                                                                                    object-fit:cover;
                                                                                    margin-right: 20px;">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="<c:url value='/img/clients/profile.png'/>"
                                                                                        class="rounded-circle me-3"
                                                                                        alt="user"
                                                                                        style="width:60px; height:60px; object-fit:cover; margin-right: 20px;" />
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                            <div class="flex-grow-1">
                                                                                <div
                                                                                    class="d-flex justify-content-between">
                                                                                    <div>
                                                                                        <strong>${c.customer.custNick}</strong>
                                                                                        <div class="text-warning ms-2">
                                                                                            <div
                                                                                                class="star-rating mb-2">
                                                                                                <c:forEach var="i"
                                                                                                    begin="1" end="5">
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${i <= c.boardScore}">
                                                                                                            <i
                                                                                                                class="bi bi-star-fill text-warning"></i>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <i
                                                                                                                class="bi bi-star"></i>
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </c:forEach>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    <small class="text-muted">
                                                                                        <fmt:formatDate
                                                                                            value="${c.boardRdate}"
                                                                                            pattern="yyyy-MM-dd" />
                                                                                    </small>
                                                                                </div>
                                                                                <p class="mt-2 mb-1">
                                                                                    ${c.boardContent}</p>
                                                                                <div class="d-flex gap-2 mt-2">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty c.boardImg}">
                                                                                            <img src="<c:url value="
                                                                                                ${c.boardImg}" />"
                                                                                            class="img-thumbnail"
                                                                                            style="width:80px;
                                                                                            height:80px;
                                                                                            object-fit:cover;">
                                                                                        </c:when>
                                                                                    </c:choose>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                    </div>
                                                </div>
                                                <div class="tab-pane shop-detail-board" id="tabs-7" role="tabpanel">
                                                    <form
                                                        action="<c:url value='/qnaboard/add?id=${sessionScope.cust.custId}'/>"
                                                        method="post">
                                                        <button type="submit" class="site-btn" style="width: 300px;">문의
                                                            작성하기</button>
                                                    </form>
                                                    <br />
                                                    <div class="product__details__tab__content">
                                                        <table class="table">
                                                            <thead>
                                                                <tr>
                                                                    <th>제목</th>
                                                                    <th>등록날짜</th>
                                                                    <th></th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="c" items="${qnaBoards}"
                                                                    varStatus="status">
                                                                    <tr id="title-content-${status.index}">
                                                                        <td>
                                                                            <a href="javascript:void(0);"
                                                                                onclick="toggleContent('content-${status.index}')">
                                                                                ${c.boardTitle}
                                                                            </a>
                                                                        </td>
                                                                        <td>
                                                                            <fmt:formatDate value="${c.boardRdate}"
                                                                                pattern="yyyy-MM-dd" />
                                                                        </td>
                                                                        <td>
                                                                            <p id="boardRe">${c.boardRe}</p>
                                                                        </td>
                                                                    </tr>
                                                                    <tr id="content-${status.index}"
                                                                        style="display:none;">
                                                                        <td colspan="3">
                                                                            <div style="margin: 20px;">
                                                                                ${fn:escapeXml(c.boardContent)}
                                                                            </div>
                                                                            <c:if test="${not empty c.adminComments}">
                                                                                <div
                                                                                    style="margin-top: 10px; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border: 1px solid #ddd;">
                                                                                    <strong>└ 🗨️</strong>
                                                                                    <p style="display:inline-block;">
                                                                                        ${fn:escapeXml(c.adminComments.adcommentsContent)}
                                                                                        (
                                                                                        <fmt:formatDate
                                                                                            value="${c.adminComments.adcommentsRdate}"
                                                                                            pattern="yyyy-MM-dd" />
                                                                                        )
                                                                                    </p>
                                                                                </div>
                                                                            </c:if>
                                                                        </td>

                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                            </di>
                                        </div>
                                    </div>
                                </div> <%-- End of container --%>
                            </div> <%-- End of product__details__content --%>
                </section>
                <!-- Shop Details Section End -->

                <!-- Sticky Footer Buttons -->
                <div class="sticky-footer-buttons">
                    <button type="button" id="add-to-wishlist-btn"
                        style="display: flex; flex-direction: column; align-items: center; justify-content: center; line-height: 1.2;">
                        <%-- Flexbox 스타일 추가 --%>
                            <img src="<c:url value='/img/icon/like.svg'/>" alt="찜하기"
                                style="height: 1.5em; margin-bottom: 2px;"> <%-- 아이콘 아래 여백 추가 --%>
                                <span style="font-size: 0.8em;">찜</span> <%-- 텍스트 추가 및 크기 조정 --%>
                    </button>
                    <button type="button" id="open-main-modal-btn">장바구니 담기</button>
                </div>

                <!-- Modal Overlay -->
                <div class="modal-overlay"></div>

                <!-- Main Bottom Sheet Modal -->
                <div id="options-bottom-sheet">
                    <div class="modal-handle"></div>
                    <div id="selected-options-container">
                        <!-- Selected options will be added here by JS -->
                    </div>
                    <div class="option-trigger-buttons">
                        <button type="button" id="trigger-color-modal">색상 옵션을 선택해주세요 <span
                                class="arrow">▼</span></button>
                        <button type="button" id="trigger-size-modal" disabled>사이즈 옵션을 선택해주세요 <span
                                class="arrow">▼</span></button>
                    </div>
                    <div class="total-summary">
                        총 수량 <span id="total-quantity">0</span>개 / 총 <span id="total-price">0</span>원
                    </div>
                    <button type="button" id="final-add-all-to-cart-btn" disabled>장바구니 담기</button>
                </div>

                <!-- Color Selection Modal (Center) -->
                <div id="color-select-modal" class="center-modal">
                    <h5>색상 선택 <button type="button" class="close-modal-btn" data-target="color-select-modal">×</button>
                    </h5>
                    <div class="modal-options-list" id="color-options-list">
                        <!-- Color options will be added here by JS -->
                    </div>
                </div>

                <!-- Size Selection Modal (Center) -->
                <div id="size-select-modal" class="center-modal">
                    <h5>사이즈 선택 <button type="button" class="close-modal-btn" data-target="size-select-modal">×</button>
                    </h5>
                    <div class="selected-color-info" id="size-modal-selected-color"></div>
                    <div class="modal-options-list" id="size-options-list">
                        <!-- Size options will be added here by JS -->
                    </div>
                </div>