<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
        <title><c:out value="${not empty pageTitle ? pageTitle : 'Dashboard'}"/> - FoodOrderingSystem</title>
        <link href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/pace.min.css" rel="stylesheet"/>
        <link rel="icon" href="${pageContext.request.contextPath}/resources/admin-theme/assets/images/favicon.ico" type="image/x-icon">
        <link href="${pageContext.request.contextPath}/resources/admin-theme/assets/plugins/simplebar/css/simplebar.css" rel="stylesheet"/>
        <link href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/bootstrap.min.css" rel="stylesheet"/>
        <link href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/animate.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/icons.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/sidebar-menu.css" rel="stylesheet"/>
        <link href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/app-style.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <style>
            html, body {
                height: 100%;
                margin: 0;
            }
            #wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .content-wrapper {
                flex: 1 0 auto;
                padding-bottom: 60px;
            }
            .footer {
                flex-shrink: 0;
            }

            .form-select, .custom-select {
                color: #ffffff;
                background-color: rgba(0, 0, 0, 0.2);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .form-select option, .custom-select option {
                background-color: #2e3b50;
                color: #ffffff;
            }
        </style>
    </head>
    <body class="bg-theme bg-theme1">
        <div id="wrapper">