<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header bg-danger text-white">
                    <h2 class="card-title mb-0"><i class="bi bi-exclamation-triangle-fill"></i> Xác Nhận Xóa Nhà Hàng</h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty restaurantToDelete}">
                        <p class="lead">Bạn có chắc chắn muốn xóa vĩnh viễn nhà hàng sau đây không?</p>
                        <p class="text-danger"><strong>CẢNH BÁO: Hành động này không thể hoàn tác!</strong> Các món ăn liên quan sẽ bị xóa theo. Nếu nhà hàng có đơn hàng, việc xóa có thể bị từ chối.</p>

                        <div class="my-4 p-3 bg-light border rounded">
                            <p><strong>ID Nhà Hàng:</strong> <c:out value="${restaurantToDelete.restaurantId}"/></p>
                            <p><strong>Tên Nhà Hàng:</strong> <c:out value="${restaurantToDelete.name}"/></p>
                            <c:if test="${not empty restaurantToDelete.address}">
                                <p><strong>Địa chỉ:</strong> <c:out value="${restaurantToDelete.address.streetAddress}"/>, <c:out value="${restaurantToDelete.address.district}"/>, <c:out value="${restaurantToDelete.address.cityProvince}"/></p>
                            </c:if>
                        </div>

                        <form:form method="post" action="${pageContext.request.contextPath}/admin/restaurants/delete/${restaurantToDelete.restaurantId}" cssClass="mt-4">
                            <button type="submit" class="btn btn-danger btn-lg me-2">
                                <i class="bi bi-trash-fill"></i> Vâng, Xóa Nhà Hàng
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/restaurants/list" class="btn btn-secondary btn-lg">
                                <i class="bi bi-x-circle"></i> Hủy Bỏ
                            </a>
                        </form:form>
                    </c:if>
                    <c:if test="${empty restaurantToDelete}">
                        <div class="alert alert-warning mt-3" role="alert">
                            Không tìm thấy thông tin nhà hàng để xóa hoặc có lỗi xảy ra.
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/restaurants/list" class="btn btn-primary mt-3">
                            <i class="bi bi-arrow-left-circle"></i> Quay lại Danh sách Nhà Hàng
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>