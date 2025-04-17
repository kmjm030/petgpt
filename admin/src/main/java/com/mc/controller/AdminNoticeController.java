package com.mc.controller;

import com.mc.app.dto.Admin;
import com.mc.app.dto.AdminNotice;
import com.mc.app.service.AdminNoticeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/notice")
public class AdminNoticeController {

    private final AdminNoticeService adminNoticeService;

    @GetMapping("/get")
    public String get(Model model) {
        try {
            model.addAttribute("noticeList", adminNoticeService.getRecentNotices());
        } catch (Exception e) {
            log.error("공지 목록 조회 실패: {}", e.getMessage());
            model.addAttribute("noticeList", null);
        }
        model.addAttribute("center", "admin/notice/get");
        return "index";
    }

    @GetMapping("/add")
    public String add(Model model) {
        model.addAttribute("center", "admin/notice/add");
        return "index";
    }

    @PostMapping("/addimpl")
    public String addImpl(@ModelAttribute AdminNotice notice, HttpSession session) {
        try {
            Admin admin = (Admin) session.getAttribute("admin");
            if (admin != null) {
                notice.setAdminId(admin.getAdminId());
            }
            adminNoticeService.writeNotice(notice);
        } catch (Exception e) {
            log.error("공지 등록 실패: {}", e.getMessage());
        }
        return "redirect:/admin/notice/get";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("id") int id, Model model) {
        try {
            AdminNotice notice = adminNoticeService.getNotice(id);
            model.addAttribute("notice", notice);
        } catch (Exception e) {
            log.warn("공지 조회 실패: {}", e.getMessage());
            model.addAttribute("notice", null);
        }
        model.addAttribute("center", "admin/notice/detail");
        return "index";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") int id) {
        try {
            adminNoticeService.deleteNotice(id);
        } catch (Exception e) {
            log.error("공지 삭제 실패: {}", e.getMessage());
        }
        return "redirect:/admin/notice/get";
    }

    @PostMapping("/editimpl")
    public String editImpl(@ModelAttribute AdminNotice notice, HttpSession session) {
        try {
            Admin admin = (Admin) session.getAttribute("admin");
            if (admin != null) {
                notice.setAdminId(admin.getAdminId());
            }
            adminNoticeService.editNotice(notice);
        } catch (Exception e) {
            log.error("공지 수정 실패: {}", e.getMessage());
        }
        return "redirect:/admin/notice/detail?id=" + notice.getId();
    }
}
