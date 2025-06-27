<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${not empty pageTitle ? pageTitle : 'User Management'}</h1>
    <div class="btn-toolbar mb-2 mb-md-0">
        <a href="${pageContext.request.contextPath}/user/register?role=STAFF" class="btn btn-sm btn-outline-primary me-2"><i class="bi bi-person-plus-fill"></i> Thêm Nhân viên NH</a>
        <a href="${pageContext.request.contextPath}/user/register?role=ADMIN" class="btn btn-sm btn-outline-danger"><i class="bi bi-person-badge-fill"></i> Thêm Quản trị viên</a>
    </div>
</div>
<div class="mb-3">
    <form action="${pageContext.request.contextPath}/admin/users/list" method="GET" class="row g-3 align-items-center">
        <div class="col-auto"><label for="userKeyword" class="visually-hidden">Từ khóa</label><input type="search" class="form-control form-control-sm" id="userKeyword" name="keyword" placeholder="Nhập tên, username, email hoặc ID user..." value="<c:out value='${searchKeyword}'/>"></div>
        <div class="col-auto"><button type="submit" class="btn btn-sm btn-primary"><i class="bi bi-search"></i> Tìm Kiếm User</button><c:if test="${not empty searchKeyword}"><a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-sm btn-outline-secondary ms-2"><i class="bi bi-x-lg"></i> Xóa tìm kiếm</a></c:if></div>
        </form>
    </div>

<c:if test="${not empty globalMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="zmdi zmdi-check-circle"></i> <c:out value="${globalMessage}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>
<c:if test="${not empty globalError}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="zmdi zmdi-alert-triangle"></i> <c:out value="${globalError}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>

<%-- ... (Phần card và table hiển thị user giữ nguyên như phiên bản đầy đủ bạn đã có) ... --%>
<div class="card">
    <div class="card-header"><c:choose><c:when test="${not empty searchKeyword}">Kết quả tìm kiếm User cho "<c:out value="${searchKeyword}"/>"</c:when><c:otherwise>Danh sách người dùng trong hệ thống</c:otherwise></c:choose></div>
            <div class="card-body"><div class="table-responsive">
            <c:if test="${not empty users}">
                <table class="table table-striped table-hover table-bordered align-middle">
                    <thead class="table-light"><tr><th>ID</th><th>Username</th><th>Email</th><th>Họ và Tên</th><th>Vai trò</th><th>Trạng thái</th><th style="min-width: 250px;">Hành động</th></tr></thead>
                    <tbody><c:forEach var="user" items="${users}"><tr>
                                <td><c:out value="${user.userId}" /></td><td><c:out value="${user.username}" /></td><td><c:out value="${user.email}" /></td><td><c:out value="${user.fullName}" /></td>
                                <td><span class="badge bg-secondary"><c:out value="${user.role}" /></span></td>
                                <td><c:choose><c:when test="${user.active}"><span class="badge bg-success">Active</span></c:when><c:otherwise><span class="badge bg-danger">Inactive</span></c:otherwise></c:choose></td>
                                        <td class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/users/edit/${user.userId}" class="btn btn-info btn-sm" title="Sửa thông tin"><i class="bi bi-pencil-square"></i> Sửa</a>
                                    <c:choose><c:when test="${user.active}"><form:form method="post" action="${pageContext.request.contextPath}/admin/users/deactivate/${user.userId}" style="display:inline-block; margin-left:5px;"><button type="submit" class="btn btn-warning btn-sm" onclick="return confirm('Bạn có chắc muốn vô hiệu hóa người dùng \'${user.username}\'?');"><i class="bi bi-slash-circle"></i> Vô hiệu hóa</button></form:form></c:when><c:otherwise><form:form method="post" action="${pageContext.request.contextPath}/admin/users/activate/${user.userId}" style="display:inline-block; margin-left:5px;"><button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Bạn có chắc muốn kích hoạt người dùng \'${user.username}\'?');"><i class="bi bi-check-circle"></i> Kích hoạt</button></form:form></c:otherwise></c:choose>
                                    <a href="${pageContext.request.contextPath}/admin/users/delete/${user.userId}/confirm" class="btn btn-danger btn-sm" title="Xóa vĩnh viễn" style="margin-left:5px;"><i class="bi bi-trash-fill"></i> Xóa hẳn</a>
                                </td></tr></c:forEach></tbody>
                    </table>
            </c:if>
            <c:if test="${empty users}"><div class="alert alert-info mt-3" role="alert"><c:choose><c:when test="${not empty searchKeyword}">Không tìm thấy người dùng nào khớp với từ khóa "<c:out value="${searchKeyword}"/>".</c:when><c:otherwise>Hiện tại không có người dùng nào trong hệ thống.</c:otherwise></c:choose></div></c:if>
        </div></div>
</div>