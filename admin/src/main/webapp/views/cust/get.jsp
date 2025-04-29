<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">
<link rel="stylesheet" href="/css/cherry-blossom.css">
<link rel="stylesheet" href="/css/cust.css">

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>

<script>
    $(function () {
        $('#dataTable').DataTable({
            pageLength: 10,
            lengthMenu: [10, 25, 50, 100],
            dom: 't<"d-flex justify-content-between mt-3 px-1"lip>',
            language: {
                search: '검색:',
                lengthMenu: '페이지당 _MENU_개씩 보기',
                info: '총 _TOTAL_개 중 _START_부터 _END_까지 표시',
                paginate: {
                    first: '처음',
                    last: '마지막',
                    next: '다음',
                    previous: '이전'
                },
                zeroRecords: '일치하는 결과가 없습니다.',
                infoEmpty: '데이터가 없습니다.',
                infoFiltered: '(총 _MAX_개 중 필터링됨)'
            }
        });
    });

    const cust_get = {
        update: function (id) {
            if (confirm('수정하시겠습니까?')) {
                location.href = '<c:url value="/cust/detail"/>' + '?id=' + id;
            }
        },
        delete: function (id) {
            if (confirm('삭제하시겠습니까?')) {
                location.href = '<c:url value="/cust/delete"/>' + '?id=' + id;
            }
        }
    };
</script>

<div class="container-fluid">
    <h1>고객 정보 테이블</h1>
    <div class="table-responsive">
        <table class="table table-hover table-bordered" id="dataTable">
            <thead>
            <tr>
                <th>ID</th>
                <th>PWD</th>
                <th>NAME</th>
                <th>EMAIL</th>
                <th>PHONE</th>
                <th>가입일</th>
                <th>포인트</th>
                <th>별명</th>
                <th>적립량</th>
                <th>사유</th>
                <th></th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${custs}">
                <tr>
                    <td><a href="<c:url value='/cust/detail'/>?id=${c.custId}">${c.custId}</a></td>
                    <td>${c.custPwd}</td>
                    <td>${c.custName}</td>
                    <td>${c.custEmail}</td>
                    <td>${c.custPhone}</td>
                    <td>${c.custRdate}</td>
                    <td>${c.custPoint}</td>
                    <td>${c.custNick}</td>
                    <td>${c.pointCharge}</td>
                    <td>${c.pointReason}</td>
                    <td><button type="button" class="btn btn-dark btn-sm" onclick="cust_get.update('${c.custId}')">수정</button></td>
                    <td><button type="button" class="btn btn-danger btn-sm" onclick="cust_get.delete('${c.custId}')">삭제</button></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
