const board_get = {
    update(id) {
        if (confirm('수정하시겠습니까?')) {
            location.href = `/qnaboard/detail?id=${encodeURIComponent(id)}`;
        }
    },
    delete(id) {
        if (confirm('삭제하시겠습니까?')) {
            location.href = `/qnaboard/delete?id=${encodeURIComponent(id)}`;
        }
    }
};
