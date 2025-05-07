<%@ page pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        <div id="shop-page-data" data-context-path="${pageContext.request.contextPath}"
          data-is-logged-in="${ isLoggedIn != null && isLoggedIn }" data-cust-id="${custId}"
          data-cart-add-url="<c:url value='/cart/add/ajax'/>" data-like-toggle-url="<c:url value='/shop/like/toggle'/>"
          data-like-check-url="<c:url value='/shop/like/check'/>" data-login-url="<c:url value='/login'/>"
          data-keyword="${keyword}" style="display: none;">
        </div>
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
                                  class="${empty selectedCategoryKey ? 'category-active' : ''}">전체 상품</a></li>
                              <c:forEach items="${categories}" var="category">
                                <li><a href="<c:url value='/shop?categoryKey=${category.categoryKey}'/>"
                                    class="${selectedCategoryKey == category.categoryKey ? 'category-active' : ''}">${category.categoryName}</a>
                                </li>
                              </c:forEach>
                            </ul>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="card">
                      <div class="card-heading">
                        <a data-toggle="collapse" data-target="#collapseThree">Price</a>
                      </div>
                      <div id="collapseThree" class="collapse show" data-parent="#accordionExample">
                        <div class="card-body">
                          <div class="shop__sidebar__price">
                            <ul>
                              <li><a
                                  href="<c:url value='/shop?price=0-10'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}"
                                  class="${param.price == '0-10' ? 'category-active' : ''}">1만원 미만</a></li>
                              <li><a
                                  href="<c:url value='/shop?price=10-20'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}"
                                  class="${param.price == '10-20' ? 'category-active' : ''}">1만원 - 2만원</a></li>
                              <li><a
                                  href="<c:url value='/shop?price=20-30'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}"
                                  class="${param.price == '20-30' ? 'category-active' : ''}">2만원 - 3만원</a></li>
                              <li><a
                                  href="<c:url value='/shop?price=30-40'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}"
                                  class="${param.price == '30-40' ? 'category-active' : ''}">3만원 - 4만원</a></li>
                              <li><a
                                  href="<c:url value='/shop?price=40-50'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}"
                                  class="${param.price == '40-50' ? 'category-active' : ''}">4만원 - 5만원</a></li>
                              <li><a
                                  href="<c:url value='/shop?price=50plus'/>${selectedCategoryKey != null ? '&categoryKey='.concat(selectedCategoryKey) : ''}${not empty selectedSize ? '&size='.concat(selectedSize) : ''}${not empty selectedColor ? '&color='.concat(selectedColor) : ''}"
                                  class="${param.price == '50-60' || param.price == '60-70' || param.price == '70-80' || param.price == '80-90' || param.price == '90-100' || param.price == '100plus' ? 'category-active' : ''}">5만원
                                  이상</a></li>
                            </ul>
                            <c:if test="${not empty param.price}">
                              <div class="mt-3">
                                <c:url var="resetPriceUrl" value="/shop">
                                  <c:if test="${selectedCategoryKey != null}">
                                    <c:param name="categoryKey" value="${selectedCategoryKey}" />
                                  </c:if>
                                  <c:if test="${not empty selectedSize}">
                                    <c:param name="size" value="${selectedSize}" />
                                  </c:if>
                                  <c:if test="${not empty selectedColor}">
                                    <c:param name="color" value="${selectedColor}" />
                                  </c:if>
                                </c:url>
                                <a href="${resetPriceUrl}" class="site-btn"
                                  style="padding: 7px 14px; font-size: 12px; height: auto; line-height: 1.2;">가격 필터
                                  초기화</a>
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
                                  <c:param name="size" value="${sizeOption}" />
                                  <c:if test="${selectedCategoryKey != null}">
                                    <c:param name="categoryKey" value="${selectedCategoryKey}" />
                                  </c:if>
                                  <c:if test="${not empty selectedColor}">
                                    <c:param name="color" value="${selectedColor}" />
                                  </c:if>
                                  <c:if test="${not empty param.price}">
                                    <c:param name="price" value="${param.price}" />
                                  </c:if>
                                </c:url>
                                <input type="radio" id="size-${sizeOption}" name="sizeFilter" value="${sizeOption}"
                                  ${selectedSize==sizeOption ? 'checked' : '' } onchange="location.href='${sizeUrl}'">
                              </label>
                            </c:forEach>
                            <c:if test="${not empty selectedSize}">
                              <div class="mt-2">
                                <c:url var="resetSizeUrl" value="/shop">
                                  <c:if test="${selectedCategoryKey != null}">
                                    <c:param name="categoryKey" value="${selectedCategoryKey}" />
                                  </c:if>
                                  <c:if test="${not empty selectedColor}">
                                    <c:param name="color" value="${selectedColor}" />
                                  </c:if>
                                  <c:if test="${not empty param.price}">
                                    <c:param name="price" value="${param.price}" />
                                  </c:if>
                                </c:url>
                                <a href="${resetSizeUrl}" class="site-btn"
                                  style="padding: 7px 14px; font-size: 12px; height: auto; line-height: 1.2;">사이즈 필터
                                  초기화</a>
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
                                <c:param name="color" value="${colorOption}" />
                                <c:if test="${selectedCategoryKey != null}">
                                  <c:param name="categoryKey" value="${selectedCategoryKey}" />
                                </c:if>
                                <c:if test="${not empty selectedSize}">
                                  <c:param name="size" value="${selectedSize}" />
                                </c:if>
                                <c:if test="${not empty param.price}">
                                  <c:param name="price" value="${param.price}" />
                                </c:if>
                              </c:url>
                              <label class="${selectedColor == colorOption ? 'active' : ''}" style="background-color: ${
                                     colorOption == '블랙' ? '#000' 
                                     : colorOption == '화이트' || colorOption == '아이보리' ? '#ffffff' 
                                     : colorOption == '레드' || colorOption == '레드체크' ? '#ff0000' 
                                     : colorOption == '블루' || colorOption == '블루체크' || colorOption == '네이비' ? '#0000ff' 
                                     : colorOption == '그레이' || colorOption == '라이트그레이' || colorOption == '차콜' || colorOption == '실버' ? '#808080' 
                                     : colorOption == '핑크' || colorOption == '라이트핑크' || colorOption == '분홍색' ? '#ffc0cb' 
                                     : colorOption == '민트' ? '#98ff98' 
                                     : colorOption == '베이지' || colorOption == '크림베이지' ? '#f5f5dc' 
                                     : colorOption == '옐로우' ? '#ffff00' 
                                     : colorOption == '그린' ? '#008000' 
                                     : colorOption == '브라운' ? '#a52a2a' 
                                     : colorOption == '카키' ? '#806b2a' 
                                     : colorOption == '오렌지' ? '#ffa500' 
                                     : colorOption == '퍼플' ? '#800080' 
                                     : colorOption == '골드' ? '#ffd700' 
                                     : colorOption == '내추럴우드' || colorOption == '월넛' ? '#966F33' 
                                     : colorOption == '혼합색' ? 'linear-gradient(90deg, red, orange, yellow, green, blue, indigo, violet)' 
                                     : '#cccccc'
                                }">
                                <input type="radio" id="color-${colorOption}" name="colorFilter" value="${colorOption}"
                                  ${selectedColor==colorOption ? 'checked' : '' }
                                  onchange="location.href='${colorUrl}'">
                              </label>
                            </c:forEach>
                            <c:if test="${not empty selectedColor}">
                              <div class="color-filter-reset">
                                <c:url var="resetColorUrl" value="/shop">
                                  <c:if test="${selectedCategoryKey != null}">
                                    <c:param name="categoryKey" value="${selectedCategoryKey}" />
                                  </c:if>
                                  <c:if test="${not empty selectedSize}">
                                    <c:param name="size" value="${selectedSize}" />
                                  </c:if>
                                  <c:if test="${not empty param.price}">
                                    <c:param name="price" value="${param.price}" />
                                  </c:if>
                                </c:url>
                                <a href="${resetColorUrl}" class="site-btn"
                                  style="padding: 7px 14px; font-size: 12px; height: auto; line-height: 1.2;">색상 필터
                                  초기화</a>
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
                        <option value="default" ${selectedSort eq 'default' ? 'selected' : '' }>상품번호순</option>
                        <option value="newest" ${selectedSort eq 'newest' ? 'selected' : '' }>최신순</option>
                        <option value="oldest" ${selectedSort eq 'oldest' ? 'selected' : '' }>오래된순</option>
                        <option value="price_high" ${selectedSort eq 'price_high' ? 'selected' : '' }>가격 높은순</option>
                        <option value="price_low" ${selectedSort eq 'price_low' ? 'selected' : '' }>가격 낮은순</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>
              <div class="row" id="product-list-container">
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
                          <div class="product__item__pic set-bg"
                            data-setbg="<c:url value='/img/product/${item.itemImg1}'/>">
                            <ul class="product__hover">
                              <li><a href="#" class="like-button" data-item-key="${item.itemKey}">
                                  <i class="fa fa-heart icon"></i>
                                </a></li>
                              <li><a href="<c:url value='/shop/details?itemKey=${item.itemKey}'/>"
                                  class="detail-button">
                                  <i class="fa fa-search icon"></i>
                                </a></li>
                            </ul>
                          </div>
                          <div class="product__item__text">
                            <h6>${item.itemName}</h6>
                            <a href="#" class="add-cart" data-item-key="${item.itemKey}">+ Add To Cart</a>
                            <div class="rating">
                              <c:set var="avgScore" value="${item.avgScore != null ? item.avgScore : 0}" />
                              <c:set var="reviewCount" value="${item.reviewCount != null ? item.reviewCount : 0}" />

                              <c:forEach var="i" begin="1" end="5">
                                <c:choose>
                                  <c:when test="${i <= avgScore}">
                                    <i class="fa fa-star"></i>
                                  </c:when>
                                  <c:when test="${i <= avgScore + 0.5 && i > avgScore}">
                                    <i class="fa fa-star-half-o"></i>
                                  </c:when>
                                  <c:otherwise>
                                    <i class="fa fa-star-o"></i>
                                  </c:otherwise>
                                </c:choose>
                              </c:forEach>
                              <span class="review-count">(${reviewCount})</span>
                            </div>
                            <div class="product__price">
                              <c:if test="${item.itemSprice > 0 and item.itemSprice < item.itemPrice}">
                                <c:set var="discountRate" value="${100 - (item.itemSprice * 100 / item.itemPrice)}" />
                                <div class="price-container">
                                  <span class="original-price">
                                    <fmt:formatNumber value="${item.itemPrice}" pattern="#,###" />원
                                  </span>
                                  <div class="sale-info">
                                    <span class="sale-price">
                                      <fmt:formatNumber value="${item.itemSprice}" pattern="#,###" />원
                                    </span>
                                    <span class="discount-badge">
                                      <fmt:formatNumber value="${discountRate}" pattern="#" />%
                                    </span>
                                  </div>
                                </div>
                              </c:if>
                              <c:if test="${!(item.itemSprice > 0 and item.itemSprice < item.itemPrice)}">
                                <div class="price-container">
                                  <span class="sale-price">
                                    <fmt:formatNumber value="${item.itemPrice}" pattern="#,###" />원
                                  </span>
                                </div>
                              </c:if>
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
                    <c:if test="${totalPages > 0}">
                      <c:if test="${currentPage > 1}">
                        <a href="<c:url value='/shop'>
                      <c:param name='page' value='${currentPage - 1}'/>
                      <c:if test='${not empty selectedCategoryKey}'><c:param name='categoryKey' value='${selectedCategoryKey}'/></c:if>
                      <c:if test='${not empty selectedSize}'><c:param name='size' value='${selectedSize}'/></c:if>
                      <c:if test='${not empty selectedColor}'><c:param name='color' value='${selectedColor}'/></c:if>
                      <c:if test='${not empty param.price}'><c:param name='price' value='${param.price}'/></c:if>
                      <c:if test='${not empty param.sort}'><c:param name='sort' value='${param.sort}'/></c:if>
                    </c:url>">&laquo;</a>
                      </c:if>

                      <c:forEach begin="1" end="${totalPages}" var="pageNum">
                        <c:if
                          test="${pageNum == 1 || pageNum == totalPages || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)}">
                          <a href="<c:url value='/shop'>
                        <c:param name='page' value='${pageNum}'/>
                        <c:if test='${not empty selectedCategoryKey}'><c:param name='categoryKey' value='${selectedCategoryKey}'/></c:if>
                        <c:if test='${not empty selectedSize}'><c:param name='size' value='${selectedSize}'/></c:if>
                        <c:if test='${not empty selectedColor}'><c:param name='color' value='${selectedColor}'/></c:if>
                        <c:if test='${not empty param.price}'><c:param name='price' value='${param.price}'/></c:if>
                        <c:if test='${not empty param.sort}'><c:param name='sort' value='${param.sort}'/></c:if>
                      </c:url>" class="${pageNum == currentPage ? 'active' : ''}">${pageNum}</a>
                        </c:if>
                        <c:if test="${pageNum == currentPage - 3 || pageNum == currentPage + 3}">
                          <span>...</span>
                        </c:if>
                      </c:forEach>

                      <c:if test="${currentPage < totalPages}">
                        <a href="<c:url value='/shop'>
                      <c:param name='page' value='${currentPage + 1}'/>
                      <c:if test='${not empty selectedCategoryKey}'><c:param name='categoryKey' value='${selectedCategoryKey}'/></c:if>
                      <c:if test='${not empty selectedSize}'><c:param name='size' value='${selectedSize}'/></c:if>
                      <c:if test='${not empty selectedColor}'><c:param name='color' value='${selectedColor}'/></c:if>
                      <c:if test='${not empty param.price}'><c:param name='price' value='${param.price}'/></c:if>
                      <c:if test='${not empty param.sort}'><c:param name='sort' value='${param.sort}'/></c:if>
                    </c:url>">&raquo;</a>
                      </c:if>
                    </c:if>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- Shop Section End -->