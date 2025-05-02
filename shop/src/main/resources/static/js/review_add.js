document.addEventListener("DOMContentLoaded", function () {
    const stars = document.querySelectorAll('.star-rating i');
    const ratingInput = document.getElementById('rating');
    const initialRating = parseInt(ratingInput.value) || 0;
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

const review_add = {
    contextPath: '',

    init: function () {
        this.contextPath = $('#review-add-data').data('context-path') || '';
        console.log("Review Add JS initialized. Context Path:", this.contextPath);

        $('#review_add_btn').click(() => {
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
        let c = confirm('후기를 등록하시겠습니까?');
        if (c == true) {
            this.send();
        }
    },

    send: function () {
        $('#review_add_form').attr('method', 'post');
        $('#review_add_form').attr('action', this.contextPath + '/review/addimpl');
        $('#review_add_form').submit();
    },
}
$(function () {
    review_add.init();
});