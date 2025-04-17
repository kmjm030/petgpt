
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
                let c = confirm('삭제하시겠습니까?');
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
    <h1 class="h3 mb-2 text-gray-800">문의글 상세보기 detail </h1>

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">문의글 보기 - ${board.boardRe}</h6>
        </div>
        <%----------------------start of--------- class="card-body" ----------------------------------------%>
        <div style="border: 10px" class="card-body">
            <div class="table-responsive">
                <form id="detail_form">
                    <div class="form-group">
                        <label for="id">Board Key :</label>
                        <input type="text"  readonly="readonly" value="${board.boardKey}" class="form-control" id="id" placeholder="${board.boardKey}" name="boardKey">

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
                        <label >상품이미지</label>
                        <img src="<c:url value='/img/item/${item.itemImg1}'/>" width="300" style="border-radius: 10%"><br>
                    </div>
                    <div class="form-group">
                        <label for="hit">Option:</label>
                        <p id="hit">${board.boardOption}</p>
                    </div>
                    <div class="form-group">
                        <label for="rdate">Register Date:</label>
                        <p id="rdate">  <fmt:formatDate  value="${board.boardRdate}" pattern="yyyy-MM-dd : HH:mm:ss" /></p>
                    </div>
                    <div class="form-group">
                        <label for="udate">Update Date:</label>
                        <p id="udate"> <fmt:formatDate  value="${board.boardUpdate}" pattern="yyyy-MM-dd : HH:mm:ss" /></p>
                    </div>
                    <button id="btn_update" type="button" class="btn btn-primary">Update</button>
                    <button id="btn_delete" type="button" class="btn btn-primary">Delete</button>

                </form>
            </div>
        </div>
<%----------------------end of--------- class="card-body" ----------------------------------------%>

        <%--        관리자 댓글 존재 여부 확인--%>
        <c:choose>
            <c:when test="${adminComments == null}">
                <jsp:include page="addAdminComments.jsp"></jsp:include>
            </c:when>
            <%--         관리자 댓글 --%>
            <c:otherwise>
                <jsp:include page="adminComments.jsp"></jsp:include>
            </c:otherwise>
        </c:choose>













    </div>
<%--    End of class="card shadow mb-4">--------------------------------------%>
</div>
<%---------------   End of class="container-fluid  --------------------------%>



