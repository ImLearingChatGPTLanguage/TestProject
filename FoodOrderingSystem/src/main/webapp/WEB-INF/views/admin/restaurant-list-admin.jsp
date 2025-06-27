<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${not empty pageTitle ? pageTitle : 'Restaurant Management (Admin)'}</h1>
    <div class="btn-toolbar mb-2 mb-md-0">
        <a href="${pageContext.request.contextPath}/restaurants/manage/add" class="btn btn-sm btn-success">
            <i class="bi bi-plus-circle-fill"></i> Thêm Nhà Hàng Mới
        </a>
    </div>
</div>

<div class="mb-3">
    <form action="${pageContext.request.contextPath}/admin/restaurants/list" method="GET" class="row g-3 align-items-center">
        <div class="col-auto">
            <label for="restaurantKeyword" class="visually-hidden">Từ khóa</label>
            <input type="search" class="form-control form-control-sm" id="restaurantKeyword" name="keyword" 
                   placeholder="Nhập tên hoặc ID nhà hàng..." value="<c:out value='${searchKeyword}'/>">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-sm btn-primary">
                <i class="bi bi-search"></i> Tìm Kiếm
            </button>
            <c:if test="${not empty searchKeyword}">
                <a href="${pageContext.request.contextPath}/admin/restaurants/list" class="btn btn-sm btn-outline-secondary ms-2">
                    <i class="bi bi-x-lg"></i> Xóa tìm kiếm
                </a>
            </c:if>
        </div>
    </form>
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

<div class="card">
    <div class="card-header">
        <c:choose>
            <c:when test="${not empty searchKeyword}">
                Kết quả tìm kiếm cho "<c:out value="${searchKeyword}"/>"
            </c:when>
            <c:otherwise>
                Danh sách tất cả nhà hàng trong hệ thống
            </c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <c:if test="${not empty restaurants}">
                <table class="table table-striped table-hover table-bordered align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Tên Nhà Hàng</th>
                            <th>Chủ Sở Hữu (User ID)</th>
                            <th>Địa chỉ</th>
                            <th>Điện thoại</th>
                            <th>Đã Duyệt</th>
                            <th>Hoạt động</th>
                            <th style="min-width: 380px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="restaurant" items="${restaurants}">
                            <tr>
                                <td><c:out value="${restaurant.restaurantId}" /></td>
                                <td>
                                    <strong><c:out value="${restaurant.name}" /></strong><br>
                                    <small class="text-muted"><c:out value="${restaurant.description}"/></small>
                                </td>
                                <td><c:out value="${restaurant.ownerUser.userId}" /></td>
                                <td>
                                    <c:if test="${not empty restaurant.address}">
                                        <small>
                                            <c:out value="${restaurant.address.streetAddress}"/><br>
                                            <c:out value="${restaurant.address.district}"/>, <c:out value="${restaurant.address.cityProvince}"/>
                                        </small>
                                    </c:if>
                                    <c:if test="${empty restaurant.address}">
                                        <small class="text-muted">Chưa có</small>
                                    </c:if>
                                </td>
                                <td><c:out value="${restaurant.phoneNumber}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${restaurant.approved}">
                                            <span class="badge bg-success">Đã Duyệt</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark">Chờ Duyệt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${restaurant.active}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="action-buttons">
                                    <a href="${pageContext.request.contextPath}/admin/restaurant/${restaurant.restaurantId}/menu/list" class="btn btn-secondary btn-sm" title="Quản lý thực đơn">
                                        <i class="bi bi-list-stars"></i> Menu
                                    </a>
                                    <c:choose>
                                        <c:when test="${!restaurant.approved}">
                                            <form:form method="post" action="${pageContext.request.contextPath}/admin/restaurants/approve/${restaurant.restaurantId}" style="display:inline-block; margin-left:5px;">
                                                <input type="hidden" name="approve" value="true"/>
                                                <button type="submit" class="btn btn-primary btn-sm" onclick="return confirm('Duyệt nhà hàng \'${restaurant.name}\'?');">
                                                    <i class="bi bi-check-lg"></i> Duyệt
                                                </button>
                                            </form:form>
                                        </c:when>
                                        <c:otherwise>
                                            <form:form method="post" action="${pageContext.request.contextPath}/admin/restaurants/approve/${restaurant.restaurantId}" style="display:inline-block; margin-left:5px;">
                                                <input type="hidden" name="approve" value="false"/>
                                                <button type="submit" class="btn btn-outline-secondary btn-sm" onclick="return confirm('Bỏ duyệt nhà hàng \'${restaurant.name}\'?');">
                                                    <i class="bi bi-x-circle-fill"></i> Bỏ Duyệt
                                                </button>
                                            </form:form>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:choose>
                                        <c:when test="${restaurant.active}">
                                            <form:form method="post" action="${pageContext.request.contextPath}/admin/restaurants/activate/${restaurant.restaurantId}" style="display:inline-block; margin-left:5px;">
                                                <input type="hidden" name="active" value="false"/>
                                                <button type="submit" class="btn btn-warning btn-sm" onclick="return confirm('Vô hiệu hóa nhà hàng \'${restaurant.name}\'?');">
                                                    <i class="bi bi-slash-circle"></i> Vô hiệu hóa
                                                </button>
                                            </form:form>
                                        </c:when>
                                        <c:otherwise>
                                            <form:form method="post" action="${pageContext.request.contextPath}/admin/restaurants/activate/${restaurant.restaurantId}" style="display:inline-block; margin-left:5px;">
                                                <input type="hidden" name="active" value="true"/>
                                                <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Kích hoạt nhà hàng \'${restaurant.name}\'?');">
                                                    <i class="bi bi-check-circle"></i> Kích hoạt
                                                </button>
                                            </form:form>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/restaurants/manage/edit/${restaurant.restaurantId}" class="btn btn-info btn-sm" title="Sửa thông tin nhà hàng" style="margin-left:5px;">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/restaurants/delete/${restaurant.restaurantId}/confirm" class="btn btn-danger btn-sm" title="Xóa Nhà Hàng" style="margin-left:5px;">
                                        <i class="bi bi-trash-fill"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <c:if test="${empty restaurants}">
                <div class="alert alert-info mt-3" role="alert">
                    <c:choose>
                        <c:when test="${not empty searchKeyword}">
                            Không tìm thấy nhà hàng nào khớp với từ khóa "<c:out value="${searchKeyword}"/>".
                        </c:when>
                        <c:otherwise>
                            Hiện tại không có nhà hàng nào trong hệ thống để quản lý.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </div>
</div>