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

    @RequestMapping("/get") //ksk
    public String get(Model model) throws Exception {
        List<QnaBoard> list = null;
        try {
            list = qnaService.get();
            model.addAttribute("boards",list);
            model.addAttribute("center",dir+"get");
            log.info("OK==============================:{}",list);
        } catch (Exception e) {
            log.info("ERROR==============================:{}",e.getMessage());
        }
        return "index";
    }

    @RequestMapping("/detail")  //ksk
    public String detail(Model model,@RequestParam("id") Integer id){
        QnaBoard board = null;
        AdminComments adminComments = null;
        Item item = null;
        try {
            board = qnaService.get(id);
            adminComments = adminCommentsService.get(id);
            item = itemService.get(board.getItemKey());
            log.info("OK==============//================:{}",id);
            log.info("OK===============//===============:{}",board);
            log.info("OK================//==============:{}",adminComments);
            model.addAttribute("board", board);
            model.addAttribute("item",item);
            model.addAttribute("adminComments", adminComments);
            model.addAttribute("center",dir+"detail");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return "index";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") Integer id) {
        try {
            qnaService.del(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/qnaboard/get";
    }
}
