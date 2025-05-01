$(function () {

    const cartDataElement = $('#shopping-cart-data');
    const updateUrl = cartDataElement.data('update-url');
    const deleteUrl = cartDataElement.data('delete-url');

    $('.shopping__cart__table tbody').on('click', '.cart-pro-qty .inc', function () {
        console.log("Inc button clicked (delegated)");
        let button = $(this);
        let input = button.siblings('input.cart-quantity');
        updateCartQuantity(input);
    });

    $('.shopping__cart__table tbody').on('click', '.cart-pro-qty .dec', function () {
        console.log("Dec button clicked (delegated)");
        let button = $(this);
        let input = button.siblings('input.cart-quantity');

        updateCartQuantity(input);
    });

    $('.shopping__cart__table tbody').on('change', 'input.cart-quantity', function () {
        let input = $(this);
        let updatedValue = parseFloat(input.val());

        if (isNaN(updatedValue) || updatedValue < 1) {
            updatedValue = 1;
            input.val(updatedValue);
        }
        updateCartQuantity(input);
    });

    function updateCartQuantity(inputElement) {
        const custId = inputElement.data('cust-id');
        const itemKey = inputElement.data('item-key');
        const optionKey = inputElement.data('option-key');
        const cartCnt = parseInt(inputElement.val());

        const originalValue = inputElement.data('original-value') || inputElement.val();
        inputElement.data('original-value', inputElement.val());

        if (!custId || isNaN(itemKey) || isNaN(cartCnt) || cartCnt < 1) {
            console.error("장바구니 업데이트 정보 부족:", custId, itemKey, cartCnt);
            alert('수량 변경 정보를 가져오는데 실패했습니다.');
            inputElement.val(originalValue);
            return;
        }

        console.log("Updating quantity:", { custId, itemKey, optionKey, cartCnt });

        $.ajax({
            url: updateUrl,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                custId: custId,
                itemKey: itemKey,
                optionKey: optionKey,
                cartCnt: cartCnt
            }),
            success: function (response) {
                console.log("Update response:", response);
                if (response.success) {
                    updateCartView(itemKey, response.cartItems, response.totalCartPrice, optionKey);
                    inputElement.removeData('original-value');
                } else {
                    alert('장바구니 수량 변경 중 오류가 발생했습니다: ' + response.message);
                    inputElement.val(originalValue);
                }
            },
            error: function (xhr, status, error) {
                console.error("Ajax 요청 오류:", status, error, xhr.responseText);
                alert('서버 통신 중 오류가 발생했습니다.');
                inputElement.val(originalValue);
            }
        });
    }

    function updateCartView(updatedItemKey, cartItems, totalCartPrice, updatedOptionKey) {
        console.log("Updating view for item:", updatedItemKey, "Option:", updatedOptionKey, "Total Price:", totalCartPrice);

        const itemRow = $('tr[data-item-key="' + updatedItemKey + '"][data-option-key="' + updatedOptionKey + '"]');

        if (itemRow.length) {
            let updatedItem = null;
            if (cartItems) {
                updatedItem = cartItems.find(item =>
                    item.item_key == updatedItemKey && item.option_key == updatedOptionKey
                );
            }

            if (updatedItem) {
                const quantityInput = itemRow.find('input.cart-quantity');
                const effectivePrice = parseFloat(quantityInput.data('item-price')) || 0;
                const itemTotalPrice = effectivePrice * updatedItem.cart_cnt;

                itemRow.find('.cart__price').text(itemTotalPrice.toLocaleString() + '원');

                if (quantityInput.length > 0) {
                    quantityInput.val(updatedItem.cart_cnt); // val() 사용 권장
                    console.log("Set input value using val() to:", updatedItem.cart_cnt);
                } else {
                    console.warn("Quantity input not found within the row!");
                }
            } else {
                console.warn("Updated item not found in response for key/option:", updatedItemKey, updatedOptionKey);
            }

        } else {
            console.warn("Item row not found for key:", updatedItemKey);
        }

        const formattedTotal = totalCartPrice.toLocaleString() + '원';
        $('#cart-subtotal-price').text(formattedTotal);
        $('#cart-total-price').text(formattedTotal);

        console.log("Cart view updated.");
    }



    window.shopping_cart = {
        del: (custId, itemKey, optionKey) => {
            if (!custId || !itemKey) {
                alert('상품 정보가 올바르지 않습니다.');
                return;
            }

            if (confirm('정말로 이 상품을 장바구니에서 삭제하시겠습니까?')) {
                let url = deleteUrl + '?custId=' + custId + '&itemKey=' + itemKey;
                if (optionKey !== null && optionKey !== undefined && optionKey !== '') {
                    url += '&optionKey=' + optionKey;
                }
                location.href = url;
            }
        }
    };

    $('#update-cart-btn').off('click').on('click', function (e) {
        e.preventDefault();
        alert('수량 변경은 각 항목에서 바로 적용됩니다.');
    });
});