<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <style>
            .error-container {
                max-width: 600px;
                margin: 50px auto;
                padding: 30px;
                text-align: center;
                border: 1px solid #eee;
                border-radius: 5px;
                background-color: #f9f9f9;
            }

            .error-message {
                font-size: 18px;
                color: #dc3545;
                margin-bottom: 20px;
            }

            .error-actions .site-btn {
                padding: 10px 25px;
            }
        </style>

        <section class="error-page spad">
            <div class="container">
                <div class="error-container">
                    <h4 class="error-message">
                        <i class="fa fa-exclamation-triangle"></i>
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                <c:out value="${errorMessage}" />
                            </c:when>
                            <c:otherwise>
                                알 수 없는 오류가 발생했습니다.
                            </c:otherwise>
                        </c:choose>
                    </h4>
                    <div class="error-actions">
                        <a href="<c:url value='/community'/>" class="site-btn">목록으로 돌아가기</a>
                        <a href="<c:url value='/'/>" class="site-btn">홈으로 가기</a>
                    </div>
                </div>
            </div>
        </section>