<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
  .quantity-controls .btn:hover {
    background-color: #000 !important;
    border-color: #000 !important;
    color: #fff !important;
  }
  .quantity-controls > * {
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
    box-shadow: 0 -2px 5px rgba(0,0,0,0.1);
    z-index: 1000;
    gap: 10px; 
  }
  .sticky-footer-buttons button {
    flex-grow: 1; 
    padding: 15px;
    font-size: 16px;
    border-radius: 5px;
    cursor: pointer;
  }
  #add-to-wishlist-btn {
    background-color: #eee;
    border: 1px solid #ddd;
    color: #333;
    flex-grow: 0; 
    padding: 15px 20px;
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
    box-shadow: 0 -5px 15px rgba(0,0,0,0.15);
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
    box-shadow: 0 5px 20px rgba(0,0,0,0.2);
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

</style>

<script>
/*
  const allOptionsData = JSON.parse('${optionsJson}');

  $(function() {

    const qtyInput = $('#detail-qty-input');
    const decreaseBtn = $('#detail-qty-decrease');
    const increaseBtn = $('#detail-qty-increase');

    increaseBtn.on('click', function(e) {
      e.preventDefault();
      let currentVal = parseInt(qtyInput.val());
      if (!isNaN(currentVal)) {
        qtyInput.val(currentVal + 1);
      } else {
        qtyInput.val(1);
      }
    });

    decreaseBtn.on('click', function(e) {
      e.preventDefault();
      let currentVal = parseInt(qtyInput.val());
      if (!isNaN(currentVal) && currentVal > 1) {
        qtyInput.val(currentVal - 1);
      } else {
        qtyInput.val(1);
      }
    });

    const sizeSelect = $('#size-select');
    const colorSelect = $('#color-select');
    const optionInfoDiv = $('#option-info');
    const addToCartBtn = $('#add-to-cart-btn');
    let currentSelectedOptionKey = null;

    function updateOptionInfo() {
        const selectedSize = sizeSelect.val();
        const selectedColor = colorSelect.val();
        currentSelectedOptionKey = null;
        optionInfoDiv.empty();
        addToCartBtn.addClass('disabled').prop('disabled', true);

        if (selectedSize && selectedColor) {

             const selectedOption = allOptionsData.find(opt => opt.size === selectedSize && opt.color === selectedColor);
             console.log("Selected Option Data:", selectedOption);

             if (selectedOption) {
                currentSelectedOptionKey = selectedOption.optionKey;
                let infoHtml = '';

                if (selectedOption.additionalPrice && selectedOption.additionalPrice > 0) {
                    infoHtml += `<span class="price-change">(+${selectedOption.additionalPrice.toLocaleString()}원)</span>`;
                 }
                  if (selectedOption.stock > 0) {

                      const stockMessage = '<span class="stock-status in-stock">구매 가능 (재고: ' + selectedOption.stock + '개)</span>';
                      infoHtml += stockMessage;
                      console.log("Constructed infoHtml with stock:", infoHtml);
                      addToCartBtn.removeClass('disabled').prop('disabled', false);

                   } else {
                      infoHtml += `<span class="stock-status out-of-stock">품절</span>`;
                      console.log("Constructed infoHtml (out of stock):", infoHtml);
                  }

                  optionInfoDiv.html(infoHtml);

            } else {
                optionInfoDiv.html('<span class="stock-status out-of-stock">선택 불가능한 조합</span>');
            }
        } else {
             optionInfoDiv.html('<span>사이즈와 색상을 모두 선택해주세요.</span>');
        }
    }

    sizeSelect.on('change', updateOptionInfo);
    colorSelect.on('change', updateOptionInfo);

    updateOptionInfo();

    addToCartBtn.on('click', function(e) {
        e.preventDefault();

        if ($(this).hasClass('disabled')) {
            alert('옵션을 선택하거나 품절된 옵션입니다.');
            return;
        }

        const itemKey = $('#product-details-data').data('item-key');
        const cartCnt = parseInt(qtyInput.val());
        const selectedSize = sizeSelect.val();
        const selectedColor = colorSelect.val();

        if (!itemKey || isNaN(cartCnt) || cartCnt < 1) {
            alert('상품 정보 또는 수량이 올바르지 않습니다.');
            return;
        }

        if (!selectedSize || !selectedColor) {
            alert('사이즈와 색상을 모두 선택해주세요.');
            return;
        }

        if (currentSelectedOptionKey === null) {
             alert('선택하신 옵션을 찾을 수 없습니다. 다시 선택해주세요.');
             return;
        }

        const cartData = {
            itemKey: itemKey,
            cartCnt: cartCnt,
            optionKey: currentSelectedOptionKey
        };

        console.log("Adding to cart via AJAX POST", cartData);

        $.ajax({
            url: '<c:url value="/cart/add/ajax"/>',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(cartData),

            success: function(response) {

                if (response.success) {
                    console.log("Successfully added to cart.");
                    location.href = '<c:url value="/cart"/>';

                } else {
                    console.error("Failed to add to cart:", response.message);

                    if (response.redirectUrl) {
                         location.href = '<c:url value="' + response.redirectUrl + '"/>';

                    } else {
                         alert(response.message || '장바구니 추가에 실패했습니다.');
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error adding to cart:", status, error);
                alert('장바구니 추가 중 오류가 발생했습니다. 다시 시도해주세요.');
            }
        });
    });

    $('.product__thumb__pic.set-bg, .product__item__pic.set-bg').each(function () {
        let bg = $(this).data('setbg');
        if (bg) {
            $(this).css('background-image', 'url(' + bg + ')');
        }
    });
  });
*/
</script>

<script>
$(function() {
    const itemKey = $('#product-details-data').data('item-key');
    const baseItemPrice = parseFloat('${item.itemPrice}') || 0;
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
        const optionsJsonString = ('${optionsJson}' || '[]').replace(/\\'/g, "'").replace(/\\"/g, '"');
        allOptionsData = JSON.parse(optionsJsonString);
        if (!Array.isArray(allOptionsData)) {
             console.error("Parsed optionsJson is not an array:", allOptionsData);
             allOptionsData = [];
        }
    } catch (e) {
        console.error("Error parsing optionsJson:", e);
        allOptionsData = []; 
    }

    if (allOptionsData.length > 0) {
         availableColors = [...new Set(allOptionsData.map(opt => opt.color))].sort();
    } else {
        console.error("allOptionsData is empty or invalid.");
         triggerColorBtn.prop('disabled', true);
     }


     function showModal(modal) {
         modalOverlay.addClass('active');
         modal.addClass('active');
        $('body').css('overflow', 'hidden'); 
    }

    function hideModal(modal) {
        modal.removeClass('active');

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

    function resetOptionSelectionTriggers() {
        selectedColor = null;
        triggerColorBtn.html('색상 옵션을 선택해주세요 <span class="arrow">▼</span>');

        triggerSizeBtn.prop('disabled', true).html('사이즈 옵션을 선택해주세요 <span class="arrow">▼</span>');
        sizeOptionsList.empty();
        sizeModalSelectedColorSpan.text('');
    }

    function populateSizeOptions() {
        if (!selectedColor || allOptionsData.length === 0) {
            console.error("Cannot populate sizes: Color not selected or no options data.");
            return;
        }

        sizeOptionsList.empty(); 
        sizeModalSelectedColorSpan.text(`선택된 색상: ${selectedColor}`);

        const sizesForColor = allOptionsData
            .filter(opt => opt.color === selectedColor)
            .sort((a, b) => (a.size || '').localeCompare(b.size || ''));

        if (sizesForColor.length === 0) {
            sizeOptionsList.append('<p>해당 색상의 사이즈 옵션이 없습니다.</p>');
            return;
        }

        const addedOptionKeys = selectedOptionsContainer.find('.selected-option-item')
                                    .map(function() { return $(this).data('option-key'); })
                                    .get();

        sizesForColor.forEach(option => {
            const btn = $('<button type="button"></button>');
            let buttonText = option.size || '단일 사이즈';
            const priceDifference = option.additionalPrice || 0;
            const isOutOfStock = option.stock <= 0;
            const isAlreadyAdded = addedOptionKeys.includes(option.optionKey);

             if (priceDifference > 0) {
                 buttonText += ` (+${priceDifference.toLocaleString('ko-KR')}원)`;
             } else if (priceDifference < 0) {
                  buttonText += ` (${priceDifference.toLocaleString('ko-KR')}원)`;
             }

             if (isOutOfStock) {
                 buttonText += ` (품절)`;
            }

            btn.text(buttonText);
            btn.prop('disabled', isOutOfStock || isAlreadyAdded); 

            if (!isOutOfStock && !isAlreadyAdded) {
                btn.on('click', function() {
                    addSelectedOption(option);
                    hideModal(sizeSelectModal);
                    resetOptionSelectionTriggers();
                });
            }
            sizeOptionsList.append(btn);
        });
    }

    function addSelectedOption(optionData) {
        const optionKey = optionData.optionKey;
        
        if (selectedOptionsContainer.find(`.selected-option-item[data-option-key="${optionKey}"]`).length > 0) {
            alert("이미 추가된 옵션입니다.");
            return;
        }

        const itemPriceWithOption = baseItemPrice + (optionData.additionalPrice || 0);
        const optionName = `${optionData.color} / ${optionData.size || '단일 사이즈'}`;

    
        const newItemHtml =
        '<div class="selected-option-item" ' +
            'data-option-key="' + optionKey + '" ' +
            'data-stock="' + optionData.stock + '" ' +
            'data-price="' + itemPriceWithOption + '">' +
            '<button type="button" class="remove-item-btn">×</button>' +
            '<span class="option-name">' + optionName + '</span>' +
            '<div class="option-controls">' +
            '<div class="quantity-control">' +
                '<button type="button" class="quantity-decrease">-</button>' +
                '<input type="number" value="1" min="1" max="' + optionData.stock + '" aria-label="수량">' +
                '<button type="button" class="quantity-increase">+</button>' +
                '<span class="stock-info">(재고: ' + optionData.stock + ')</span>' +
            '</div>' +
            '<span class="item-price">' + itemPriceWithOption.toLocaleString('ko-KR') + '원</span>' +
            '</div>' +
        '</div>';

        const newItemElement = $(newItemHtml);
        selectedOptionsContainer.append(newItemElement);
        attachOptionItemListeners(newItemElement);
        updateTotals(); 
    }

    function attachOptionItemListeners(itemElement) {
        const quantityInput = itemElement.find('.quantity-control input');
        const decreaseBtn = itemElement.find('.quantity-decrease');
        const increaseBtn = itemElement.find('.quantity-increase');
        const removeBtn = itemElement.find('.remove-item-btn');
        const maxStock = parseInt(itemElement.data('stock'), 10);

        decreaseBtn.on('click', function() {
            let currentVal = parseInt(quantityInput.val(), 10);
            if (currentVal > 1) {
                quantityInput.val(currentVal - 1).trigger('change'); 
            }
        });

        increaseBtn.on('click', function() {
            let currentVal = parseInt(quantityInput.val(), 10);
            if (currentVal < maxStock) {
                quantityInput.val(currentVal + 1).trigger('change');
            } else {
                alert(`최대 ${maxStock}개까지만 구매 가능합니다.`);
            }
        });

        quantityInput.on('change blur', function() {
            let currentVal = parseInt($(this).val(), 10);
            if (isNaN(currentVal) || currentVal < 1) {
                $(this).val(1);
                 alert("수량은 1개 이상이어야 합니다.");
            } else if (currentVal > maxStock) {
                $(this).val(maxStock);
                alert(`최대 ${maxStock}개까지만 구매 가능합니다.`);
            }

            updateTotals();
        });

        removeBtn.on('click', function() {
            itemElement.remove(); 
            updateTotals(); 
        });
    }

    function updateTotals() {
        let totalQuantity = 0;
        let totalPrice = 0;

        selectedOptionsContainer.find('.selected-option-item').each(function() {
            const item = $(this);
            const quantity = parseInt(item.find('.quantity-control input').val(), 10) || 0;
            const price = parseFloat(item.data('price')) || 0;

            if (!isNaN(quantity) && !isNaN(price)) {
                totalQuantity += quantity;
                 totalPrice += price * quantity;
                 item.find('.item-price').text((price * quantity).toLocaleString('ko-KR') + '원');
             } else {
                  console.warn("Invalid quantity or price found for item:", item.data('option-key'));
                  item.find('.item-price').text('가격 오류');
            }
         });

         totalQuantitySpan.text(totalQuantity);
         totalPriceSpan.text(totalPrice.toLocaleString('ko-KR'));

         finalAddToCartBtn.prop('disabled', totalQuantity <= 0);
     }

    

    // 이벤트 리스너 
    $('#open-main-modal-btn').on('click', function() {
        resetOptionSelectionTriggers();
        updateTotals();
        showModal(mainBottomSheet);
    });

    modalOverlay.on('click', function(e) {
        if ($(e.target).is(modalOverlay)) {
             hideAllModals();

        }
    });

    $('.close-modal-btn').on('click', function() {
        const targetModalId = $(this).data('target');
        hideModal($('#' + targetModalId));
    });

    $('.modal-handle').on('click', function() {
        hideModal(mainBottomSheet);
    });

    triggerColorBtn.on('click', function() {
        if ($(this).prop('disabled')) return;
        populateColorOptions();
        showModal(colorSelectModal);
    });

    triggerSizeBtn.on('click', function() {
        if ($(this).prop('disabled')) return;
        if (!selectedColor) {
             alert('색상을 먼저 선택해주세요.'); 
             return;
         }
        populateSizeOptions(); 
        showModal(sizeSelectModal);
    });

    function populateColorOptions() {
        const list = $('#color-options-list');
        list.empty(); 
        if (availableColors.length === 0) {
             list.append('<p>사용 가능한 색상이 없습니다.</p>');
             return;
        }
        availableColors.forEach(color => {
            const btn = $('<button type="button"></button>').text(color);
            btn.on('click', function() {
                selectedColor = color;
                triggerSizeBtn.prop('disabled', false); 
                triggerColorBtn.html(`${color} 선택됨 <span class="arrow">▼</span>`); 
                hideModal(colorSelectModal); 
            });
            list.append(btn);
        });
    }

    finalAddToCartBtn.on('click', function() {
        if ($(this).prop('disabled')) {
            return; 
        }

        const itemsToCart = [];
        selectedOptionsContainer.find('.selected-option-item').each(function() {
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
            alert("장바구니에 담을 상품이 없습니다. 옵션을 선택하고 수량을 확인해주세요.");
            return;
        }

        console.log("Adding batch to cart via AJAX POST:", itemsToCart);

        $.ajax({
            url: '<c:url value="/cart/add/ajax"/>', 
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(itemsToCart),
            beforeSend: function() {
                finalAddToCartBtn.prop('disabled', true).text('처리중...');
            },
            success: function(response) {
                if (response.success) {
                    console.log("Successfully added batch to cart.");
                    selectedOptionsContainer.empty();
                    updateTotals();
                    hideAllModals();

                    if (confirm("상품을 장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")) {
                        location.href = '<c:url value="/cart"/>';
                    }
                } else {
                    console.error("Failed to add batch to cart:", response.message);
                    alert(response.message || '장바구니 추가에 실패했습니다. 잠시 후 다시 시도해주세요.');
                    finalAddToCartBtn.prop('disabled', false).text('장바구니 담기');
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error adding batch to cart:", status, error);
                alert('장바구니 추가 중 오류가 발생했습니다. 서버 상태를 확인하거나 관리자에게 문의하세요.');
                 finalAddToCartBtn.prop('disabled', false).text('장바구니 담기');
            }
        });
    });

     // --- Initial Setup ---
     updateTotals();

    $('.product__thumb__pic.set-bg, .product__item__pic.set-bg').each(function () {
        let bg = $(this).data('setbg');
        if (bg) {
            $(this).css('background-image', 'url(' + bg + ')');
        }
    });
});
</script>

<!-- Shop Details Section Begin -->
<section class="shop-details">
    <div id="product-details-data" data-item-key="${item.itemKey}" style="display: none;"></div> <%-- Moved itemKey div here for cleaner structure --%>

    <div class="product__details__pic">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="product__details__breadcrumb">
                        <a href="<c:url value='/'/>">Home</a>
                        <a href="<c:url value='/shop'/>">Shop</a>
                        <span><c:out value="${item.itemName}"/></span>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-3 col-md-3">
                    <ul class="nav nav-tabs" role="tablist">

                        <c:if test="${not empty item.itemImg1}">
                            <li class="nav-item">
                                <a class="nav-link active" data-toggle="tab" href="#tabs-1" role="tab">
                                    <div class="product__thumb__pic set-bg" data-setbg="<c:url value='/img/product/${item.itemImg1}'/>"></div>
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${not empty item.itemImg2}">
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#tabs-2" role="tab">
                                    <div class="product__thumb__pic set-bg" data-setbg="<c:url value='/img/product/${item.itemImg2}'/>"></div>
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
                                    <img src="<c:url value='/img/product/${item.itemImg1}'/>" alt="${item.itemName}">
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${not empty item.itemImg2}">
                            <div class="tab-pane <c:if test='${empty item.itemImg1}'>active</c:if>" id="tabs-2" role="tabpanel">
                                <div class="product__details__pic__item">
                                    <img src="<c:url value='/img/product/${item.itemImg2}'/>" alt="${item.itemName}">
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
                        <%-- 상품명 --%>
                        <h4><c:out value="${item.itemName}"/></h4>
                        <%-- 평점 --%>
                        <%-- <div class="rating"> ... </div> --%>
                        <%-- 가격 --%>
                        <h3><fmt:formatNumber value="${item.itemPrice}" type="currency" currencySymbol="₩"/></h3>
                        <%-- 상품 설명 --%>
                        <p><c:out value="${item.itemContent}"/></p> <%-- itemDetail -> itemContent 로 수정 --%>

                        <%-- 기존 옵션 선택 영역 및 장바구니 버튼 제거됨 --%>
                        <script>
                          const optionsJson = '${optionsJson}'; 
                          const baseItemPrice = parseFloat('${item.itemPrice}') || 0; 
                        </script>

                    </div> <%-- End of product__details__text --%>
                </div> <%-- End of col-lg-8 --%>
            </div> <%-- End of row d-flex --%>
            <%-- Tabs for Description, Reviews, Q&A should start here --%>
            <div class="row">
                <div class="col-lg-12">
                    <div class="product__details__tab">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" data-toggle="tab" href="#tabs-5" role="tab">Description</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#tabs-6" role="tab">Customer Previews(5)</a> <%-- 리뷰 개수 동적 표시 --%>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" data-toggle="tab" href="#tabs-7" role="tab">Q & A</a> <%-- 리뷰 개수 동적 표시 --%>
                            </li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="tabs-5" role="tabpanel">
                                <div class="product__details__tab__content">
                                    <%-- 상품 설명 동적 표시 필요 --%>
                                    <p class="note">Nam tempus turpis at metus scelerisque placerat nulla deumantos
                                        solicitud felis. Pellentesque diam dolor, elementum etos lobortis des mollis
                                        ut risus. Sedcus faucibus an sullamcorper mattis drostique des commodo
                                        pharetras loremos.</p>
                                    <div class="product__details__tab__content__item">
                                        <h5>Products Infomation</h5>
                                        <p>A Pocket PC is a handheld computer...</p>
                                        <p>As is the case with any new technology product...</p>
                                    </div>
                                    <div class="product__details__tab__content__item">
                                        <h5>Material used</h5>
                                        <p>Polyester is deemed lower quality...</p>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="tabs-6" role="tabpanel">
                                <div class="product__details__tab__content">
                                    <%-- 고객 리뷰 동적 표시 필요 --%>
                                    <p>Customer reviews will be displayed here.</p>
                                </div>
                            </div>
                            <div class="tab-pane shop-detail-board" id="tabs-7" role="tabpanel">
                                <form action="<c:url value='/qnaboard/add?id=${sessionScope.cust.custId}'/>" method="post">
                                    <button type="submit" class="site-btn" style="width: 300px;">문의 작성하기</button>
                                </form>
                                <br/>
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
                                        <c:forEach var="c" items="${qnaBoards}">
                                            <tr>
                                                <td>${c.boardTitle}</td>
                                                <td><fmt:formatDate  value="${c.boardRdate}" pattern="yyyy-MM-dd" /></td>
                                                <td><p id="boardRe">${c.boardRe}</p></td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> <%-- End of container --%>
    </div> <%-- End of product__details__content --%>
</section>
<!-- Shop Details Section End -->

<!-- Related Section Begin -->
<section class="related spad">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <h3 class="related-title">Related Product</h3>
            </div>
        </div>
        <div class="row">
            <c:forEach var="relatedItem" items="${relatedItems}">
                <div class="col-lg-3 col-md-6 col-sm-6">
                    <div class="product__item">
                        <div class="product__item__pic set-bg" data-setbg="<c:url value='/img/product/${relatedItem.itemImg1}'/>">
                            <ul class="product__hover">
                                <li><a href="#"><img src="<c:url value='/img/icon/heart.png'/>" alt=""></a></li>
                                <li><a href="<c:url value='/shop/details?itemKey=${relatedItem.itemKey}'/>"><img src="<c:url value='/img/icon/search.png'/>" alt=""></a></li>
                            </ul>
                        </div>
                        <div class="product__item__text">
                            <h6><c:out value="${relatedItem.itemName}"/></h6>
                            <a href="#" class="add-cart" data-item-key="${relatedItem.itemKey}">+ Add To Cart</a>
                            <h5><fmt:formatNumber value="${relatedItem.itemPrice}" type="currency" currencySymbol="₩"/></h5>
                        </div>
                    </div>
                 </div>
            </c:forEach>
        </div>
    </div>
</section>
<!-- Related Section End -->

<!-- Sticky Footer Buttons -->
<div class="sticky-footer-buttons">
    <button type="button" id="add-to-wishlist-btn">찜</button>
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
        <button type="button" id="trigger-color-modal">색상 옵션을 선택해주세요 <span class="arrow">▼</span></button>
        <button type="button" id="trigger-size-modal" disabled>사이즈 옵션을 선택해주세요 <span class="arrow">▼</span></button>
    </div>
    <div class="total-summary">
        총 수량 <span id="total-quantity">0</span>개 / 총 <span id="total-price">0</span>원
    </div>
    <button type="button" id="final-add-all-to-cart-btn" disabled>장바구니 담기</button>
</div>

<!-- Color Selection Modal (Center) -->
<div id="color-select-modal" class="center-modal">
    <h5>색상 선택 <button type="button" class="close-modal-btn" data-target="color-select-modal">×</button></h5>
    <div class="modal-options-list" id="color-options-list">
        <!-- Color options will be added here by JS -->
    </div>
</div>

<!-- Size Selection Modal (Center) -->
<div id="size-select-modal" class="center-modal">
    <h5>사이즈 선택 <button type="button" class="close-modal-btn" data-target="size-select-modal">×</button></h5>
    <div class="selected-color-info" id="size-modal-selected-color"></div>
    <div class="modal-options-list" id="size-options-list">
        <!-- Size options will be added here by JS -->
    </div>
</div>
