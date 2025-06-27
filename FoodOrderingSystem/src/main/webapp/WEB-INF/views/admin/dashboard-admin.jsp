<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="row mt-3">
    <div class="col-12">
        <h1 class="h2 page-title">${not empty pageTitle ? pageTitle : 'Admin Dashboard'}</h1>
        <hr>
    </div>
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
    <div class="alert alert-info bg-transparent border-info">
        <i class="zmdi zmdi-info-outline"></i> Chào mừng trở lại, <strong><c:out value="${user.fullName != null ? user.fullName : user.username}"/></strong>!
    </div>
</c:if>
<div class="card mt-3">
    <div class="card-content">
        <div class="row row-group m-0">
            <div class="col-12 col-lg-6 col-xl-3 border-light">
                <div class="card-body">
                    <h5 class="text-white mb-0">${totalUsers != null ? totalUsers : '0'} <span class="float-right"><i class="fa fa-users"></i></span></h5>
                    <div class="progress my-3" style="height:3px;"><div class="progress-bar" style="width:100%"></div></div>
                    <p class="mb-0 text-white small-font">Tổng Số Người Dùng</p>
                </div>
            </div>
            <div class="col-12 col-lg-6 col-xl-3 border-light">
                <div class="card-body">
                    <h5 class="text-white mb-0">${totalRestaurants != null ? totalRestaurants : '0'} <span class="float-right"><i class="fa fa-cutlery"></i></span></h5>
                    <div class="progress my-3" style="height:3px;"><div class="progress-bar" style="width:100%"></div></div>
                    <p class="mb-0 text-white small-font">Tổng Số Nhà Hàng</p>
                </div>
            </div>
            <div class="col-12 col-lg-6 col-xl-3 border-light">
                <div class="card-body">
                    <h5 class="text-white mb-0">${totalOrders != null ? totalOrders : '0'} <span class="float-right"><i class="fa fa-shopping-cart"></i></span></h5>
                    <div class="progress my-3" style="height:3px;"><div class="progress-bar" style="width:100%"></div></div>
                    <p class="mb-0 text-white small-font">Tổng Số Đơn Hàng</p>
                </div>
            </div>
            <div class="col-12 col-lg-6 col-xl-3 border-light">
                <div class="card-body">
                    <h5 class="text-white mb-0"><fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/> <span class="float-right"><i class="fa fa-usd"></i></span></h5>
                    <div class="progress my-3" style="height:3px;"><div class="progress-bar" style="width:100%"></div></div>
                    <p class="mb-0 text-white small-font">Tổng Doanh Thu</p>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row mt-4">
    <div class="col-12 col-lg-8 col-xl-8">
        <div class="card">
            <div class="card-header">Thống Kê Truy Cập (Ví dụ)<div class="card-action"><div class="dropdown"><a href="javascript:void();" class="dropdown-toggle dropdown-toggle-nocaret" data-toggle="dropdown"><i class="icon-options"></i></a><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="javascript:void();">Action</a></div></div></div></div>
            <div class="card-body"><div class="chart-container-1"><canvas id="chart1"></canvas></div></div>
        </div>
    </div>
    <div class="col-12 col-lg-4 col-xl-4">
        <div class="card">
            <div class="card-header">Doanh Số Tuần (Ví dụ)<div class="card-action"><div class="dropdown"><a href="javascript:void();" class="dropdown-toggle dropdown-toggle-nocaret" data-toggle="dropdown"><i class="icon-options"></i></a><div class="dropdown-menu dropdown-menu-right"><a class="dropdown-item" href="javascript:void();">Action</a></div></div></div></div>
            <div class="card-body"><div class="chart-container-2"><canvas id="chart2"></canvas></div></div>
            <div class="table-responsive"><table class="table align-items-center"><tbody><tr><td><i class="fa fa-circle text-white mr-2"></i> Direct</td><td>$5856</td><td>+55%</td></tr></tbody></table></div>
        </div>
    </div>
</div>
<div class="row mt-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header">Các Chức Năng Quản Trị Chính</div>
            <div class="card-body">
                <div class="list-group">
                    <a href="${pageContext.request.contextPath}/admin/users/list" class="list-group-item list-group-item-action"><i class="zmdi zmdi-accounts-alt mr-2"></i>Quản Lý Người Dùng</a>
                    <a href="${pageContext.request.contextPath}/admin/restaurants/list" class="list-group-item list-group-item-action"><i class="zmdi zmdi-store mr-2"></i>Quản Lý Nhà Hàng</a>
                    <a href="${pageContext.request.contextPath}/admin/categories/list" class="list-group-item list-group-item-action"><i class="zmdi zmdi-folder-star mr-2"></i>Quản Lý Danh Mục Món Ăn</a>
                    <a href="${pageContext.request.contextPath}/admin/orders/list" class="list-group-item list-group-item-action"><i class="zmdi zmdi-assignment mr-2"></i>Quản Lý Đơn Hàng</a>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="list-group-item list-group-item-action"><i class="zmdi zmdi-chart mr-2"></i>Báo cáo & Thống kê</a>
                </div>
            </div>
        </div>
    </div>
</div>