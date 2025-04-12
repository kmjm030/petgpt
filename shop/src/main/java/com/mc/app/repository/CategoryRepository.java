package com.mc.app.repository;

import com.mc.app.dto.Category;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CategoryRepository extends MCRepository<Category, Integer> {
    List<Category> findAll() throws Exception;
} 