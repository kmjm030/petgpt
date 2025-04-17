<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script>
  const admincomments_detail = {
    init:function(){},
    update:function(id){
      let c = confirm('수정하시겠습니까?');
      if(c == true){
        location.href = '<c:url value="/board/detail"/>?id='+id;
      }
    },
    delete:function(id, boardKey){
      let c = confirm('삭제하시겠습니까?');
      if(c == true){
        location.href = '<c:url value="/admincomments/delete"/>?adcommentsKey=' + id + '&boardKey=' + boardKey;
      }
    }
  }
  $(function(){
    admincomments_detail.init();
  });
</script>
<div class="card-body">
  <div class="table-responsive">
    <h2> 관리자 댓글</h2>
    <table class="table table-bordered"  width="100%" cellspacing="0">
      <thead>
      <tr>
        <th>boardkey</th>
        <th>adcommentsKey</th>
        <th>ItemKey</th>
        <th>adminId</th>
        <th>adcommentsContent</th>
        <th>adcommentsRdate</th>
        <th>adcommentsUpdate</th>
        <th>수정</th>
        <th>삭제</th>
      </tr>
      </thead>
     <tbody>
      <tr>
        <td><a href="<c:url value="/board/detail"/>?id=${a.boardKey}">${board.boardKey}</a></td>
        <td>${adminComments.adcommentsKey}</td>
        <td>${adminComments.itemKey}</td>
        <td>${adminComments.adminId}</td>
        <td>${adminComments.adcommentsContent}</td>
        <td>${adminComments.adcommentsRdate}</td>
        <td>${adminComments.adcommentsUpdate}</td>

        <td>
          <button onclick="admincomments_detail.update('${adminComments.adcommentsKey}')" type="button" class="btn btn-secondary">수정</button>
        </td>
        <td>
          <button onclick="admincomments_detail.delete('${adminComments.adcommentsKey}','${board.boardKey}')" type="button" class="btn btn-secondary">삭제</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
</div>
