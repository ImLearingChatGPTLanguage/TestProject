<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${pageTitle}</h1>
</div>

<c:if test="${not empty globalError}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <c:out value="${globalError}"/>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
</c:if>

<div class="card">
    <div class="card-body">
        <form:form action="${pageContext.request.contextPath}/admin/categories/save" 
                   method="post" 
                   modelAttribute="category"
                   enctype="multipart/form-data">

            <form:hidden path="categoryId"/>

            <div class="mb-3">
                <label for="name" class="form-label fw-bold">Tên Danh Mục:</label>
                <form:input path="name" cssClass="form-control" cssErrorClass="form-control is-invalid" required="true"/>
                <form:errors path="name" cssClass="invalid-feedback d-block"/>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label fw-bold">Mô tả:</label>
                <form:textarea path="description" cssClass="form-control" cssErrorClass="form-control is-invalid" rows="3"/>
                <form:errors path="description" cssClass="invalid-feedback d-block"/>
            </div>

            <div class="mb-3">
                <label for="categoryImageFile" class="form-label fw-bold">Upload Hình ảnh:</label>
                <input type="file" name="categoryImageFile" id="categoryImageFile" class="form-control">
                <c:if test="${not empty category.imageUrl}">
                    <small class="form-text text-muted">Ảnh hiện tại: 
                        <a href="${pageContext.request.contextPath}${category.imageUrl}" target="_blank">Xem ảnh</a>
                    </small>
                    <form:hidden path="imageUrl"/>
                </c:if>
            </div>

            <hr>
            <button type="submit" class="btn btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/categories/list" class="btn btn-secondary">Hủy</a>
        </form:form>
    </div>
</div>