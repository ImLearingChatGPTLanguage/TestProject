package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.Address;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.model.User;
import com.mycompany.foodorderingsystem.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/restaurants")
public class RestaurantController {

    @Autowired
    private RestaurantService restaurantService;

    private boolean isAdmin(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        return loggedInUser != null && "ADMIN".equalsIgnoreCase(loggedInUser.getRole());
    }

    @GetMapping("/list")
    public String listRestaurantsForCustomer(Model model) {
        List<Restaurant> restaurants = restaurantService.getAllApprovedAndActiveRestaurants();
        model.addAttribute("restaurants", restaurants);
        model.addAttribute("pageTitle", "Danh Sách Nhà Hàng");
        model.addAttribute("body", "/WEB-INF/views/restaurant/restaurant-list-customer.jsp");
        return "layout/admin-main";
    }

    @GetMapping("/manage/add")
    public String showAddRestaurantForm(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("globalError", "Bạn không có quyền thực hiện chức năng này.");
            return "redirect:/restaurants/list";
        }

        if (!model.containsAttribute("restaurant")) {
            Restaurant restaurant = new Restaurant();
            restaurant.setAddress(new Address());
            model.addAttribute("restaurant", restaurant);
        }

        model.addAttribute("pageTitle", "Đăng Ký Nhà Hàng Mới (Admin)");
        model.addAttribute("body", "/WEB-INF/views/restaurant/restaurant-form.jsp");

        return "layout/admin-main";
    }

    @GetMapping("/manage/edit/{restaurantId}")
    public String showEditRestaurantForm(@PathVariable Long restaurantId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("globalError", "Bạn không có quyền thực hiện chức năng này.");
            return "redirect:/restaurants/list";
        }

        Restaurant restaurantToEdit = restaurantService.getRestaurantById(restaurantId).orElse(null);

        if (restaurantToEdit == null) {
            redirectAttributes.addFlashAttribute("globalError", "Nhà hàng không tồn tại với ID: " + restaurantId);
            return "redirect:/admin/restaurants/list";
        }

        if (restaurantToEdit.getAddress() == null) {
            restaurantToEdit.setAddress(new Address());
        }

        if (!model.containsAttribute("restaurant")) {
            model.addAttribute("restaurant", restaurantToEdit);
        }

        model.addAttribute("pageTitle", "Chỉnh Sửa Nhà Hàng (Admin): " + restaurantToEdit.getName());
        model.addAttribute("body", "/WEB-INF/views/restaurant/restaurant-form.jsp");

        return "layout/admin-main";
    }

    @PostMapping("/manage/save")
    public String saveRestaurant(
            @Valid @ModelAttribute("restaurant") Restaurant restaurant,
            BindingResult result,
            @RequestParam("logoImageFile") MultipartFile logoImageFile,
            @RequestParam("coverImageFile") MultipartFile coverImageFile,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!isAdmin(session)) {
            redirectAttributes.addFlashAttribute("globalError", "Permission denied.");
            return "redirect:/";
        }

        if (result.hasErrors()) {
            model.addAttribute("pageTitle", (restaurant.getRestaurantId() == null ? "Đăng Ký Nhà Hàng Mới" : "Chỉnh Sửa Nhà Hàng") + " (Lỗi Validation)");
            model.addAttribute("body", "/WEB-INF/views/restaurant/restaurant-form.jsp");
            return "layout/admin-main";
        }

        String uploadDir = "C:/Users/MSI-ADMIN/OneDrive/Pictures/food_app_upload/";

        if (logoImageFile != null && !logoImageFile.isEmpty()) {
            try {
                Path logoUploadPath = Paths.get(uploadDir, "logos");
                Files.createDirectories(logoUploadPath);
                String uniqueFileName = UUID.randomUUID().toString() + "_" + logoImageFile.getOriginalFilename();
                Files.copy(logoImageFile.getInputStream(), logoUploadPath.resolve(uniqueFileName));
                restaurant.setLogoImageUrl("/uploads/logos/" + uniqueFileName);
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("globalError", "Lỗi khi upload ảnh logo: " + e.getMessage());
                return "redirect:/restaurants/manage/add";
            }
        }

        if (coverImageFile != null && !coverImageFile.isEmpty()) {
            try {
                Path coverUploadPath = Paths.get(uploadDir, "covers");
                Files.createDirectories(coverUploadPath);
                String uniqueFileName = UUID.randomUUID().toString() + "_" + coverImageFile.getOriginalFilename();
                Files.copy(coverImageFile.getInputStream(), coverUploadPath.resolve(uniqueFileName));
                restaurant.setCoverImageUrl("/uploads/covers/" + uniqueFileName);
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("globalError", "Lỗi khi upload ảnh bìa: " + e.getMessage());
                return "redirect:/restaurants/manage/add";
            }
        }

        try {
            boolean isNewRestaurant = (restaurant.getRestaurantId() == null);
            if (isNewRestaurant) {
                restaurant.setOwnerUser(loggedInUser);
            }

            if (restaurant.getAddress() != null) {
                restaurant.getAddress().setUser(loggedInUser);
                restaurant.getAddress().setAddressType("RESTAURANT");
            }

            if (isNewRestaurant) {
                restaurantService.createRestaurant(restaurant, restaurant.getAddress());
                redirectAttributes.addFlashAttribute("globalMessage", "Nhà hàng '" + restaurant.getName() + "' đã được đăng ký và đang chờ duyệt.");
            } else {
                restaurantService.updateRestaurantInfo(restaurant, restaurant.getAddress());
                redirectAttributes.addFlashAttribute("globalMessage", "Thông tin nhà hàng '" + restaurant.getName() + "' đã được cập nhật.");
            }

            return "redirect:/admin/restaurants/list";

        } catch (Exception ex) {
            model.addAttribute("restaurant", restaurant);
            model.addAttribute("globalError", "Lỗi khi xử lý nhà hàng: " + ex.getMessage());
            model.addAttribute("body", "/WEB-INF/views/restaurant/restaurant-form.jsp");
            return "layout/admin-main";
        }
    }
}
