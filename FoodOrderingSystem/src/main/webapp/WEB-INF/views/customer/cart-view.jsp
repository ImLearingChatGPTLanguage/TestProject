<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2">${not empty pageTitle ? pageTitle : 'Giỏ Hàng Của Bạn'}</h1>
    </div>

    <c:if test="${not empty globalMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill"></i> <c:out value="${globalMessage}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>
    <c:if test="${not empty globalError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i> <c:out value="${globalError}"/>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty sessionScope.cart and not empty sessionScope.cart.values()}">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">Bạn có <c:out value="${sessionScope.cart.size()}"/> sản phẩm trong giỏ hàng</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                                <tr>
                                    <th scope="col" style="width: 50%;">Sản phẩm</th>
                                    <th scope="col" class="text-center">Đơn giá</th>
                                    <th scope="col" class="text-center" style="width: 15%;">Số lượng</th>
                                    <th scope="col" class="text-end">Thành tiền</th>
                                    <th scope="col" class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="grandTotal" value="0" />
                                <c:forEach var="entry" items="${sessionScope.cart}">
                                    <c:set var="orderItem" value="${entry.value}" />
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${not empty orderItem.menuItem.imageUrl}">
                                                        <c:choose>
                                                            <c:when test="${orderItem.menuItem.imageUrl.startsWith('http')}">
                                                                <img src="${orderItem.menuItem.imageUrl}" alt="${orderItem.menuItem.name}" class="img-fluid rounded me-3" style="width: 80px; height: 80px; object-fit: cover;">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="${pageContext.request.contextPath}${orderItem.menuItem.imageUrl}" alt="${orderItem.menuItem.name}" class="img-fluid rounded me-3" style="width: 80px; height: 80px; object-fit: cover;">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/80x80.png?text=N/A" alt="No Image" class="img-fluid rounded me-3" style="width: 80px; height: 80px; object-fit: cover;">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <h6 class="mb-0">${orderItem.menuItem.name}</h6>
                                                    <small class="text-muted">${orderItem.menuItem.restaurant.name}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatNumber value="${orderItem.pricePerItem}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-flex justify-content-center">
                                                <input type="hidden" name="itemId" value="${orderItem.menuItem.itemId}" />
                                                <input type="number" name="quantity" class="form-control form-control-sm text-center" value="${orderItem.quantity}" min="1" style="width: 60px;">
                                                <button type="submit" class="btn btn-sm btn-outline-secondary ms-2" title="Cập nhật"><i class="bi bi-arrow-repeat"></i></button>
                                            </form>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${orderItem.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center">
                                            <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                                <input type="hidden" name="itemId" value="${orderItem.menuItem.itemId}" />
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Xóa"><i class="bi bi-trash"></i></button>
                                            </form>
                                        </td>
                                    </tr>
                                    <c:set var="grandTotal" value="${grandTotal + orderItem.subtotal}" />
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr class="fw-bold">
                                    <td colspan="3" class="text-end">Tổng cộng:</td>
                                    <td class="text-end fs-5 text-danger">
                                        <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                <div class="card-footer d-flex justify-content-between align-items-center">
                    <a href="${pageContext.request.contextPath}/restaurants/list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Tiếp tục mua sắm
                    </a>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg">
                        Tiến hành Thanh toán <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center p-5">
                <i class="bi bi-cart-x" style="font-size: 5rem; color: #6c757d;"></i>
                <h3 class="mt-3">Giỏ hàng của bạn đang trống.</h3>
                <p class="text-muted">Hãy bắt đầu khám phá các món ăn ngon từ nhà hàng của chúng tôi!</p>
                <a href="${pageContext.request.contextPath}/restaurants/list" class="btn btn-primary mt-3">
                    <i class="bi bi-search"></i> Bắt đầu mua sắm
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>