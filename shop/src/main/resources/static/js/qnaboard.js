const qna_board = {
    contextPath: '',
    init: function () {
        this.contextPath = $('#qna-data').data('context-path') || '';
        console.log("QnA Board JS initialized. Context Path:", this.contextPath);
    },
    del: function (boardKey) {
        console.log("Deleting QnA board with key:", boardKey);
        let c = confirm('문의글을 삭제하시겠습니까?');
        if (c == true) {
            location.href = this.contextPath + '/qnaboard/delimpl?boardKey=' + boardKey;
        }
    }
}
$(function () {
    qna_board.init();
});