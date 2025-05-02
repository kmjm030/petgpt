<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">

                <!-- Shop Details Section Begin -->
                <section class="shop-details">
                    <div id="shop-details-data" data-item-key="${item.itemKey}"
                        data-is-hot-deal-active="${isHotDealActive}" data-original-base-price="${item.itemPrice}"
                        data-options-json='${optionsJson}' data-cart-url="
                        <c:url value='/cart' />" data-cart-add-batch-url="
                        <c:url value='/cart/add/batch/ajax' />" data-login-url="
                        <c:url value='/login' />" style="display: none;">
                    </div>

                    <div class="product__details__pic">
                        <div class="container">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="product__details__breadcrumb">
                                        <a href="<c:url value='/'/>">Home</a>
                                        <a href="<c:url value='/shop'/>">Shop</a>
                                        <span>
                                            <c:out value="${item.itemName}" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-3 col-md-3">
                                    <ul class="nav nav-tabs" role="tablist">

                                        <c:if test="${not empty item.itemImg1}">
                                            <li class="nav-item">
                                                <a class="nav-link active" data-toggle="tab" href="#tabs-1" role="tab">
                                                    <div class="product__thumb__pic set-bg"
                                                        data-setbg="<c:url value='/img/product/${item.itemImg1}'/>">
                                                    </div>
                                                </a>
                                            </li>
                                        </c:if>
                                        <c:if test="${not empty item.itemImg2}">
                                            <li class="nav-item">
                                                <a class="nav-link" data-toggle="tab" href="#tabs-2" role="tab">
                                                    <div class="product__thumb__pic set-bg"
                                                        data-setbg="<c:url value='/img/product/${item.itemImg2}'/>">
                                                    </div>
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
                                                    <img src="<c:url value='/img/product/${item.itemImg1}'/>"
                                                        alt="${item.itemName}">
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty item.itemImg2}">
                                            <div class="tab-pane <c:if test='${empty item.itemImg1}'>active</c:if>"
                                                id="tabs-2" role="tabpanel">
                                                <div class="product__details__pic__item">
                                                    <img src="<c:url value='/img/product/${item.itemImg2}'/>"
                                                        alt="${item.itemName}">
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
                                        <h4>
                                            <c:out value="${item.itemName}" />
                                        </h4>
                                        <div class="product__details__price">
                                            <c:choose>
                                                <c:when test="${isHotDealActive}">
                                                    <span class="hot-deal-price">
                                                        <fmt:formatNumber value="${hotDealPrice}" pattern="#,##0" />
                                                        원
                                                        <span class="discount-badge">🔥핫딜 50%</span>
                                                    </span>
                                                    <del>
                                                        <fmt:formatNumber value="${item.itemPrice}" pattern="#,##0" />원
                                                    </del>
                                                </c:when>
                                                <c:otherwise>
                                                    <h3>
                                                        <fmt:formatNumber value="${item.itemPrice}" pattern="#,##0" />원
                                                    </h3>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <p>
                                            <c:out value="${item.itemContent}" />
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="product__details__tab">
                                        <ul class="nav nav-tabs" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" data-toggle="tab" href="#tabs-5"
                                                    role="tab">상세설명</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" data-toggle="tab" href="#tabs-6" role="tab">상품후기</a>
                                                <%-- 리뷰 개수 동적 표시 --%>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" data-toggle="tab" href="#tabs-7" role="tab">Q &
                                                    A</a> <%-- 리뷰 개수 동적 표시 --%>
                                            </li>
                                        </ul>
                                        <div class="tab-content">
                                            <div class="tab-pane active" id="tabs-5" role="tabpanel">
                                                <div class="product__details__tab__content">
                                                    ${item.itemDetail}
                                                </div>
                                            </div>
                                            <div class="tab-pane shop-detail-board" id="tabs-6" role="tabpanel">
                                                <div class="product__details__tab__content">
                                                    <%-- 고객 리뷰 동적 표시 필요 --%>
                                                        <c:forEach var="c" items="${reviews}">
                                                            <div class="container mt-4">
                                                                <div class="card mb-3 p-3">
                                                                    <div class="d-flex">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty c.customer.custImg}">
                                                                                <img src="<c:url value="
                                                                                    ${c.customer.custImg}" />"
                                                                                class="rounded-circle me-3"
                                                                                alt="user"
                                                                                style="width:60px;
                                                                                height:60px;
                                                                                object-fit:cover;
                                                                                margin-right: 20px;">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <img src="<c:url value='/img/clients/profile.png'/>"
                                                                                    class="rounded-circle me-3"
                                                                                    alt="user"
                                                                                    style="width:60px; height:60px; object-fit:cover; margin-right: 20px;" />
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <div class="flex-grow-1">
                                                                            <div class="d-flex justify-content-between">
                                                                                <div>
                                                                                    <strong>${c.customer.custNick}</strong>
                                                                                    <div class="text-warning ms-2">
                                                                                        <div class="star-rating mb-2">
                                                                                            <c:forEach var="i" begin="1"
                                                                                                end="5">
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${i <= c.boardScore}">
                                                                                                        <i
                                                                                                            class="bi bi-star-fill text-warning"></i>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <i
                                                                                                            class="bi bi-star"></i>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                            </c:forEach>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <small class="text-muted">
                                                                                    <fmt:formatDate
                                                                                        value="${c.boardRdate}"
                                                                                        pattern="yyyy-MM-dd" />
                                                                                </small>
                                                                            </div>
                                                                            <p class="mt-2 mb-1">
                                                                                ${c.boardContent}</p>
                                                                            <div class="d-flex gap-2 mt-2">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty c.boardImg}">
                                                                                        <img src="<c:url value="
                                                                                            ${c.boardImg}" />"
                                                                                        class="img-thumbnail"
                                                                                        style="width:80px;
                                                                                        height:80px;
                                                                                        object-fit:cover;">
                                                                                    </c:when>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                </div>
                                            </div>
                                            <div class="tab-pane shop-detail-board" id="tabs-7" role="tabpanel">
                                                <form
                                                    action="<c:url value='/qnaboard/add?id=${sessionScope.cust.custId}'/>"
                                                    method="post">
                                                    <button type="submit" class="site-btn" style="width: 300px;">문의
                                                        작성하기</button>
                                                </form>
                                                <br />
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
                                                            <c:forEach var="c" items="${qnaBoards}" varStatus="status">
                                                                <tr id="title-content-${status.index}">
                                                                    <td>
                                                                        <a href="javascript:void(0);"
                                                                            onclick="toggleContent('content-${status.index}')">
                                                                            ${c.boardTitle}
                                                                        </a>
                                                                    </td>
                                                                    <td>
                                                                        <fmt:formatDate value="${c.boardRdate}"
                                                                            pattern="yyyy-MM-dd" />
                                                                    </td>
                                                                    <td>
                                                                        <p id="boardRe">${c.boardRe}</p>
                                                                    </td>
                                                                </tr>
                                                                <tr id="content-${status.index}" style="display:none;">
                                                                    <td colspan="3">
                                                                        <div style="margin: 20px;">
                                                                            ${fn:escapeXml(c.boardContent)}
                                                                        </div>
                                                                        <c:if test="${not empty c.adminComments}">
                                                                            <div
                                                                                style="margin-top: 10px; padding: 10px; background-color: #f9f9f9; border-radius: 5px; border: 1px solid #ddd;">
                                                                                <strong>└ 🗨️</strong>
                                                                                <p style="display:inline-block;">
                                                                                    ${fn:escapeXml(c.adminComments.adcommentsContent)}
                                                                                    (
                                                                                    <fmt:formatDate
                                                                                        value="${c.adminComments.adcommentsRdate}"
                                                                                        pattern="yyyy-MM-dd" />
                                                                                    )
                                                                                </p>
                                                                            </div>
                                                                        </c:if>
                                                                    </td>

                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        </di>
                                    </div>
                                </div>
                            </div> <%-- End of container --%>
                        </div> <%-- End of product__details__content --%>
                </section>
                <!-- Shop Details Section End -->

                <!-- Sticky Footer Buttons -->
                <div class="sticky-footer-buttons">
                    <button type="button" id="add-to-wishlist-btn"
                        style="display: flex; flex-direction: column; align-items: center; justify-content: center; line-height: 1.2;">
                        <%-- Flexbox 스타일 추가 --%>
                            <img src="<c:url value='/img/icon/like.svg'/>" alt="찜하기"
                                style="height: 1.5em; margin-bottom: 2px;"> <%-- 아이콘 아래 여백 추가 --%>
                                <span style="font-size: 0.8em;">찜</span> <%-- 텍스트 추가 및 크기 조정 --%>
                    </button>
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
                        <button type="button" id="trigger-color-modal">색상 옵션을 선택해주세요 <span
                                class="arrow">▼</span></button>
                        <button type="button" id="trigger-size-modal" disabled>사이즈 옵션을 선택해주세요 <span
                                class="arrow">▼</span></button>
                    </div>
                    <div class="total-summary">
                        총 수량 <span id="total-quantity">0</span>개 / 총 <span id="total-price">0</span>원
                    </div>
                    <button type="button" id="final-add-all-to-cart-btn" disabled>장바구니 담기</button>
                </div>

                <!-- Color Selection Modal (Center) -->
                <div id="color-select-modal" class="center-modal">
                    <h5>색상 선택 <button type="button" class="close-modal-btn" data-target="color-select-modal">×</button>
                    </h5>
                    <div class="modal-options-list" id="color-options-list">
                        <!-- Color options will be added here by JS -->
                    </div>
                </div>

                <!-- Size Selection Modal (Center) -->
                <div id="size-select-modal" class="center-modal">
                    <h5>사이즈 선택 <button type="button" class="close-modal-btn" data-target="size-select-modal">×</button>
                    </h5>
                    <div class="selected-color-info" id="size-modal-selected-color"></div>
                    <div class="modal-options-list" id="size-options-list">
                        <!-- Size options will be added here by JS -->
                    </div>
                </div>