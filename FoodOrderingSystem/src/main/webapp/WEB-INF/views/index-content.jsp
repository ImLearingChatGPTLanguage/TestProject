<%-- 
    Document   : index-content
    Created on : May 26, 2025, 4:06:15 PM
    Author     : MSI-ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">Trang Chủ - Food Ordering System</h1>
</div>


<div class="container mt-4">
    <div class="p-5 mb-4 bg-light rounded-3 text-center">
        <div class="container-fluid py-5">
            <h1 class="display-4 fw-bold">Chào mừng đến với Food Ordering System!</h1>
            <p class="fs-5">Nền tảng đặt đồ ăn trực tuyến tiện lợi và nhanh chóng.</p>
            <hr class="my-4">
            <p>Khám phá các nhà hàng và món ăn yêu thích của bạn ngay hôm nay.</p>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/restaurants/list" class="btn btn-primary btn-lg mx-2" type="button">
                    <i class="bi bi-search"></i> Tìm Món Ngay
                </a>

                <%-- Hiển thị nút Đăng nhập/Đăng ký nếu người dùng chưa đăng nhập --%>
                <c:if test="${empty sessionScope.loggedInUser}">
                    <a href="${pageContext.request.contextPath}/user/login" class="btn btn-success btn-lg mx-2" type="button">
                        <i class="bi bi-box-arrow-in-right"></i> Đăng Nhập
                    </a>
                    <a href="${pageContext.request.contextPath}/user/register" class="btn btn-info btn-lg mx-2" type="button">
                        <i class="bi bi-person-plus-fill"></i> Đăng Ký
                    </a>
                </c:if>

                <%-- Hiển thị thông tin người dùng và nút Dashboard nếu đã đăng nhập --%>
                <c:if test="${not empty sessionScope.loggedInUser}">
                    <p class="mt-3 fs-5">Chào mừng trở lại, <strong><c:out value="${sessionScope.loggedInUser.fullName != null && !sessionScope.loggedInUser.fullName.isEmpty() ? sessionScope.loggedInUser.fullName : sessionScope.loggedInUser.username}"/></strong>!</p>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary btn-lg mx-2" type="button">
                        <i class="bi bi-speedometer2"></i> Đến Dashboard
                    </a>
                </c:if>
            </div>
        </div>
    </div>

    <div class="row text-center mt-5">
        <div class="col-lg-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <i class="bi bi-hand-thumbs-up-fill display-3 text-primary mb-3"></i>
                    <h3 class="fw-normal mt-2">Dễ Dàng Đặt Hàng</h3>
                    <p>Chỉ với vài cú nhấp chuột, món ăn yêu thích sẽ đến tận tay bạn.</p>
                </div>
            </div>
        </div>
        <div class="col-lg-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <i class="bi bi-truck display-3 text-success mb-3"></i>
                    <h3 class="fw-normal mt-2">Giao Hàng Nhanh Chóng</h3>
                    <p>Hệ thống theo dõi đơn hàng và giao hàng hiệu quả.</p>
                </div>
            </div>
        </div>
        <div class="col-lg-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <i class="bi bi-star-fill display-3 text-warning mb-3"></i>
                    <h3 class="fw-normal mt-2">Chất Lượng Đảm Bảo</h3>
                    <p>Đánh giá từ cộng đồng giúp bạn chọn lựa tốt nhất.</p>
                </div>
            </div>
        </div>
    </div>
</div>