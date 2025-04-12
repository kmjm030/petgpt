package com.mc.app.service;

import com.mc.app.dto.Admin;
import com.mc.app.frame.MCService;
import com.mc.app.repository.AdminRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService implements MCService<Admin, String> {

    private final AdminRepository adminRepository;

    @Override
    public void add(Admin admin) throws Exception {
        adminRepository.insert(admin);
    }

    @Override
    public void mod(Admin admin) throws Exception {
        adminRepository.update(admin);
    }

    @Override
    public void del(String adminId) throws Exception {
        adminRepository.delete(adminId);
    }

    @Override
    public Admin get(String adminId) throws Exception {
        return adminRepository.select(adminId);
    }

    @Override
    public List<Admin> get() throws Exception {
        return adminRepository.selectAll();
    }

    // 로그인 전용 메서드
    public Admin login(String id, String pwd) throws Exception {
        Admin admin = adminRepository.select(id);
        if (admin != null && admin.getAdminPwd().equals(pwd)) {
            return admin;
        }
        return null;
    }
}

