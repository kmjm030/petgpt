const qnaboard_detail = {
    contextPath: '',

    init: function () {
        this.contextPath = $('#qna-detail-data').data('context-path') || '';
        console.log("QnA Detail JS initialized. Context Path:", this.contextPath);

        $('#qna_update_btn').click(() => {
            this.check();
        });
    },

    check: function () {
        let title = $('#boardTitle').val();
        let content = $('#boardContent').val();

        if (title == '' || title == null) {
            $('#msg').text('제목을 입력하세요.');
            $('#boardTitle').focus();
            return;
        }
        if (content == '' || content == null) {
            $('#msg').text('문의 내용을 작성하세요.');
            $('#boardContent').focus();
            return;
        }
        let c = confirm('문의글을 수정하시겠습니까?');
        if (c == true) {
            this.send();
        }
    },

    send: function () {
        $('#qna_update_form').attr('method', 'post');
        $('#qna_update_form').attr('action', this.contextPath + '/qnaboard/updateimpl');
        $('#qna_update_form').submit();
    },
}
$(function () {
    qnaboard_detail.init();
});