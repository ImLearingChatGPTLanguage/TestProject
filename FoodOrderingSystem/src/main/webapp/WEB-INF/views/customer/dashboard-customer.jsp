<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${not empty pageTitle ? pageTitle : 'My Dashboard'}</h1>
</div>
    
<c:if test="${not empty globalMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="zmdi zmdi-check-circle"></i> <c:out value="${globalMessage}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>
<c:if test="${not empty user}">
    <div class="alert alert-light shadow-sm" role="alert">
        <h4>Chào mừng trở lại, <strong><c:out value="${user.fullName != null && !user.fullName.isEmpty() ? user.fullName : user.username}"/></strong>!</h4>
        <p class="mb-0">Chúc bạn một ngày tốt lành và có những trải nghiệm đặt món tuyệt vời.</p>
    </div>
</c:if>

<p class="lead">Tại đây bạn có thể dễ dàng quản lý các đơn hàng, thông tin cá nhân và khám phá những món ăn hấp dẫn từ các nhà hàng yêu thích.</p>

<div class="row mt-4">
    <div class="col-md-6 col-lg-4 mb-4">
        <div class="card text-center h-100 shadow-sm hover-shadow-lg">
            <div class="card-body">
                <i class="bi bi-search display-3 text-primary mb-3"></i>
                <h5 class="card-title">Khám Phá Nhà Hàng</h5>
                <p class="card-text">Tìm kiếm và lựa chọn từ hàng trăm nhà hàng với thực đơn đa dạng.</p>
                <a href="${pageContext.request.contextPath}/restaurants/list" class="btn btn-primary stretched-link">
                    <i class="bi bi-arrow-right-circle-fill"></i> Xem Nhà Hàng
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-4 mb-4">
        <div class="card text-center h-100 shadow-sm hover-shadow-lg">
            <div class="card-body">
                <i class="bi bi-receipt-cutoff display-3 text-info mb-3"></i>
                <h5 class="card-title">Đơn Hàng Của Tôi</h5>
                <p class="card-text">Theo dõi trạng thái các đơn hàng hiện tại và xem lại lịch sử đặt món.</p>
                <a href="${pageContext.request.contextPath}/orders/my-history" class="btn btn-info stretched-link text-white"> 
                    <i class="bi bi-list-check"></i> Lịch Sử Đặt Hàng
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-4 mb-4">
        <div class="card text-center h-100 shadow-sm hover-shadow-lg">
            <div class="card-body">
                <i class="bi bi-person-vcard-fill display-3 text-success mb-3"></i>
                <h5 class="card-title">Thông Tin Cá Nhân</h5>
                <p class="card-text">Cập nhật địa chỉ giao hàng, số điện thoại và các thông tin cá nhân khác.</p>
                <a href="${pageContext.request.contextPath}/user/profile/edit" class="btn btn-success stretched-link"> 
                    <i class="bi bi-pencil-fill"></i> Cập Nhật Hồ Sơ
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-6 col-lg-4 mb-4">
        <div class="card text-center h-100 shadow-sm hover-shadow-lg">
            <div class="card-body">
                <i class="bi bi-cart-check-fill display-3 text-warning mb-3"></i>
                <h5 class="card-title">Giỏ Hàng Của Bạn</h5>
                <p class="card-text">Xem lại các món ăn đã chọn và tiến hành đặt hàng.</p>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-warning stretched-link text-dark"> 
                    <i class="bi bi-basket2-fill"></i> Đến Giỏ Hàng
                </a>
            </div>
        </div>
    </div>
</div>