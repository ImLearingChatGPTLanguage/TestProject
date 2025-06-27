package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.User;
import com.mycompany.foodorderingsystem.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.Optional;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        if (!model.containsAttribute("user")) {
            model.addAttribute("user", new User());
        }
        model.addAttribute("pageTitle", "Đăng Ký Tài Khoản");
        model.addAttribute("body", "/WEB-INF/views/user/user-register.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/register")
    public String processRegistration(@Valid @ModelAttribute("user") User user,
            BindingResult result,
            RedirectAttributes redirectAttributes,
            Model model) {
        if (result.hasErrors()) {
            model.addAttribute("pageTitle", "Đăng Ký Tài Khoản (Lỗi)");
            model.addAttribute("user", user);
            model.addAttribute("body", "/WEB-INF/views/user/user-register.jsp");
            return "layout/admin-main";
        }
        try {
            userService.registerUser(user);
            redirectAttributes.addFlashAttribute("globalMessage",
                    "Đăng ký thành công cho " + user.getUsername() + "! Vui lòng đăng nhập.");
            return "redirect:/user/login";
        } catch (Exception e) {
            model.addAttribute("pageTitle", "Đăng Ký Tài Khoản (Lỗi)");
            model.addAttribute("user", user);
            model.addAttribute("registrationErrorMessage", e.getMessage());
            model.addAttribute("body", "/WEB-INF/views/user/user-register.jsp");
            return "layout/admin-main";
        }
    }

    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("pageTitle", "Đăng Nhập");
        model.addAttribute("body", "/WEB-INF/views/user/user-login.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/login")
    public String processLogin(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {
        Optional<User> optionalUser = userService.findByUsername(username);
        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            if (user.getPassword().equals(password)) {
                if (!user.isActive()) {
                    model.addAttribute("loginError", "Tài khoản của bạn đã bị vô hiệu hóa.");
                    model.addAttribute("pageTitle", "Đăng Nhập (Lỗi)");
                    model.addAttribute("body", "/WEB-INF/views/user/user-login.jsp");
                    return "layout/admin-main";
                }
                session.setAttribute("loggedInUser", user);
                String welcomeName = (user.getFullName() != null && !user.getFullName().trim().isEmpty())
                        ? user.getFullName()
                        : user.getUsername();
                redirectAttributes.addFlashAttribute("globalMessage", "Chào mừng trở lại, " + welcomeName + "!");
                return "redirect:/dashboard";
            }
        }
        model.addAttribute("loginError", "Tên đăng nhập hoặc mật khẩu không đúng.");
        model.addAttribute("pageTitle", "Đăng Nhập (Lỗi)");
        model.addAttribute("body", "/WEB-INF/views/user/user-login.jsp");
        return "layout/admin-main";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("globalMessage", "Bạn đã đăng xuất thành công.");
        return "redirect:/user/login?logout";
    }

    @GetMapping("/profile/edit")
    public String showEditProfileForm(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("globalError", "Vui lòng đăng nhập để cập nhật hồ sơ.");
            return "redirect:/user/login";
        }

        Optional<User> userFromDbOpt = userService.findUserById(loggedInUser.getUserId());
        if (userFromDbOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("globalError", "Không tìm thấy thông tin người dùng.");
            session.invalidate();
            return "redirect:/user/login";
        }

        if (!model.containsAttribute("userProfile")) {
            model.addAttribute("userProfile", userFromDbOpt.get());
        }

        model.addAttribute("pageTitle", "Cập Nhật Hồ Sơ Cá Nhân");
        model.addAttribute("body", "/WEB-INF/views/user/customer-profile-form.jsp");

        String layoutToUse = "layout/admin-main";
        if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) || "STAFF".equalsIgnoreCase(loggedInUser.getRole())) {
            layoutToUse = "layout/admin-main";
        }
        return layoutToUse;
    }

    @PostMapping("/profile/update")
    public String processUpdateProfile(
            @Valid @ModelAttribute("userProfile") User userFormData,
            BindingResult result,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/user/login";
        }
        if (!loggedInUser.getUserId().equals(userFormData.getUserId())) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi: Bạn không thể cập nhật hồ sơ của người dùng khác.");
            return "redirect:/dashboard";
        }

        if (result.hasErrors()) {
            model.addAttribute("pageTitle", "Cập Nhật Hồ Sơ (Lỗi Validation)");
            model.addAttribute("body", "/WEB-INF/views/user/customer-profile-form.jsp");
            String layoutToUse = "layout/admin-main";
            if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) || "STAFF".equalsIgnoreCase(loggedInUser.getRole())) {
                layoutToUse = "layout/admin-main";
            }
            return layoutToUse;
        }

        try {
            userService.updateCustomerProfile(userFormData, loggedInUser.getUserId());
            redirectAttributes.addFlashAttribute("globalMessage", "Hồ sơ của bạn đã được cập nhật thành công!");
            User updatedUser = userService.findUserById(loggedInUser.getUserId()).orElse(loggedInUser);
            session.setAttribute("loggedInUser", updatedUser);
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("pageTitle", "Cập Nhật Hồ Sơ (Lỗi)");
            model.addAttribute("userProfile", userFormData);
            model.addAttribute("globalError", "Lỗi khi cập nhật hồ sơ: " + e.getMessage());
            model.addAttribute("body", "/WEB-INF/views/user/customer-profile-form.jsp");
            String layoutToUse = "layout/admin-main";
            if ("ADMIN".equalsIgnoreCase(loggedInUser.getRole()) || "STAFF".equalsIgnoreCase(loggedInUser.getRole())) {
                layoutToUse = "layout/admin-main";
            }
            return layoutToUse;
        }
    }

    @GetMapping("/profile/change-password")
    public String showChangePasswordForm(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("globalError", "Vui lòng đăng nhập để thực hiện chức năng này.");
            return "redirect:/user/login";
        }

        model.addAttribute("pageTitle", "Đổi Mật Khẩu");
        model.addAttribute("body", "/WEB-INF/views/user/change-password-form.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/profile/change-password")
    public String processChangePassword(@RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/user/login";
        }

        if (newPassword == null || newPassword.isEmpty() || !newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("globalError", "Mật khẩu mới và mật khẩu xác nhận không khớp hoặc bị bỏ trống.");
            return "redirect:/user/profile/change-password";
        }

        try {
            userService.changeUserPassword(loggedInUser, currentPassword, newPassword);
            redirectAttributes.addFlashAttribute("globalMessage", "Đổi mật khẩu thành công!");
            return "redirect:/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", e.getMessage());
            return "redirect:/user/profile/change-password";
        }
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm(Model model) {
        model.addAttribute("pageTitle", "Quên Mật Khẩu");
        model.addAttribute("body", "/WEB-INF/views/user/forgot-password-form.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String userEmail, RedirectAttributes redirectAttributes) {
        try {
            userService.createPasswordResetTokenForUser(userEmail);
            redirectAttributes.addFlashAttribute("globalMessage", "Yêu cầu thành công. Nếu email tồn tại, một hướng dẫn đặt lại mật khẩu sẽ được gửi đến.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", e.getMessage());
        }
        return "redirect:/user/forgot-password";
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam("token") String token, Model model, RedirectAttributes redirectAttributes) {
        User user = userService.validatePasswordResetToken(token);
        if (user == null) {
            redirectAttributes.addFlashAttribute("globalError", "Token không hợp lệ hoặc đã hết hạn.");
            return "redirect:/user/login";
        }

        model.addAttribute("token", token);
        model.addAttribute("pageTitle", "Đặt Lại Mật Khẩu Mới");
        model.addAttribute("body", "/WEB-INF/views/user/reset-password-form.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam("token") String token,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("globalError", "Mật khẩu mới và mật khẩu xác nhận không khớp.");
            return "redirect:/user/reset-password?token=" + token;
        }

        try {
            userService.changeUserPassword(token, newPassword);
            redirectAttributes.addFlashAttribute("globalMessage", "Mật khẩu của bạn đã được thay đổi thành công. Vui lòng đăng nhập lại.");
            return "redirect:/user/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", e.getMessage());
            return "redirect:/user/reset-password?token=" + token;
        }
    }
}
