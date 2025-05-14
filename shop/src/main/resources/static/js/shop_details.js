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
    const detailsDataElement = $('#shop-details-data');
    const itemKey = detailsDataElement.data('item-key');
    const isHotDealActive = detailsDataElement.data('is-hot-deal-active') === true;
    const originalBasePrice = parseFloat(detailsDataElement.data('original-base-price')) || 0;
    const rawOptionsJson = detailsDataElement.data('options-json');
    const cartUrl = detailsDataElement.data('cart-url');
    const cartAddBatchUrl = detailsDataElement.data('cart-add-batch-url');
    const orderAddBatchUrl = detailsDataElement.data('order-add-batch-url');
    const loginUrl = detailsDataElement.data('login-url');


    const modalOverlay = $('.modal-overlay');
    const mainBottomSheet = $('#options-bottom-sheet');
    const colorSelectModal = $('#color-select-modal');
    const sizeSelectModal = $('#size-select-modal');
    const selectedOptionsContainer = $('#selected-options-container');
    const triggerColorBtn = $('#trigger-color-modal');
    const triggerSizeBtn = $('#trigger-size-modal');
    const finalAddToCartBtn = $('#final-add-all-to-cart-btn');
    const finalAddToOrderBtn = $('#final-add-all-to-order-btn');
    const totalQuantitySpan = $('#total-quantity');
    const totalPriceSpan = $('#total-price');
    const sizeOptionsList = $('#size-options-list');
    const sizeModalSelectedColorSpan = $('#size-modal-selected-color');

    let selectedColor = null;
    let availableColors = [];
    let allOptionsData = [];

    try {
        if (typeof rawOptionsJson === 'string') {
            allOptionsData = JSON.parse(rawOptionsJson || '[]');
        } else if (typeof rawOptionsJson === 'object' && rawOptionsJson !== null) {
            allOptionsData = rawOptionsJson; // 이미 객체인 경우
        } else {
            allOptionsData = [];
        }

        if (!Array.isArray(allOptionsData)) {
            console.error("Parsed optionsJson is not an array:", allOptionsData);
            allOptionsData = [];
        }

    } catch (e) {
        console.error("Error parsing optionsJson:", e, "Raw JSON:", rawOptionsJson);
        allOptionsData = [];
    }

    // --- 사용 가능한 색상 추출 및 버튼 활성화 ---
    if (allOptionsData.length > 0) {
        availableColors = [...new Set(allOptionsData.map(opt => opt.color))].sort();
        triggerColorBtn.prop('disabled', false);
    } else {
        console.error("allOptionsData is empty or invalid.");
        triggerColorBtn.prop('disabled', true);
        triggerSizeBtn.prop('disabled', true);
    }

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
        finalAddToOrderBtn.prop('disabled', totalQuantity <= 0);
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
            url: cartAddBatchUrl,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(itemsToCart),
            beforeSend: function () {
                finalAddToCartBtn.prop('disabled', true).text('처리중...');
            },
            success: function (response) {
                if (response.success) {
                    console.log("Successfully added batch to cart.");
                    selectedOptionsContainer.empty();
                    updateTotals();
                    hideAllModals();

                    if (confirm("상품을 장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")) {
                        location.href = cartUrl;
                    }
                } else {
                    console.error("Failed to add batch to cart:", response.message);

                    if (response.redirectUrl) {
                        alert(response.message || '로그인이 필요합니다. 로그인 페이지로 이동합니다.');
                        const currentUrl = encodeURIComponent(location.pathname + location.search);
                        location.href = loginUrl + '?redirectURL=' + currentUrl;
                    } else {
                        alert(response.message || '장바구니 추가에 실패했습니다. 잠시 후 다시 시도해주세요.');
                    }

                    finalAddToCartBtn.prop('disabled', false).text('장바구니 담기');
                }
            },
            error: function (xhr, status, error) {
                alert('장바구니 추가 중 오류가 발생했습니다. 서버 상태를 확인하거나 관리자에게 문의하세요.');
                finalAddToCartBtn.prop('disabled', false).text('장바구니 담기');
            }
        });
    });

    // 주문 담기
    finalAddToOrderBtn.on('click', function () {
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
            itemKey: itemKey,
            optionKey: optionKey,
            cartCnt: quantity
          });
        }
      });
      if (itemsToCart.length === 0) {
        alert("주문할 상품이 없습니다. 옵션을 선택하고 수량을 확인해주세요.");
        return;
      }

      // 폼 만들기
      const form = $('<form>', {
        method: 'POST',
        action: '/checkout'
      });

      // JSON 문자열을 숨은 input에 넣기
      const input = $('<input>', {
        type: 'hidden',
        name: 'itemsJson',
        value: JSON.stringify(itemsToCart)
      });

      form.append(input);
      $('body').append(form);
      form.submit();
    });

    // --- 초기 설정 ---
    updateTotals();

    // 배경 이미지 설정 (썸네일 등)
    $('.product__thumb__pic.set-bg, .product__item__pic.set-bg').each(function () {
        let bg = $(this).data('setbg');
        if (bg) {
            $(this).css('background-image', 'url(' + bg + ')');
        }
    });

    // --- Intersection Observer 설정  ---
    const descriptionContent = document.querySelector('#tabs-5 .product__details__tab__content');
    if (!descriptionContent) {
        console.error("Cannot set up IntersectionObserver: Description content container not found!");
    } else {
        const observerCallback = (entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && entry.target.dataset.animated !== 'true') {
                    animateDescription();
                    observer.unobserve(entry.target);
                }
            });
        };
        const observerOptions = { root: null, rootMargin: '0px', threshold: 0.1 };
        const observer = new IntersectionObserver(observerCallback, observerOptions);
        observer.observe(descriptionContent);
        console.log("IntersectionObserver set up for description content.");
    }

});
