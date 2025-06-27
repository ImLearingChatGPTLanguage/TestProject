package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.MenuItem;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface MenuItemService {

    MenuItem addMenuItemToRestaurant(Long restaurantId, MenuItem menuItem) throws Exception;

    Optional<MenuItem> getMenuItemById(Long itemId);

    List<MenuItem> getAllMenuItemsByRestaurantId(Long restaurantId);

    List<MenuItem> getAvailableMenuItemsByRestaurantId(Long restaurantId);

    List<MenuItem> getMenuItemsByRestaurantAndCategory(Long restaurantId, Long categoryId);

    MenuItem updateMenuItem(MenuItem menuItem) throws Exception;

    void deleteMenuItem(Long itemId, Long restaurantId) throws Exception;

    void setMenuItemAvailability(Long itemId, Long restaurantId, boolean isAvailable) throws Exception;

    MenuItem saveOrUpdateMenuItem(MenuItem menuItem) throws Exception;

    Map<String, List<MenuItem>> getAvailableMenuItemsGroupedByCategory(Long restaurantId);
}
