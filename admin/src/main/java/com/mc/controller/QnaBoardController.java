package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.AdminCommentsService;
import com.mc.app.service.ItemService;
import com.mc.app.service.QnaBoardService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/qnaboard")
public class QnaBoardController {

    private final QnaBoardService qnaService;
    private final ItemService itemService;
    private final AdminCommentsService adminCommentsService;
    String dir = "qnaboard/";

    @RequestMapping("/get")
    public String get(Model model,
                      @RequestParam(defaultValue = "1") int page,
                      @RequestParam(required = false) String field,
                      @RequestParam(required = false) String keyword) throws Exception {

        int limit = 10;
        int offset = (page - 1) * limit;

        try {
            List<QnaBoard> list;
            int totalCount;

            if (field != null && keyword != null && !field.isEmpty() && !keyword.isEmpty()) {
                list = qnaService.searchPage(field, keyword, offset, limit);
                totalCount = qnaService.searchCount(field, keyword);
            } else {
                list = qnaService.getPage(offset, limit);
                totalCount = qnaService.getTotalCount();
            }

            int totalPages = (int) Math.ceil((double) totalCount / limit);

            model.addAttribute("boards", list);
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("field", field);
            model.addAttribute("keyword", keyword);
            model.addAttribute("center", dir + "get");

            log.info("QnA list loaded: page={}, field={}, keyword={}", page, field, keyword);
        } catch (Exception e) {
            log.error("Error loading QnA list", e);
        }

        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("id") Integer id) {
        QnaBoard board = null;
        AdminComments adminComments = null;
        Item item = null;

        try {
            board = qnaService.get(id);
            adminComments = adminCommentsService.get(id);
            item = itemService.get(board.getItemKey());

            model.addAttribute("board", board);
            model.addAttribute("item", item);
            model.addAttribute("adminComments", adminComments);
            model.addAttribute("center", dir + "detail");

            log.info("QnA detail loaded: {}", id);
        } catch (Exception e) {
            log.error("Error loading QnA detail", e);
        }

        return "index";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") Integer id) {
        try {
            qnaService.del(id);
        } catch (Exception e) {
            log.error("Error deleting QnA", e);
        }
        return "redirect:/qnaboard/get";
    }
}
