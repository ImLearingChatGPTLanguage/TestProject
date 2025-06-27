<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2"><c:out value="${not empty pageTitle ? pageTitle : 'Quản Lý Thực Đơn (Admin)'}"/><c:if test="${not empty restaurant}"><small class="text-muted fs-5">- Nhà Hàng: <c:out value="${restaurant.name}"/></small></c:if></h1>
    <div class="btn-toolbar mb-2 mb-md-0"><a href="${pageContext.request.contextPath}/admin/restaurant/${restaurant.restaurantId}/menu/add" class="btn btn-sm btn-success"><i class="bi bi-plus-circle-fill"></i> Thêm Món Ăn Mới</a></div>
</div>

<c:if test="${not empty globalMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="zmdi zmdi-check-circle"></i> <c:out value="${globalMessage}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>
<c:if test="${not empty globalError}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="zmdi zmdi-alert-triangle"></i> <c:out value="${globalError}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>

<div class="card">
    <div class="card-header">Danh sách món ăn <c:if test="${not empty restaurant}">của nhà hàng <c:out value="${restaurant.name}"/></c:if></div>
        <div class="card-body">
            <div class="table-responsive">
            <c:if test="${not empty menuItems}">
                <table class="table table-striped table-hover table-bordered align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Hình Ảnh</th>
                            <th>Tên Món Ăn</th>
                            <th>Danh Mục</th>
                            <th>Giá</th>
                            <th>Trạng Thái</th>
                            <th style="min-width: 200px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${menuItems}">
                            <tr>
                                <td><c:out value="${item.itemId}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.imageUrl}">
                                            <c:choose>
                                                <c:when test="${item.imageUrl.startsWith('http')}">
                                                    <img src="${item.imageUrl}" alt="<c:out value="${item.name}"/>" style="width: 60px; height: 60px; object-fit: cover; border-radius: .25rem;">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}${item.imageUrl}" alt="<c:out value="${item.name}"/>" style="width: 60px; height: 60px; object-fit: cover; border-radius: .25rem;">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/60x60.png?text=N/A" alt="No Image" style="width: 60px; height: 60px; object-fit: cover; border-radius: .25rem;">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong><c:out value="${item.name}" /></strong><br><small class="text-muted"><c:out value="${item.description}"/></small></td>
                                <td><c:out value="${item.category.name}" /></td>
                                <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.available}"><span class="badge bg-success">Còn hàng</span></c:when>
                                        <c:otherwise><span class="badge bg-danger">Hết hàng</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/admin/restaurant/${restaurant.restaurantId}/menu/edit/${item.itemId}" class="btn btn-info btn-sm mb-1" title="Sửa món ăn"><i class="bi bi-pencil-square"></i> Sửa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty menuItems}">
                <div class="alert alert-info mt-3" role="alert">Nhà hàng này hiện chưa có món ăn nào trong thực đơn. <a href="${pageContext.request.contextPath}/admin/restaurant/${restaurant.restaurantId}/menu/add">Thêm món ăn mới?</a></div>
            </c:if>
        </div>
    </div>
    <div class="card-footer"><a href="${pageContext.request.contextPath}/admin/restaurants/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left-circle"></i> Quay lại Danh sách Nhà hàng (Admin)</a></div>
</div>