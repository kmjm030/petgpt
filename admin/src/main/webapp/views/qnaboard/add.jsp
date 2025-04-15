
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
    let board_add = {
        init:function(){

            $('#board_form > #btn_add').click(()=>{

                let c = confirm('등록하기겠습니까?');
                if(c == true){
                   this.send();
                }
            });
        },
        send:function(){
            $('#board_form').attr({
                'method':'post',
                'action':'<c:url value="/board/addimpl"/>'
            });
            $('#board_form').submit();
        }
    };
    $(function(){
        board_add.init();
    });
</script>



<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Tables</h1>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <form id="board_form">
                    <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text"  class="form-control" id="title" placeholder="Enter title" name="boardTitle">

                    </div>
                    <div class="form-group">
                        <label for="content">Content:</label>
                        <textarea name="boardContent" class="form-control" rows="5" id="content"></textarea>

                    </div>
                    <input type="hidden" name="boardAuthor" value="${sessionScope.admin}"/>
                    <button id="btn_add" type="button" class="btn btn-primary">Add</button>

                </form>
            </div>
        </div>
    </div>

</div>


