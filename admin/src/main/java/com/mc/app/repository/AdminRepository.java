package com.mc.app.repository;

import com.mc.app.dto.Admin;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminRepository {
    void insert(Admin admin);
    void update(Admin admin);
    void delete(String adminId);
    Admin select(String adminId);
    List<Admin> selectAll();
    List<Map<String, Object>> selectOrderStatusCount();
}



