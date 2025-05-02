document.addEventListener("DOMContentLoaded", function () {
    const stars = document.querySelectorAll('.star-rating i');
    const ratingInput = document.getElementById('rating');

    const initialRating = parseInt(ratingInput.value);
    stars.forEach((s, i) => {
        if (i < initialRating) {
            s.classList.remove('bi-star');
            s.classList.add('bi-star-fill');
            s.classList.add('text-warning');
        } else {
            s.classList.remove('bi-star-fill');
            s.classList.add('bi-star');
            s.classList.remove('text-warning');
        }
    });

    stars.forEach((star, idx) => {
        star.addEventListener('click', () => {
            const rating = parseInt(star.getAttribute('data-value'));
            ratingInput.value = rating;

            stars.forEach((s, i) => {
                if (i < rating) {
                    s.classList.remove('bi-star');
                    s.classList.add('bi-star-fill');
                    s.classList.add('text-warning');
                } else {
                    s.classList.remove('bi-star-fill');
                    s.classList.add('bi-star');
                    s.classList.remove('text-warning');
                }
            });
        });
    });
});

const review_detail = {
    contextPath: '',

    init: function () {
        this.contextPath = $('#review-detail-data').data('context-path') || '';
        console.log("Review Detail JS initialized. Context Path:", this.contextPath);

        $('#review_update_btn').click(() => {
            this.check();
        });
    },

    check: function () {
        let content = $('#boardContent').val();
        let score = $('#rating').val();

        $('#msg').text('');

        if (content == '' || content == null) {
            $('#msg').text('리뷰를 작성해주세요.');
            $('#boardContent').focus();
            return;
        }
        if (score == null || score == 0) {
            $('#msg').text('별점을 선택해주세요.');
            return;
        }
        let c = confirm('후기를 수정하시겠습니까?');
        if (c == true) {
            this.send();
        }
    },

    send: function () {
        $('#review_update_form').attr('method', 'post');
        $('#review_update_form').attr('action', this.contextPath + '/review/updateimpl');
        $('#review_update_form').submit();
    },
}

$(function () {
    review_detail.init();
});