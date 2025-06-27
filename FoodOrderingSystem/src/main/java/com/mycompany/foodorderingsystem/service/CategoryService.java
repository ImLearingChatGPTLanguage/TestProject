package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Category;
import java.util.List;
import java.util.Optional;

public interface CategoryService {

    Category saveCategory(Category category) throws Exception;

    Optional<Category> findById(Long categoryId);

    List<Category> findAllCategories();

    Category updateCategory(Category category) throws Exception;

    void deleteCategory(Long categoryId) throws Exception;
}
