<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h2">${not empty pageTitle ? pageTitle : 'Khám Phá Nhà Hàng'}</h1>
        <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/restaurants/manage/add" class="btn btn-success">
                <i class="bi bi-plus-circle-fill"></i> Đăng Ký/Thêm Nhà Hàng
            </a>
        </c:if>
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

    <div class="row">
        <c:choose>
            <c:when test="${not empty restaurants}">
                <c:forEach var="restaurant" items="${restaurants}">
                    <div class="col-md-6 col-lg-4 mb-4 d-flex align-items-stretch">
                        <div class="card h-100 shadow-sm w-100">
                            <c:choose>
                                <c:when test="${not empty restaurant.coverImageUrl}">
                                    <c:choose>
                                        <c:when test="${restaurant.coverImageUrl.startsWith('http')}">
                                            <img src="${restaurant.coverImageUrl}" class="card-img-top" alt="<c:out value="${restaurant.name}"/>" style="height: 200px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}${restaurant.coverImageUrl}" class="card-img-top" alt="<c:out value="${restaurant.name}"/>" style="height: 200px; object-fit: cover;">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/400x200.png?text=${restaurant.name}" class="card-img-top" alt="Default Restaurant Image" style="height: 200px; object-fit: cover;">
                                </c:otherwise>
                            </c:choose>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><c:out value="${restaurant.name}"/></h5>
                                <p class="card-text text-muted small flex-grow-1">
                                    <c:choose>
                                        <c:when test="${restaurant.description != null && restaurant.description.length() > 100}">
                                            <c:out value="${restaurant.description.substring(0, 100)}"/>...
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${restaurant.description}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="card-text mb-1">
                                    <small class="text-muted">
                                        <i class="bi bi-geo-alt-fill text-danger"></i> 
                                        <c:if test="${not empty restaurant.address && not empty restaurant.address.streetAddress}">
                                            <c:out value="${restaurant.address.streetAddress}"/>, <c:out value="${restaurant.address.district}"/>, <c:out value="${restaurant.address.cityProvince}"/>
                                        </c:if>
                                        <c:if test="${empty restaurant.address || empty restaurant.address.streetAddress}">
                                            Địa chỉ không có sẵn
                                        </c:if>
                                    </small>
                                </p>
                                <p class="card-text mb-1">
                                    <small class="text-muted"><i class="bi bi-clock-fill"></i> <c:out value="${restaurant.operatingHours}"/></small>
                                </p>
                                <p class="card-text">
                                    <small class="text-muted">Đánh giá: 
                                        <c:forEach begin="1" end="5" varStatus="loop">
                                            <i class="bi <c:choose><c:when test="${restaurant.averageRating >= loop.index}">bi-star-fill text-warning</c:when><c:when test="${restaurant.averageRating >= loop.index - 0.5}">bi-star-half text-warning</c:when><c:otherwise>bi-star text-warning</c:otherwise></c:choose>"></i>
                                        </c:forEach>
                                        (<c:out value="${restaurant.averageRating != null && restaurant.averageRating > 0 ? restaurant.averageRating : 'Chưa có'}"/>)
                                    </small>
                                </p>
                                <a href="${pageContext.request.contextPath}/restaurants/menu/${restaurant.restaurantId}" class="btn btn-primary mt-auto w-100">
                                    <i class="bi bi-book-half"></i> Xem Thực Đơn & Đặt Món
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col">
                    <div class="alert alert-info mt-3" role="alert">
                        Hiện tại không có nhà hàng nào được duyệt và hoạt động.
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>