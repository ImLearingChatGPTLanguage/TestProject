<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="card shadow-sm">
                <div class="card-header <c:choose><c:when test='${empty menuItem.itemId or menuItem.itemId eq 0}'>bg-success</c:when><c:otherwise>bg-info</c:otherwise></c:choose> text-white">
                            <h2 class="card-title mb-0">
                                <i class="bi bi-egg-fried"></i>
                        <c:out value="${not empty pageTitle ? pageTitle : (empty menuItem.itemId or menuItem.itemId eq 0 ? 'Thêm Món Ăn Mới (Admin)' : 'Chỉnh Sửa Món Ăn (Admin)')}"/>
                        <c:if test="${not empty restaurant}">
                            <small class="fs-6">- Cho nhà hàng: <c:out value="${restaurant.name}"/></small>
                        </c:if>
                    </h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty globalError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <c:out value="${globalError}"/>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>

                    <form:form modelAttribute="menuItem" method="post"
                               action="${pageContext.request.contextPath}/admin/restaurant/${restaurant.restaurantId}/menu/save"
                               enctype="multipart/form-data">

                        <form:hidden path="itemId"/>
                        <form:hidden path="restaurant.restaurantId"/>

                        <div class="mb-3">
                            <form:label path="name" cssClass="form-label fw-bold">Tên Món Ăn:</form:label>
                            <form:input path="name" cssClass="form-control" cssErrorClass="form-control is-invalid" />
                            <form:errors path="name" cssClass="invalid-feedback d-block"/>
                        </div>

                        <div class="mb-3">
                            <form:label path="description" cssClass="form-label fw-bold">Mô tả:</form:label>
                            <form:textarea path="description" cssClass="form-control" cssErrorClass="form-control is-invalid" rows="3"/>
                            <form:errors path="description" cssClass="invalid-feedback d-block"/>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <form:label path="price" cssClass="form-label fw-bold">Giá (VNĐ):</form:label>
                                <form:input path="price" type="number" step="1000" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                                <form:errors path="price" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="categoryId" class="form-label fw-bold">Danh mục:</label>
                                <form:select path="category.categoryId" cssClass="form-select" cssErrorClass="form-select is-invalid" id="categoryId">
                                    <form:option value="" label="-- Chọn Danh mục --"/>
                                    <form:options items="${allCategories}" itemValue="categoryId" itemLabel="name"/>
                                </form:select>
                                <form:errors path="category.categoryId" cssClass="invalid-feedback d-block"/>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="menuImageFile" class="form-label fw-bold">Upload Hình Ảnh:</label>
                            <input type="file" name="menuImageFile" id="menuImageFile" class="form-control">
                            <c:if test="${not empty menuItem.imageUrl}">
                                <small class="form-text text-muted">Ảnh hiện tại:
                                    <a href="${pageContext.request.contextPath}${menuItem.imageUrl}" target="_blank">Xem ảnh</a>
                                </small>
                                <form:hidden path="imageUrl"/>
                            </c:if>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <form:label path="preparationTimeMinutes" cssClass="form-label fw-bold">Thời gian chuẩn bị (phút):</form:label>
                                <form:input path="preparationTimeMinutes" type="number" min="0" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                                <form:errors path="preparationTimeMinutes" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="col-md-6 mb-3 align-self-center">
                                <div class="form-check mt-4">
                                    <form:checkbox path="available" id="itemIsAvailable" cssClass="form-check-input"/>
                                    <form:label path="available" for="itemIsAvailable" cssClass="form-check-label fw-bold">Có sẵn (Còn hàng)</form:label>
                                    </div>
                                </div>
                            </div>

                            <hr class="my-4">

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="bi bi-save"></i>
                                <c:choose>
                                    <c:when test="${empty menuItem.itemId or menuItem.itemId eq 0}">Thêm Món</c:when>
                                    <c:otherwise>Cập Nhật Món</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/restaurant/${restaurant.restaurantId}/menu/list" class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle"></i> Hủy Bỏ
                            </a>
                        </div>
                    </form:form>
                </div>
            </div>
        </div>
    </div>
</div>