<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header bg-warning text-dark">
                    <h4 class="mb-0"><i class="bi bi-key-fill"></i> ${not empty pageTitle ? pageTitle : 'Đổi Mật Khẩu'}</h4>
                </div>
                <div class="card-body p-4">

                    <c:if test="${not empty globalMessage}">
                        <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i> <c:out value="${globalMessage}"/></div>
                    </c:if>
                    <c:if test="${not empty globalError}">
                        <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> <c:out value="${globalError}"/></div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/user/profile/change-password">
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label fw-bold">Mật khẩu hiện tại:</label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label fw-bold">Mật khẩu mới:</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label fw-bold">Xác nhận mật khẩu mới:</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        </div>

                        <hr class="my-4">
                        <div class="d-grid gap-2 d-md-flex justify-content-end">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="bi bi-save2"></i> Lưu Mật Khẩu
                            </button>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle"></i> Hủy Bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>