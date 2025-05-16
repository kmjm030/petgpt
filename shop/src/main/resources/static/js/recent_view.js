const recent_view = {
    ontextPath: '',
    init: function () {
        this.contextPath = $('#like-data').data('context-path') || '';
        console.log("Like JS initialized. Context Path:", this.contextPath);
    },
    del: function (viewKey) {
        let c = confirm('최근 본 상품에서 삭제하시겠습니까?');
        if (c == true) {
            const deleteUrl = this.contextPath + '/mypage/viewdelimpl?viewKey=' + viewKey;
            location.href = deleteUrl;
        }
    }
}
$(function () {
    recent_view.init();
});