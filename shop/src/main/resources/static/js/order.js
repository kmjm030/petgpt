const order = {
    contextPath: '',
    init: function () {
        this.contextPath = $('#order-data').data('context-path') || '';
        console.log("Order (like?) JS initialized. Context Path:", this.contextPath);
    },
    del: function (boardKey) {
        console.log("Deleting QnA board with boardKey: " + boardKey);
        let c = confirm('문의글을 삭제하시겠습니까?');
        if (c == true) {
            const deleteUrl = this.contextPath + '/qnaboard/delimpl?boardKey=' + boardKey;
            location.href = deleteUrl;
        }
    }
}
$(function () {
    order.init();
});