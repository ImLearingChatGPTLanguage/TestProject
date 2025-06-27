package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Address;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.repository.AddressRepository;
import com.mycompany.foodorderingsystem.repository.RestaurantRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class RestaurantServiceImpl implements RestaurantService {

    @Autowired
    private RestaurantRepository restaurantRepository;

    @Autowired
    private AddressRepository addressRepository;

    @Override
    public Restaurant createRestaurant(Restaurant restaurant, Address address) throws Exception {
        if (address == null || restaurant == null) {
            throw new IllegalArgumentException("Address and Restaurant must not be null.");
        }

        address.setAddressType("RESTAURANT");
        Address savedAddress = addressRepository.save(address);

        restaurant.setAddress(savedAddress);
        restaurant.setApproved(false);
        restaurant.setActive(true);

        return restaurantRepository.save(restaurant);
    }

    @Override
    public Optional<Restaurant> getRestaurantById(Long restaurantId) {
        return restaurantRepository.findById(restaurantId);
    }

    @Override
    public List<Restaurant> getAllApprovedAndActiveRestaurants() {
        return restaurantRepository.findByIsApprovedTrueAndIsActiveTrue();
    }

    @Override
    public List<Restaurant> getAllRestaurantsForAdmin() {
        return restaurantRepository.findAll();
    }

    @Override
    public List<Restaurant> getRestaurantsByOwner(Long ownerUserId) {
        return restaurantRepository.findByOwnerUser_UserId(ownerUserId);
    }

    @Override
    @Transactional
    public Restaurant updateRestaurantInfo(Restaurant restaurantData, Address addressData) throws Exception {
        if (restaurantData == null || restaurantData.getRestaurantId() == null) {
            throw new IllegalArgumentException("Restaurant data and Restaurant ID must not be null for update.");
        }
        Restaurant existingRestaurant = restaurantRepository.findById(restaurantData.getRestaurantId())
                .orElseThrow(() -> new Exception("Restaurant not found with ID: " + restaurantData.getRestaurantId()));
        if (addressData != null) {
            if (existingRestaurant.getAddress() != null) {
                Address existingAddress = existingRestaurant.getAddress();
                existingAddress.setStreetAddress(addressData.getStreetAddress());
                existingAddress.setWard(addressData.getWard());
                existingAddress.setDistrict(addressData.getDistrict());
                existingAddress.setCityProvince(addressData.getCityProvince());
                addressRepository.save(existingAddress);
            } else {
                addressData.setAddressType("RESTAURANT");
                addressData.setUser(existingRestaurant.getOwnerUser());
                Address savedAddress = addressRepository.save(addressData);
                existingRestaurant.setAddress(savedAddress);
            }
        }
        existingRestaurant.setName(restaurantData.getName());
        existingRestaurant.setDescription(restaurantData.getDescription());
        existingRestaurant.setPhoneNumber(restaurantData.getPhoneNumber());
        existingRestaurant.setOperatingHours(restaurantData.getOperatingHours());
        if (restaurantData.getLogoImageUrl() != null) {
            existingRestaurant.setLogoImageUrl(restaurantData.getLogoImageUrl());
        }
        if (restaurantData.getCoverImageUrl() != null) {
            existingRestaurant.setCoverImageUrl(restaurantData.getCoverImageUrl());
        }

        return restaurantRepository.save(existingRestaurant);
    }

    @Override
    public void approveRestaurantByAdmin(Long restaurantId, boolean approvedStatus) throws Exception {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new Exception("Restaurant not found with ID: " + restaurantId));
        restaurant.setApproved(approvedStatus);
        restaurantRepository.save(restaurant);
    }

    @Override
    public void activateRestaurantByAdmin(Long restaurantId, boolean activeStatus) throws Exception {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new Exception("Restaurant not found with ID: " + restaurantId));
        restaurant.setActive(activeStatus);
        restaurantRepository.save(restaurant);
    }

    @Override
    public void deleteRestaurantByAdmin(Long restaurantId) throws Exception {
        if (!restaurantRepository.existsById(restaurantId)) {
            throw new Exception("Restaurant not found with ID: " + restaurantId);
        }
        restaurantRepository.deleteById(restaurantId);
    }

    @Override
    public List<Restaurant> searchRestaurantsByName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllApprovedAndActiveRestaurants();
        }
        return restaurantRepository.searchByNameAndApprovedAndActive(keyword.trim());
    }

    @Override
    public List<Restaurant> searchRestaurantsForAdmin(String keywordOrId) {
        if (keywordOrId == null || keywordOrId.trim().isEmpty()) {
            return getAllRestaurantsForAdmin();
        }
        return restaurantRepository.searchByNameForAdmin(keywordOrId.trim());
    }

    @Override
    public long getTotalRestaurantCount() {
        return restaurantRepository.count();
    }
}
