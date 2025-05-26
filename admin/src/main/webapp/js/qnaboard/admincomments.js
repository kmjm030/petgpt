const admincomments_detail = {
    update(id) {
        if (confirm('수정하시겠습니까?')) {
            location.href = '/board/detail?id=' + encodeURIComponent(id);
        }
    },
    delete(id, boardKey) {
        if (confirm('삭제하시겠습니까?')) {
            location.href = '/admincomments/delete?adcommentsKey=' + encodeURIComponent(id) + '&boardKey=' + encodeURIComponent(boardKey);
        }
    }
};
