<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <script>
                $(function () {

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
                            url: '<c:url value="/cart/updateQuantity"/>',
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
                                let url = '<c:url value="/cart/del"/>?custId=' + custId + '&itemKey=' + itemKey;
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
            </script>

            <!-- Breadcrumb Section Begin -->
            <section class="breadcrumb-option">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="breadcrumb__text">
                                <h4>Shopping Cart</h4>
                                <div class="breadcrumb__links">
                                    <a href="<c:url value='/'/>">Home</a>
                                    <a href="<c:url value='/shop'/>">Shop</a>
                                    <span>Shopping Cart</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Breadcrumb Section End -->

            <!-- Shopping Cart Section Begin -->
            <section class="shopping-cart spad">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="shopping__cart__table">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Quantity</th>
                                            <th>Total</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cartItems}">
                                            <c:set var="effectivePrice" value="${item.item_price}" />
                                            <c:if test="${item.is_hot_deal}">
                                                <c:set var="effectivePrice" value="${item.item_price * 0.5}" />
                                            </c:if>

                                            <tr data-item-key="${item.item_key}" data-option-key="${item.option_key}">
                                                <td class="product__cart__item">
                                                    <div class="product__cart__item__pic">
                                                        <img src="<c:url value='/img/product/${item.item_img1}'/>"
                                                            alt="${item.item_name}" width="90">

                                                    </div>
                                                    <div class="product__cart__item__text">
                                                        <h6>${item.item_name}</h6>
                                                        <c:if test="${not empty item.option_key}">
                                                            <p style="font-size: 0.9em; color: #666;">
                                                                옵션: ${item.size} / ${item.color}
                                                                <c:if
                                                                    test="${not empty item.additional_price and item.additional_price > 0}">
                                                                    (+
                                                                    <fmt:formatNumber value="${item.additional_price}"
                                                                        type="number" />원)
                                                                </c:if>
                                                            </p>
                                                        </c:if>
                                                        <h5>
                                                            <c:if test="${item.is_hot_deal}">
                                                                <del
                                                                    style="color: #b2b2b2; font-size: 0.9em; margin-right: 5px;">
                                                                    <fmt:formatNumber value="${item.item_price}"
                                                                        type="number" />원
                                                                </del>
                                                                <span style="color: #ca1515; font-weight: bold;">
                                                                    <fmt:formatNumber value="${effectivePrice}"
                                                                        type="number" />원
                                                                </span>
                                                                <span class="badge badge-danger ml-1">핫딜</span>
                                                            </c:if>

                                                            <c:if test="${not item.is_hot_deal}">
                                                                <fmt:formatNumber value="${effectivePrice}"
                                                                    type="number" />원
                                                            </c:if>
                                                        </h5>
                                                    </div>
                                                </td>
                                                <td class="quantity__item">
                                                    <div class="quantity">
                                                        <div class="pro-qty-2 cart-pro-qty">
                                                            <input type="text" value="${item.cart_cnt}"
                                                                data-cust-id="${item.cust_id}"
                                                                data-item-key="${item.item_key}"
                                                                data-option-key="${item.option_key}"
                                                                class="cart-quantity"
                                                                data-item-price="${effectivePrice}">
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="cart__price item-total-price"
                                                    data-item-key="${item.item_key}"
                                                    data-option-key="${item.option_key}">
                                                    <fmt:formatNumber value="${effectivePrice * item.cart_cnt}"
                                                        type="number" />원
                                                </td>
                                                <td class="cart__close">
                                                    <a href="#"
                                                        onclick="window.shopping_cart.del('${item.cust_id}', '${item.item_key}', '${item.option_key}'); return false;">
                                                        <i class="fa fa-close"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="row">
                                <div class="col-lg-6 col-md-6 col-sm-6">
                                    <div class="continue__btn">
                                        <a href="<c:url value='/shop'/>">Continue Shopping</a>
                                    </div>
                                </div>
                                <div class="col-lg-6 col-md-6 col-sm-6">
                                    <%-- 업데이트 버튼 기능 변경 또는 제거할 것 --%>
                                        <div class="continue__btn update__btn">
                                            <a href="#" id="update-cart-btn"><i class="fa fa-refresh"></i> Refresh Cart
                                                (Manual)</a>
                                        </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="cart__discount">
                                <h6>Discount codes</h6>
                                <form action="#">
                                    <input type="text" placeholder="Coupon code">
                                    <button type="submit">Apply</button>
                                </form>
                            </div>
                            <div class="cart__total">
                                <h6>Cart total</h6>
                                <ul>
                                    <c:set var="total" value="0" />
                                    <c:forEach var="item" items="${cartItems}">
                                        <c:set var="itemEffectivePrice" value="${item.item_price}" />
                                        <c:if test="${item.is_hot_deal}">
                                            <c:set var="itemEffectivePrice" value="${item.item_price * 0.5}" />
                                        </c:if>
                                        <c:set var="total" value="${total + (itemEffectivePrice * item.cart_cnt)}" />
                                    </c:forEach>
                                    <li>Subtotal <span id="cart-subtotal-price">
                                            <fmt:formatNumber value="${total}" type="number" />원
                                        </span></li>
                                    <li>Total <span id="cart-total-price">
                                            <fmt:formatNumber value="${total}" type="number" />원
                                        </span></li>
                                </ul>
                                <a href="<c:url value='/checkout'/>" class="primary-btn">Proceed to checkout</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Shopping Cart Section End -->