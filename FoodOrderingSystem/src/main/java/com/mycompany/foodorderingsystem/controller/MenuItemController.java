package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.Category;
import com.mycompany.foodorderingsystem.model.MenuItem;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.model.User;
import com.mycompany.foodorderingsystem.service.CategoryService;
import com.mycompany.foodorderingsystem.service.MenuItemService;
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
import java.util.Optional;
import java.util.UUID;

@Controller
@RequestMapping("/admin/restaurant/{restaurantId}/menu")
public class MenuItemController {

    @Autowired
    private MenuItemService menuItemService;

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private CategoryService categoryService;

    private boolean canAdminManageMenu(HttpSession session, Long restaurantId, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            redirectAttributes.addFlashAttribute("globalError", "Permission Denied. Admin rights required.");
            return false;
        }
        Optional<Restaurant> restaurantOpt = restaurantService.getRestaurantById(restaurantId);
        if (restaurantOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("globalError", "Restaurant not found with ID: " + restaurantId);
            return false;
        }
        return true;
    }

    @GetMapping("/list")
    public String listMenuItemsForAdmin(@PathVariable Long restaurantId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!canAdminManageMenu(session, restaurantId, redirectAttributes)) {
            return "redirect:/admin/restaurants/list";
        }
        Optional<Restaurant> restaurantOpt = restaurantService.getRestaurantById(restaurantId);
        List<MenuItem> menuItems = menuItemService.getAllMenuItemsByRestaurantId(restaurantId);

        model.addAttribute("menuItems", menuItems);
        model.addAttribute("restaurant", restaurantOpt.get());
        model.addAttribute("pageTitle", "Quản Lý Thực Đơn (Admin)");
        model.addAttribute("body", "/WEB-INF/views/menuitem/menuitem-list-staff.jsp");
        return "layout/admin-main";
    }

    @GetMapping("/add")
    public String showAddMenuItemForm(@PathVariable Long restaurantId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!canAdminManageMenu(session, restaurantId, redirectAttributes)) {
            return "redirect:/admin/restaurants/list";
        }
        Optional<Restaurant> restaurantOpt = restaurantService.getRestaurantById(restaurantId);

        if (!model.containsAttribute("menuItem")) {
            MenuItem menuItem = new MenuItem();
            restaurantOpt.ifPresent(menuItem::setRestaurant);
            model.addAttribute("menuItem", menuItem);
        }

        model.addAttribute("allCategories", categoryService.findAllCategories());
        model.addAttribute("restaurant", restaurantOpt.get());
        model.addAttribute("pageTitle", "Thêm Món Ăn Mới");
        model.addAttribute("body", "/WEB-INF/views/menuitem/menuitem-form.jsp");
        return "layout/admin-main";
    }

    @GetMapping("/edit/{itemId}")
    public String showEditMenuItemForm(@PathVariable Long restaurantId, @PathVariable Long itemId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!canAdminManageMenu(session, restaurantId, redirectAttributes)) {
            return "redirect:/admin/restaurants/list";
        }
        Optional<Restaurant> restaurantOpt = restaurantService.getRestaurantById(restaurantId);
        Optional<MenuItem> menuItemOpt = menuItemService.getMenuItemById(itemId);

        if (menuItemOpt.isPresent() && menuItemOpt.get().getRestaurant().getRestaurantId().equals(restaurantId)) {
            if (!model.containsAttribute("menuItem")) {
                model.addAttribute("menuItem", menuItemOpt.get());
            }
            model.addAttribute("allCategories", categoryService.findAllCategories());
            model.addAttribute("restaurant", restaurantOpt.get());
            model.addAttribute("pageTitle", "Chỉnh Sửa Món Ăn");
            model.addAttribute("body", "/WEB-INF/views/menuitem/menuitem-form.jsp");
            return "layout/admin-main";
        } else {
            redirectAttributes.addFlashAttribute("globalError", "Menu item not found or does not belong to this restaurant.");
            return "redirect:/admin/restaurant/" + restaurantId + "/menu/list";
        }
    }

    @PostMapping("/save")
    public String saveMenuItem(@PathVariable Long restaurantId,
            @Valid @ModelAttribute("menuItem") MenuItem menuItem,
            BindingResult result,
            @RequestParam("menuImageFile") MultipartFile menuImageFile,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (!canAdminManageMenu(session, restaurantId, redirectAttributes)) {
            return "redirect:/admin/restaurants/list";
        }

        Optional<Restaurant> restaurantOpt = restaurantService.getRestaurantById(restaurantId);
        if (restaurantOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("globalError", "Restaurant not found.");
            return "redirect:/admin/restaurants/list";
        }

        restaurantOpt.ifPresent(menuItem::setRestaurant);

        if (menuItem.getCategory() != null && menuItem.getCategory().getCategoryId() != null) {
            Optional<Category> categoryOpt = categoryService.findById(menuItem.getCategory().getCategoryId());
            categoryOpt.ifPresent(menuItem::setCategory);
        } else {
            menuItem.setCategory(null);
        }

        if (menuImageFile != null && !menuImageFile.isEmpty()) {
            String uploadDir = "C:/Users/MSI-ADMIN/OneDrive/Pictures/food_app_upload/";
            try {
                Path menuUploadPath = Paths.get(uploadDir, "menu-items");
                Files.createDirectories(menuUploadPath);
                String uniqueFileName = UUID.randomUUID().toString() + "_" + menuImageFile.getOriginalFilename();
                Files.copy(menuImageFile.getInputStream(), menuUploadPath.resolve(uniqueFileName));
                menuItem.setImageUrl("/uploads/menu-items/" + uniqueFileName);
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("globalError", "Lỗi khi upload ảnh món ăn: " + e.getMessage());
                String redirectUrl = (menuItem.getItemId() == null) ? "/add" : "/edit/" + menuItem.getItemId();
                return "redirect:/admin/restaurant/" + restaurantId + "/menu" + redirectUrl;
            }
        }

        if (result.hasErrors()) {
            model.addAttribute("restaurant", restaurantOpt.get());
            model.addAttribute("allCategories", categoryService.findAllCategories());
            model.addAttribute("pageTitle", "Lỗi Validation");
            model.addAttribute("body", "/WEB-INF/views/menuitem/menuitem-form.jsp");
            return "layout/admin-main";
        }

        try {
            menuItemService.saveOrUpdateMenuItem(menuItem);
            redirectAttributes.addFlashAttribute("globalMessage", "Lưu món ăn '" + menuItem.getName() + "' thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi khi lưu món ăn: " + e.getMessage());
        }

        return "redirect:/admin/restaurant/" + restaurantId + "/menu/list";
    }

    @PostMapping("/delete/{itemId}")
    public String deleteMenuItem(@PathVariable Long restaurantId, @PathVariable Long itemId, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!canAdminManageMenu(session, restaurantId, redirectAttributes)) {
            return "redirect:/admin/restaurants/list";
        }
        try {
            menuItemService.deleteMenuItem(itemId, restaurantId);
            redirectAttributes.addFlashAttribute("globalMessage", "Menu item deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Error deleting menu item: " + e.getMessage());
        }
        return "redirect:/admin/restaurant/" + restaurantId + "/menu/list";
    }

    @PostMapping("/toggle-availability/{itemId}")
    public String toggleMenuItemAvailability(@PathVariable Long restaurantId,
            @PathVariable Long itemId,
            @RequestParam boolean currentAvailability,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (!canAdminManageMenu(session, restaurantId, redirectAttributes)) {
            return "redirect:/admin/restaurants/list";
        }
        try {
            menuItemService.setMenuItemAvailability(itemId, restaurantId, !currentAvailability);
            redirectAttributes.addFlashAttribute("globalMessage", "Menu item availability updated.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Error updating menu item availability: " + e.getMessage());
        }
        return "redirect:/admin/restaurant/" + restaurantId + "/menu/list";
    }
}
