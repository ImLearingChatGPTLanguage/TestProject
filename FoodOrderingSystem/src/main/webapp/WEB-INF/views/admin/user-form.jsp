<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="card shadow-sm">
                <div class="card-header bg-info text-white">
                    <h2 class="card-title mb-0"><i class="bi bi-person-fill-gear"></i> Chỉnh Sửa Thông Tin Người Dùng</h2>
                </div>
                <div class="card-body">
<c:if test="${not empty userToEdit}"><p class="text-muted text-center mb-3">Đang chỉnh sửa cho: <strong><c:out value="${userToEdit.username}"/></strong> (ID: <c:out value="${userToEdit.userId}"/>)</p></c:if>
<c:if test="${not empty globalError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="zmdi zmdi-alert-triangle"></i> <c:out value="${globalError}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        </div>
</c:if>
<form:form modelAttribute="userToEdit" method="post" action="${pageContext.request.contextPath}/admin/users/update">
    <form:hidden path="userId"/>
    <form:hidden path="username"/>
                        <div class="mb-3"><label class="form-label fw-bold">Tên đăng nhập (Không thể thay đổi):</label><input type="text" class="form-control" value="<c:out value="${userToEdit.username}"/>" readonly /></div>
                        <div class="mb-3">
    <form:label path="fullName" cssClass="form-label fw-bold">Họ và Tên:</form:label>
    <form:input path="fullName" cssClass="form-control" cssErrorClass="form-control is-invalid" id="fullName"/>
    <form:errors path="fullName" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
    <form:label path="email" cssClass="form-label fw-bold">Email:</form:label>
    <form:input path="email" type="email" cssClass="form-control" cssErrorClass="form-control is-invalid" id="email"/>
    <form:errors path="email" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
    <form:label path="phoneNumber" cssClass="form-label fw-bold">Số điện thoại:</form:label>
    <form:input path="phoneNumber" cssClass="form-control" cssErrorClass="form-control is-invalid" id="phoneNumber"/>
    <form:errors path="phoneNumber" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
    <form:label path="role" cssClass="form-label fw-bold">Vai trò:</form:label>
    <form:select path="role" cssClass="form-select" cssErrorClass="form-select is-invalid" id="role">
        <form:option value="CUSTOMER" label="Khách hàng (Customer)"/>
        <form:option value="ADMIN" label="Nhân viên nhà hàng (Restaurant Staff)"/>
    </form:select>
    <form:errors path="role" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3 form-check">
    <form:checkbox path="active" id="isActive" cssClass="form-check-input"/>
    <form:label path="active" for="isActive" cssClass="form-check-label fw-bold">Kích hoạt (Active)</form:label>
    <form:errors path="active" cssClass="text-danger small d-block"/>
                        </div>
                        <hr class="my-4">
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="${pageContext.request.contextPath}/admin/users/change-password/${userToEdit.userId}" class="btn btn-warning">
                                <i class="bi bi-key"></i> Đổi Mật Khẩu
                            </a>
                            <button type="submit" class="btn btn-primary btn-lg"><i class="bi bi-save2"></i> Cập Nhật Thông Tin</button>
                            <a href="${pageContext.request.contextPath}/admin/users/list" class="btn btn-secondary btn-lg"><i class="bi bi-x-circle"></i> Hủy Bỏ</a>
                        </div>
</form:form>
                </div>
            </div>
        </div>
    </div>
</div>