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
import org.springframework.http.MediaType;
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
    public String mypage(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {

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
        model.addAttribute("cust", cust);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "MyPage");
        model.addAttribute("viewName", "mypage");
        model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
        return "index";
    }

    @PostMapping(value = "/updateimpl", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public String updateimpl(Model model, Customer cust,
            @RequestParam(value = "newPwd", required = false) String newPwd,
            @RequestParam("img") MultipartFile img,
            @RequestParam(value = "imgDelete", required = false) String imgDelete) throws Exception {

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
                return "redirect:/mypage?id=" + dbCust.getCustId();

            } else if (!dbCust.getCustPwd().equals(cust.getCustPwd())) {

                model.addAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
                return "redirect:/mypage?id=" + dbCust.getCustId();
            }

            if (newPwd != null && !newPwd.trim().isEmpty()) {

                dbCust.setCustPwd(newPwd);
            }
        }

        // 4. 이미지 처리 (모든 사용자 공통)
        try {
            // 기존 게시글을 불러와서 기존 이미지 경로를 알아냄
            String oldImgPath = dbCust.getCustImg();

            // 4-1. 새 이미지 파일이 업로드된 경우
            if (img != null && !img.isEmpty()) {

                // 기존 이미지 삭제
                if (oldImgPath != null && !oldImgPath.isEmpty()) {

                    try {
                        String relativePath = oldImgPath.replace(uploadUrlPrefix, "");
                        Path oldFilePath = Paths.get(uploadDirectory, relativePath);
                        Files.deleteIfExists(oldFilePath);
                        log.info("기존 이미지 삭제됨: {}", oldFilePath);

                    } catch (Exception e) {
                        log.error("기존 이미지 파일 삭제 실패: {}", oldImgPath, e);
                    }
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
                dbCust.setCustImg(webAccessiblePath);

            }
            // 4-2. 이미지 삭제 플래그가 true인 경우 (새 이미지 업로드는 없음)
            else if ("true".equals(imgDelete)) {

                // 기존 이미지 파일 삭제
                if (oldImgPath != null && !oldImgPath.isEmpty()) {

                    try {
                        String relativePath = oldImgPath.replace(uploadUrlPrefix, "");
                        Path oldFilePath = Paths.get(uploadDirectory, relativePath);
                        Files.deleteIfExists(oldFilePath);
                        log.info("요청에 의해 기존 이미지 삭제됨: {}", oldFilePath);

                    } catch (Exception e) {
                        log.error("기존 이미지 파일 삭제 실패 (삭제 요청): {}", oldImgPath, e);
                    }
                }
                dbCust.setCustImg(null);
            }

            // 5. 기타 정보 업데이트 (Form에서 받은 정보로 DB 객체 업데이트)
            dbCust.setCustNick(cust.getCustNick());
            dbCust.setCustPhone(cust.getCustPhone());
            dbCust.setCustEmail(cust.getCustEmail());

            // 6. DB에 최종 업데이트 수행
            custService.mod(dbCust);

        } catch (Exception e) {
            log.error("회원 정보 수정 중 오류 발생 (custId: {}): {}", dbCust.getCustId(), e.getMessage(), e);
            model.addAttribute("msg", "정보 수정 중 오류가 발생했습니다.");
            // 에러 발생 시 다시 마이페이지로 리다이렉트 (메시지 전달은 RedirectAttributes 필요)
            return "redirect:/mypage?id=" + dbCust.getCustId();
        }

        // 7. 성공 시 마이페이지로 리다이렉트
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
