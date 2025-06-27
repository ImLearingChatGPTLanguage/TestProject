<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/layout/admin-header.jsp" />

<body class="bg-theme bg-theme1 d-flex flex-column min-vh-100">
    <div id="wrapper" class="flex-grow-1 d-flex flex-column">

        <jsp:include page="/WEB-INF/views/layout/admin-sidebar.jsp" />

        <div class="content-wrapper flex-grow-1">
            <div class="container-fluid py-4">
                <c:if test="${not empty body}">
                    <jsp:include page="${body}" />
                </c:if>

            </div>
        </div> 
    </div>

    <jsp:include page="/WEB-INF/views/layout/admin-footer.jsp" />
</body>
</html>