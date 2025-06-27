/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.foodorderingsystem.controller;

/**
 *
 * @author MSI-ADMIN
 */
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String showHomePage(Model model) {
        model.addAttribute("pageTitle", "Trang Chủ - Food Ordering System");
        model.addAttribute("body", "/WEB-INF/views/index-content.jsp");
        return "layout/admin-main";
    }
}
