package com.mycompany.foodorderingsystem.service;

import com.mycompany.foodorderingsystem.model.Category;
import com.mycompany.foodorderingsystem.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    @Override
    public Category saveCategory(Category category) throws Exception {
        if (categoryRepository.findByName(category.getName()).isPresent()) {
            throw new Exception("Tên danh mục '" + category.getName() + "' đã tồn tại.");
        }
        return categoryRepository.save(category);
    }

    @Override
    public Optional<Category> findById(Long categoryId) {
        return categoryRepository.findById(categoryId);
    }

    @Override
    public List<Category> findAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    public Category updateCategory(Category category) throws Exception {
        Optional<Category> existing = categoryRepository.findByName(category.getName());
        if (existing.isPresent() && !existing.get().getCategoryId().equals(category.getCategoryId())) {
            throw new Exception("Tên danh mục '" + category.getName() + "' đã tồn tại.");
        }
        return categoryRepository.save(category);
    }

    @Override
    public void deleteCategory(Long categoryId) throws Exception {
        if (!categoryRepository.existsById(categoryId)) {
            throw new Exception("Không tìm thấy danh mục để xóa.");
        }
        categoryRepository.deleteById(categoryId);
    }
}
