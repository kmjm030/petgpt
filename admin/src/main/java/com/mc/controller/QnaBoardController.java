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
//            list.forEach(cust -> cust.setCustName(standardPBEStringEncryptor.decrypt(cust.getCustName())));
            model.addAttribute("boards",list);
            model.addAttribute("center",dir+"get");
            log.info("OK==============================:{}",list);
        } catch (Exception e) {
            log.info("OK==============================:{}",e.getMessage());
            throw new Exception("ER0001");
        }
        return "index";
    }

    @RequestMapping("/detail")  //ksk
    public String detail(Model model,@RequestParam("id") Integer id){
        // Database에서 데이터를 가지고 온다.
        QnaBoard board = null;
        AdminComments adminComments = null;
        Item item = null;
        try {
            board = qnaService.get(id);
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

//
//
//    @GetMapping("")
//    public String mypage(Model model, @RequestParam("id") String id, HttpSession session) throws Exception{
//
//        // 세션에서 로그인된 사용자 확인
//        Customer loggedInCustomer = (Customer)session.getAttribute("cust");
//
//        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
//        if (loggedInCustomer == null) {
//            return "redirect:/login";  // 로그인 페이지로 리다이렉트
//        }
//
//        // 로그인된 사용자만 자신의 QnA목록를 볼 수 있도록 처리
//        if (!loggedInCustomer.getCustId().equals(id)) {
//            return "redirect:/qnaboard?id=" + loggedInCustomer.getCustId();  // 자신의 마이페이지만 보여줌
//        }
//
//        List<QnaBoard> qnaBoards =  qnaService.findAllByCust(id);
//        model.addAttribute("qnaBoards", qnaBoards);
//        model.addAttribute("currentPage", "pages");
//        model.addAttribute("pageTitle", "QnA Board");
//        model.addAttribute("centerPage", "pages/mypage/qnaboard.jsp");
//        return "index";
//    }
//
//    @RequestMapping("/add")
//    public String add(Model model, HttpSession session) throws Exception{
//        List<Item> items = itemService.get();
//
//        model.addAttribute("items", items);
//        model.addAttribute("currentPage", "pages");
//        model.addAttribute("pageTitle", "QnA Add");
//        model.addAttribute("centerPage", "pages/mypage/qnaboard_add.jsp");
//        return "index";
//    }
//
//    @RequestMapping("/detail")
//    public String detail(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception{
//
//        QnaBoard board = qnaService.get(boardKey);
//
//        model.addAttribute("board", board);
//        model.addAttribute("currentPage", "pages");
//        model.addAttribute("pageTitle", "QnA Detail");
//        model.addAttribute("centerPage", "pages/mypage/qnaboard_detail.jsp");
//        return "index";
//    }
//
//    @RequestMapping("/addimpl")
//    public String addimpl(Model model, @RequestParam("custId") String custId, QnaBoard board) throws Exception {
//        board.setCustId(custId);
//        qnaService.add(board);
//        return "redirect:/qnaboard?id=" + custId;
//    }
//
//    @RequestMapping("/updateimpl")
//    public String updateimpl(Model model, @RequestParam("custId") String custId, QnaBoard board) throws Exception {
//        qnaService.mod(board);
//        return "redirect:/qnaboard?id=" + custId;
//    }

}
