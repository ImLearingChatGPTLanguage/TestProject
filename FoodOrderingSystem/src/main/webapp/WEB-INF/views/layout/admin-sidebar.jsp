<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="sidebar-wrapper" data-simplebar="" data-simplebar-auto-hide="true">
    <div class="brand-logo">
        <a href="${pageContext.request.contextPath}/dashboard">
            <img src="${pageContext.request.contextPath}/resources/admin-theme/assets/images/logo-icon.png" class="logo-icon" alt="logo icon">
            <h5 class="logo-text">Food Ordering System</h5>
        </a>
    </div>
    <ul class="sidebar-menu do-nicescrol">
        <li class="sidebar-header">MAIN NAVIGATION</li>

        <li>
            <a href="${pageContext.request.contextPath}/dashboard" class="waves-effect">
                <i class="zmdi zmdi-view-dashboard"></i> <span>Dashboard</span>
            </a>
        </li>


        <c:if test="${not empty sessionScope.loggedInUser && sessionScope.loggedInUser.role == 'ADMIN'}">
            <li>
                <a href="${pageContext.request.contextPath}/admin/users/list" class="waves-effect">
                    <i class="zmdi zmdi-accounts-alt"></i> <span>Quản Lý User</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/restaurants/list" class="waves-effect">
                    <i class="zmdi zmdi-store"></i> <span>Quản Lý Nhà Hàng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/categories/list" class="waves-effect">
                    <i class="zmdi zmdi-folder-star"></i> <span>Quản Lý Danh Mục</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/orders/list" class="waves-effect">
                    <i class="zmdi zmdi-mall"></i> <span>Quản Lý Đơn Hàng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/reports" class="waves-effect">
                    <i class="zmdi zmdi-chart"></i> <span>Báo cáo & Thống kê</span>
                </a>
            </li>
        </c:if>


        <c:if test="${not empty sessionScope.loggedInUser && sessionScope.loggedInUser.role == 'CUSTOMER'}">
            <li>
                <a href="${pageContext.request.contextPath}/restaurants/list" class="waves-effect">
                    <i class="zmdi zmdi-store"></i> <span>Khám Phá Nhà Hàng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/orders/my-history" class="waves-effect">
                    <i class="zmdi zmdi-receipt"></i> <span>Đơn Hàng Của Tôi</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/cart" class="waves-effect">
                    <i class="zmdi zmdi-shopping-cart"></i> <span>Giỏ Hàng</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/user/profile/edit" class="waves-effect">
                    <i class="zmdi zmdi-account-box"></i> <span>Hồ Sơ Của Tôi</span>
                </a>
            </li>
        </c:if>


        <c:if test="${not empty sessionScope.loggedInUser && sessionScope.loggedInUser.role == 'ADMIN'}">
            <li class="sidebar-header">LABELS</li>
            <li><a href="javascript:void();" class="waves-effect"><i class="zmdi zmdi-coffee text-danger"></i> <span>Important</span></a></li>
            <li><a href="javaScript:void();" class="waves-effect"><i class="zmdi zmdi-chart-donut text-success"></i> <span>Warning</span></a></li>
            <li><a href="javaScript:void();" class="waves-effect"><i class="zmdi zmdi-share text-info"></i> <span>Information</span></a></li>
            </c:if>


        <c:if test="${not empty sessionScope.loggedInUser}">
            <li class="sidebar-header">ACCOUNT</li>
            <li>
                <a href="${pageContext.request.contextPath}/user/logout" class="waves-effect">
                    <i class="zmdi zmdi-power"></i> <span>Đăng xuất</span>
                </a>
            </li>
        </c:if>
    </ul>
</div>