$(function () {
  const today = new Date().toISOString().slice(0, 10);
  $('#regDate').val(today);

  $('#btn_add').click(function () {
    $('#errorMsg').hide();
    const requiredFields = [
      'select[name="categoryKey"]',
      'input[name="itemName"]',
      'input[name="itemPrice"]',
      'select[name="size"]',
      'input[name="color"]',
      'input[name="additionalPrice"]',
      'input[name="stock"]'
    ];
    for (const field of requiredFields) {
      if (!$(field).val()?.trim()) {
        $('#errorMsg').show();
        return;
      }
    }

    Swal.fire({
      title: '상품을 등록하시겠습니까?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: '등록',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
          url: '/item/addimpl',
          type: 'POST',
          data: new FormData($('#item_add_form')[0]),
          processData: false,
          contentType: false,
          success: function () {
            Swal.fire({
              title: '등록 완료!',
              text: '상품이 성공적으로 등록되었습니다.',
              icon: 'success'
            }).then(() => {
              window.location.href = '/item/get';
            });
          },
          error: function () {
            Swal.fire({
              title: '오류',
              text: '상품 등록 중 문제가 발생했습니다.',
              icon: 'error'
            });
          }
        });
      }
    });
  });

  $('#btn_reset').click(function () {
    $('#item_add_form')[0].reset();
    $('#regDate').val(today);
    $('#errorMsg').hide();
  });
});
