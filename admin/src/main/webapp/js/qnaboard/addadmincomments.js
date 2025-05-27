document.addEventListener('DOMContentLoaded', () => {
    const toggleBtn = document.getElementById('toggleCommentFormBtn');
    const formWrapper = document.getElementById('admin-comment-form-wrapper');
    const submitBtn = document.getElementById('submitCommentBtn');

    if (toggleBtn && formWrapper) {
        toggleBtn.addEventListener('click', () => {
            $(formWrapper).slideToggle(200); // jQuery 효과 유지
        });
    }

    if (submitBtn) {
        submitBtn.addEventListener('click', () => {
            const formData = $('#adminCommentForm').serialize();

            $.ajax({
                type: 'POST',
                url: '/admincomments/addimpl',
                data: formData,
                success: () => {
                    alert('댓글이 등록되었습니다.');
                    location.reload();
                },
                error: (xhr) => {
                    alert('등록 실패: ' + xhr.responseText);
                }
            });
        });
    }
});
