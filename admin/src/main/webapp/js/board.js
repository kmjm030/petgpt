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

document.addEventListener('DOMContentLoaded', function () {
    const detailForm = document.getElementById('detail_form');
    const btnUpdate = document.getElementById('btn_update');
    const btnDelete = document.getElementById('btn_delete');

    if (btnUpdate) {
        btnUpdate.addEventListener('click', function () {
            detailForm.setAttribute('method', 'post');
            detailForm.setAttribute('action', '/board/update');
            detailForm.submit();
        });
    }

    if (btnDelete) {
        btnDelete.addEventListener('click', function () {
            const id = document.getElementById('id').value;
            if (confirm('삭제하시겠습니까?')) {
                window.location.href = `/board/delete?id=${encodeURIComponent(id)}`;
            }
        });
    }
});

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