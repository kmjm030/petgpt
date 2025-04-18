package com.mc.app.service;

import com.mc.app.dto.AdminNotice;
import com.mc.app.repository.AdminNoticeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminNoticeService {

    private final AdminNoticeRepository adminNoticeRepository;

    public List<AdminNotice> getRecentNotices() {
        return adminNoticeRepository.selectWithAdminName();
    }

    public void writeNotice(AdminNotice notice) {
        adminNoticeRepository.insert(notice);
    }

    public AdminNotice getNotice(int id) {
        return adminNoticeRepository.selectOne(id);
    }

    public void deleteNotice(int id) {
        adminNoticeRepository.delete(id);
    }

    public void editNotice(AdminNotice notice) {
        adminNoticeRepository.update(notice);
    }
}
