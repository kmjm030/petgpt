
$(function () {

    let hotDealCountdownInterval = null;

    function loadHotDeal() {
        $.ajax({
            url: contextPath + '/api/hotdeal/current',
            type: 'GET',
            dataType: 'json',
            success: function (hotDeal) {
                console.log("핫딜 데이터:", hotDeal);
                if (hotDeal && hotDeal.itemKey && hotDeal.expiryTime) {
                    updateHotDealSection(hotDeal);
                    startCountdown(hotDeal.expiryTime);
                } else {
                    displayNoHotDeal();
                    setTimeout(loadHotDeal, 10000); // 10초 후 재시도
                }
            },
            error: function (xhr, status, error) {
                console.error("핫딜 정보를 불러오는 중 오류 발생:", status, error);
                displayNoHotDeal("핫딜 정보를 불러오는 중 오류 발생");
                setTimeout(loadHotDeal, 10000); // 10초 후 재시도
            }
        });
    }

    function updateHotDealSection(deal) {
        const imgUrl = contextPath + '/img/product/' + (deal.itemImg1 || 'default-placeholder.png');
        const detailUrl = contextPath + '/shop/details?itemKey=' + deal.itemKey;

        $('#hotdeal-img').attr('src', imgUrl);
        $('#hotdeal-name').text(deal.itemName);
        $('#hotdeal-price').text(deal.hotDealPrice.toLocaleString() + '원');
        $('#hotdeal-original-price').text(deal.itemPrice.toLocaleString() + '원');
        $('#hotdeal-link').attr('href', detailUrl);

        // 로딩 상태 제거 (만약 있다면)
        $('.categories__deal__countdown span:first-child').show(); // 타이머 문구 다시 보이게
    }

    function displayNoHotDeal(message = "진행 중인 핫딜이 없습니다.") {
        $('#hotdeal-img').attr('src', contextPath + '/img/product-sale.png');
        $('#hotdeal-name').text(message);
        $('#hotdeal-price').text('0원');
        $('#hotdeal-original-price').text('0원');
        $('#hotdeal-minutes').text('00');
        $('#hotdeal-seconds').text('00');
        $('#hotdeal-link').attr('href', '#').addClass('disabled'); // 링크 비활성화
        $('.categories__deal__countdown span:first-child').hide(); // 타이머 문구 숨김
        if (hotDealCountdownInterval) {
            clearInterval(hotDealCountdownInterval); // 기존 카운트다운 중지
        }
    }

    function startCountdown(expiryTimeString) {
        if (hotDealCountdownInterval) {
            clearInterval(hotDealCountdownInterval);
        }

        const expiryTime = new Date(expiryTimeString).getTime(); // 만료 시간을 밀리초로 변환

        hotDealCountdownInterval = setInterval(function () {
            const now = new Date().getTime();
            const distance = expiryTime - now;

            if (distance <= 0) {
                clearInterval(hotDealCountdownInterval);
                $('#hotdeal-minutes').text('00');
                $('#hotdeal-seconds').text('00');
                $('#hotdeal-name').text('다음 딜 준비 중...');
                setTimeout(loadHotDeal, 3000);
            } else {
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                $('#hotdeal-minutes').text(minutes.toString().padStart(2, '0'));
                $('#hotdeal-seconds').text(seconds.toString().padStart(2, '0'));
            }
        }, 1000);
    }

    function createProductItemHtml(item) {
        const priceHtml = '<h5>' + item.itemPrice.toLocaleString() + '원</h5>';

        const imgUrl = contextPath + '/img/product/' + (item.itemImg1 || 'default-placeholder.png');
        const detailUrl = contextPath + '/shop/details?itemKey=' + item.itemKey;

        const isSale = (item.itemSprice != null && item.itemSprice >= 0 && item.itemSprice < item.itemPrice);
        const saleLabelHtml = isSale ? '<span class="label sale">Sale</span>' : '';

        return (
            '<div class="col-lg-4 col-md-6 col-sm-6">' +
            '    <div class="product__item">' +
            '        <div class="product__item__pic set-bg" data-setbg="' + imgUrl + '">' +
            saleLabelHtml +
            '            <ul class="product__hover">' +
            '                <li><a href="#" class="like-button" data-item-key="' + item.itemKey + '"><i class="fa fa-heart icon"></i></a></li>' +
            '                <li><a href="' + detailUrl + '" class="detail-button"><i class="fa fa-search icon"></i></a></li>' +
            '            </ul>' +
            '        </div>' +
            '        <div class="product__item__text">' +
            '            <h6>' + item.itemName + '</h6>' +
            '            <a href="#" class="add-cart" onclick="shop.addToCart(' + item.itemKey + '); return false;">+ Add To Cart</a>' +
            '            <div class="rating">' +
            '                <i class="fa fa-star-o"></i>' +
            '                <i class="fa fa-star-o"></i>' +
            '                <i class="fa fa-star-o"></i>' +
            '                <i class="fa fa-star-o"></i>' +
            '                <i class="fa fa-star-o"></i>' +
            '            </div>' +
            priceHtml +
            '        </div>' +
            '    </div>' +
            '</div>'
        );
    }

    $('.filter__controls li').on('click', function () {
        if ($(this).hasClass('active')) { return; }
        $('.filter__controls li').removeClass('active');
        $(this).addClass('active');

        const filterType = $(this).data('filter');
        const productContainer = $('#product-list-container');
        productContainer.html('<div class="col-12 loading-indicator">상품을 불러오는 중...</div>');

        $.ajax({
            url: contextPath + '/api/items/' + filterType,
            type: 'GET',
            dataType: 'json',
            success: function (items) {
                productContainer.empty();
                if (items && items.length > 0) {
                    items.forEach(function (item) {
                        const itemHtml = createProductItemHtml(item);
                        productContainer.append(itemHtml);
                    });
                    productContainer.find('.set-bg').each(function () {
                        var bg = $(this).data('setbg');
                        if (bg) { $(this).css('background-image', 'url(' + bg + ')'); }
                    });
                    // AJAX 로드 후 shop.js의 찜하기 버튼 초기화 함수 호출
                    if (typeof shop !== 'undefined' && shop.initializeLikeButtons) {
                        console.log("Calling shop.initializeLikeButtons from home.js AJAX success...");
                        shop.initializeLikeButtons(); // 전역 shop 객체의 함수 호출
                    }
                } else {
                    productContainer.html('<div class="col-12 text-center">표시할 상품이 없습니다.</div>');
                }
            },
            error: function (xhr, status, error) {
                console.error("Error fetching items:", status, error);
                productContainer.html('<div class="col-12 text-center text-danger">상품을 불러오는 중 오류가 발생했습니다.</div>');
            }
        });
    });

    $('#product-list-container .set-bg').each(function () {
        var bg = $(this).data('setbg');
        if (bg) { $(this).css('background-image', 'url(' + bg + ')'); }
    });

    loadHotDeal();
});