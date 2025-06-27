package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.MenuItem;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.repository.MenuItemRepository;
import com.mycompany.foodorderingsystem.repository.RestaurantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class MenuItemServiceImpl implements MenuItemService {

    @Autowired
    private MenuItemRepository menuItemRepository;

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Override
    public MenuItem addMenuItemToRestaurant(Long restaurantId, MenuItem menuItem) throws Exception {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new Exception("Restaurant not found: " + restaurantId));
        menuItem.setRestaurant(restaurant);
        return menuItemRepository.save(menuItem);
    }

    @Override
    public Optional<MenuItem> getMenuItemById(Long itemId) {
        return menuItemRepository.findById(itemId);
    }

    @Override
    public List<MenuItem> getAllMenuItemsByRestaurantId(Long restaurantId) {
        return menuItemRepository.findAllByRestaurant_RestaurantId(restaurantId);
    }

    @Override
    public List<MenuItem> getAvailableMenuItemsByRestaurantId(Long restaurantId) {
        return menuItemRepository.findAllByRestaurant_RestaurantId(restaurantId).stream()
                .filter(MenuItem::isAvailable)
                .collect(Collectors.toList());
    }

    @Override
    public List<MenuItem> getMenuItemsByRestaurantAndCategory(Long restaurantId, Long categoryId) {
        return menuItemRepository.findAllByRestaurant_RestaurantIdAndCategory_CategoryIdAndIsAvailableTrue(restaurantId, categoryId);
    }

    @Override
    public MenuItem updateMenuItem(MenuItem menuItem) throws Exception {
        if (menuItem.getItemId() == null) {
            throw new Exception("MenuItem ID is required for update.");
        }
        MenuItem existingItem = menuItemRepository.findById(menuItem.getItemId())
                .orElseThrow(() -> new Exception("MenuItem not found: " + menuItem.getItemId()));

        existingItem.setName(menuItem.getName());
        existingItem.setDescription(menuItem.getDescription());
        existingItem.setPrice(menuItem.getPrice());
        existingItem.setCategory(menuItem.getCategory());
        existingItem.setImageUrl(menuItem.getImageUrl());
        existingItem.setAvailable(menuItem.isAvailable());
        existingItem.setPreparationTimeMinutes(menuItem.getPreparationTimeMinutes());

        return menuItemRepository.save(existingItem);
    }

    @Override
    public void deleteMenuItem(Long itemId, Long restaurantId) throws Exception {
        MenuItem item = menuItemRepository.findById(itemId)
                .orElseThrow(() -> new Exception("MenuItem not found: " + itemId));

        if (!item.getRestaurant().getRestaurantId().equals(restaurantId)) {
            throw new Exception("MenuItem does not belong to this restaurant.");
        }
        menuItemRepository.deleteById(itemId);
    }

    @Override
    public void setMenuItemAvailability(Long itemId, Long restaurantId, boolean isAvailable) throws Exception {
        MenuItem item = menuItemRepository.findById(itemId)
                .orElseThrow(() -> new Exception("MenuItem not found: " + itemId));
        if (!item.getRestaurant().getRestaurantId().equals(restaurantId)) {
            throw new Exception("MenuItem does not belong to this restaurant.");
        }
        item.setAvailable(isAvailable);
        menuItemRepository.save(item);
    }

    @Override
    public MenuItem saveOrUpdateMenuItem(MenuItem menuItem) throws Exception {
        if (menuItem.getRestaurant() == null || menuItem.getRestaurant().getRestaurantId() == null) {
            throw new Exception("Restaurant ID is required.");
        }
        restaurantRepository.findById(menuItem.getRestaurant().getRestaurantId())
                .orElseThrow(() -> new Exception("Restaurant not found"));
        return menuItemRepository.save(menuItem);
    }

    @Override
    public Map<String, List<MenuItem>> getAvailableMenuItemsGroupedByCategory(Long restaurantId) {
        return menuItemRepository.findAllByRestaurant_RestaurantId(restaurantId).stream()
                .filter((MenuItem item) -> item.isAvailable())
                .collect(Collectors.groupingBy((MenuItem item)
                        -> item.getCategory() != null ? item.getCategory().getName() : "Khác"
                ));
    }
}
