const register = {
    init: function () {
        $('#register_btn').click(() => {
            console.log("Register button clicked.");
            this.check();
        });
        $('#id').keyup(() => {
            let id = $('#id').val();
            if (id.length >= 2) {
                $('#id_msg').text(id);
                this.checkId(id);
            }
        });
        $('#nick').keyup(() => {
            let nick = $('#nick').val();
            if (nick.length >= 2) {
                $('#nick_msg').text(nick);
                this.checkNick(nick);
            }
        });
    },
    check: function () {
        let id = $('#id').val();
        let pwd = $('#pwd').val();
        let pwd2 = $('#pwd2').val();
        let name = $('#name').val();
        let nick = $('#nick').val();
        let phone = $('#phone').val();
        let email = $('#email').val();
        let address = $('#sample6_detailAddress').val();

        console.log('ID: %s, PWD: %s, NAME: %s', id, pwd, name);
        if (id == '' || id == null) {
            $('#msg').text('ID를 입력하세요.');
            $('#id').focus();
            return;
        }
        if (pwd == '' || pwd == null) {
            $('#msg').text('비밀번호를 입력하세요.');
            $('#pwd').focus();
            return;
        }
        if (name == '' || name == null) {
            $('#msg').text('이름을 입력하세요.');
            $('#name').focus();
            return;
        }
        if (pwd2 == '' || pwd2 == null) {
            $('#msg').text('비밀번호를 확인해주세요.');
            $('#pwd2').focus();
            return;
        }
        if (pwd != pwd2) {
            $('#msg').text('패스워드가 틀립니다.다시 입력하세요');
            $('#pwd2').focus();
            return;
        }
        if (phone == '' || phone == null) {
            $('#msg').text('전화번호를 입력하세요');
            $('#phone').focus();
            return;
        }
        if (email == '' || email == null) {
            $('#msg').text('이메일을 입력하세요');
            $('#email').focus();
            return;
        }
        if (address == '' || address == null) {
            $('#msg').text('기본 배송지를 입력하세요');
            $('#sample6_detailAddress').focus();
            return;
        }
        let c = confirm('회원가입 하시겠습니까?');
        if (c == true) {

            this.send();
        }
    },
    checkId: function (id) {
        $.ajax({
            url: contextPath + '/checkid',
            data: { cid: id },
            success: (result) => {
                //alert(result);
                if (result == 1) {
                    $('#id_msg').text('사용 가능한 아이디입니다.');
                    $('#id').off('blur');
                } else {
                    $('#id_msg').text('이미 존재하는 아이디입니다.');
                    $('#id').blur(() => {
                        $('#id').focus();
                    });
                }
            },
            error: () => { }
        });
    },
    checkNick: function (nick) {
        $.ajax({
            url: contextPath + '/checknick',
            data: { nick: nick },
            success: (result) => {
                //alert(result);
                if (result == 1) {
                    $('#nick_msg').text('사용 가능한 닉네임입니다.');
                    $('#nick').off('blur');
                } else {
                    $('#nick_msg').text('이미 존재하는 닉네임입니다.');
                    $('#id').blur(() => {
                        $('#nick').focus();
                    });
                }
            },
            error: () => { }
        });
    },
    send: function () {
        $('#register_form').attr('method', 'post');
        $('#register_form').attr('action', contextPath + '/goregister');
        $('#register_form').submit();
    }
}
$(function () {
    register.init();
});