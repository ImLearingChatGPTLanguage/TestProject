/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Order;
import com.mycompany.foodorderingsystem.model.OrderItem;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 *
 * @author MSI-ADMIN
 */
public interface OrderService {

    Order placeOrder(Order order, Map<Long, OrderItem> cartItems) throws Exception;

    List<Order> getOrderHistory(Long customerId);

    List<Order> getAllOrders();

    Optional<Order> getOrderById(Long orderId);

    Order updateOrderStatus(Long orderId, String newStatus) throws Exception;

    long countTotalOrders();

    BigDecimal getTotalRevenue();

    Order confirmOrderReceived(Long orderId, Long customerId) throws Exception;

    BigDecimal getRevenueForPeriod(Timestamp startDate, Timestamp endDate);

    long getOrderCountForPeriod(Timestamp startDate, Timestamp endDate);

    List<Object[]> getDailyRevenueForPeriod(Timestamp startDate, Timestamp endDate);
}
