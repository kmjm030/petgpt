package com.mc.controller;

import com.mc.app.dto.Address;
import com.mc.app.dto.Customer;
import com.mc.app.dto.Item;
import com.mc.app.dto.QnaBoard;
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

    @GetMapping("")
    public String mypage(Model model, @RequestParam("id") String id, HttpSession session) throws Exception{

        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer)session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login";  // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 QnA목록를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/qnaboard?id=" + loggedInCustomer.getCustId();  // 자신의 마이페이지만 보여줌
        }

        List<QnaBoard> qnaBoards =  qnaService.findAllByCust(id);
        model.addAttribute("qnaBoards", qnaBoards);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Board");
        model.addAttribute("centerPage", "pages/mypage/qnaboard.jsp");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model, HttpSession session) throws Exception{
        List<Item> items = itemService.get();

        model.addAttribute("items", items);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Add");
        model.addAttribute("centerPage", "pages/mypage/qnaboard_add.jsp");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception{

        QnaBoard board = qnaService.get(boardKey);

        model.addAttribute("board", board);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Detail");
        model.addAttribute("centerPage", "pages/mypage/qnaboard_detail.jsp");
        return "index";
    }

    @RequestMapping("/addimpl")
    public String addimpl(Model model, @RequestParam("custId") String custId, QnaBoard board) throws Exception {
        board.setCustId(custId);
        qnaService.add(board);
        return "redirect:/qnaboard?id=" + custId;
    }

}
