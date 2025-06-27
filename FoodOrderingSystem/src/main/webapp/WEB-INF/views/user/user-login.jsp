<%-- 
    Document   : user-login
    Created on : May 29, 2025, 1:03:12 AM
    Author     : MSI-ADMIN
--%>

<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow-sm" style="margin-top: 50px;">
                <div class="card-header bg-primary text-white text-center">
                    <h4>Đăng Nhập Tài Khoản</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty loginError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${loginError}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            Tên đăng nhập hoặc mật khẩu không đúng.
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-info alert-dismissible fade show" role="alert">
                            Bạn đã đăng xuất thành công.
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/user/login">
                        <div class="mb-3">
                            <label for="username" class="form-label">Tên đăng nhập:</label>
                            <input type="text" class="form-control" id="username" name="username" required value="${param.username}"/>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Mật khẩu:</label>
                            <input type="password" class="form-control" id="password" name="password" required/>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-block">Đăng Nhập</button>
                        </div>
                    </form>
                    <p class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/user/forgot-password">Quên mật khẩu?</a> |
                        <a href="${pageContext.request.contextPath}/user/register">Chưa có tài khoản? Đăng ký</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>