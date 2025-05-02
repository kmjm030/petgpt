const address = {
    contextPath: '',
    init: function () {
        this.contextPath = $('#address-data').data('context-path') || '';
        console.log("Address JS initialized. Context Path:", this.contextPath);
    },
    del: function (addrKey) {
        console.log("Deleting address with addrKey: " + addrKey);
        let c = confirm('배송지를 삭제 하시겠습니까 ?');
        if (c == true) {
            location.href = this.contextPath + '/address/delimpl?addrKey=' + addrKey;
        }
    }
}
$(function () {
    address.init();
});