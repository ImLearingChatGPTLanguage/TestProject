<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h2">${pageTitle}</h1>
    <a href="${pageContext.request.contextPath}/admin/categories/add" class="btn btn-success">
        <i class="bi bi-plus-circle"></i> Thêm Danh Mục Mới
    </a>
</div>

<c:if test="${not empty globalMessage}"><div class="alert alert-success">${globalMessage}</div></c:if>
<c:if test="${not empty globalError}"><div class="alert alert-danger">${globalError}</div></c:if>

    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Hình Ảnh</th>
                    <th>Tên Danh Mục</th>
                    <th>Mô tả</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
<c:forEach var="category" items="${categories}">
                <tr>
                    <td>${category.categoryId}</td>
                    <td>
    <c:choose>
        <c:when test="${not empty category.imageUrl}">
            <c:choose>
                <c:when test="${category.imageUrl.startsWith('http')}">
                                        <img src="${category.imageUrl}" alt="${category.name}" style="width: 60px; height: 60px; object-fit: cover; border-radius: .25rem;">
                </c:when>
                <c:otherwise>
                                        <img src="${pageContext.request.contextPath}${category.imageUrl}" alt="${category.name}" style="width: 60px; height: 60px; object-fit: cover; border-radius: .25rem;">
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
                                <img src="https://via.placeholder.com/60x60.png?text=N/A" alt="No Image" style="width: 60px; height: 60px; object-fit: cover; border-radius: .25rem;">
        </c:otherwise>
    </c:choose>
                    </td>
                    <td>${category.name}</td>
                    <td>${category.description}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/categories/edit/${category.categoryId}" class="btn btn-primary btn-sm">Sửa</a>
                        <a href="${pageContext.request.contextPath}/admin/categories/delete/${category.categoryId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa danh mục này?')">Xóa</a>
                    </td>
                </tr>
</c:forEach>
        </tbody>
    </table>
</div>