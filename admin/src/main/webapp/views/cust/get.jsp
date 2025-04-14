
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<style>--%>
<%--    #dataTable img {--%>
<%--        width: 100px !important;--%>
<%--    }--%>
<%--</style>--%>
<script>
    let cust_get = {
        init:function(){},
        update:function(id){
            let c = confirm('수정하시겠습니까?');
            if(c == true){
                location.href = '<c:url value="/cust/detail"/>?id='+id;
            }
        },
        delete:function(id){
            let c = confirm('삭제하시겠습니까?');
            if(c == true){
                location.href = '<c:url value="/cust/delete"/>?id='+id;
            }
        }
    };
    $(function(){
        cust_get.init();
    });
</script>
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Tables</h1>
    <p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below.
        For more information about DataTables, please visit the <a target="_blank"
                                                                   href="https://datatables.net">official DataTables documentation</a>.</p>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <h2>관리자는 customer의 모든 것을 알고있다!!!! 일단 모든컬럼 뿌립니다!</h2>
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>PWD</th>
                        <th>NAME</th>
                        <th>EMAIL</th>
                        <th>PHONE</th>
                        <th>가입일</th>
                        <th>보유포인트</th>
                        <th>별명</th>
                        <th>포인트적립량</th>
                        <th>포인트적립사유</th>
                        <th>수정</th>
                        <th>삭제</th>
                    </tr>
                    </thead>
                    <tfoot>
                    <tr>
                        <th>Cust_id</th>
                        <th>cust_pwd</th>
                        <th>cust_name</th>
                        <th>cust_email</th>
                        <th>cust_phone</th>
                        <th>c.custRdate</th>
                        <th>c.custPoint</th>
                        <th>c.custNick</th>
                        <th>c.pointCharge</th>
                        <th>c.pointReason</th>
                        <th>수정</th>
                        <th>삭제</th>
                    </tr>
                    </tfoot>
                    <tbody>
                    <c:forEach var="c" items="${custs}">
                        <tr>
                            <td><a href="<c:url value="/cust/detail"/>?id=${c.custId}">${c.custId}</a></td>
                            <td>${c.custPwd}</td>
                            <td>${c.custName}</td>
                            <td>${c.custEmail}</td>
                            <td>${c.custPhone}</td>
                            <td>${c.custRdate}</td>
                            <td>${c.custPoint}</td>
                            <td>${c.custNick}</td>
                            <td>${c.pointCharge}</td>
                            <td>${c.pointReason}</td>
                            <td>
                                <button onclick="cust_get.update('${c.custId}')" type="button" class="btn btn-secondary">수정</button>
                            </td>
                            <td>
                                <button onclick="cust_get.delete('${c.custId}')" type="button" class="btn btn-secondary">삭제</button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>


