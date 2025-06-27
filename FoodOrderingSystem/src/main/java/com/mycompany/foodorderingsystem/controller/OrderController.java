package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.Address;
import com.mycompany.foodorderingsystem.model.Order;
import com.mycompany.foodorderingsystem.model.OrderItem;
import com.mycompany.foodorderingsystem.model.User;
import com.mycompany.foodorderingsystem.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderService;

    @GetMapping("/checkout")
    public String showCheckoutPage(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("globalError", "Vui lòng đăng nhập để tiến hành thanh toán.");
            return "redirect:/user/login";
        }

        Map<Long, OrderItem> cart = (Map<Long, OrderItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            redirectAttributes.addFlashAttribute("globalError", "Giỏ hàng của bạn đang trống.");
            return "redirect:/cart";
        }

        if (!model.containsAttribute("order")) {
            Order order = new Order();
            order.setDeliveryAddress(new Address());
            model.addAttribute("order", order);
        }

        model.addAttribute("pageTitle", "Thanh Toán Đơn Hàng");
        model.addAttribute("body", "/WEB-INF/views/customer/checkout.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/order/place")
    public String placeOrder(@Valid @ModelAttribute("order") Order order,
            BindingResult result,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            return "redirect:/user/login";
        }

        Map<Long, OrderItem> cart = (Map<Long, OrderItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            return "redirect:/cart";
        }

        if (result.hasErrors()) {
            model.addAttribute("pageTitle", "Thanh Toán Đơn Hàng (Lỗi)");
            model.addAttribute("body", "/WEB-INF/views/customer/checkout.jsp");
            return "layout/admin-main";
        }

        try {
            order.setCustomerUser(loggedInUser);
            orderService.placeOrder(order, cart);

            session.removeAttribute("cart");
            redirectAttributes.addFlashAttribute("globalMessage", "Đặt hàng thành công! Đơn hàng của bạn đang được xử lý.");
            return "redirect:/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Đã xảy ra lỗi khi đặt hàng: " + e.getMessage());
            redirectAttributes.addFlashAttribute("order", order);
            return "redirect:/checkout";
        }
    }

    @GetMapping("/orders/my-history")
    public String showOrderHistory(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("globalError", "Vui lòng đăng nhập để xem lịch sử đặt hàng.");
            return "redirect:/user/login";
        }
        List<Order> orderHistory = orderService.getOrderHistory(loggedInUser.getUserId());
        model.addAttribute("orderHistory", orderHistory);
        model.addAttribute("pageTitle", "Lịch Sử Đặt Hàng");
        model.addAttribute("body", "/WEB-INF/views/customer/order-history.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/orders/confirm-received/{orderId}")
    public String confirmOrderReceived(@PathVariable Long orderId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("globalError", "Vui lòng đăng nhập để thực hiện chức năng này.");
            return "redirect:/user/login";
        }

        try {
            orderService.confirmOrderReceived(orderId, loggedInUser.getUserId());
            redirectAttributes.addFlashAttribute("globalMessage", "Xác nhận đơn hàng #" + orderId + " thành công! Cảm ơn bạn đã mua sắm.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi: " + e.getMessage());
        }

        return "redirect:/orders/my-history";
    }
}
