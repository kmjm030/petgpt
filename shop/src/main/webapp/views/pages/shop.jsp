<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  .shop__sidebar__categories ul li a.category-active {
    color: #000 !important;
    font-weight: bold !important;
    background-color: #f5f5f5 !important;
    display: block;
    padding: 2px 5px;
    border-radius: 4px;
  }
  
  .shop__sidebar__price ul li a.category-active {
    color: #000 !important;
    font-weight: bold !important;
    background-color: #f5f5f5 !important;
    display: block;
    padding: 2px 5px;
    border-radius: 4px;
  }
  
  #collapseFive .shop__sidebar__color {
    display: flex;
    flex-wrap: wrap;
    gap: 10px; 
    padding: 10px 0; 
  }
  
  #collapseFive .shop__sidebar__color label {
    display: block;
    width: 26px !important;
    height: 26px !important;
    border-radius: 50% !important;
    cursor: pointer;
    position: relative;
    box-sizing: border-box !important;
    border: 1px solid rgba(0, 0, 0, 0.1) !important;
    background-image: none !important;
    padding: 0 !important;
    margin: 0 !important;
    float: none !important;
    transition: all 0.3s ease !important;
    overflow: hidden;
  }
  
  #collapseFive .shop__sidebar__color label:hover {
    transform: scale(1.15);
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.3);
    z-index: 2;
  }
  
  #collapseFive .shop__sidebar__color label.active {
    transform: scale(1.2);
    border: 2px solid rgba(255, 255, 255, 0.8) !important;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.4), inset 0px 0px 4px rgba(0, 0, 0, 0.2);
    z-index: 3;
  }
  
  #collapseFive .shop__sidebar__color label::before,
  #collapseFive .shop__sidebar__color label::after {
    content: none !important;
    display: none !important;
  }
  
  #collapseFive .shop__sidebar__color label.active::after {
    content: '✓';
    display: block !important;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: white;
    font-size: 14px;
    font-weight: bold;
    text-shadow: 0 0 2px rgba(0, 0, 0, 0.8);
    pointer-events: none;
    animation: pulse 1s ease-in-out infinite alternate;
  }
  
  @keyframes pulse {
    from { opacity: 0.8; transform: translate(-50%, -50%) scale(1); }
    to { opacity: 1; transform: translate(-50%, -50%) scale(1.1); }
  }
  
  .color-name-display {
    position: absolute;
    bottom: -25px;
    left: 50%;
    transform: translateX(-50%);
    background-color: rgba(0, 0, 0, 0.7);
    color: white;
    font-size: 10px;
    padding: 2px 5px;
    border-radius: 3px;
    white-space: nowrap;
    opacity: 0;
    transition: opacity 0.3s ease;
    pointer-events: none;
    z-index: 10;
  }
  
  #collapseFive .shop__sidebar__color label:hover .color-name-display,
  #collapseFive .shop__sidebar__color label.active .color-name-display {
    opacity: 1;
  }
  
  #collapseFive .shop__sidebar__color input[type="radio"] {
    display: none !important;
    opacity: 0 !important;
    position: absolute !important;
    width: 0 !important;
    height: 0 !important;
    margin: -1px !important;
    padding: 0 !important;
    overflow: hidden !important;
    clip: rect(0, 0, 0, 0) !important;
    border: 0 !important;
  }
  
  .color-filter-reset { 
    width: 100%;
    margin-top: 15px;
  }
  
  .product__hover .like-button {
    display: inline-block;
    transition: all 0.3s ease;
    background-color: rgba(255, 255, 255, 0.8);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .product__hover .like-button:hover {
    transform: scale(1.2);
    background-color: rgba(255, 255, 255, 0.9);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  }
  
  .product__hover .like-button.liked {
    background-color: #ff6b6b;
  }
  
  .product__hover .like-button.liked .icon {
    color: white;
  }
  
  .product__hover .detail-button {
    display: inline-block;
    transition: all 0.3s ease;
    background-color: rgba(255, 255, 255, 0.8);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .product__hover .detail-button:hover {
    transform: scale(1.2);
    background-color: rgba(255, 255, 255, 0.9);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  }
  
  .product__hover .icon {
    font-size: 18px;
    color: #333;
  }
  
  .like-overlay {
    display: none;
  }
  
  .product__item.liked .product__hover .like-button {
    background-color: #ff6b6b;
  }
</style>

<script>
  const shop = {
    init: () => {
      shop.filterDuplicateColors();
      shop.initializeLikeButtons();
    },
    filterDuplicateColors: () => {
      const processedColors = {};
      const colorMapping = {
        '블랙': '#000',
        '화이트': '#ffffff', '아이보리': '#ffffff',
        '레드': '#ff0000', '레드체크': '#ff0000',
        '블루': '#0000ff', '블루체크': '#0000ff', '네이비': '#0000ff',
        '그레이': '#808080', '라이트그레이': '#808080', '차콜': '#808080', '실버': '#808080',
        '핑크': '#ffc0cb', '라이트핑크': '#ffc0cb', '분홍색': '#ffc0cb',
        '민트': '#98ff98',
        '베이지': '#f5f5dc', '크림베이지': '#f5f5dc',
        '옐로우': '#ffff00',
        '그린': '#008000',
        '브라운': '#a52a2a',
        '카키': '#806b2a',
        '오렌지': '#ffa500',
        '퍼플': '#800080',
        '골드': '#ffd700',
        '내추럴우드': '#966F33', '월넛': '#966F33',
        '혼합색': 'mixed'
      };
      
      const colorLabels = document.querySelectorAll('.shop__sidebar__color label');
      
      colorLabels.forEach(label => {
        const colorInput = label.querySelector('input[type="radio"]');
        const colorName = colorInput.value;
        
        const colorNameDisplay = document.createElement('span');
        colorNameDisplay.className = 'color-name-display';
        colorNameDisplay.textContent = colorName;
        label.appendChild(colorNameDisplay);
        
        label.addEventListener('click', function() {
          if(this.classList.contains('active')) {
            this.classList.remove('active');
            setTimeout(() => {
              this.classList.add('active');
            }, 10);
          }
        });
        
        const colorCode = colorMapping[colorName] || '#cccccc';
        
        if (processedColors[colorCode]) {
          if (colorInput.checked) {
            const existingLabel = processedColors[colorCode].label;
            const existingInput = existingLabel.querySelector('input[type="radio"]');
            existingLabel.classList.add('active');
            existingInput.checked = true;
            label.style.display = 'none';
          } else {
            label.style.display = 'none';
          }
        } else {
          processedColors[colorCode] = {
            label: label,
            name: colorName
          };
        }
      });
    },
    addToCart: (itemKey) => {
      console.log("Adding item to cart from shop page:", itemKey);

      const requestData = {
          itemKey: itemKey,
          cartCnt: 1 
      };

      $.ajax({
          url: '<c:url value="/cart/add/ajax"/>', 
          type: 'POST',
          contentType: 'application/json',
          data: JSON.stringify(requestData),
          success: function(response) {
              console.log("Add to cart response:", response);
              if (response.success) {
                  alert('상품이 장바구니에 추가되었습니다.');             
              } else {
                  alert(response.message || '장바구니 추가 중 오류가 발생했습니다.');
                  if (response.redirectUrl) {
                       window.location.href = response.redirectUrl;
                  }
              }
          },
          error: function(xhr, status, error) {
              console.error("Add to cart Ajax error:", status, error, xhr.responseText);
              alert('장바구니 추가 중 서버 통신 오류가 발생했습니다.');
          }
      });
    },

    initializeLikeButtons: () => {
      document.querySelectorAll('.product__hover .like-button').forEach(button => {
        const itemKey = button.getAttribute('data-item-key');
        const productItem = button.closest('.product__item');
        
        if (shop.isLoggedIn) {
          shop.checkLiked(itemKey, (isLiked) => {
            if (isLiked) {
              button.classList.add('liked');
              productItem.classList.add('liked');
            }
          });
        }
        
        button.addEventListener('click', function(e) {
          e.preventDefault();
          shop.toggleLike(itemKey, this);
        });
      });
    },

    toggleLike: (itemKey, button) => {
      if (!shop.isLoggedIn) {
        if (confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) {
          window.location.href = contextPath + '/login';
        }
        return;
      }
      
      $.ajax({
        url: contextPath + '/shop/like/toggle',
        type: 'POST',
        data: { itemKey: itemKey },
        success: function(response) {
          if (response.success) {
            const productItem = button.closest('.product__item');
            
            if (response.action === 'added') {
              button.classList.add('liked');
              productItem.classList.add('liked');
              shop.showToast('상품이 찜 목록에 추가되었습니다.');
            } else {
              button.classList.remove('liked');
              productItem.classList.remove('liked');
              shop.showToast('상품이 찜 목록에서 제거되었습니다.');
            }
          } else {
            alert(response.message || '찜하기 처리 중 오류가 발생했습니다.');
            if (response.redirectUrl) {
              window.location.href = contextPath + response.redirectUrl;
            }
          }
        },
        error: function() {
          alert('서버 통신 오류가 발생했습니다.');
        }
      });
    },

    checkLiked: (itemKey, callback) => {
      $.ajax({
        url: contextPath + '/shop/like/check',
        type: 'GET',
        data: { itemKey: itemKey },
        success: function(response) {
          if (response.success && response.isLiked) {
            callback(true);
          } else {
            callback(false);
          }
        },
        error: function() {
          callback(false);
        }
      });
    },

    showToast: (message) => {
      if (!document.getElementById('toast-container')) {
        const toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.style.cssText = `
          position: fixed;
          bottom: 20px;
          right: 20px;
          z-index: 9999;
        `;
        document.body.appendChild(toastContainer);
      }
      
      const toast = document.createElement('div');
      toast.className = 'toast-message';
      toast.innerHTML = message;
      toast.style.cssText = `
        background-color: rgba(0, 0, 0, 0.7);
        color: white;
        padding: 15px 25px;
        margin-top: 10px;
        border-radius: 4px;
        opacity: 0;
        transition: opacity 0.3s ease;
      `;
      
      document.getElementById('toast-container').appendChild(toast);
      
      setTimeout(() => {
        toast.style.opacity = '1';
      }, 10);
      
      setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => {
          toast.remove();
        }, 300);
      }, 3000);
    }
  };
  
  const contextPath = '${pageContext.request.contextPath}';
  shop.isLoggedIn = ${isLoggedIn != null && isLoggedIn ? 'true' : 'false'};
  shop.customerId = '${custId}';
  
  $(function() {
    shop.init();
  });

  function changeSortOrder(sortValue) {
    const currentUrl = new URL(window.location.href);
    const params = new URLSearchParams(currentUrl.search);
    
    params.set('sort', sortValue);
    
    if (currentUrl.pathname.includes('/shop/search') && !params.has('keyword') && "${keyword}" !== "") {
      params.set('keyword', "${keyword}");
    }
    
    currentUrl.search = params.toString();
    window.location.href = currentUrl.toString();
  }
</script>

<!-- Breadcrumb Section Begin -->
<section class="breadcrumb-option">
  <div class="container">
    <div class="row">
      <div class="col-lg-12">
        <div class="breadcrumb__text">
          <h4>Shop</h4>
          <div class="breadcrumb__links">
            <a href="<c:url value='/'/>">Home</a>
            <span>Shop</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>
<!-- Breadcrumb Section End -->

<!-- Shop Section Begin -->
<section class="shop spad">
  <div class="container">
    <div class="row">
      <div class="col-lg-3">
        <div class="shop__sidebar">
          <div class="shop__sidebar__search">
            <form action="<c:url value='/shop/search'/>" method="GET">
              <input type="text" name="keyword" placeholder="상품명 검색..." value="${keyword}">
              <button type="submit"><span class="icon_search"></span></button>
            </form>
          </div>
          <div class="shop__sidebar__accordion">
            <div class="accordion" id="accordionExample">
              <div class="card">
                <div class="card-heading">
                  <a data-toggle="collapse" data-target="#collapseOne">Categories</a>
                </div>
                <div id="collapseOne" class="collapse show" data-parent="#accordionExample">
                  <div class="card-body">
                    <div class="shop__sidebar__categories">
                      <ul class="nice-scroll">
                        <li><a href="<c:url value='/shop'/>" 
                              class="${empty selectedCategoryKey ? 'category-active' : ''}"
                              >전체 상품</a></li>
                        <c:forEach items="${categories}" var="category">
                          <li><a href="<c:url value='/shop?categoryKey=${category.categoryKey}'/>" 
                                class="${selectedCategoryKey == category.categoryKey ? 'category-active' : ''}"
                                >${category.categoryName}</a></li>
                        </c:forEach>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card">
                <div class="card-heading">
                  <a data-toggle="collapse" data-target="#collapseThree">Filter Price</a>
                </div>
                <div id="collapseThree" class="collapse show" data-parent="#accordionExample">
                  <div class="card-body">
                    <div class="shop__sidebar__price">
                      <ul>           
                        <li><a href="<c:url value='/shop?price=0-10'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}" class="${param.price == '0-10' ? 'category-active' : ''}">1만원 미만</a></li>
                        <li><a href="<c:url value='/shop?price=10-20'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}" class="${param.price == '10-20' ? 'category-active' : ''}">1만원 - 2만원</a></li>
                        <li><a href="<c:url value='/shop?price=20-30'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}" class="${param.price == '20-30' ? 'category-active' : ''}">2만원 - 3만원</a></li>
                        <li><a href="<c:url value='/shop?price=30-40'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}" class="${param.price == '30-40' ? 'category-active' : ''}">3만원 - 4만원</a></li>
                        <li><a href="<c:url value='/shop?price=40-50'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}" class="${param.price == '40-50' ? 'category-active' : ''}">4만원 - 5만원</a></li>
                        <li><a href="<c:url value='/shop?price=50plus'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}" class="${param.price == '50-60' || param.price == '60-70' || param.price == '70-80' || param.price == '80-90' || param.price == '90-100' || param.price == '100plus' ? 'category-active' : ''}">5만원 이상</a></li>
                      </ul>
                      <c:if test="${not empty param.price}">
                        <div class="mt-3">
                          <c:url var="resetPriceUrl" value="/shop">
                            <c:if test="${selectedCategoryKey != null}">
                              <c:param name="categoryKey" value="${selectedCategoryKey}"/>
                            </c:if>
                            <c:if test="${not empty selectedSize}">
                              <c:param name="size" value="${selectedSize}"/>
                            </c:if>
                            <c:if test="${not empty selectedColor}">
                              <c:param name="color" value="${selectedColor}"/>
                            </c:if>
                          </c:url>
                          <a href="${resetPriceUrl}" class="site-btn" style="padding: 7px 14px; font-size: 12px; height: auto; line-height: 1.2;">가격 필터 초기화</a>
                        </div>
                      </c:if>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card">
                <div class="card-heading">
                  <a data-toggle="collapse" data-target="#collapseFour">Size</a>
                </div>
                <div id="collapseFour" class="collapse show" data-parent="#accordionExample">
                  <div class="card-body">
                    <div class="shop__sidebar__size">
                      <c:forEach items="${sizes}" var="sizeOption">
                        <label for="size-${sizeOption}" class="${selectedSize == sizeOption ? 'active' : ''}">
                          ${sizeOption}
                          <c:url var="sizeUrl" value="/shop">
                            <c:param name="size" value="${sizeOption}"/>
                            <c:if test="${selectedCategoryKey != null}">
                              <c:param name="categoryKey" value="${selectedCategoryKey}"/>
                            </c:if>
                            <c:if test="${not empty selectedColor}">
                              <c:param name="color" value="${selectedColor}"/>
                            </c:if>
                            <c:if test="${not empty param.price}">
                              <c:param name="price" value="${param.price}"/>
                            </c:if>
                          </c:url>
                          <input type="radio" id="size-${sizeOption}" name="sizeFilter" value="${sizeOption}" 
                                 ${selectedSize == sizeOption ? 'checked' : ''} 
                                 onchange="location.href='${sizeUrl}'">
                        </label>
                      </c:forEach>
                      <c:if test="${not empty selectedSize}">
                        <div class="mt-2">
                          <c:url var="resetSizeUrl" value="/shop">
                            <c:if test="${selectedCategoryKey != null}">
                              <c:param name="categoryKey" value="${selectedCategoryKey}"/>
                            </c:if>
                            <c:if test="${not empty selectedColor}">
                              <c:param name="color" value="${selectedColor}"/>
                            </c:if>
                            <c:if test="${not empty param.price}">
                              <c:param name="price" value="${param.price}"/>
                            </c:if>
                          </c:url>
                          <a href="${resetSizeUrl}" class="site-btn" style="padding: 7px 14px; font-size: 12px; height: auto; line-height: 1.2;">사이즈 필터 초기화</a>
                        </div>
                      </c:if>
                    </div>
                  </div>
                </div>
              </div>
              <div class="card">
                <div class="card-heading">
                  <a data-toggle="collapse" data-target="#collapseFive">Colors</a>
                </div>
                <div id="collapseFive" class="collapse show" data-parent="#accordionExample">
                  <div class="card-body">
                    <div class="shop__sidebar__color">
                      <c:forEach items="${colors}" var="colorOption">
                        <c:url var="colorUrl" value="/shop">
                          <c:param name="color" value="${colorOption}"/>
                          <c:if test="${selectedCategoryKey != null}">
                            <c:param name="categoryKey" value="${selectedCategoryKey}"/>
                          </c:if>
                          <c:if test="${not empty selectedSize}">
                            <c:param name="size" value="${selectedSize}"/>
                          </c:if>
                          <c:if test="${not empty param.price}">
                            <c:param name="price" value="${param.price}"/>
                          </c:if>
                        </c:url>
                        <label class="${selectedColor == colorOption ? 'active' : ''}" 
                               style="background-color: ${ 
                                       colorOption == '블랙' ? '#000' : 
                                       colorOption == '화이트' || colorOption == '아이보리' ? '#ffffff' : 
                                       colorOption == '레드' || colorOption == '레드체크' ? '#ff0000' : 
                                       colorOption == '블루' || colorOption == '블루체크' || colorOption == '네이비' ? '#0000ff' : 
                                       colorOption == '그레이' || colorOption == '라이트그레이' || colorOption == '차콜' || colorOption == '실버' ? '#808080' : 
                                       colorOption == '핑크' || colorOption == '라이트핑크' || colorOption == '분홍색' ? '#ffc0cb' : 
                                       colorOption == '민트' ? '#98ff98' : 
                                       colorOption == '베이지' || colorOption == '크림베이지' ? '#f5f5dc' : 
                                       colorOption == '옐로우' ? '#ffff00' : 
                                       colorOption == '그린' ? '#008000' : 
                                       colorOption == '브라운' ? '#a52a2a' : 
                                       colorOption == '카키' ? '#806b2a' : 
                                       colorOption == '오렌지' ? '#ffa500' : 
                                       colorOption == '퍼플' ? '#800080' : 
                                       colorOption == '골드' ? '#ffd700' : 
                                       colorOption == '내추럴우드' || colorOption == '월넛' ? '#966F33' : 
                                       colorOption == '혼합색' ? 'linear-gradient(90deg, red, orange, yellow, green, blue, indigo, violet)' : 
                                        '#cccccc'}">
                          <input type="radio" id="color-${colorOption}" name="colorFilter" value="${colorOption}" 
                                 ${selectedColor == colorOption ? 'checked' : ''}
                                 onchange="location.href='${colorUrl}'">
                        </label>
                      </c:forEach>
                      <c:if test="${not empty selectedColor}">
                        <div class="color-filter-reset">
                          <c:url var="resetColorUrl" value="/shop">
                            <c:if test="${selectedCategoryKey != null}">
                              <c:param name="categoryKey" value="${selectedCategoryKey}"/>
                            </c:if>
                            <c:if test="${not empty selectedSize}">
                              <c:param name="size" value="${selectedSize}"/>
                            </c:if>
                            <c:if test="${not empty param.price}">
                              <c:param name="price" value="${param.price}"/>
                            </c:if>
                          </c:url>
                          <a href="${resetColorUrl}" class="site-btn" style="padding: 7px 14px; font-size: 12px; height: auto; line-height: 1.2;">색상 필터 초기화</a>
                        </div>
                      </c:if>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-9">
          <div class="shop__product__option">
            <div class="row">
              <div class="col-lg-6 col-md-6 col-sm-6">
                <div class="shop__product__option__left">
                  <c:choose>
                    <c:when test="${not empty keyword}">
                      <p>"${keyword}" 검색 결과 ${resultCount}개의 상품</p>
                    </c:when>
                    <c:otherwise>
                      <p>Showing 1–12 of 126 results</p>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
              <div class="col-lg-6 col-md-6 col-sm-6">
                <div class="shop__product__option__right">
                  <p>상품 정렬:</p>
                  <select id="sortSelector" onchange="changeSortOrder(this.value)">
                    <option value="default" ${selectedSort eq 'default' ? 'selected' : ''}>상품번호순</option>
                    <option value="newest" ${selectedSort eq 'newest' ? 'selected' : ''}>최신순</option>
                    <option value="oldest" ${selectedSort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                    <option value="price_high" ${selectedSort eq 'price_high' ? 'selected' : ''}>가격 높은순</option>
                    <option value="price_low" ${selectedSort eq 'price_low' ? 'selected' : ''}>가격 낮은순</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <c:choose>
              <c:when test="${empty itemList}">
                <div class="col-lg-12 text-center my-5">
                  <h4>검색 결과가 없습니다.</h4>
                  <c:if test="${not empty keyword}">
                    <p>"${keyword}"에 대한 상품을 찾을 수 없습니다.</p>
                  </c:if>
                  <a href="<c:url value='/shop'/>" class="primary-btn mt-3">모든 상품 보기</a>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach items="${itemList}" var="item">
                  <div class="col-lg-4 col-md-6 col-sm-6">
                    <div class="product__item">
                      <div class="product__item__pic set-bg" data-setbg="<c:url value='/img/product/${item.itemImg1}'/>">
                        <ul class="product__hover">
                          <li><a href="#" class="like-button" data-item-key="${item.itemKey}">
                            <i class="fa fa-heart icon"></i>
                          </a></li>
                          <li><a href="<c:url value='/shop/details?itemKey=${item.itemKey}'/>" class="detail-button">
                            <i class="fa fa-search icon"></i>
                          </a></li>
                        </ul>
                      </div>
                      <div class="product__item__text">
                        <h6>${item.itemName}</h6>
                        <a href="#" class="add-cart" onclick="shop.addToCart(${item.itemKey}); return false;">+ Add To Cart</a>
                        <div class="rating">
                          <i class="fa fa-star-o"></i>
                          <i class="fa fa-star-o"></i>
                          <i class="fa fa-star-o"></i>
                          <i class="fa fa-star-o"></i>
                          <i class="fa fa-star-o"></i>
                        </div>
                        <h5>${item.itemPrice}원</h5>
                        <div class="product__color__select">
                          <label for="pc-4">
                            <input type="radio" id="pc-4" name="color-product-2" value="color1">
                          </label>
                          <label class="active black" for="pc-5">
                            <input type="radio" id="pc-5" name="color-product-2" value="black" checked>
                          </label>
                          <label class="grey" for="pc-6">
                            <input type="radio" id="pc-6" name="color-product-2" value="grey">
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
          <div class="row">
            <div class="col-lg-12">
              <div class="product__pagination">
                <a class="active" href="#">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <span>...</span>
                <a href="#">21</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
</section>
<!-- Shop Section End -->
