
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
            <h6 class="m-0 font-weight-bold text-primary">문의글 보기</h6>
        </div>
        <div class="card-body">
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

        <%--        관리자 댓글 존재 여부 확인--%>
        <c:choose>
            <c:when test="${adminComments == null}">
                <h1><a href="#" data-toggle="modal" data-target="#loginModal">관리자 댓글 쓰기</a></h1>
            </c:when>


            <%--        관리자 댓글 존재 여부 확인끝--%>

            <%--         관리자 댓글 --%>
            <c:otherwise>
                <div class="card-body">
                    <div class="table-responsive">
                        <h2> 관리자 댓글</h2>
                        <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>게시판글번호</th>
                                <th>adcommentsKey</th>
                                <th>boardKey</th>
                                <th>adminId</th>
                                <th>adcommentsContent</th>
                                <th>adcommentsRdate</th>
                                <th>adcommentsUpdate</th>
                                <th>수정</th>
                                <th>삭제</th>
                            </tr>
                            </thead>
                                <%--                    <tfoot>--%>
                                <%--                    <tr>--%>
                                <%--                        <th>게시판글번호</th>--%>
                                <%--                        <th>adminComments.adcommentsKey</th>--%>
                                <%--                        <th>adminComments.boardKey</th>--%>
                                <%--                        <th>adminComments.adminId</th>--%>
                                <%--                        <th>adminComments.adcommentsContent</th>--%>
                                <%--                        <th>adminComments.adcommentsRdate</th>--%>
                                <%--                        <th>adminComments.adcommentsUpdate</th>--%>
                                <%--                        <th>${adminComments}</th>--%>
                                <%--                        <th>삭제</th>--%>
                                <%--                    </tr>--%>
                                <%--                    </tfoot>--%>
                            <tbody>
                                <%--                    <c:forEach var="a" items="${adminComments}">--%>
                            <tr>
                                <td><a href="<c:url value="/board/detail"/>?id=${a.boardKey}">${board.boardKey}</a></td>
                                <td>${adminComments.adcommentsKey}</td>
                                <td>${adminComments.boardKey}</td>
                                <td>${adminComments.adminId}</td>
                                <td>${adminComments.adcommentsContent}</td>
                                <td>${adminComments.adcommentsRdate}</td>
                                <td>${adminComments.adcommentsUpdate}</td>

                                <td>
                                    <button onclick="board_get.update('${board.boardKey}')" type="button" class="btn btn-secondary">수정</button>
                                </td>
                                <td>
                                    <button onclick="board_get.delete('${board.boardKey}')" type="button" class="btn btn-secondary">삭제</button>
                                </td>
                            </tr>
                                <%--                    </c:forEach>--%>
                            </tbody>
                            </tbody>
                        </table>
                    </div>
                </div>

                <%--         관리자댓글 끝--%>
                관련아이템 :  <h1>${item.itemName}</h1>h1>
            </c:otherwise>
        </c:choose>
    </div>

</div>


<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">관련상품 상세 보기</h1>

    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <form id="item_update_form">

                    <div class="form-group">
                        <label>상품 번호</label>
                        <input type="text" readonly class="form-control" id="itemKey" name="itemKey" value="${item.itemKey}">
                    </div>

                    <div class="form-group">
                        <label>카테고리 번호</label>
                        <input type="number" class="form-control" name="categoryKey" value="${item.categoryKey}">
                    </div>

                    <div class="form-group">
                        <label>상품명</label>
                        <input type="text" class="form-control" name="itemName" value="${item.itemName}">
                    </div>

                    <div class="form-group">
                        <label>상품 설명</label>
                        <textarea class="form-control" name="itemContent" rows="4">${item.itemContent}</textarea>
                    </div>

                    <div class="form-group">
                        <label>정가</label>
                        <input type="number" class="form-control" name="itemPrice" value="${item.itemPrice}">
                    </div>

                    <div class="form-group">
                        <label>할인가</label>
                        <input type="number" class="form-control" name="itemSprice" value="${item.itemSprice}">
                    </div>

                    <div class="form-group">
                        <label>재고 수량</label>
                        <input type="number" class="form-control" name="itemCount" value="${item.itemCount}">
                    </div>

                    <div class="form-group">
                        <label>이미지 1</label><br>
                        <c:choose>
                            <c:when test="${not empty item.itemImg1}">
                                <img src="<c:url value='/img/item/${item.itemImg1}'/>" width="100"><br>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">이미지 없음</span><br>
                            </c:otherwise>
                        </c:choose>
                        <input type="hidden" name="itemImg1" value="${item.itemImg1}">
                    </div>

                    <div class="form-group">
                        <label>이미지</label><br>
                        <c:choose>
                            <c:when test="${not empty item.itemImg2}">
                                <img src="<c:url value='/img/item/${item.itemImg2}'/>" width="100"><br>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">이미지 없음</span><br>
                            </c:otherwise>
                        </c:choose>
                        <input type="hidden" name="itemImg2" value="${item.itemImg2}">
                    </div>

                    <div class="form-group">
                        <label>이미지</label><br>
                        <c:choose>
                            <c:when test="${not empty item.itemImg3}">
                                <img src="<c:url value='/img/item/${item.itemImg3}'/>" width="100"><br>
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">이미지 없음</span><br>
                            </c:otherwise>
                        </c:choose>
                        <input type="hidden" name="itemImg3" value="${item.itemImg3}">
                    </div>

                    <div class="form-group">
                        <label>새 이미지</label>
                        <input type="file" class="form-control" name="img1">
                    </div>
                    <div class="form-group">
                        <label>새 이미지</label>
                        <input type="file" class="form-control" name="img2">
                    </div>
                    <div class="form-group">
                        <label>새 이미지</label>
                        <input type="file" class="form-control" name="img3">
                    </div>

                    <hr>
<%--                    <h5 class="mt-4">옵션 정보</h5>--%>
<%--                    <table class="table table-bordered">--%>
<%--                        <tr><th>사이즈</th><td>${option.size}</td></tr>--%>
<%--                        <tr><th>색상</th><td>${option.color}</td></tr>--%>
<%--                        <tr><th>재고</th><td>${option.stock}</td></tr>--%>
<%--                        <tr><th>추가 금액</th><td><fmt:formatNumber value="${option.additionalPrice}" pattern="#,###"/>원</td></tr>--%>
<%--                    </table>--%>

                    <button id="btn_update2" type="button" class="btn btn-primary mt-3">수정</button>
                    <button id="btn_delete2" type="button" class="btn btn-danger mt-3">삭제</button>

                </form>
            </div>
        </div>
    </div>
</div>


