package com.mc.app.service;

import com.mc.app.dto.Admin;
import com.mc.app.frame.MCService;
import com.mc.app.repository.AdminRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public Admin login(String id, String pwd) throws Exception {
        Admin admin = adminRepository.select(id);
        if (admin != null && admin.getAdminPwd().equals(pwd)) {
            return admin;
        }
        return null;
    }

    public Map<String, Integer> getOrderStatusCountMap() throws Exception {
        List<Map<String, Object>> rawList = adminRepository.selectOrderStatusCount();
        Map<String, Integer> result = new HashMap<>();

        for (Map<String, Object> row : rawList) {
            String status = (String) row.get("order_status");
            Integer count = ((Number) row.get("count")).intValue();
            result.put(status, count);
        }

        return result;
    }
}


