const review = {
    contextPath: '',

    init: function () {
        this.contextPath = $('#review-data').data('context-path') || '';
        console.log("Review List JS initialized. Context Path:", this.contextPath);
    },

    del: function (boardKey) {
        console.log("Deleting review with key:", boardKey);
        let c = confirm('리뷰를 삭제 하시겠습니까 ?');
        if (c == true) {
            // contextPath 사용
            location.href = this.contextPath + '/review/delimpl?boardKey=' + boardKey;
        }
    }
}

$(function () {
    review.init();
});