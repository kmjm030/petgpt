$(function () {
  $('.inquiry-toggle').click(function () {
    const $answer = $(this).next('.answer-content');
    const isVisible = $answer.is(':visible');

    $('.answer-content').slideUp();
    $('.toggle-icon').removeClass('bi-chevron-up').addClass('bi-chevron-down');

    if (!isVisible) {
      $answer.slideDown();
      $(this).find('.toggle-icon').removeClass('bi-chevron-down').addClass('bi-chevron-up');
    }
  });
});
