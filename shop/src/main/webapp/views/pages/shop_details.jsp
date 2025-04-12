<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
  $(function() {
    // 수량 조절 스크립트 (기존 main.js에 있을 수 있으므로 확인 필요)
    let proQty = $('.pro-qty');
    proQty.prepend('<span class="fa fa-angle-up dec qtybtn"></span>');
    proQty.append('<span class="fa fa-angle-down inc qtybtn"></span>');
    proQty.on('click', '.qtybtn', function () {
        let button = $(this);
        let oldValue = button.parent().find('input').val();
        let newVal;
        if (button.hasClass('inc')) {
            newVal = parseFloat(oldValue) + 1;
        } else {
            if (oldValue > 1) {
                newVal = parseFloat(oldValue) - 1;
            } else {
                newVal = 1;
            }
        }
        button.parent().find('input').val(newVal);
    });

    // 옵션 선택 시 active 클래스 토글
    $('.option-group label').on('click', function() {
        $(this).closest('.option-group').find('label').removeClass('active'); 
        $(this).addClass('active');
    });

    // 'Add to Cart' 버튼 클릭 이벤트
    $('#add-to-cart-btn').on('click', function(e) {
        e.preventDefault();

        const itemKey = $('#product-details-data').data('item-key');
        const cartCnt = parseInt($('.pro-qty input').val());
        const selectedOptionKey = $('input[name="selectedOptionKey"]:checked').val(); 
        const hasOptions = $('input[name="selectedOptionKey"]').length > 0;

        // 필수 값 체크 (itemKey, cartCnt)
        if (!itemKey || isNaN(cartCnt) || cartCnt < 1) {
            alert('상품 정보 또는 수량이 올바르지 않습니다.');
            return;
        }

        // 옵션이 있는 상품인데 옵션이 선택되지 않은 경우 체크
        if (hasOptions && !selectedOptionKey) {
            alert('옵션을 선택해주세요.');
            return;
        }

        // 장바구니 추가 URL 생성 (optionKey 포함)
        let addToCartUrl = "<c:url value='/cart/add' />" +
                           "?itemKey=" + itemKey +
                           "&cartCnt=" + cartCnt;

        // 선택된 옵션 키가 있을 경우에만 추가
        if (selectedOptionKey) {
            addToCartUrl += "&optionKey=" + selectedOptionKey;
        }

        console.log("Add to cart URL:", addToCartUrl);

        location.href = addToCartUrl;
    });


    // 썸네일 이미지 배경 설정
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
    <div id="product-details-data" data-item-key="${item.itemKey}"></div>

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

                        <%-- 옵션 선택 영역 --%>
                        <c:if test="${not empty options}">
                            <div class="product__details__option option-group">
                                <span>옵션 선택:</span>
                                <c:forEach var="option" items="${options}" varStatus="status">
                                    <label for="option_${option.optionKey}" class="${option.stock <= 0 ? 'disabled' : ''}">
                                        <c:out value="${option.size}"/> / <c:out value="${option.color}"/>
                                        <c:if test="${option.additionalPrice > 0}">
                                            (+<fmt:formatNumber value="${option.additionalPrice}" type="currency" currencySymbol="₩"/>)
                                        </c:if>
                                        <c:if test="${option.stock <= 0}"> (품절)</c:if>
                                        <input type="radio" id="option_${option.optionKey}" name="selectedOptionKey" value="${option.optionKey}" ${option.stock <= 0 ? 'disabled' : ''} ${status.first ? 'checked' : ''}>
                                    </label>
                                </c:forEach>
                            </div>
                        </c:if>

                        <div class="product__details__cart__option">
                            <div class="quantity">
                                <div class="pro-qty">
                                    <input type="text" value="1">
                                </div>
                            </div>
                            <a href="#" class="primary-btn" id="add-to-cart-btn">add to cart</a>
                 </div>
         </div>
     </div>
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
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-lg-12">
        <div class="product__details__tab">
          <ul class="nav nav-tabs" role="tablist">
            <li class="nav-item">
              <a class="nav-link active" data-toggle="tab" href="#tabs-5"
                 role="tab">Description</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" data-toggle="tab" href="#tabs-6" role="tab">Customer
                Previews(5)</a> <%-- 리뷰 개수 동적 표시 --%>
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
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</section>
<!-- Shop Details Section End -->
