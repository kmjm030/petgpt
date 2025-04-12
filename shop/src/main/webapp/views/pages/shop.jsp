<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  const shop = {
    init: () => {
      
    },
    addToCart: (itemKey) => {
      console.log("Adding item to cart from shop page:", itemKey);

      // 옵션 키는 현재 없으므로 null 또는 생략
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
    }
  }
  $(function() {
    shop.init();
  });

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
            <form action="#"> <%-- 실제 검색 처리 URL 필요 --%>
              <input type="text" placeholder="Search...">
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
                        <li><a href="<c:url value='/shop'/>">전체 상품</a></li>
 
                        <li><a href="<c:url value='/shop?categoryKey=1'/>" class="${selectedCategoryKey == 1 ? 'active' : ''}">카테고리 1</a></li>
                        <li><a href="<c:url value='/shop?categoryKey=2'/>" class="${selectedCategoryKey == 2 ? 'active' : ''}">카테고리 2</a></li>
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
                        <li><a href="<c:url value='/shop?price=0-50'/>">$0.00 - $50.00</a></li>
                        <li><a href="<c:url value='/shop?price=50-100'/>">$50.00 - $100.00</a></li>
                        <li><a href="<c:url value='/shop?price=100-150'/>">$100.00 - $150.00</a></li>
                        <li><a href="<c:url value='/shop?price=150-200'/>">$150.00 - $200.00</a></li>
                        <li><a href="<c:url value='/shop?price=200-250'/>">$200.00 - $250.00</a></li>
                        <li><a href="<c:url value='/shop?price=250plus'/>">250.00+</a></li>
                      </ul>
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
                      <label for="sm">s
                        <input type="radio" id="sm" name="sizeFilter" value="s">
                      </label>
                      <label for="md">m
                        <input type="radio" id="md" name="sizeFilter" value="m">
                      </label>
                      <label for="l">l
                        <input type="radio" id="l" name="sizeFilter" value="l">
                      </label>
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
                      <label class="c-1" for="sp-1">
                        <input type="radio" id="sp-1" name="colorFilter" value="color1">
                      </label>
                      <label class="c-2" for="sp-2">
                        <input type="radio" id="sp-2" name="colorFilter" value="color2">
                      </label>
                      <label class="c-9" for="sp-9">
                        <input type="radio" id="sp-9" name="colorFilter" value="color9">
                      </label>
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
                  <p>Showing 1–12 of 126 results</p>
                </div>
              </div>
              <div class="col-lg-6 col-md-6 col-sm-6">
                <div class="shop__product__option__right">
                  <%-- 정렬 기능 구현 필요 --%>
                  <p>상품 정렬:</p>
                  <select>
                    <option value="">인기순</option>
                    <option value="">최신 등록순</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
              <c:forEach items="${itemList}" var="item">
            <div class="col-lg-4 col-md-6 col-sm-6">
            <div class="product__item">
                <div class="product__item__pic set-bg" data-setbg="<c:url value='/img/product/${item.itemImg1}'/>">
                  <ul class="product__hover">
                    <li><a href="#"><img src="<c:url value='/img/icon/heart.png'/>" alt=""></a></li>
                    <li><a href="<c:url value='/shop/details?itemKey=${item.itemKey}'/>"><img src="<c:url value='/img/icon/search.png'/>" alt=""></a></li>
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
