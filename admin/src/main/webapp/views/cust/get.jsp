<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    body, .container-fluid {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        background-color: #f5f5f7;
        color: #1d1d1f;
        padding: 2rem;
    }

    .card {
        background-color: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        margin-bottom: 2rem;
    }

    .card-header {
        border-bottom: 1px solid #e0e0e0;
        padding: 1rem 1.25rem;
        background-color: transparent;
    }

    .card-header h6 {
        font-size: 1.125rem;
        font-weight: 600;
        color: #1d1d1f;
    }

    .table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.95rem;
        margin-top: 1rem;
    }

    .table th, .table td {
        padding: 0.75rem;
        border: 1px solid #e0e0e0;
        text-align: center;
        vertical-align: middle;
    }

    .table thead th {
        background-color: #f9f9fa;
        font-weight: 600;
        color: #6e6e73;
        text-transform: uppercase;
        font-size: 0.85rem;
    }

    .table tfoot th {
        background-color: #f5f5f7;
        color: #999;
        font-weight: 400;
        font-size: 0.8rem;
    }

    .table tbody tr:hover {
        background-color: #f0f0f5;
    }

    .btn {
        border-radius: 8px;
        font-size: 0.85rem;
        padding: 0.35rem 0.9rem;
        transition: background-color 0.2s ease;
    }

    .btn-secondary {
        background-color: #1d1d1f;
        color: white;
        border: none;
    }

    .btn-secondary:hover {
        background-color: #333;
    }

    h1 {
        font-size: 2rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
    }

    p.mb-4 {
        font-size: 0.95rem;
        color: #555;
        margin-bottom: 2rem;
    }

    a {
        color: #0071e3;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }
</style>

<script>
    let cust_get = {
        init: function () {},
        update: function (id) {
            if (confirm('수정하시겠습니까?')) {
                location.href = '<c:url value="/cust/detail"/>?id=' + id;
            }
        },
        delete: function (id) {
            if (confirm('삭제하시겠습니까?')) {
                location.href = '<c:url value="/cust/delete"/>?id=' + id;
            }
        }
    };
    $(function () {
        cust_get.init();
    });
</script>

<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-2">고객 정보 테이블</h1>
    <p class="mb-4">
        아래는 모든 고객 정보를 나열한 표입니다.
        <a target="_blank" href="https://datatables.net">DataTables 공식 문서</a>도 참고해보세요.
    </p>

    <div class="card">
        <div class="card-header">
            <h6>고객 전체 정보 목록</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <h2 style="font-size: 1.25rem; font-weight: 500; margin-bottom: 1rem;">관리자는 고객의 모든 것을 알고 있다.</h2>
                <table class="table table-bordered" id="dataTable">
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
                        <th>적립량</th>
                        <th>적립사유</th>
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
                        <th>custRdate</th>
                        <th>custPoint</th>
                        <th>custNick</th>
                        <th>pointCharge</th>
                        <th>pointReason</th>
                        <th></th>
                        <th></th>
                    </tr>
                    </tfoot>
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
