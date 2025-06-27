<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header bg-success text-white text-center">
                    <h4 class="mb-0"><i class="bi bi-person-plus-fill"></i> Đăng Ký Tài Khoản Mới</h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty registrationErrorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> <c:out value="${registrationErrorMessage}"/>
                            <%-- SỬA ĐỔI --%>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${not empty globalMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill"></i> <c:out value="${globalMessage}"/>
                            <%-- SỬA ĐỔI --%>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <form:form modelAttribute="user" method="post" action="${pageContext.request.contextPath}/user/register">
                        <div class="mb-3">
                            <form:label path="username" cssClass="form-label fw-bold">Tên đăng nhập:</form:label>
                            <form:input path="username" cssClass="form-control" cssErrorClass="form-control is-invalid" id="username" placeholder="Nhập tên đăng nhập"/>
                            <form:errors path="username" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
                            <form:label path="password" cssClass="form-label fw-bold">Mật khẩu:</form:label>
                            <form:password path="password" cssClass="form-control" cssErrorClass="form-control is-invalid" id="password" placeholder="Nhập mật khẩu"/>
                            <form:errors path="password" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
                            <form:label path="email" cssClass="form-label fw-bold">Email:</form:label>
                            <form:input path="email" type="email" cssClass="form-control" cssErrorClass="form-control is-invalid" id="email" placeholder="your.email@example.com"/>
                            <form:errors path="email" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
                            <form:label path="fullName" cssClass="form-label fw-bold">Họ và tên đầy đủ:</form:label>
                            <form:input path="fullName" cssClass="form-control" cssErrorClass="form-control is-invalid" id="fullName" placeholder="Nguyễn Văn A"/>
                            <form:errors path="fullName" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
                            <form:label path="phoneNumber" cssClass="form-label fw-bold">Số điện thoại:</form:label>
                            <form:input path="phoneNumber" cssClass="form-control" cssErrorClass="form-control is-invalid" id="phoneNumber" placeholder="09xxxxxxxx"/>
                            <form:errors path="phoneNumber" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="mb-3">
                            <form:label path="role" cssClass="form-label fw-bold">Đăng ký với vai trò:</form:label>
                            <form:select path="role" cssClass="form-select" cssErrorClass="form-select is-invalid" id="role">
                                <form:option value="CUSTOMER" label="Khách hàng (Customer)"/>
                                <form:option value="ADMIN" label="Nhân viên nhà hàng (Restaurant Staff)"/>
                            </form:select>
                            <form:errors path="role" cssClass="invalid-feedback d-block"/>
                        </div>
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="bi bi-check2-circle"></i> Đăng Ký Ngay
                            </button>
                        </div>
                    </form:form>
                    <p class="text-center mt-4">
                        Đã có tài khoản? <a href="${pageContext.request.contextPath}/user/login">Đăng nhập tại đây</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>