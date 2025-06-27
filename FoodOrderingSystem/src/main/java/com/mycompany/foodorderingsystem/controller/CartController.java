package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.MenuItem;
import com.mycompany.foodorderingsystem.model.OrderItem;
import com.mycompany.foodorderingsystem.model.Restaurant;
import com.mycompany.foodorderingsystem.service.MenuItemService;
import com.mycompany.foodorderingsystem.service.RestaurantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class CartController {

    @Autowired
    private MenuItemService menuItemService;

    @Autowired
    private RestaurantService restaurantService;

    @PostMapping("/cart/add")
    public String addToCart(@RequestParam("itemId") Long itemId,
            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        Optional<MenuItem> menuItemOpt = menuItemService.getMenuItemById(itemId);
        if (!menuItemOpt.isPresent() || !menuItemOpt.get().isAvailable()) {
            redirectAttributes.addFlashAttribute("globalError", "Món ăn không tồn tại hoặc đã hết hàng.");
            return "redirect:/restaurants/list";
        }
        MenuItem item = menuItemOpt.get();
        Map<Long, OrderItem> cart = (Map<Long, OrderItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }
        if (!cart.isEmpty() && !cart.values().iterator().next().getMenuItem().getRestaurant().getRestaurantId().equals(item.getRestaurant().getRestaurantId())) {
            cart.clear();
            redirectAttributes.addFlashAttribute("globalMessage", "Giỏ hàng của bạn đã được làm mới để thêm món từ nhà hàng mới.");
        }
        OrderItem orderItem = cart.get(itemId);
        if (orderItem == null) {
            orderItem = new OrderItem();
            orderItem.setMenuItem(item);
            orderItem.setQuantity(quantity);
            orderItem.setPricePerItem(item.getPrice());
        } else {
            orderItem.setQuantity(orderItem.getQuantity() + quantity);
        }
        orderItem.setSubtotal(orderItem.getPricePerItem().multiply(new BigDecimal(orderItem.getQuantity())));
        cart.put(itemId, orderItem);
        session.setAttribute("cart", cart);
        redirectAttributes.addFlashAttribute("globalMessage", "Đã thêm '" + item.getName() + "' vào giỏ hàng.");
        return "redirect:/restaurants/menu/" + item.getRestaurant().getRestaurantId();
    }

    @GetMapping("/cart")
    public String viewCart(HttpSession session, Model model) {
        model.addAttribute("pageTitle", "Giỏ Hàng Của Bạn");
        model.addAttribute("body", "/WEB-INF/views/customer/cart-view.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/cart/update")
    public String updateCart(@RequestParam("itemId") Long itemId, @RequestParam("quantity") int quantity, HttpSession session) {
        Map<Long, OrderItem> cart = (Map<Long, OrderItem>) session.getAttribute("cart");
        if (cart != null && cart.containsKey(itemId)) {
            if (quantity > 0) {
                OrderItem orderItem = cart.get(itemId);
                orderItem.setQuantity(quantity);
                orderItem.setSubtotal(orderItem.getPricePerItem().multiply(new BigDecimal(quantity)));
                cart.put(itemId, orderItem);
            } else {
                cart.remove(itemId);
            }
            session.setAttribute("cart", cart);
        }
        return "redirect:/cart";
    }

    @PostMapping("/cart/remove")
    public String removeFromCart(@RequestParam("itemId") Long itemId, HttpSession session) {
        Map<Long, OrderItem> cart = (Map<Long, OrderItem>) session.getAttribute("cart");
        if (cart != null) {
            cart.remove(itemId);
            session.setAttribute("cart", cart);
        }
        return "redirect:/cart";
    }
}
