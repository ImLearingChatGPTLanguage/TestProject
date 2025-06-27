<%-- 
    Document   : admin-footer
    Created on : May 29, 2025, 12:30:41 AM
    Author     : MSI-ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Food Ordering System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/bootstrap.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin-theme/assets/css/app-style.css" />
    </head>
    <body>

        <div class="wrapper d-flex flex-column min-vh-100">

            <div class="content flex-grow-1">
            </div>
            <footer class="footer mt-auto py-3">
                <div class="container text-center">
                    ${java.time.Year.now().getValue()} FoodOrderingSystem By Nguyễn Quốc Triệu + Nguyễn Minh Hy
                </div>
            </footer>

        </div>
        <a href="javascript:void(0);" class="back-to-top"><i class="fa fa-angle-double-up"></i></a>
        <div class="right-sidebar">
            <div class="switcher-icon">
                <i class="zmdi zmdi-settings zmdi-hc-spin"></i>
            </div>
            <div class="right-sidebar-content">
                <p class="mb-0">Gaussion Texture</p><hr>
                <ul class="switcher">
                    <li id="theme1"></li><li id="theme2"></li><li id="theme3"></li>
                    <li id="theme4"></li><li id="theme5"></li><li id="theme6"></li>
                </ul>
                <p class="mb-0">Gradient Background</p><hr>
                <ul class="switcher">
                    <li id="theme7"></li><li id="theme8"></li><li id="theme9"></li>
                    <li id="theme10"></li><li id="theme11"></li><li id="theme12"></li>
                    <li id="theme13"></li><li id="theme14"></li><li id="theme15"></li>
                </ul>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/plugins/simplebar/js/simplebar.js"></script>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/js/sidebar-menu.js"></script>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/js/app-script.js"></script>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/plugins/Chart.js/Chart.min.js"></script>
        <script src="${pageContext.request.contextPath}/resources/admin-theme/assets/js/pace.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const body = document.body;
                const themeSwitchers = document.querySelectorAll('.right-sidebar .switcher li');

                const savedTheme = localStorage.getItem('foodOrderingTheme');
                if (savedTheme) {
                    for (let i = 1; i <= 15; i++) {
                        body.classList.remove('bg-theme' + i);
                    }
                    body.classList.add(savedTheme);
                }

                themeSwitchers.forEach(function (switcher) {
                    switcher.addEventListener('click', function () {
                        const themeId = this.id;
                        const themeClass = 'bg-' + themeId;

                        localStorage.setItem('foodOrderingTheme', themeClass);

                        for (let i = 1; i <= 15; i++) {
                            body.classList.remove('bg-theme' + i);
                        }
                        body.classList.add(themeClass);
                    });
                });
            });
        </script>

    </body>
</html>
