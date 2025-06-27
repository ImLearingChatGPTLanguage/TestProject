<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="card shadow-sm">
                <div class="card-header bg-info text-white">
                    <h4 class="mb-0"><i class="bi bi-person-lines-fill"></i> ${not empty pageTitle ? pageTitle : 'Cập Nhật Hồ Sơ Cá Nhân'}</h4>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty globalMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill"></i> <c:out value="${globalMessage}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${not empty globalError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> <c:out value="${globalError}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <form:form modelAttribute="userProfile" method="post" action="${pageContext.request.contextPath}/user/profile/update">
                        <form:hidden path="userId"/>
                        <form:hidden path="username"/>
                        <form:hidden path="role"/>
                        <form:hidden path="active"/>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên đăng nhập:</label>
                            <input type="text" class="form-control" value="<c:out value="${userProfile.username}"/>" readonly disabled/>
                        </div>

                        <div class="mb-3">
                            <form:label path="fullName" cssClass="form-label fw-bold">Họ và tên đầy đủ:</form:label>
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

                        <hr class="my-4">
                        <div class="d-grid gap-2 d-md-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/user/profile/change-password" class="btn btn-warning me-auto">
                                <i class="bi bi-key"></i> Đổi Mật Khẩu
                            </a>
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-save2"></i> Lưu Thay Đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle"></i> Hủy Bỏ
                            </a>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>