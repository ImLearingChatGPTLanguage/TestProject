<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${pageTitle}</h1>
    <a href="${pageContext.request.contextPath}/admin/orders/list" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> Quay Lại Danh Sách
    </a>
</div>

<c:if test="${not empty globalMessage}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
    <c:out value="${globalMessage}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>
<c:if test="${not empty globalError}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
    <c:out value="${globalError}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>

<div class="row">
    <div class="col-lg-8">
        <div class="card shadow-sm mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Các món đã đặt</h5>
                <span class="badge bg-success fs-6"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
<c:forEach var="item" items="${order.orderItems}">
                        <li class="list-group-item d-flex justify-content-between align-items-start">
                            <div class="ms-2 me-auto">
                                <div class="fw-bold">${item.menuItem.name}</div>
                                <small class="text-muted">SL: ${item.quantity} x <fmt:formatNumber value="${item.pricePerItem}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></small>
                            </div>
                            <span class="badge bg-primary rounded-pill"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                        </li>
</c:forEach>
                </ul>
            </div>
            <div class="card-footer text-muted">
                Phí giao hàng: <fmt:formatNumber value="${order.deliveryFee}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header"><h5 class="mb-0">Thông tin giao hàng</h5></div>
            <div class="card-body">
                <p><strong>Khách hàng:</strong> <c:out value="${order.customerUser.fullName}"/></p>
                <p><strong>Số điện thoại:</strong> <c:out value="${order.customerUser.phoneNumber}"/></p>
<c:if test="${not empty order.deliveryAddress}">
                    <p><strong>Địa chỉ giao:</strong> <c:out value="${order.deliveryAddress.streetAddress}, ${order.deliveryAddress.ward}, ${order.deliveryAddress.district}, ${order.deliveryAddress.cityProvince}"/></p>
</c:if>
                <p><strong>Ghi chú:</strong> <c:out value="${empty order.notes ? 'Không có' : order.notes}"/></p>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="card shadow-sm">
            <div class="card-header"><h5 class="mb-0">Cập nhật trạng thái</h5></div>
            <div class="card-body">
                <p><strong>Trạng thái hiện tại:</strong> 
                    <span class="badge fs-6
<c:choose>
    <c:when test='${order.orderStatus eq "PENDING"}'>bg-warning text-dark</c:when>
    <c:when test='${order.orderStatus eq "PROCESSING"}'>bg-info text-dark</c:when>
    <c:when test='${order.orderStatus eq "DELIVERING"}'>bg-primary</c:when>
    <c:when test='${order.orderStatus eq "COMPLETED"}'>bg-success</c:when>
    <c:when test='${order.orderStatus eq "CANCELLED"}'>bg-danger</c:when>
    <c:otherwise>bg-secondary</c:otherwise>
</c:choose>">
<c:out value="${order.orderStatus}"/>
                    </span>
                </p>
                <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDatetime}" pattern="HH:mm dd/MM/yyyy"/></p>
<c:if test="${not empty order.actualDeliveryTime}">
                    <p><strong>Ngày giao:</strong> <fmt:formatDate value="${order.actualDeliveryTime}" pattern="HH:mm dd/MM/yyyy"/></p>
</c:if>

                <hr>

                <form action="${pageContext.request.contextPath}/admin/orders/update-status/${order.orderId}" method="post">
                    <div class="mb-3">
                        <label for="statusSelect" class="form-label">Chọn trạng thái mới:</label>
                        <select id="statusSelect" name="status" class="form-select">
                            <option value="PENDING" ${order.orderStatus eq 'PENDING' ? 'selected' : ''}>Chờ xác nhận (Pending)</option>
                            <option value="PROCESSING" ${order.orderStatus eq 'PROCESSING' ? 'selected' : ''}>Đang xử lý (Processing)</option>
                            <option value="DELIVERING" ${order.orderStatus eq 'DELIVERING' ? 'selected' : ''}>Đang giao hàng (Delivering)</option>
                            <option value="COMPLETED" ${order.orderStatus eq 'COMPLETED' ? 'selected' : ''}>Hoàn thành (Completed)</option>
                            <option value="CANCELLED" ${order.orderStatus eq 'CANCELLED' ? 'selected' : ''}>Đã hủy (Cancelled)</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-success w-100">
                        <i class="bi bi-check-circle"></i> Cập Nhật
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>