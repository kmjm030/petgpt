const like = {
    contextPath: '',
    init: function () {
        this.contextPath = $('#coupon-data').data('context-path') || '';
        console.log("Coupon (like?) JS initialized. Context Path:", this.contextPath);
    },
    del: function (itemKey, custId) {
        console.log("Deleting Like with itemKey: " + itemKey + ", custId: " + custId);
        let c = confirm('상품을 찜목록에서 삭제하시겠습니까?');
        if (c == true) {
            const deleteUrl = this.contextPath + '/mypage/likedelimpl?itemKey=' + itemKey + '&id=' + custId;
            location.href = deleteUrl;
        }
    }
}
$(function () {
    like.init();
});