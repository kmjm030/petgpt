package com.mc.app.service;

import com.mc.app.dto.Category;
import com.mc.app.frame.MCService;
import com.mc.app.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryService implements MCService<Category, Integer> {

    final CategoryRepository categoryRepository;

    @Override
    public void add(Category category) throws Exception {
        categoryRepository.insert(category);
    }

    @Override
    public void mod(Category category) throws Exception {
        categoryRepository.update(category);
    }

    @Override
    public void del(Integer integer) throws Exception {
        categoryRepository.delete(integer);
    }

    @Override
    public Category get(Integer integer) throws Exception {
        return categoryRepository.selectOne(integer);
    }

    @Override
    public List<Category> get() throws Exception {
        return categoryRepository.select();
    }
    
    public List<Category> findAll() throws Exception {
        return categoryRepository.findAll();
    }
} 