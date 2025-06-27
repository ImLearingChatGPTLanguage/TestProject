<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
    <h1 class="h2">${pageTitle}</h1>
</div>

<%-- Form chọn khoảng thời gian --%>
<div class="card mb-4">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/admin/reports" method="GET" class="row g-3 align-items-center">
            <div class="col-md-5">
                <label for="startDate" class="form-label">Từ ngày</label>
                <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}">
            </div>
            <div class="col-md-5">
                <label for="endDate" class="form-label">Đến ngày</label>
                <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Xem Báo cáo</button>
            </div>
        </form>
    </div>
</div>

<%-- Khu vực hiển thị kết quả thống kê --%>
<div class="row">
    <div class="col-md-4 mb-4">
        <div class="card text-white bg-success">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="me-3">
                        <div class="text-white-75 small">Doanh thu (${startDate} - ${endDate})</div>
                        <div class="text-lg fw-bold">
                            <fmt:formatNumber value="${revenueForPeriod}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </div>
                    </div>
                    <i class="fa fa-usd fa-2x text-white-50"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-4">
        <div class="card text-white bg-primary">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="me-3">
                        <div class="text-white-75 small">Đơn hàng hoàn thành</div>
                        <div class="text-lg fw-bold">${ordersForPeriod}</div>
                    </div>
                    <i class="fa fa-shopping-cart fa-2x text-white-50"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4 mb-4">
        <div class="card text-white bg-warning">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="me-3">
                        <div class="text-white-75 small">Người dùng mới</div>
                        <div class="text-lg fw-bold">${newUsersForPeriod}</div>
                    </div>
                    <i class="fa fa-users fa-2x text-white-50"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Khu vực hiển thị biểu đồ --%>
<div class="card">
    <div class="card-header">
        Biểu đồ Doanh thu theo ngày
    </div>
    <div class="card-body">
        <canvas id="revenueChart"></canvas>
    </div>
</div>

<%-- Script để vẽ biểu đồ --%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Lấy dữ liệu từ model mà controller đã truyền sang
        const labels = JSON.parse('${chartLabels}');
        const data = JSON.parse('${chartData}');

        const ctx = document.getElementById('revenueChart').getContext('2d');

        const revenueChart = new Chart(ctx, {
            type: 'line', // Loại biểu đồ: đường
            data: {
                labels: labels, // Nhãn cho trục X (các ngày)
                datasets: [{
                        label: 'Doanh thu',
                        data: data, // Dữ liệu cho trục Y (doanh thu)
                        fill: true,
                        borderColor: 'rgb(75, 192, 192)',
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        tension: 0.1
                    }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            // Định dạng số trên trục Y thành tiền tệ VNĐ
                            callback: function (value, index, values) {
                                return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(value);
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            // Định dạng số trong ô tooltip khi di chuột vào
                            label: function (context) {
                                let label = context.dataset.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.parsed.y !== null) {
                                    label += new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(context.parsed.y);
                                }
                                return label;
                            }
                        }
                    }
                }
            }
        });
    });
</script>