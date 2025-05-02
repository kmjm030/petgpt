const mypage = {
    // 카카오 로그인 여부 확인 (custId가 'kakao_'로 시작하는지)
    isKakaoUser: 'false',
    contextPath: '',
    defaultProfileImg: '',

    init: function () {
        const mypageData = $('#mypage-data');
        this.isKakaoUser = mypageData.data('is-kakao-user') === true ? 'true' : 'false';
        this.contextPath = mypageData.data('context-path') || '';
        this.defaultProfileImg = mypageData.data('default-profile-img') || '';
        console.log("Mypage JS initialized. isKakaoUser:", this.isKakaoUser, "Context Path:", this.contextPath);

        $('#uploadFile').change(function (e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    $('#profile-img').attr('src', e.target.result);
                };
                reader.readAsDataURL(file);
            }
        });

        $('#cust_update_btn').click(() => {
            this.check();
        });
    },

    check: function () {
        let pwd = $('#pwd').val();
        let new_pwd = $('#new_pwd').val();
        let new_pwd2 = $('#new_pwd2').val();
        let nick = $('#nick').val();
        let phone = $('#phone').val();
        let email = $('#email').val();

        $('#msg').text('');

        // 카카오 로그인 사용자가 아닌 경우에만 비밀번호 관련 검사 수행
        if (this.isKakaoUser !== 'true') {
            if (pwd == '' || pwd == null) {
                $('#msg').text('수정을 위해서는 비밀번호를 입력해야 합니다.');
                $('#pwd').focus();
                return;
            }
            // 새 비밀번호 입력 필드가 하나라도 채워져 있으면 둘 다 검사
            if ((new_pwd && new_pwd.trim() !== '') || (new_pwd2 && new_pwd2.trim() !== '')) {
                if (!new_pwd || new_pwd.trim() === '') {
                    $('#msg').text('새 비밀번호를 입력해주세요.');
                    $('#new_pwd').focus();
                    return;
                }
                if (!new_pwd2 || new_pwd2.trim() === '') {
                    $('#msg').text('새 비밀번호를 확인해주세요.');
                    $('#new_pwd2').focus();
                    return;
                }
                if (new_pwd !== new_pwd2) {
                    $('#msg').text('새 비밀번호가 일치하지 않습니다.');
                    $('#new_pwd2').focus();
                    return;
                }
            }
        }

        if (nick == '' || nick == null) {
            $('#msg').text('닉네임을 입력하세요.');
            $('#nick').focus();
            return;
        }
        if (phone == '' || phone == null) {
            $('#msg').text('전화번호를 입력하세요.');
            $('#phone').focus();
            return;
        }
        if (email == '' || email == null) {
            $('#msg').text('이메일을 입력하세요.');
            $('#email').focus();
            return;
        }

        let c = confirm('회원정보를 수정하시겠습니까?');
        if (c == true) {
            this.send();
        }
    },

    imgDelete: function () {
        $('#imgDeleteFlag').val('true');
        $('#profile-img').attr('src', this.defaultProfileImg);
    },

    send: function () {
        $('#cust_update_form').attr('method', 'post');
        $('#cust_update_form').attr('action', this.contextPath + '/mypage/updateimpl');
        $('#cust_update_form').submit();
    },

}
$(function () {
    mypage.init();
});