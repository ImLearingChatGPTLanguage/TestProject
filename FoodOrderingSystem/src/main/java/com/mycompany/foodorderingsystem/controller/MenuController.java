package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.MenuItem;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.service.MenuItemService;
import com.mycompany.foodorderingsystem.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/restaurants/menu")
public class MenuController {

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private MenuItemService menuItemService;

    @GetMapping("/{restaurantId}")
    public String showRestaurantMenu(@PathVariable Long restaurantId, Model model) {
        Optional<Restaurant> restaurantOpt = restaurantService.getRestaurantById(restaurantId);

        if (restaurantOpt.isPresent()) {
            Restaurant restaurant = restaurantOpt.get();
            Map<String, List<MenuItem>> groupedMenuItems = menuItemService.getAvailableMenuItemsGroupedByCategory(restaurantId);
            model.addAttribute("restaurant", restaurant);
            model.addAttribute("groupedMenuItems", groupedMenuItems);
            model.addAttribute("pageTitle", "Thực đơn - " + restaurant.getName());
            model.addAttribute("body", "/WEB-INF/views/customer/menu-display.jsp");
            return "layout/admin-main";
        } else {
            return "redirect:/restaurants/list";
        }
    }
}
