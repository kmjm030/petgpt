const qna_add = {
    contextPath: '',

    init: function () {
        this.contextPath = $('#qna-add-data').data('context-path') || '';
        console.log("QnA Add JS initialized. Context Path:", this.contextPath);

        // Select2 초기화
        $('#itemSelect').addClass('select2');
        $('#itemSelect').select2({
            placeholder: "상품을 선택하세요",
            allowClear: true,
            minimumResultsForSearch: 0
        });

        // niceSelect는 select2 제외하고 적용
        $('select').not('.select2, #orderSelect').niceSelect();

        // 초기상태가 '상품문의'이면 select2보이도록
        if ($('#optionSelect').val() === '상품문의') {
            $('#itemSelectWrapper').show();
        }

        // 문의 종류 변경 이벤트
        $('#optionSelect').on('change', function () {
            const selectedOption = $(this).val();

            if (selectedOption === '상품문의') {
                $('#itemSelectWrapper').show();
            } else {
                $('#itemSelectWrapper').hide();
                $('#itemSelect').val(null).trigger('change'); // 아이템 선택값 초기화
            }
            if (['배송문의', '교환/환불문의'].includes(selectedOption)) {
                $('#orderSelectWrapper').show();
                $('#orderSelect').select2({
                    placeholder: "문의하실 주문건을 선택하세요",
                    allowClear: true
                });
            } else {
                $('#orderSelectWrapper').hide();
                $('#orderSelect').val(null).trigger('change');
            }
        });

        $('#qna_add_btn').click(() => {
            this.check();
        });
    },
    check: function () {
        let title = $('#boardTitle').val();
        let content = $('#boardContent').val();
        let option = $('#optionSelect').val();
        let item = $('#itemSelect').val();

        if (title == '' || title == null) {
            $('#msg').text('제목을 입력하세요.');
            $('#boardTitle').focus();
            return;
        }
        if (content == '' || content == null) {
            $('#msg').text('문의 내용을 입력하세요');
            $('#boardContent').focus();
            return;
        }
        if (option == '상품문의') {
            if (item == '' || item == null) {
                $('#msg').text('문의하실 상품을 선택하세요.');
                $('#itemSelect').focus();
                return;
            }
        }
        let c = confirm('문의글을 등록하시겠습니까?');
        if (c == true) {
            this.send();
        }
    },
    send: function () {
        $('#qna_add_form').attr('method', 'post');
        $('#qna_add_form').attr('action', this.contextPath + '/qnaboard/addimpl');
        $('#qna_add_form').submit();
    },
}
$(function () {
    qna_add.init();
});