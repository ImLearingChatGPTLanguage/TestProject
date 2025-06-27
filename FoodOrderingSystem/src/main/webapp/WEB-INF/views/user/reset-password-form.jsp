<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="container mt-5"><div class="row justify-content-center"><div class="col-md-6">
            <div class="card"><div class="card-header"><h4>Đặt Lại Mật Khẩu Mới</h4></div>
                <div class="card-body">
                    <c:if test="${not empty globalError}"><div class="alert alert-danger">${globalError}</div></c:if>
                    <form method="post" action="${pageContext.request.contextPath}/user/reset-password">
                        <input type="hidden" name="token" value="${token}">
                        <div class="mb-3"><label for="newPassword" class="form-label">Mật khẩu mới:</label>
                            <input type="password" name="newPassword" id="newPassword" class="form-control" required></div>
                        <div class="mb-3"><label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới:</label>
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required></div>
                        <button type="submit" class="btn btn-primary">Đặt Lại Mật Khẩu</button>
                    </form>
                </div></div></div></div></div>