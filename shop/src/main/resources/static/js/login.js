const login = {
    init: function () {
        $('#pwd').on('keypress', function (e) {
            if (e.which === 13) { // Enter key pressed
                login.send();
            }
        });
        $('#id').on('keypress', function (e) {
            if (e.which === 13) { // Enter key pressed
                $('#pwd').focus();
            }
        });
    },

    send: function () {
        const form = $('#login_form');
        const actionUrl = form.data('action-url');

        if (!actionUrl) {
            console.error("Login form action URL not found!");
            alert("로그인 처리 중 오류가 발생했습니다. (URL 설정 오류)");
            return;
        }

        form.attr('method', 'post');
        form.attr('action', actionUrl);
        form.submit();
    },

    kakaoLogin: function () {
        const REST_API_KEY = '0404d3d84de08ad89ff1804757d2047a';
        const REDIRECT_URI = 'http://localhost/auth/kakao/callback';
        const kakaoAuthUrl = 'https://kauth.kakao.com/oauth/authorize?client_id=' + REST_API_KEY + '&redirect_uri=' + REDIRECT_URI + '&response_type=code';
        window.location.href = kakaoAuthUrl;
    }
}
$(function () {
    if ($('#login_form').length > 0) {
        login.init();
    }
})