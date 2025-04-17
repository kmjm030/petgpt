
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script>
    let board_get = {
        init:function(){},
        update:function(id){
            let c = confirm('수정하시겠습니까?');
            if(c == true){
                location.href = '<c:url value="/qnaboard/detail"/>?id='+id;
            }
        },
        delete:function(id){
            let c = confirm('삭제하시겠습니까?');
            if(c == true){
                location.href = '<c:url value="/qnaboard/delete"/>?id='+id;
            }
        }
    };
    $(function(){
        board_get.init();
    });
</script>
<div class="container-fluid">

    <!-- Page Heading -->

    <!-- DataTales Example -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <h2> QNABoard 상품 문의게시판 </h2>
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                    <tr>
                        <th>board.boardKey</th>
                        <th>board.boardRe</th>
                        <th>board.itemKey</th>
                        <th>board.custId</th>
                        <th>board.orderKey</th>
                        <th>board.boardTitle</th>
                        <th>board.boardRdate</th>
                        <th>board.Content</th>
                        <th>board.boardImg</th>
                        <th>board.boardOption</th>
                        <th>board.boardUpdate</th>

                        <th>수정</th>
                        <th>삭제</th>
                    </tr>
                    </thead>
                    <tfoot>
                    <tr>
                        <th>board.boardKey</th>
                        <th>board.itemKey</th>
                        <th>board.custId</th>
                        <th>board.orderKey</th>
                        <th>board.boardTitle</th>
                        <th>board.boardRdate</th>
                        <th>board.Content</th>
                        <th>board.boardImg</th>
                        <th>board.boardOption</th>
                        <th>board.boardUpdate</th>
                        <th>board.boardRe</th>
                        <th>수정</th>
                        <th>삭제</th>
                    </tr>
                    </tfoot>
                    <tbody>
                    <c:forEach var="board" items="${boards}">
                        <tr>
                            <td><a href="<c:url value="/qnaboard/detail"/>?id=${board.boardKey}">${board.boardKey}</a></td>
                            <td>${board.boardRe}</td>
                            <td>${board.itemKey}</td>
                            <td>${board.custId}</td>
                            <td>${board.orderKey}</td>
                            <td>${board.boardTitle}</td>
                            <td>${board.boardRdate}</td>
                            <td>${board.boardContent}</td>
                            <td>${board.boardImg}</td>
                            <td>${board.boardOption}</td>
                            <td>${board.boardUpdate}</td>

                            <td>
                                <button onclick="board_get.update('${board.boardKey}')" type="button" class="btn btn-secondary">수정</button>
                            </td>
                            <td>
                                <button onclick="board_get.delete('${board.boardKey}')" type="button" class="btn btn-secondary">삭제</button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>


