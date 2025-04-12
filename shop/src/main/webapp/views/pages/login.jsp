
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #msg{
        color: darkred;
    }
</style>
<script>
    const login = {
        init:function(){

        },
        send:function(){
            $('#login_form').attr('method','post');
            $('#login_form').attr('action','<c:url value="/loginimpl"/>');
            $('#login_form').submit();
        },
    }
    $(function(){
        login.init();
    })
</script>

<!-- Breadcrumb Section Begin -->
<section class="breadcrumb-option">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb__text">
                    <h4>Log In</h4>
                    <div class="breadcrumb__links">
                        <a href="<c:url value='/'/>">Home</a>
                        <span>Log in</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Breadcrumb Section End -->



<!-- Checkout Section Begin -->
<section class="checkout spad">
    <div class="container">
        <div class="checkout__form">
            <div class="row">
                <div class="col-lg-6">
                    <form id="login_form">
                        <div class="form-group">
                            <div class="checkout__input">
                                <label for="id">ID</label>
                                <input type="text" placeholder="아이디를 입력하세요." id="id" name="id">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="checkout__input">
                                <label for="pwd">비밀번호</label>
                                <input type="password" placeholder="비밀번호를 입력하세요." id="pwd" name="pwd">
                            </div>
                        </div>
                    </form>
                    <c:choose>
                        <c:when test="${msg != null}">
                            <h6 id="msg">${msg}</h6>
                            <br/><br/>
                        </c:when>
                        <c:otherwise>
                            <h6></h6>
                        </c:otherwise>
                    </c:choose>

                    <button class="site-btn" id="login_btn" onclick="login.send()">로그인</button>


                </div>
            </div>
        </div>
   </div>
</section>
