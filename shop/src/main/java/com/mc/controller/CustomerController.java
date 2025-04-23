package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.Item;
import com.mc.app.dto.Like;
import com.mc.app.dto.QnaBoard;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import com.mc.app.service.ItemService;
import com.mc.app.service.LikeService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class CustomerController {

    @Value("${file.upload.directory}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix}")
    private String uploadUrlPrefix;

    private final CustomerService custService;
    private final LikeService likeService;
    private final ItemService itemService;


    @GetMapping("")
    public String mypage(Model model, @RequestParam("id") String id, HttpSession session) throws Exception{

        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer)session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login";  // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 마이페이지를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/mypage?id=" + loggedInCustomer.getCustId();  // 자신의 마이페이지만 보여줌
        }

        Customer cust = custService.get(id);
        model.addAttribute("cust", cust);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "MyPage");
        model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
        return "index";
    }

    @RequestMapping("/updateimpl")
    public String updateimpl(Model model, Customer cust,
                             @RequestParam("newPwd") String newPwd,
                             @RequestParam("img") MultipartFile img,
                             @RequestParam(value = "imgDelete", required = false) String imgDelete) throws Exception {

        // 현재 비밀번호 확인
        Customer dbCust = custService.get(cust.getCustId());
        if (dbCust == null) {
            model.addAttribute("msg", "사용자 정보를 찾을 수 없습니다.");
            model.addAttribute("cust", cust);
            return "redirect:/mypage?id=" + cust.getCustId(); // 사용자 정보 없음
        } else if (!dbCust.getCustPwd().equals(cust.getCustPwd())) {
            model.addAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
            model.addAttribute("cust", cust);
            return "redirect:/mypage?id=" + cust.getCustId(); // 비밀번호 불일치 시 에러 메시지 출력
        }

        if (newPwd != null && !newPwd.trim().isEmpty()) {
            cust.setCustPwd(newPwd);
        }

        try {
            // 기존 게시글을 불러와서 기존 이미지 경로를 알아냄
            Customer exCust = custService.get(cust.getCustId());
            String oldImgPath = exCust.getCustImg();

            // 새 이미지가 업로드되었을 경우
            if (img != null && !img.isEmpty()) {
                // 기존 이미지 삭제
                if (oldImgPath != null && !oldImgPath.isEmpty()) {
                    // 웹 경로를 실제 경로로 변환
                    String relativePath = oldImgPath.replace(uploadUrlPrefix, ""); // "/2025/04/15/abc.jpg"
                    Path oldFilePath = Paths.get(uploadDirectory, relativePath);
                    Files.deleteIfExists(oldFilePath);
                    log.info("기존 이미지 삭제됨: {}", oldFilePath);
                }

                // 새 이미지 저장
                String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
                String originalFilename = img.getOriginalFilename();
                String fileExtension = extractExtension(originalFilename);
                String storedFileName = UUID.randomUUID().toString() + fileExtension;
                Path targetDirectory = Paths.get(uploadDirectory, dateFolder);
                Path targetLocation = targetDirectory.resolve(storedFileName);

                Files.createDirectories(targetDirectory);
                Files.copy(img.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

                String webAccessiblePath = uploadUrlPrefix + "/" + dateFolder + "/" + storedFileName;
                cust.setCustImg(webAccessiblePath);

            } else if ("true".equals(imgDelete)) {
                // 이미지를 삭제만 하고 새 업로드 없음
                if (oldImgPath != null && !oldImgPath.isEmpty()) {
                    String relativePath = oldImgPath.replace(uploadUrlPrefix, "");
                    Path oldFilePath = Paths.get(uploadDirectory, relativePath);
                    Files.deleteIfExists(oldFilePath);
                }
                cust.setCustImg(null);  // DB에서도 제거
            } else {
                // 아무 변화 없으면 기존 이미지 유지
                cust.setCustImg(oldImgPath);
            }
            custService.mod(cust);
        } catch (Exception e) {
            log.error("게시글 수정 중 오류", e);
        }
        return "redirect:/mypage?id=" + dbCust.getCustId();
    }

    @RequestMapping("/like")
    public String like(Model model, @RequestParam("id") String id) throws Exception {

        List<Like> likes = likeService.getLikesByCustomer(id);
        List<Item> items = new ArrayList<>();
        for (Like like : likes) {
            Item item = itemService.get(like.getItemKey());
            items.add(item);
        }

        model.addAttribute("items", items);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Like Page");
        model.addAttribute("centerPage", "pages/mypage/like.jsp");
        return "index";
    }

    @RequestMapping("/likedelimpl")
    public String likedelimpl(Model model, @RequestParam("itemKey") int itemKey,
                                            @RequestParam("id") String custId) throws Exception {
        likeService.deleteForMypage(custId, itemKey);
        return "redirect:/mypage/like?id=" + custId;
    }

    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }



}
