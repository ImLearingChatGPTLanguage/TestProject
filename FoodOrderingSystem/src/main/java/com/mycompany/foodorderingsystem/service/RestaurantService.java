package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Address;
import com.mycompany.foodorderingsystem.model.Restaurant;
import java.util.List;
import java.util.Optional;

public interface RestaurantService {

    Restaurant createRestaurant(Restaurant restaurant, Address address) throws Exception;

    Optional<Restaurant> getRestaurantById(Long restaurantId);

    List<Restaurant> getAllApprovedAndActiveRestaurants();

    List<Restaurant> getAllRestaurantsForAdmin();

    List<Restaurant> getRestaurantsByOwner(Long ownerUserId);

    Restaurant updateRestaurantInfo(Restaurant restaurant, Address address) throws Exception;

    void approveRestaurantByAdmin(Long restaurantId, boolean approved) throws Exception;

    void activateRestaurantByAdmin(Long restaurantId, boolean active) throws Exception;

    void deleteRestaurantByAdmin(Long restaurantId) throws Exception;

    List<Restaurant> searchRestaurantsByName(String keyword);

    List<Restaurant> searchRestaurantsForAdmin(String keywordOrId);

    long getTotalRestaurantCount();
}
