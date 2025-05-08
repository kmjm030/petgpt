package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.Item;
import com.mc.app.dto.Like;
import com.mc.app.dto.QnaBoard;
import com.mc.app.service.CouponService;
import com.mc.app.service.CustomerService;
import com.mc.app.service.ItemService;
import com.mc.app.service.LikeService;
import jakarta.servlet.http.HttpServletRequest;
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

    private void setDefaultProfileImage(Customer cust, HttpServletRequest request) {
        if (cust.getCustImg() == null || cust.getCustImg().isEmpty()) {
            String defaultImagePath = "/img/user/" + cust.getCustName() + ".png";

            String filePath = request.getSession().getServletContext()
                    .getRealPath("/resources/static" + defaultImagePath);

            if (new java.io.File(filePath).exists()) {
                cust.setCustImg(defaultImagePath);
            } else {
                cust.setCustImg("/img/clients/profile.png");
            }
        }
    }

    @GetMapping("")
    public String mypage(Model model, @RequestParam("id") String id, HttpSession session, HttpServletRequest request)
            throws Exception {

        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/login"; // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 마이페이지를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/mypage?id=" + loggedInCustomer.getCustId(); // 자신의 마이페이지만 보여줌
        }

        Customer cust = custService.get(id);

        // 프로필 이미지가 없는 경우 기본 이미지 설정
        setDefaultProfileImage(cust, request);

        model.addAttribute("cust", cust);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "MyPage");
        model.addAttribute("viewName", "mypage");
        model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
        return "index";
    }

    @RequestMapping("/updateimpl")
    public String updateimpl(Model model, Customer cust,
            @RequestParam(value = "newPwd", required = false) String newPwd,
            @RequestParam("img") MultipartFile img,
            @RequestParam(value = "imgDelete", required = false) String imgDelete,
            HttpServletRequest request) throws Exception {

        // 1. DB에서 현재 사용자 정보 조회
        Customer dbCust = custService.get(cust.getCustId());
        if (dbCust == null) {
            return "redirect:/login";
        }

        model.addAttribute("cust", dbCust);

        // 2. 카카오 사용자인지 확인
        boolean isKakaoUser = dbCust.getCustId() != null && dbCust.getCustId().startsWith("kakao_");

        // 3. 비밀번호 처리 (카카오 사용자가 아닌 경우에만)
        if (!isKakaoUser) {

            if (cust.getCustPwd() == null || cust.getCustPwd().isEmpty()) {
                model.addAttribute("msg", "수정을 위해서는 현재 비밀번호를 입력해야 합니다.");
                model.addAttribute("currentPage", "pages");
                model.addAttribute("pageTitle", "마이페이지");
                model.addAttribute("viewName", "mypage");
                model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
                return "index";
            }

            // 현재 비밀번호 확인
            if (!dbCust.getCustPwd().equals(cust.getCustPwd())) {
                model.addAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
                model.addAttribute("currentPage", "pages");
                model.addAttribute("pageTitle", "마이페이지");
                model.addAttribute("viewName", "mypage");
                model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
                return "index";
            }

            // 새 비밀번호 처리
            if (newPwd != null && !newPwd.isEmpty()) {
                cust.setCustPwd(newPwd);
            } else {
                cust.setCustPwd(dbCust.getCustPwd());
            }
        } else {
            // 카카오 사용자는 기존 비밀번호를 유지
            cust.setCustPwd(dbCust.getCustPwd());
        }

        // 4. 이미지 처리
        if ("true".equals(imgDelete)) {
            // 이미지 삭제 요청이 있는 경우
            cust.setCustImg(null);
            // 이미지를 삭제했을 경우 기본 이미지로 사용자 이름 기반 이미지 설정
            setDefaultProfileImage(cust, request);
        } else if (!img.isEmpty()) {
            // 새 이미지 업로드가 있는 경우
            String originalFilename = img.getOriginalFilename();
            String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = cust.getCustId() + "_" + System.currentTimeMillis() + fileExtension;
            String filePath = uploadDirectory + "/cust/" + newFilename;
            String fileUrl = uploadUrlPrefix + "/cust/" + newFilename;

            // 파일 저장
            try {
                Path uploadPath = Paths.get("C:", "petshop", "uploads", "images", "cust");
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                java.nio.file.Files.copy(img.getInputStream(), java.nio.file.Paths.get(filePath),
                        java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                cust.setCustImg(fileUrl);
            } catch (Exception e) {
                log.error("이미지 저장 중 오류 발생: " + e.getMessage(), e);
                model.addAttribute("msg", "이미지 저장 중 오류가 발생했습니다.");
                model.addAttribute("currentPage", "pages");
                model.addAttribute("pageTitle", "마이페이지");
                model.addAttribute("viewName", "mypage");
                model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
                return "index";
            }
        } else {
            // 이미지 변경이 없는 경우 기존 이미지 유지
            cust.setCustImg(dbCust.getCustImg());
            // 만약 기존 이미지가 없다면 기본 이미지 설정
            if (cust.getCustImg() == null || cust.getCustImg().isEmpty()) {
                setDefaultProfileImage(cust, request);
            }
        }

        // 5. 나머지 필드 처리
        cust.setCustRdate(dbCust.getCustRdate());
        cust.setCustPoint(dbCust.getCustPoint());
        cust.setPointCharge(dbCust.getPointCharge());
        cust.setPointReason(dbCust.getPointReason());
        cust.setCustAuth(dbCust.getCustAuth());

        custService.mod(cust);

        return "redirect:/mypage?id=" + cust.getCustId();
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
        model.addAttribute("viewName", "like");
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
