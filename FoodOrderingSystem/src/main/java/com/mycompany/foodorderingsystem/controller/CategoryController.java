package com.mycompany.foodorderingsystem.controller;

import com.mycompany.foodorderingsystem.model.Category;
import com.mycompany.foodorderingsystem.service.CategoryService;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/categories")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/list")
    public String listCategories(Model model) {
        model.addAttribute("categories", categoryService.findAllCategories());
        model.addAttribute("pageTitle", "Quản Lý Danh Mục");
        model.addAttribute("body", "/WEB-INF/views/admin/category-list.jsp");
        return "layout/admin-main";
    }

    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("category", new Category());
        model.addAttribute("pageTitle", "Thêm Danh Mục Mới");
        model.addAttribute("body", "/WEB-INF/views/admin/category-form.jsp");
        return "layout/admin-main";
    }

    @PostMapping("/save")
    public String saveCategory(
            @ModelAttribute Category category,
            @RequestParam("categoryImageFile") MultipartFile categoryImageFile,
            RedirectAttributes redirectAttributes) {

        if (categoryImageFile != null && !categoryImageFile.isEmpty()) {
            String uploadDir = "C:/Users/MSI-ADMIN/OneDrive/Pictures/food_app_upload/";
            try {
                Path categoryUploadPath = Paths.get(uploadDir, "categories");
                Files.createDirectories(categoryUploadPath);

                String uniqueFileName = UUID.randomUUID().toString() + "_" + categoryImageFile.getOriginalFilename();
                Files.copy(categoryImageFile.getInputStream(), categoryUploadPath.resolve(uniqueFileName));

                category.setImageUrl("/uploads/categories/" + uniqueFileName);
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("globalError", "Lỗi khi upload ảnh danh mục: " + e.getMessage());
                String redirectUrl = (category.getCategoryId() == null) ? "/add" : "/edit/" + category.getCategoryId();
                return "redirect:/admin/categories" + redirectUrl;
            }
        }

        try {
            if (category.getCategoryId() == null) {
                categoryService.saveCategory(category);
                redirectAttributes.addFlashAttribute("globalMessage", "Thêm danh mục thành công!");
            } else {
                categoryService.updateCategory(category);
                redirectAttributes.addFlashAttribute("globalMessage", "Cập nhật danh mục thành công!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/categories/list";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Category> categoryOpt = categoryService.findById(id);
        if (categoryOpt.isPresent()) {
            model.addAttribute("category", categoryOpt.get());
            model.addAttribute("pageTitle", "Chỉnh Sửa Danh Mục");
            model.addAttribute("body", "/WEB-INF/views/admin/category-form.jsp");
            return "layout/admin-main";
        } else {
            redirectAttributes.addFlashAttribute("globalError", "Không tìm thấy danh mục.");
            return "redirect:/admin/categories/list";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteCategory(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            categoryService.deleteCategory(id);
            redirectAttributes.addFlashAttribute("globalMessage", "Xóa danh mục thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("globalError", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/categories/list";
    }
}
