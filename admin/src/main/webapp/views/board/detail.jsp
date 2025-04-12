
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
    let board_detail = {
        init:function(){
            $('#detail_form > #btn_update').click(()=>{
                this.send();
            });
            $('#detail_form > #btn_delete').click(()=>{
                let c = confirm('삭제하기겠습니까?');
                if(c == true){
                    let id = $('#id').val();
                    location.href = '<c:url value="/board/delete"/>?=id'+id;
                }
            });
        },
        send:function(){
            $('#detail_form').attr({
                'method':'post',
                'action':'<c:url value="/board/update"/>'
            });
            $('#detail_form').submit();
        }
    };
    $(function(){
        board_detail.init();
    });
</script>



<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2 text-gray-800">Tables</h1>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Board</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <form id="detail_form">
                    <div class="form-group">
                        <label for="id">ID:</label>
                        <input type="text"  readonly="readonly" value="${board.boardId}" class="form-control" id="id" placeholder="Enter id" name="boardId">

                    </div>
                    <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text"  value="${board.boardTitle}"  class="form-control" id="title" placeholder="Enter title" name="boardTitle">

                    </div>
                    <div class="form-group">
                        <label for="content">Content:</label>
                        <textarea name="boardContent" class="form-control" rows="5" id="content">${board.boardContent}</textarea>

                    </div>
                    <div class="form-group">
                        <label for="hit">Hit:</label>
                        <p id="hit">${board.boardHit}</p>
                    </div>
                    <div class="form-group">
                        <label for="rdate">Register Date:</label>
                        <p id="rdate"><fmt:formatDate  value="${board.boardRdate}" pattern="yyyy-MM-dd : HH:mm:ss" /></p>
                    </div>
                    <div class="form-group">
                        <label for="udate">Update Date:</label>
                        <p id="udate"><fmt:formatDate  value="${board.boardUdate}" pattern="yyyy-MM-dd : HH:mm:ss" /></p>
                    </div>
                    <button id="btn_update" type="button" class="btn btn-primary">Update</button>
                    <button id="btn_delete" type="button" class="btn btn-primary">Delete</button>

                </form>
            </div>
        </div>
    </div>

</div>


