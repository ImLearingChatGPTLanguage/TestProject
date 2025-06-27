<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="container mt-5"><div class="row justify-content-center"><div class="col-md-6">
            <div class="card"><div class="card-header"><h4>Quên Mật Khẩu</h4></div>
                <div class="card-body">
                    <c:if test="${not empty globalMessage}"><div class="alert alert-success">${globalMessage}</div></c:if>
                    <c:if test="${not empty globalError}"><div class="alert alert-danger">${globalError}</div></c:if>
                        <p>Vui lòng nhập email của bạn. Chúng tôi sẽ gửi hướng dẫn đặt lại mật khẩu.</p>
                        <form method="post" action="${pageContext.request.contextPath}/user/forgot-password">
                        <div class="mb-3"><label for="email" class="form-label">Email:</label>
                            <input type="email" name="email" id="email" class="form-control" required></div>
                        <button type="submit" class="btn btn-primary">Gửi Yêu Cầu</button>
                    </form>
                </div></div></div></div></div>