$(function () {
  $('#btn_delete').click(() => {
    const key = $('#itemKey').val();
    Swal.fire({
      title: '정말로 이 상품을 삭제하시겠습니까?',
      text: '삭제된 상품은 복구할 수 없습니다.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: '삭제',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
          url: `/item/del?item_key=${key}`,
          type: 'POST',
          success: function () {
            Swal.fire({
              title: '삭제 완료!',
              text: '상품이 성공적으로 삭제되었습니다.',
              icon: 'success'
            }).then(() => {
              window.location.href = '/item/get';
            });
          },
          error: function () {
            Swal.fire({
              title: '오류',
              text: '상품 삭제 중 문제가 발생했습니다.',
              icon: 'error'
            });
          }
        });
      }
    });
  });

  $('#btn_update').click(() => {
    const $form = $('#item_update_form');
    if ($form.length === 0) {
      Swal.fire({
        icon: 'error',
        title: '폼 오류',
        text: '업데이트 폼이 페이지에서 발견되지 않았습니다.'
      });
      return;
    }

    Swal.fire({
      title: '이 상품 정보를 수정하시겠습니까?',
      icon: 'question',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#aaa',
      confirmButtonText: '수정',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
          url: '/item/update',
          type: 'POST',
          data: new FormData($form[0]),
          processData: false,
          contentType: false,
          success: function () {
            Swal.fire({
              title: '수정 완료!',
              text: '상품 정보가 성공적으로 수정되었습니다.',
              icon: 'success'
            }).then(() => {
              window.location.href = `/item/detail?item_key=${$('#itemKey').val()}`;
            });
          },
          error: function () {
            Swal.fire({
              title: '오류',
              text: '상품 수정 중 문제가 발생했습니다.',
              icon: 'error'
            });
          }
        });
      }
    });
  });
});
