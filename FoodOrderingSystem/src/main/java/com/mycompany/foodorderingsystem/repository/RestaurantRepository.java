package com.mycompany.foodorderingsystem.repository;

import com.mycompany.foodorderingsystem.model.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {

    List<Restaurant> findByOwnerUser_UserId(Long ownerUserId);

    List<Restaurant> findByIsApprovedTrueAndIsActiveTrue();

    @Query("SELECT r FROM Restaurant r WHERE r.name LIKE %:keyword% AND r.isApproved = true AND r.isActive = true")
    List<Restaurant> searchByNameAndApprovedAndActive(@Param("keyword") String keyword);

    @Query("SELECT r FROM Restaurant r WHERE r.name LIKE %:keyword%")
    List<Restaurant> searchByNameForAdmin(@Param("keyword") String keyword);
}
