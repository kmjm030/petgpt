package com.mc.controller;

import com.mc.app.dto.AdminComments;
import com.mc.app.dto.Board;
import com.mc.app.dto.Item;
import com.mc.app.service.AdminCommentsService;
import com.mc.app.service.BoardService;
import com.mc.app.service.ItemService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/board")
public class BoardController {

    final BoardService boardService;
    final AdminCommentsService adminCommentsService;
    final ItemService itemService;
    final BCryptPasswordEncoder bCryptPasswordEncoder;
    final StandardPBEStringEncryptor standardPBEStringEncryptor;

    String dir = "board/";

    @RequestMapping("/get")
    public String get(Model model) throws Exception {
        // Database에서 데이터를 가지고 온다.
        List<Board> list = null;
        try {
            list = boardService.get();
//            list.forEach(cust -> cust.setCustName(standardPBEStringEncryptor.decrypt(cust.getCustName())));
            model.addAttribute("boards",list);
            model.addAttribute("center",dir+"get");
            log.info("OK==============================:{}",list);
        } catch (Exception e) {
            throw new Exception("ER0001");
        }
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model){

        model.addAttribute("center",dir+"add");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model,@RequestParam("id") Integer id){
        // Database에서 데이터를 가지고 온다.
        Board board = null;
        AdminComments adminComments = null;
        Item item = null;
        try {
            board = boardService.get(id);
            adminComments = adminCommentsService.get(id);
            item = itemService.get(board.getItemKey());
//            cust.setCustName(standardPBEStringEncryptor.decrypt(cust.getCustName()));
//            if(adminComments == null){
//                model.addAttribute("reply",board);
//            }
            log.info("OK==============================:{}",id);
            log.info("OK==============================:{}",board);
            log.info("OK==============================:{}",adminComments);
            model.addAttribute("board", board);
            model.addAttribute("item",item);
            model.addAttribute("adminComments", adminComments);
            model.addAttribute("center",dir+"detail");
            model.addAttribute("result","수정완료");

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return "index";
    }
    @RequestMapping("/update")
    public String update(Model model,Board board){

        try {
//            board.setCustName(standardPBEStringEncryptor.encrypt(cust.getCustName()));

            boardService.mod(board);
            return "redirect:/board/detail?id="+board.getBoardKey();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
//    @RequestMapping("/addimpl")
//    public String addimpl(Model model,Customer cust) throws Exception {
//        cust.setCustPwd(bCryptPasswordEncoder.encode(cust.getCustPwd()));
//        cust.setCustName(standardPBEStringEncryptor.encrypt(cust.getCustName()));
//        custService.add(cust);
//        return "redirect:/cust/detail?id="+cust.getCustId();
//
//    }
//    @RequestMapping("/delete")
//    public String delete(Model model,@RequestParam("id") String id){
//
//        try {
//            custService.del(id);
//            return "redirect:/cust/get";
//        } catch (Exception e) {
//            throw new RuntimeException(e);
//        }
//    }


}
