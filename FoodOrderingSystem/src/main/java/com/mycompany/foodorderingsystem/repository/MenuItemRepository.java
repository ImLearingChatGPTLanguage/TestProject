package com.mycompany.foodorderingsystem.repository;

import com.mycompany.foodorderingsystem.model.MenuItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {

    List<MenuItem> findAllByRestaurant_RestaurantId(Long restaurantId);

    List<MenuItem> findAllByRestaurant_RestaurantIdAndCategory_CategoryIdAndIsAvailableTrue(Long restaurantId, Long categoryId);
}