<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${not empty pageTitle ? pageTitle : 'Quản Lý Đơn Hàng'}</h1>
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

<div class="card">
    <div class="card-header">Danh sách tất cả đơn hàng</div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>ID Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Nhà Hàng</th>
                        <th>Tổng Tiền</th>
                        <th>Ngày Đặt</th>
                        <th>Trạng Thái</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${allOrders}">
                        <tr>
                            <td>#<c:out value="${order.orderId}"/></td>
                            <td><c:out value="${order.customerUser.fullName}"/></td>
                            <td><c:out value="${order.restaurant.name}"/></td>
                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            <td><fmt:formatDate value="${order.orderDatetime}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <span class="badge 
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
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/orders/${order.orderId}" class="btn btn-primary btn-sm">
                                    <i class="bi bi-eye-fill"></i> Xem Chi Tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>