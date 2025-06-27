package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.User;
import com.mycompany.foodorderingsystem.service.OrderService;
import com.mycompany.foodorderingsystem.service.RestaurantService;
import com.mycompany.foodorderingsystem.service.UserService;
import java.math.BigDecimal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Controller
public class DashboardController {

    @Autowired
    private UserService userService;

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            return "redirect:/user/login";
        }

        model.addAttribute("hideMainTitle", true);

        model.addAttribute("pageTitle", "Dashboard");
        model.addAttribute("user", loggedInUser);

        String userRole = loggedInUser.getRole();
        String bodyJspPath;
        String layoutName = "layout/admin-main";

        if ("ADMIN".equalsIgnoreCase(userRole)) {
            long totalUsers = userService.getTotalUserCount();
            long totalRestaurants = restaurantService.getTotalRestaurantCount();
            long totalOrders = orderService.countTotalOrders();
            BigDecimal totalRevenue = orderService.getTotalRevenue(); // THÊM DÒNG NÀY

            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("totalRestaurants", totalRestaurants);
            model.addAttribute("totalOrders", totalOrders);
            model.addAttribute("totalRevenue", totalRevenue); // THÊM DÒNG NÀY

            bodyJspPath = "/WEB-INF/views/admin/dashboard-admin.jsp";
        } else {
            bodyJspPath = "/WEB-INF/views/customer/dashboard-customer.jsp";
        }

        model.addAttribute("body", bodyJspPath);
        return layoutName;
    }
}
