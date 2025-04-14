
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
    let cust_detail = {
        init:function(){
            $('#detail_form > #btn_update').click(()=>{
                this.send();
            });
            $('#detail_form > #btn_delete').click(()=>{
                let c = confirm('삭제하시겠습니까?');
                if(c == true){
                    let id = $('#id').val();
                    location.href = '<c:url value="/cust/delete"/>?=id'+id;
                }
            });
            $('#detail_form > #btn_showlist').click(()=>{
               location.href = '<c:url value="/cust/get"/>';
            });
        },
        send:function(){
            $('#detail_form').attr({
                'method':'post',
                'action':'<c:url value="/cust/update"/>'
            });
            $('#detail_form').submit();
        }
    };
    $(function(){
        cust_detail.init();
    });
</script>

<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">${cust.custName}님, 회원정보 수정!!!!!! </h1>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">${cust.custName}님, 회원정보 수정!!!!!!</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <form id="detail_form">
                    <div class="form-group">
                        <label for="id">ID:</label>
                        <input type="text"  readonly="readonly" value="${cust.custId}" class="form-control" id="id" placeholder="Enter id" name="custId">
                    </div>
                    <div class="form-group">
                        <label for="pwd">Password:</label>
                        <input type="password"  value="${cust.custPwd}"  class="form-control" id="pwd" placeholder="Enter password" name="custPwd">
                    </div>
                    <div class="form-group">
                        <label for="name">Name:</label>
                        <input type="text" value="${cust.custName}"  class="form-control" id="name" placeholder="Enter name" name="custName">
                    </div>
                    <div class="form-group">
                        <label for="name">Email:</label>
                        <input type="text" value="${cust.custEmail}"  class="form-control" id="email" placeholder="Enter email" name="custEmail">
                    </div>
                    <div class="form-group">
                        <label for="name">Phone:</label>
                        <input type="text" value="${cust.custPhone}"  class="form-control" id="phone" placeholder="Enter Phone" name="custPhone">
                    </div>
                    <div class="form-group">
                        <label for="name">Point:</label>
                        <input type="text" value="${cust.custPoint}"  class="form-control" id="point" placeholder="Enter Point" name="custPoint">
                    </div>
                    <div class="form-group">
                        <label for="name">Nick:</label>
                        <input type="text" value="${cust.custNick}"  class="form-control" id="nick" placeholder="Enter email" name="custNick">
                    </div>
                    <div class="form-group">
                        <label for="name">point charge:</label>
                        <input type="text" value="${cust.pointCharge}"  class="form-control" id="pointcharge" placeholder="Enter PointCharge" name="pointCharge">
                    </div>
                    <div class="form-group">
                        <label for="name">point Reason:</label>
                        <input type="text" value="${cust.pointReason}"  class="form-control" id="pointreason" placeholder="Enter PointReason" name="pointReason">
                    </div>

                    <button id="btn_update" type="button" class="btn btn-secondary">수정</button>
                    <button id="btn_delete" type="button" class="btn btn-secondary">삭제</button>
                    <button id="btn_showlist" type="button" class="btn btn-secondary">목록보기</button>

                </form>
            </div>
        </div>
    </div>

</div>


