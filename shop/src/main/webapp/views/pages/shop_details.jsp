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
       color: black;
       background-color: beige;
       text-align: center;
       border-radius: 10px;
       padding: 10px;
   }

</style>

<script>
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
                        <c:if test="${not empty availableSizes or not empty availableColors}">
                            <div class="product__details__option">
                                <div style="margin-bottom: 10px; font-weight: bold;">옵션 선택:</div>
                                <select id="size-select" name="selectedSize">
                                    <option value="">사이즈 선택</option>
                                    <c:forEach var="size" items="${availableSizes}">
                                        <option value="${size}"><c:out value="${size}"/></option>
                                    </c:forEach>
                                </select>
                                <select id="color-select" name="selectedColor">
                                    <option value="">색상 선택</option>
                                    <c:forEach var="color" items="${availableColors}">
                                        <option value="${color}"><c:out value="${color}"/></option>
                                    </c:forEach>
                                </select>
                                <div id="option-info" class="option-info">
                                    <span>사이즈와 색상을 모두 선택해주세요.</span>
                                </div>
                            </div>
                        </c:if>
                        <script>
                          const optionsJson = '${optionsJson}';
                        </script>

                        <div class="product__details__cart__option" style="margin-top: 30px;"> <%-- 옵션 영역과 간격 조정 --%>
                            <div class="quantity">
                                <div class="quantity-controls">
                                    <button class="btn btn-outline-dark" type="button" id="detail-qty-decrease" style="border-radius: 0;">-</button>
                                    <input type="text" class="form-control text-center mx-1" id="detail-qty-input" value="1" style="width: 50px; display: inline-block; border-radius: 0;">
                                    <button class="btn btn-outline-dark" type="button" id="detail-qty-increase" style="border-radius: 0;">+</button>
                                </div>
                            </div>
                            <%-- 초기에는 비활성화 상태 --%>
                            <a href="#" class="primary-btn disabled" id="add-to-cart-btn" disabled>add to cart</a>
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
              <li class="nav-item">
                  <a class="nav-link" data-toggle="tab" href="#tabs-7" role="tab">
                      Q & A
                  </a> <%-- 리뷰 개수 동적 표시 --%>
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
  </div>
</div>
</section>
<!-- Shop Details Section End -->
