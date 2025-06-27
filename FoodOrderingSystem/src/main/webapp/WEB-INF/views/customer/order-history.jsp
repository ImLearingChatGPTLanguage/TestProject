<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2">${not empty pageTitle ? pageTitle : 'Lịch Sử Đặt Hàng'}</h1>
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

    <c:choose>
        <c:when test="${not empty orderHistory}">
            <div class="accordion" id="orderHistoryAccordion">
                <c:forEach var="order" items="${orderHistory}" varStatus="status">
                    <div class="accordion-item mb-3 border rounded">
                        <h2 class="accordion-header" id="heading${status.index}">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${status.index}" aria-expanded="false" aria-controls="collapse${status.index}">
                                <div class="d-flex w-100 justify-content-between align-items-center">
                                    <span class="fw-bold">Đơn hàng #${order.orderId}</span>
                                    <span>- <fmt:formatDate value="${order.orderDatetime}" pattern="dd/MM/yyyy HH:mm"/></span>
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
                                    <span class="fw-bold text-danger"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                </div>
                            </button>
                        </h2>
                        <div id="collapse${status.index}" class="accordion-collapse collapse" aria-labelledby="heading${status.index}" data-bs-parent="#orderHistoryAccordion">
                            <div class="accordion-body">
                                <p><strong>Nhà hàng:</strong> <c:out value="${order.restaurant.name}"/></p>
                                <c:if test="${not empty order.deliveryAddress}">
                                    <p><strong>Giao đến:</strong> <c:out value="${order.deliveryAddress.streetAddress}, ${order.deliveryAddress.ward}, ${order.deliveryAddress.district}, ${order.deliveryAddress.cityProvince}"/></p>
                                </c:if>
                                <ul class="list-group">
                                    <c:forEach var="item" items="${order.orderItems}">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            ${item.menuItem.name} (SL: ${item.quantity})
                                            <span><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                                        </li>
                                    </c:forEach>
                                </ul>

                            </div>
                        </div>
                    </div>

                    <c:if test="${order.orderStatus eq 'DELIVERING'}">
                        <div class="p-3 border-top text-end">
                            <form action="${pageContext.request.contextPath}/orders/confirm-received/${order.orderId}" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xác nhận đã nhận được đơn hàng này?');">
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-check-circle-fill"></i> Đã nhận được hàng
                                </button>
                            </form>
                        </div>
                    </c:if>

                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
        </c:otherwise>
    </c:choose>
</div>