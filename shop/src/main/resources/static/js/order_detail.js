const order_detail = {
    contextPath: '',
    init: function () {
        this.contextPath = $('#order-detail-data').data('context-path') || '';
        console.log("Order Detail JS initialized. Context Path:", this.contextPath);
    },
    del: function (orderKey) {
        console.log("Cancelling order with orderKey: " + orderKey);
        let c = confirm('주문을 취소하시겠습니까?');
        if (c == true) {
            // contextPath를 사용하여 URL 생성
            location.href = this.contextPath + '/checkout/delimpl?orderKey=' + orderKey;
        }
    }
}
$(function () {
    order_detail.init();
});