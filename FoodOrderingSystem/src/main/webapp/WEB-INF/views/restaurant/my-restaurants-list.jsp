<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${not empty pageTitle ? pageTitle : 'Nhà Hàng Của Tôi'}</h1>
    <div class="btn-toolbar mb-2 mb-md-0">
        <a href="${pageContext.request.contextPath}/restaurants/manage/add" class="btn btn-sm btn-success">
            <i class="bi bi-plus-circle-fill"></i> Đăng Ký/Thêm Nhà Hàng Mới
        </a>
    </div>
</div>

<c:if test="${not empty globalMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill"></i> <c:out value="${globalMessage}"/>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${not empty globalError}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill"></i> <c:out value="${globalError}"/>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<div class="card">
    <div class="card-header">
        Danh sách nhà hàng bạn đang quản lý
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <c:if test="${not empty restaurants}">
                <table class="table table-striped table-hover table-bordered align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Tên Nhà Hàng</th>
                            <th>Địa chỉ</th>
                            <th>Trạng thái Duyệt</th>
                            <th>Trạng thái Hoạt động</th>
                            <th style="min-width: 280px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="restaurant" items="${restaurants}">
                            <tr>
                                <td><c:out value="${restaurant.restaurantId}" /></td>
                                <td>
                                    <strong><c:out value="${restaurant.name}" /></strong><br>
                                    <small class="text-muted"><c:out value="${restaurant.description}"/></small>
                                </td>
                                <td>
                                    <c:if test="${not empty restaurant.address}">
                                        <small>
                                            <c:out value="${restaurant.address.streetAddress}"/><br>
                                            <c:out value="${restaurant.address.district}"/>, <c:out value="${restaurant.address.cityProvince}"/>
                                        </small>
                                    </c:if>
                                    <c:if test="${empty restaurant.address}">
                                        <small class="text-muted">Chưa có thông tin</small>
                                    </c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${restaurant.approved}">
                                            <span class="badge bg-success">Đã Duyệt</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark">Chờ Duyệt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${restaurant.active}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/restaurants/manage/edit/${restaurant.restaurantId}" class="btn btn-info btn-sm mb-1" title="Sửa thông tin nhà hàng">
                                        <i class="bi bi-pencil-square"></i> Sửa TT Nhà Hàng
                                    </a>
                                    <a href="${pageContext.request.contextPath}/staff/restaurant/${restaurant.restaurantId}/menu/list" class="btn btn-primary btn-sm mb-1" title="Quản lý thực đơn">
                                        <i class="bi bi-book-half"></i> Quản Lý Menu
                                    </a>
                                    <a href="#" class="btn btn-warning btn-sm mb-1" title="Xem đơn hàng">
                                        <i class="bi bi-receipt"></i> Xem Đơn Hàng
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty restaurants}">
                <div class="alert alert-info mt-3" role="alert">
                    Bạn hiện chưa quản lý nhà hàng nào, hoặc chưa có nhà hàng nào được đăng ký.
                    <a href="${pageContext.request.contextPath}/restaurants/manage/add">Đăng ký nhà hàng mới?</a>
                </div>
            </c:if>
        </div>
    </div>
</div>