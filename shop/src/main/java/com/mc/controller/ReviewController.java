package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.Item;
import com.mc.app.dto.QnaBoard;
import com.mc.app.service.ItemService;
import com.mc.app.service.QnaBoardService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/review")
public class ReviewController {

    private final QnaBoardService boardService;
    private final ItemService itemService;

    @Value("${file.upload.directory}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix}")
    private String uploadUrlPrefix;


    @GetMapping("")
    public String review(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {

        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login";  // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 QnA목록를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/qnaboard?id=" + loggedInCustomer.getCustId();  // 자신의 마이페이지만 보여줌
        }

        List<QnaBoard> reviews = boardService.findReviewByCust(id);
        model.addAttribute("reviews", reviews);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Review");
        model.addAttribute("centerPage", "pages/mypage/review.jsp");
        return "index";
    }

}