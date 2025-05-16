document.addEventListener('DOMContentLoaded', () => {
    // 1. 좋아요 버튼 토글 (하트 채우기/비우기)
    const likeButtons = document.querySelectorAll('.post-actions button:first-child');
    likeButtons.forEach(button => {
        button.addEventListener('click', () => {
            const icon = button.querySelector('i');
            icon.classList.toggle('far'); // 빈 하트
            icon.classList.toggle('fas'); // 꽉 찬 하트
            icon.classList.toggle('active-like'); // 색상 변경용 클래스 (CSS에서 정의)

            // 실제 좋아요 수 업데이트는 서버 연동 필요 (여기서는 시뮬레이션)
            const postElement = button.closest('.post');
            const likesCountElement = postElement.querySelector('.like-count');
            let currentLikes = parseInt(likesCountElement.textContent.replace(/,/g, ''));
            if (icon.classList.contains('fas')) {
                currentLikes++;
            } else {
                currentLikes--;
            }
            likesCountElement.textContent = currentLikes.toLocaleString();
        });
    });

    // 2. 댓글 입력창 활성화 (글자 입력 시 '게시' 버튼 활성화)
    const commentInputs = document.querySelectorAll('.add-comment input');
    commentInputs.forEach(input => {
        const postButton = input.nextElementSibling; // '게시' 버튼
        if (postButton) { // 게시 버튼이 있을 경우에만
            input.addEventListener('input', () => {
                if (input.value.trim() !== '') {
                    postButton.style.opacity = '1';
                    postButton.style.cursor = 'pointer';
                } else {
                    postButton.style.opacity = '0.3';
                    postButton.style.cursor = 'default';
                }
            });
        }
    });

    // 3. 더 많은 기능들... (예: 스토리 클릭 시 모달, 댓글 더 보기 등)
});

// CSS에 좋아요 활성화 시 색상 추가
/*
.active-like {
    color: red !important;
}
*/