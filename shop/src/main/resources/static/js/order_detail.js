const order_detail = {
    contextPath: '',
    init: function () {
        this.contextPath = $('#order-detail-data').data('context-path') || '';
        console.log("Order Detail JS initialized. Context Path:", this.contextPath);
    },
    del: function (orderKey, event) {
        const orderStatus = event.currentTarget.dataset.orderStatus;

        if (orderStatus === "결제완료" || orderStatus === "상품준비중") {
            let c = confirm('주문을 취소하시겠습니까?');
            if (c === true) {
                location.href = this.contextPath + '/checkout/delimpl?orderKey=' + orderKey;
            }
        } else {
            alert('취소가 불가합니다. 교환/반품 문의로 접수해주세요.');
        }
    }
}
$(function () {
    order_detail.init();
});