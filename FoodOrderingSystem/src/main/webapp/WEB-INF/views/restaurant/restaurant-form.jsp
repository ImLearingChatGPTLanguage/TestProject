<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="card shadow-sm">
                <div class="card-header <c:choose><c:when test='${empty restaurant.restaurantId or restaurant.restaurantId eq 0}'>bg-success</c:when><c:otherwise>bg-info</c:otherwise></c:choose> text-white">
                            <h2 class="card-title mb-0">
                                <i class="bi bi-shop-window"></i> 
                        <c:choose>
                            <c:when test="${empty restaurant.restaurantId or restaurant.restaurantId eq 0}">Đăng Ký Nhà Hàng Mới</c:when>
                            <c:otherwise>Chỉnh Sửa Thông Tin Nhà Hàng</c:otherwise>
                        </c:choose>
                    </h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty restaurant.name && (restaurant.restaurantId != null && restaurant.restaurantId ne 0)}">
                        <p class="text-muted">Đang chỉnh sửa cho nhà hàng: <strong><c:out value="${restaurant.name}"/></strong> (ID: <c:out value="${restaurant.restaurantId}"/>)</p>
                    </c:if>

                    <c:if test="${not empty globalError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${globalError}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <form:form modelAttribute="restaurant" method="post" 
                               action="${pageContext.request.contextPath}/restaurants/manage/save"
                               enctype="multipart/form-data">

                        <form:hidden path="restaurantId"/>
                        <form:hidden path="ownerUser.userId"/>
                        <form:hidden path="address.addressId"/>
                        <form:hidden path="address.user.userId"/>
                        <form:hidden path="address.addressType" value="RESTAURANT"/>

                        <fieldset class="mb-4 p-3 border rounded">
                            <legend class="w-auto px-2 fs-5">Thông Tin Nhà Hàng Cơ Bản</legend>
                            <div class="mb-3">
                                <form:label path="name" cssClass="form-label fw-bold">Tên Nhà Hàng:</form:label>
                                <form:input path="name" cssClass="form-control" cssErrorClass="form-control is-invalid" />
                                <form:errors path="name" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="description" cssClass="form-label fw-bold">Mô tả ngắn:</form:label>
                                <form:textarea path="description" cssClass="form-control" cssErrorClass="form-control is-invalid" rows="3"/>
                                <form:errors path="description" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <form:label path="phoneNumber" cssClass="form-label fw-bold">Số điện thoại:</form:label>
                                    <form:input path="phoneNumber" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                                    <form:errors path="phoneNumber" cssClass="invalid-feedback d-block"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <form:label path="operatingHours" cssClass="form-label fw-bold">Giờ hoạt động:</form:label>
                                    <form:input path="operatingHours" cssClass="form-control" cssErrorClass="form-control is-invalid" placeholder="Ví dụ: 07:00 AM - 10:00 PM"/>
                                    <form:errors path="operatingHours" cssClass="invalid-feedback d-block"/>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="logoImageFile" class="form-label fw-bold">Upload Ảnh Logo:</label>
                                <input type="file" name="logoImageFile" id="logoImageFile" class="form-control">
                                <c:if test="${not empty restaurant.logoImageUrl}">
                                    <small class="form-text text-muted">Ảnh hiện tại: 
                                        <a href="${pageContext.request.contextPath}${restaurant.logoImageUrl}" target="_blank">Xem ảnh</a>
                                    </small>
                                    <form:hidden path="logoImageUrl"/>
                                </c:if>
                            </div>
                            <div class="mb-3">
                                <label for="coverImageFile" class="form-label fw-bold">Upload Ảnh Bìa:</label>
                                <input type="file" name="coverImageFile" id="coverImageFile" class="form-control">
                                <c:if test="${not empty restaurant.coverImageUrl}">
                                    <small class="form-text text-muted">Ảnh hiện tại: 
                                        <a href="${pageContext.request.contextPath}${restaurant.coverImageUrl}" target="_blank">Xem ảnh</a>
                                    </small>
                                    <form:hidden path="coverImageUrl"/>
                                </c:if>
                            </div>
                        </fieldset>

                        <fieldset class="mb-4 p-3 border rounded">
                            <legend class="w-auto px-2 fs-5">Địa Chỉ Nhà Hàng</legend>
                            <div class="mb-3">
                                <form:label path="address.streetAddress" cssClass="form-label fw-bold">Số nhà, Đường:</form:label>
                                <form:input path="address.streetAddress" cssClass="form-control" cssErrorClass="form-control is-invalid" />
                                <form:errors path="address.streetAddress" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="address.ward" cssClass="form-label fw-bold">Phường/Xã:</form:label>
                                <form:input path="address.ward" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                                <form:errors path="address.ward" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <form:label path="address.district" cssClass="form-label fw-bold">Quận/Huyện:</form:label>
                                    <form:input path="address.district" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                                    <form:errors path="address.district" cssClass="invalid-feedback d-block"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <form:label path="address.cityProvince" cssClass="form-label fw-bold">Tỉnh/Thành phố:</form:label>
                                    <form:input path="address.cityProvince" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                                    <form:errors path="address.cityProvince" cssClass="invalid-feedback d-block"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <form:label path="address.postalCode" cssClass="form-label fw-bold">Mã bưu điện:</form:label>
                                    <form:input path="address.postalCode" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                                    <form:errors path="address.postalCode" cssClass="invalid-feedback d-block"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <form:label path="address.country" cssClass="form-label fw-bold">Quốc gia:</form:label>
                                    <form:input path="address.country" cssClass="form-control" readonly="true" value="Vietnam"/>
                                    <form:errors path="address.country" cssClass="invalid-feedback d-block"/>
                                </div>
                            </div>
                        </fieldset>

                        <hr class="my-4">
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="bi bi-save"></i> 
                                <c:choose>
                                    <c:when test="${empty restaurant.restaurantId or restaurant.restaurantId eq 0}">Đăng Ký Nhà Hàng</c:when>
                                    <c:otherwise>Cập Nhật Thông Tin</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/restaurants/list" class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle"></i> Hủy Bỏ
                            </a>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>