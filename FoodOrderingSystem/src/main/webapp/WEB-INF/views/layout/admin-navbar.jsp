<%-- 
    Document   : admin-navbar
    Created on : May 29, 2025, 3:17:45 PM
    Author     : MSI-ADMIN
--%>

<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-egg-fried"></i> 
            ${not empty projectArtifactId ? projectArtifactId : 'YourApp'} <%-- Thay YourApp bằng tên project của bạn --%>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainAppNavbar" 
                aria-controls="mainAppNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainAppNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link <c:if test='${pageContext.request.requestURI.endsWith("/") || pageContext.request.requestURI.endsWith("/index.jsp") || pageContext.request.requestURI.endsWith(pageContext.request.contextPath.concat("/"))}'>active</c:if>" 
                       aria-current="page" href="${pageContext.request.contextPath}/">
                        <i class="bi bi-house-door"></i> Trang Chủ
                    </a>
                </li>
                <%-- Thêm các mục menu khác của bạn tại đây --%>
                <c:if test="${not empty sessionScope.loggedInUser}">
                    <li class="nav-item">
                        <a class="nav-link <c:if test='${pageContext.request.requestURI.contains("/restaurants/list")}'>active</c:if>" 
                           href="${pageContext.request.contextPath}/restaurants/list">
                            <i class="bi bi-shop"></i> Nhà Hàng
                        </a>
                    </li>
                </c:if>
            </ul>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userActionsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle"></i> 
                                <c:out value="${sessionScope.loggedInUser.fullName != null && !sessionScope.loggedInUser.fullName.isEmpty() ? sessionScope.loggedInUser.fullName : sessionScope.loggedInUser.username}"/>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userActionsDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a></li>
                                <li><a class="dropdown-item" href="#"><i class="bi bi-person-vcard"></i> Tài khoản của tôi</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/logout">
                                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link <c:if test='${pageContext.request.requestURI.contains("/user/login")}'>active</c:if>" 
                               href="${pageContext.request.contextPath}/user/login">
                                <i class="bi bi-box-arrow-in-right"></i> Đăng Nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <c:if test='${pageContext.request.requestURI.contains("/user/register")}'>active</c:if>" 
                               href="${pageContext.request.contextPath}/user/register">
                                <i class="bi bi-person-plus"></i> Đăng Ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
