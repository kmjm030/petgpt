package com.mc.controller;

import com.mc.app.dto.AdminComments;
import com.mc.app.service.AdminCommentsService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/admincomments")
public class AdminCommentsController {
    private final AdminCommentsService adminCommentsService;

    @PostMapping("/addimpl")
    public String addimpl(Model model, AdminComments adminComments, HttpSession session) throws Exception {

        adminComments.setAdminId("admin1");
        try {
            adminCommentsService.add(adminComments);
            adminCommentsService.updateBoardReStatus(adminComments.getBoardKey(),"답변있음");

        }catch (Exception e) {
            log.info("addimpl error========================{}", e.getMessage());
        }
        model.addAttribute("adminComments", adminComments);

        return "redirect:/qnaboard/detail?id=" + adminComments.getBoardKey();
    }

    @RequestMapping("/delete")
    public String delete(Model model,   @RequestParam("adcommentsKey") int adcommentsKey,
                                        @RequestParam("boardKey") int boardKey                ) throws Exception {

        try {
            log.info("delete=======adcommentsKey={}",adcommentsKey);
            log.info("delete=======boardKey={}",boardKey);
            adminCommentsService.del(adcommentsKey);
            adminCommentsService.updateBoardReStatus(boardKey,"답변대기");

            return "redirect:/qnaboard/detail?id=" + boardKey;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
