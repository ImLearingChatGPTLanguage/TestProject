<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container mt-5">
    <h1 class="h2 mb-4">${not empty pageTitle ? pageTitle : 'Thanh Toán Đơn Hàng'}</h1>

    <c:if test="${not empty globalMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="zmdi zmdi-check-circle"></i> <c:out value="${globalMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

    <div class="row g-5">
        <div class="col-md-5 col-lg-4 order-md-last">
            <h4 class="d-flex justify-content-between align-items-center mb-3">
                <span class="text-primary">Giỏ hàng của bạn</span>
                <span class="badge bg-primary rounded-pill">${sessionScope.cart.size()}</span>
            </h4>
            <ul class="list-group mb-3">
                <c:set var="grandTotal" value="0" />
                <c:forEach var="entry" items="${sessionScope.cart}">
                    <c:set var="orderItem" value="${entry.value}" />
                    <li class="list-group-item d-flex justify-content-between lh-sm">
                        <div>
                            <h6 class="my-0">${orderItem.menuItem.name}</h6>
                            <small class="text-muted">Số lượng: ${orderItem.quantity}</small>
                        </div>
                        <span class="text-muted"><fmt:formatNumber value="${orderItem.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                    </li>
                    <c:set var="grandTotal" value="${grandTotal + orderItem.subtotal}" />
                </c:forEach>
                <li class="list-group-item d-flex justify-content-between bg-light">
                    <div class="text-success">
                        <h6 class="my-0">Phí giao hàng</h6>
                        <small>DELIVERYFEE</small>
                    </div>
                    <span class="text-success_"><fmt:formatNumber value="15000" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                </li>
                <li class="list-group-item d-flex justify-content-between">
                    <span>Tổng cộng (VNĐ)</span>
                    <strong><fmt:formatNumber value="${grandTotal + 15000}" type="currency" currencySymbol="₫" minFractionDigits="0"/></strong>
                </li>
            </ul>
        </div>
        <div class="col-md-7 col-lg-8">
            <h4 class="mb-3">Thông tin giao hàng</h4>
            <form:form modelAttribute="order" method="post" action="${pageContext.request.contextPath}/order/place">
                <div class="row g-3">
                    <div class="col-12">
                        <form:label path="deliveryAddress.streetAddress" cssClass="form-label fw-bold">Số nhà, Đường:</form:label>
                        <form:input path="deliveryAddress.streetAddress" cssClass="form-control" cssErrorClass="form-control is-invalid" required="true" placeholder="Ví dụ: 2c/33 Bình Quới"/>
                        <form:errors path="deliveryAddress.streetAddress" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="col-12">
                        <form:label path="deliveryAddress.ward" cssClass="form-label fw-bold">Phường/Xã:</form:label>
                        <form:input path="deliveryAddress.ward" cssClass="form-control" cssErrorClass="form-control is-invalid" placeholder="Ví dụ: P.27"/>
                        <form:errors path="deliveryAddress.ward" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="col-md-6">
                        <form:label path="deliveryAddress.district" cssClass="form-label fw-bold">Quận/Huyện:</form:label>
                        <form:input path="deliveryAddress.district" cssClass="form-control" cssErrorClass="form-control is-invalid" required="true" placeholder="Ví dụ: Quận Bình Thạnh"/>
                        <form:errors path="deliveryAddress.district" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="col-md-6">
                        <form:label path="deliveryAddress.cityProvince" cssClass="form-label fw-bold">Tỉnh/Thành phố:</form:label>
                        <form:input path="deliveryAddress.cityProvince" cssClass="form-control" cssErrorClass="form-control is-invalid" required="true" placeholder="Ví dụ: TP. Hồ Chí Minh"/>
                        <form:errors path="deliveryAddress.cityProvince" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="col-12">
                        <form:label path="notes" cssClass="form-label fw-bold">Ghi chú cho đơn hàng:</form:label>
                        <form:textarea path="notes" cssClass="form-control" rows="3"/>
                    </div>
                    <div class="col-12">
                        <h5 class="mb-3">Phương thức thanh toán</h5>
                        <div class="form-check">
                            <form:radiobutton path="paymentMethod" id="cod" value="CASH_ON_DELIVERY" checked="true" cssClass="form-check-input"/>
                            <label class="form-check-label" for="cod">Thanh toán khi nhận hàng</label>
                        </div>
                    </div>
                </div>

                <hr class="my-4">
                <button class="w-100 btn btn-primary btn-lg" type="submit">
                    <i class="bi bi-cart-check-fill"></i> Xác Nhận Đặt Hàng
                </button>
            </form:form>
        </div>
    </div>
</div>