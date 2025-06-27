<%-- 
    Document   : admin-topbar
    Created on : May 29, 2025, 12:30:14 AM
    Author     : MSI-ADMIN
--%>


<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="topbar-nav">
    <nav class="navbar navbar-expand fixed-top">
        <ul class="navbar-nav mr-auto align-items-center">
            <li class="nav-item">
                <a class="nav-link toggle-menu" href="javascript:void();">
                    <i class="icon-menu menu-icon"></i>
                </a>
            </li>
            <li class="nav-item">
                <form class="search-bar">
                    <input type="text" class="form-control" placeholder="Enter keywords">
                    <a href="javascript:void();"><i class="icon-magnifier"></i></a>
                </form>
            </li>
        </ul>

        <ul class="navbar-nav align-items-center right-nav-link">
            <li class="nav-item dropdown-lg">
                <a class="nav-link dropdown-toggle dropdown-toggle-nocaret waves-effect" data-toggle="dropdown" href="javascript:void();">
                    <i class="fa fa-envelope-open-o"></i>
                </a>
            </li>
            <li class="nav-item dropdown-lg">
                <a class="nav-link dropdown-toggle dropdown-toggle-nocaret waves-effect" data-toggle="dropdown" href="javascript:void();">
                    <i class="fa fa-bell-o"></i>
                </a>
            </li>
            <li class="nav-item language">
                <a class="nav-link dropdown-toggle dropdown-toggle-nocaret waves-effect" data-toggle="dropdown" href="javascript:void();"><i class="fa fa-flag"></i></a>
                <ul class="dropdown-menu dropdown-menu-right">
                    <li class="dropdown-item"> <i class="flag-icon flag-icon-gb mr-2"></i> English</li>
                    <li class="dropdown-item"> <i class="flag-icon flag-icon-fr mr-2"></i> French</li>
                    <li class="dropdown-item"> <i class="flag-icon flag-icon-vn mr-2"></i> Vietnamese</li>
                </ul>
            </li>
            <li class="nav-item">
                <a class="nav-link dropdown-toggle dropdown-toggle-nocaret" data-toggle="dropdown" href="#">
                    <span class="user-profile">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.avatarUrl}">
                                <img src="${pageContext.request.contextPath}${sessionScope.loggedInUser.avatarUrl}" class="img-circle" alt="User Avatar">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/resources/admin-theme/assets/images/placeholder-avatar.png" class="img-circle" alt="Default User Avatar">
                            </c:otherwise>
                        </c:choose>
                    </span>
                </a>
                <ul class="dropdown-menu dropdown-menu-right">
                    <li class="dropdown-item user-details">
                        <a href="javaScript:void();">
                            <div class="media">
                                <div class="avatar">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.loggedInUser.avatarUrl}">
                                            <img class="align-self-start mr-3" src="${pageContext.request.contextPath}${sessionScope.loggedInUser.avatarUrl}" alt="User Avatar">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="align-self-start mr-3" src="${pageContext.request.contextPath}/resources/admin-theme/assets/images/placeholder-avatar.png" alt="Default User Avatar">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="media-body">
                                    <h6 class="mt-2 user-title"><c:out value="${sessionScope.loggedInUser.fullName != null && !sessionScope.loggedInUser.fullName.isEmpty() ? sessionScope.loggedInUser.fullName : sessionScope.loggedInUser.username}"/></h6>
                                    <p class="user-subtitle"><c:out value="${sessionScope.loggedInUser.email}"/></p>
                                </div>
                            </div>
                        </a>
                    </li>
                    <li class="dropdown-divider"></li>
                    <li class="dropdown-item"><i class="icon-wallet mr-2"></i> Account</li>
                    <li class="dropdown-divider"></li>
                    <li class="dropdown-item"><i class="icon-settings mr-2"></i> Setting</li>
                    <li class="dropdown-divider"></li>
                    <li class="dropdown-item">
                        <a href="${pageContext.request.contextPath}/user/logout" style="text-decoration: none; color: inherit;">
                            <i class="icon-power mr-2"></i> Logout
                        </a>
                    </li>
                </ul>
            </li>
        </ul>
    </nav>
</header>
<div class="clearfix"></div>
