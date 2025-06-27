<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">
                    <h2 class="card-title mb-0"><i class="bi bi-exclamation-triangle-fill"></i> ${not empty pageTitle ? pageTitle : 'Xác Nhận Xóa Người Dùng'}</h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty globalError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="zmdi zmdi-alert-triangle"></i> <c:out value="${globalError}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty userToDelete}">
                        <p class="lead">Bạn có chắc chắn muốn xóa vĩnh viễn người dùng sau đây không?</p>
                        <p class="text-danger"><strong>CẢNH BÁO: Hành động này không thể hoàn tác!</strong></p>
                        <div class="user-details my-4 p-3 bg-light border rounded">
                            <p><strong>ID:</strong> <c:out value="${userToDelete.userId}"/></p>
                            <p><strong>Username:</strong> <c:out value="${userToDelete.username}"/></p>
                            <p><strong>Họ và Tên:</strong> <c:out value="${userToDelete.fullName}"/></p>
                            <p><strong>Email:</strong> <c:out value="${userToDelete.email}"/></p>
                            <p><strong>Vai trò:</strong> <c:out value="${userToDelete.role}"/></p>
                        </div>
                        <form:form method="post" action="${pageContext.request.contextPath}/admin/users/delete/${userToDelete.userId}" cssClass="mt-4">
                            <button type="submit" class="btn btn-danger btn-lg me-2"><i class="bi bi-trash-fill"></i> Vâng, Xóa Người Dùng</button>
                            <a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-secondary btn-lg"><i class="bi bi-x-circle"></i> Hủy Bỏ</a>
                        </form:form>
                    </c:if>
                    <c:if test="${empty userToDelete && empty globalError}">
                        <div class="alert alert-warning mt-3" role="alert">Không tìm thấy thông tin người dùng để xóa.</div>
                        <a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-primary mt-3"><i class="bi bi-arrow-left-circle"></i> Quay lại Danh sách</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>