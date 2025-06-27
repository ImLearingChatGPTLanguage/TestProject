package com.mycompany.foodorderingsystem.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mycompany.foodorderingsystem.model.Order;
import com.mycompany.foodorderingsystem.model.User;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.service.OrderService;
import com.mycompany.foodorderingsystem.service.UserService;
import com.mycompany.foodorderingsystem.service.RestaurantService;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private RestaurantService restaurantService;

    @Autowired
    private OrderService orderService;

    private boolean isAdmin(HttpSession session, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            if (redirectAttributes != null) {
                redirectAttributes.addFlashAttribute("globalError", "Permission Denied. You do not have admin rights.");
            }
            return false;
        }
        return true;
    }

    @GetMapping("/users/list")
    public String listAllUsers(
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }

        List<User> users;
        String pageTitleSuffix = "";
        if (keyword != null && !keyword.trim().isEmpty()) {
            users = userService.searchUsersByNameForAdmin(keyword.trim());
            model.addAttribute("searchKeyword", keyword.trim());
            pageTitleSuffix = " (Search: '" + keyword.trim() + "')";
        } else {
            users = userService.getAllUsers();
        }

        model.addAttribute("users", users);
        model.addAttribute("pageTitle", "User Management" + pageTitleSuffix);
        model.addAttribute("body", "/WEB-INF/views/admin/user-list.jsp");
        return "layout/admin-main";
    }

    @GetMapping("/users/edit/{userId}")
    public String showEditUserForm(@PathVariable Long userId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        Optional<User> userOptional = userService.findUserById(userId);
        if (userOptional.isPresent()) {
            if (!model.containsAttribute("userToEdit")) {
                model.addAttribute("userToEdit", userOptional.get());
            }
            model.addAttribute("pageTitle", "Edit User - " + userOptional.get().getUsername());
            model.addAttribute("body", "/WEB-INF/views/admin/user-form.jsp");
            return "layout/admin-main";
        } else {
            redirectAttributes.addFlashAttribute("globalError", "User not found with ID: " + userId);
            return "redirect:/admin/users/list";
        }
    }

    @PostMapping("/users/update")
    public String processUpdateUser(@Valid @ModelAttribute("userToEdit") User user,
            BindingResult result,
            RedirectAttributes redirectAttributes,
            Model model, HttpSession session) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }

        if (result.hasErrors()) {
            model.addAttribute("pageTitle", "Edit User - " + user.getUsername() + " (Validation Errors)");
            model.addAttribute("userToEdit", user);
            model.addAttribute("body", "/WEB-INF/views/admin/user-form.jsp");
            return "layout/admin-main";
        }
        try {
            User existingUser = userService.findUserById(user.getUserId())
                    .orElseThrow(() -> new Exception("User không tồn tại để cập nhật."));
            user.setPassword(existingUser.getPassword());
            user.setUsername(existingUser.getUsername());

            userService.updateUserByAdmin(user);
            redirectAttributes.addFlashAttribute("globalMessage", "User '" + user.getUsername() + "' updated successfully.");
            return "redirect:/admin/users/list";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Error updating user '" + user.getUsername() + "': " + e.getMessage());
            redirectAttributes.addFlashAttribute("userToEdit", user);
            return "redirect:/admin/users/edit/" + user.getUserId();
        }
    }

    @PostMapping("/users/deactivate/{userId}")
    public String deactivateUser(@PathVariable Long userId, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        try {
            User userToDeactivate = userService.findUserById(userId)
                    .orElseThrow(() -> new Exception("User không tồn tại với ID: " + userId));
            if (userToDeactivate.getUserId().equals(((User) session.getAttribute("loggedInUser")).getUserId())) {
                redirectAttributes.addFlashAttribute("globalError", "Bạn không thể tự vô hiệu hóa tài khoản của mình.");
                return "redirect:/admin/users/list";
            }
            boolean success = userService.deactivateUser(userId);
            if (success) {
                redirectAttributes.addFlashAttribute("globalMessage", "User với ID " + userId + " đã được vô hiệu hóa.");
            } else {
                redirectAttributes.addFlashAttribute("globalError", "Không thể vô hiệu hóa user với ID " + userId + ".");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi khi vô hiệu hóa user: " + e.getMessage());
        }
        return "redirect:/admin/users/list";
    }

    @PostMapping("/users/activate/{userId}")
    public String activateUser(@PathVariable Long userId, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        try {
            boolean success = userService.activateUser(userId);
            if (success) {
                redirectAttributes.addFlashAttribute("globalMessage", "User với ID " + userId + " đã được kích hoạt.");
            } else {
                redirectAttributes.addFlashAttribute("globalError", "Không thể kích hoạt user với ID " + userId + ".");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi khi kích hoạt user: " + e.getMessage());
        }
        return "redirect:/admin/users/list";
    }

    @GetMapping("/users/delete/{userId}/confirm")
    public String showDeleteUserConfirmPage(@PathVariable Long userId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        Optional<User> userOptional = userService.findUserById(userId);
        if (userOptional.isPresent()) {
            if (userOptional.get().getUserId().equals(((User) session.getAttribute("loggedInUser")).getUserId())) {
                redirectAttributes.addFlashAttribute("globalError", "Bạn không thể tự xóa tài khoản của mình.");
                return "redirect:/admin/users/list";
            }
            model.addAttribute("userToDelete", userOptional.get());
            model.addAttribute("pageTitle", "Xác Nhận Xóa User - " + userOptional.get().getUsername());
            model.addAttribute("body", "/WEB-INF/views/admin/user-delete-confirm.jsp");
            return "layout/admin-main";
        } else {
            redirectAttributes.addFlashAttribute("globalError", "User không tồn tại với ID: " + userId);
            return "redirect:/admin/users/list";
        }
    }

    @PostMapping("/users/delete/{userId}")
    public String deleteUserPermanently(@PathVariable Long userId, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        Optional<User> userOptional = userService.findUserById(userId);
        if (userOptional.isPresent() && userOptional.get().getUserId().equals(((User) session.getAttribute("loggedInUser")).getUserId())) {
            redirectAttributes.addFlashAttribute("globalError", "Bạn không thể tự xóa tài khoản của mình.");
            return "redirect:/admin/users/list";
        }
        try {
            userService.deleteUserPermanently(userId);
            redirectAttributes.addFlashAttribute("globalMessage", "User với ID " + userId + " đã được xóa vĩnh viễn.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi khi xóa user: " + e.getMessage());
        }
        return "redirect:/admin/users/list";
    }

    @GetMapping("/restaurants/list")
    public String listAllRestaurantsForAdmin(
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }

        List<Restaurant> restaurants;
        String pageTitleSuffix = "";
        if (keyword != null && !keyword.trim().isEmpty()) {
            restaurants = restaurantService.searchRestaurantsForAdmin(keyword.trim());
            model.addAttribute("searchKeyword", keyword.trim());
            pageTitleSuffix = " (Search: '" + keyword.trim() + "')";
        } else {
            restaurants = restaurantService.getAllRestaurantsForAdmin();
        }

        model.addAttribute("restaurants", restaurants);
        model.addAttribute("pageTitle", "Restaurant Management" + pageTitleSuffix);
        model.addAttribute("body", "/WEB-INF/views/admin/restaurant-list-admin.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/restaurants/approve/{restaurantId}")
    public String approveRestaurant(@PathVariable Long restaurantId,
            @RequestParam(defaultValue = "true") boolean approve,
            RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        try {
            restaurantService.approveRestaurantByAdmin(restaurantId, approve);
            redirectAttributes.addFlashAttribute("globalMessage", "Restaurant ID " + restaurantId + " approval status updated to: " + approve);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Error updating restaurant approval: " + e.getMessage());
        }
        return "redirect:/admin/restaurants/list";
    }

    @PostMapping("/restaurants/activate/{restaurantId}")
    public String activateRestaurant(@PathVariable Long restaurantId,
            @RequestParam(defaultValue = "true") boolean active,
            RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        try {
            restaurantService.activateRestaurantByAdmin(restaurantId, active);
            redirectAttributes.addFlashAttribute("globalMessage", "Restaurant ID " + restaurantId + " active status updated to: " + active);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Error updating restaurant active status: " + e.getMessage());
        }
        return "redirect:/admin/restaurants/list";
    }

    @GetMapping("/restaurants/delete/{restaurantId}/confirm")
    public String showDeleteRestaurantConfirmPage(@PathVariable Long restaurantId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        Optional<Restaurant> restaurantOptional = restaurantService.getRestaurantById(restaurantId);
        if (restaurantOptional.isPresent()) {
            model.addAttribute("restaurantToDelete", restaurantOptional.get());
            model.addAttribute("pageTitle", "Confirm Restaurant Deletion - " + restaurantOptional.get().getName());
            model.addAttribute("body", "/WEB-INF/views/admin/restaurant-delete-confirm.jsp");
            return "layout/admin-main";
        } else {
            redirectAttributes.addFlashAttribute("globalError", "Restaurant not found with ID: " + restaurantId);
            return "redirect:/admin/restaurants/list";
        }
    }

    @PostMapping("/restaurants/delete/{restaurantId}")
    public String deleteRestaurant(@PathVariable Long restaurantId, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        try {
            restaurantService.deleteRestaurantByAdmin(restaurantId);
            redirectAttributes.addFlashAttribute("globalMessage", "Restaurant with ID " + restaurantId + " has been processed for deletion.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Error deleting restaurant: " + e.getMessage());
        }
        return "redirect:/admin/restaurants/list";
    }

    @GetMapping("/orders/list")
    public String listAllOrders(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        model.addAttribute("allOrders", orderService.getAllOrders());
        model.addAttribute("pageTitle", "Quản Lý Đơn Hàng");
        model.addAttribute("body", "/WEB-INF/views/admin/order-list-admin.jsp");
        return "layout/admin-main";
    }

    @GetMapping("/orders/{orderId}")
    public String viewOrderDetails(@PathVariable Long orderId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        Optional<Order> orderOpt = orderService.getOrderById(orderId);
        if (orderOpt.isPresent()) {
            model.addAttribute("order", orderOpt.get());
            model.addAttribute("pageTitle", "Chi Tiết Đơn Hàng #" + orderId);
            model.addAttribute("body", "/WEB-INF/views/admin/order-details-admin.jsp");
            return "layout/admin-main";
        } else {
            redirectAttributes.addFlashAttribute("globalError", "Không tìm thấy đơn hàng.");
            return "redirect:/admin/orders/list";
        }
    }

    @PostMapping("/orders/update-status/{orderId}")
    public String updateOrderStatus(@PathVariable Long orderId,
            @RequestParam String status,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        try {
            orderService.updateOrderStatus(orderId, status);
            redirectAttributes.addFlashAttribute("globalMessage", "Cập nhật trạng thái đơn hàng #" + orderId + " thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/orders/" + orderId;
    }

    @GetMapping("/users/change-password/{userId}")
    public String showAdminChangePasswordForm(@PathVariable Long userId, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }
        Optional<User> userOpt = userService.findUserById(userId);
        if (userOpt.isPresent()) {
            model.addAttribute("userToModify", userOpt.get());
            model.addAttribute("pageTitle", "Đổi Mật khẩu cho User");
            model.addAttribute("body", "/WEB-INF/views/admin/admin-change-password-form.jsp");
            return "layout/admin-main";
        } else {
            redirectAttributes.addFlashAttribute("globalError", "User not found with ID: " + userId);
            return "redirect:/admin/users/list";
        }
    }

    // Phương thức để xử lý yêu cầu đổi mật khẩu từ form
    @PostMapping("/users/change-password")
    public String processAdminChangePassword(@RequestParam("userId") Long userId,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("globalError", "Mật khẩu mới và mật khẩu xác nhận không khớp.");
            return "redirect:/admin/users/change-password/" + userId;
        }

        try {
            userService.adminSetUserPassword(userId, newPassword);
            redirectAttributes.addFlashAttribute("globalMessage", "Đã đổi mật khẩu thành công cho người dùng ID " + userId + ".");
            return "redirect:/admin/users/list";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi khi đổi mật khẩu: " + e.getMessage());
            return "redirect:/admin/users/change-password/" + userId;
        }
    }

    @GetMapping("/reports")
    public String showReportsPage(
            @RequestParam(value = "startDate", required = false) String startDateStr,
            @RequestParam(value = "endDate", required = false) String endDateStr,
            Model model, HttpSession session, RedirectAttributes redirectAttributes) throws JsonProcessingException {

        if (!isAdmin(session, redirectAttributes)) {
            return "redirect:/user/login";
        }

        LocalDate startDate;
        LocalDate endDate;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        if (endDateStr != null && !endDateStr.isEmpty()) {
            endDate = LocalDate.parse(endDateStr, formatter);
        } else {
            endDate = LocalDate.now();
        }

        if (startDateStr != null && !startDateStr.isEmpty()) {
            startDate = LocalDate.parse(startDateStr, formatter);
        } else {
            startDate = endDate.minusDays(30); // Mặc định lấy 30 ngày gần nhất
        }

        Timestamp startTimestamp = Timestamp.valueOf(startDate.atStartOfDay());
        Timestamp endTimestamp = Timestamp.valueOf(endDate.atTime(23, 59, 59));

        // Lấy dữ liệu thống kê tổng hợp
        BigDecimal revenue = orderService.getRevenueForPeriod(startTimestamp, endTimestamp);
        long completedOrders = orderService.getOrderCountForPeriod(startTimestamp, endTimestamp);
        long newUsers = userService.getNewUserCountForPeriod(startTimestamp, endTimestamp);

        // LẤY DỮ LIỆU CHO BIỂU ĐỒ
        List<Object[]> dailyRevenueData = orderService.getDailyRevenueForPeriod(startTimestamp, endTimestamp);

        // Xử lý dữ liệu để truyền sang JavaScript
        List<String> chartLabels = new ArrayList<>();
        List<BigDecimal> chartData = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");

        for (Object[] record : dailyRevenueData) {
            chartLabels.add(sdf.format((java.util.Date) record[0]));
            chartData.add((BigDecimal) record[1]);
        }

        model.addAttribute("revenueForPeriod", revenue);
        model.addAttribute("ordersForPeriod", completedOrders);
        model.addAttribute("newUsersForPeriod", newUsers);
        model.addAttribute("startDate", startDate.format(formatter));
        model.addAttribute("endDate", endDate.format(formatter));

        // Đưa dữ liệu biểu đồ vào model
        model.addAttribute("chartLabels", new ObjectMapper().writeValueAsString(chartLabels));
        model.addAttribute("chartData", new ObjectMapper().writeValueAsString(chartData));

        model.addAttribute("pageTitle", "Báo cáo & Thống kê");
        model.addAttribute("body", "/WEB-INF/views/admin/reports.jsp");
        return "layout/admin-main";
    }
}
