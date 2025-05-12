const cust_get = {
    update: function (id) {
        if (confirm('수정하시겠습니까?')) {
            location.href = '/cust/detail?id=' + encodeURIComponent(id);
        }
    },
    delete: function (id) {
        if (confirm('삭제하시겠습니까?')) {
            location.href = '/cust/delete?id=' + encodeURIComponent(id);
        }
    }
};

