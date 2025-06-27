package com.mycompany.foodorderingsystem.repository;

import com.mycompany.foodorderingsystem.model.Order;
import java.math.BigDecimal;
import java.sql.Timestamp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByCustomerUser_UserId(Long customerUserId);

    List<Order> findByRestaurant_RestaurantId(Long restaurantId);

    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.orderStatus = 'COMPLETED'")
    BigDecimal calculateTotalRevenue();

    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.orderStatus = 'COMPLETED' AND o.orderDatetime BETWEEN :startDate AND :endDate")
    BigDecimal calculateRevenueBetweenDates(@Param("startDate") Timestamp startDate, @Param("endDate") Timestamp endDate);

    long countByOrderStatusAndOrderDatetimeBetween(String orderStatus, Timestamp startDate, Timestamp endDate);

    @Query(value = "SELECT CAST(order_datetime AS DATE) AS orderDate, SUM(total_amount) AS dailyRevenue "
            + "FROM orders "
            + "WHERE order_status = 'COMPLETED' AND order_datetime BETWEEN :startDate AND :endDate "
            + "GROUP BY CAST(order_datetime AS DATE) "
            + "ORDER BY CAST(order_datetime AS DATE)", nativeQuery = true)
    List<Object[]> findDailyRevenueBetweenDates(@Param("startDate") Timestamp startDate, @Param("endDate") Timestamp endDate);
}
