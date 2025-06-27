package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Address;
import com.mycompany.foodorderingsystem.model.Order;
import com.mycompany.foodorderingsystem.model.OrderItem;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.repository.AddressRepository;
import com.mycompany.foodorderingsystem.repository.OrderItemRepository;
import com.mycompany.foodorderingsystem.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private AddressRepository addressRepository;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Order placeOrder(Order order, Map<Long, OrderItem> cartItems) throws Exception {
        if (cartItems == null || cartItems.isEmpty()) {
            throw new Exception("Giỏ hàng không được để trống.");
        }

        Address deliveryAddress = order.getDeliveryAddress();
        deliveryAddress.setUser(order.getCustomerUser());
        deliveryAddress.setAddressType("SHIPPING");
        Address savedAddress = addressRepository.save(deliveryAddress);
        order.setDeliveryAddress(savedAddress);

        OrderItem firstItem = cartItems.values().iterator().next();
        Restaurant restaurant = firstItem.getMenuItem().getRestaurant();
        order.setRestaurant(restaurant);

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItem item : cartItems.values()) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        BigDecimal deliveryFee = new BigDecimal("15000");
        order.setDeliveryFee(deliveryFee);
        order.setTotalAmount(totalAmount.add(deliveryFee));
        order.setOrderStatus("PENDING");
        order.setPaymentStatus("PENDING");

        order.setOrderDatetime(new java.sql.Timestamp(System.currentTimeMillis()));

        Order savedOrder = orderRepository.save(order);

        List<OrderItem> orderItems = new ArrayList<>(cartItems.values());
        for (OrderItem item : orderItems) {
            item.setOrder(savedOrder);
        }

        orderItemRepository.saveAll(orderItems);
        savedOrder.setOrderItems(orderItems);

        return savedOrder;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> getOrderHistory(Long customerId) {
        List<Order> orders = orderRepository.findByCustomerUser_UserId(customerId);
        for (Order order : orders) {
            order.getRestaurant().getName();
            for (OrderItem item : order.getOrderItems()) {
                item.getMenuItem().getName();
            }
        }
        return orders;
    }

    @Override
    public List<Order> getAllOrders() {
        return orderRepository.findAll(
                org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "orderDatetime")
        );
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Order> getOrderById(Long orderId) {
        Optional<Order> orderOpt = orderRepository.findById(orderId);

        if (orderOpt.isPresent()) {
            Order order = orderOpt.get();
            order.getOrderItems().size();
            for (OrderItem item : order.getOrderItems()) {
                item.getMenuItem().getName();
            }
        }

        return orderOpt;
    }

    @Override
    @Transactional
    public Order updateOrderStatus(Long orderId, String newStatus) throws Exception {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new Exception("Không tìm thấy đơn hàng với ID: " + orderId));

        order.setOrderStatus(newStatus);
        if ("COMPLETED".equalsIgnoreCase(newStatus)) {
            order.setActualDeliveryTime(new java.sql.Timestamp(System.currentTimeMillis()));
        }

        return orderRepository.save(order);
    }

    @Override
    public long countTotalOrders() {
        return orderRepository.count();
    }

    @Override
    public BigDecimal getTotalRevenue() {
        return orderRepository.calculateTotalRevenue();
    }

    @Override
    @Transactional
    public Order confirmOrderReceived(Long orderId, Long customerId) throws Exception {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new Exception("Không tìm thấy đơn hàng với ID: " + orderId));

        if (!order.getCustomerUser().getUserId().equals(customerId)) {
            throw new Exception("Bạn không có quyền xác nhận đơn hàng này.");
        }

        if (!"DELIVERING".equalsIgnoreCase(order.getOrderStatus())) {
            throw new Exception("Chỉ có thể xác nhận khi đơn hàng ở trạng thái 'Đang giao hàng'.");
        }

        order.setOrderStatus("COMPLETED");
        order.setActualDeliveryTime(new java.sql.Timestamp(System.currentTimeMillis()));

        return orderRepository.save(order);
    }

    @Override
    public BigDecimal getRevenueForPeriod(Timestamp startDate, Timestamp endDate) {
        return orderRepository.calculateRevenueBetweenDates(startDate, endDate);
    }

    @Override
    public long getOrderCountForPeriod(Timestamp startDate, Timestamp endDate) {
        return orderRepository.countByOrderStatusAndOrderDatetimeBetween("COMPLETED", startDate, endDate);
    }

    @Override
    public List<Object[]> getDailyRevenueForPeriod(Timestamp startDate, Timestamp endDate) {
        return orderRepository.findDailyRevenueBetweenDates(startDate, endDate);
    }
}
