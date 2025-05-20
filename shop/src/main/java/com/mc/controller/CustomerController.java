package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.*;
import jakarta.servlet.http.HttpServletRequest;
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
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
    private final RecentViewService viewService;

    private void setDefaultProfileImage(Customer cust, HttpServletRequest request) {
        if (cust.getCustImg() == null || cust.getCustImg().isEmpty()) {
            String defaultImagePath = "/img/user/" + cust.getCustName() + ".png";

            try {
                String staticImagePath = request.getServletContext().getRealPath("/static" + defaultImagePath);
                if (new java.io.File(staticImagePath).exists()) {
                    cust.setCustImg(defaultImagePath);
                    return;
                }

                java.net.URL resourceUrl = getClass().getResource("/static" + defaultImagePath);
                if (resourceUrl != null) {
                    cust.setCustImg(defaultImagePath);
                    return;
                }

                String projectPath = System.getProperty("user.dir");
                String resourcePath = projectPath + "/shop/src/main/resources/static" + defaultImagePath;
                if (new java.io.File(resourcePath).exists()) {
                    cust.setCustImg(defaultImagePath);
                    return;
                }

                cust.setCustImg("/img/clients/profile.png");

            } catch (Exception e) {
                log.debug("기본 이미지 설정 중 오류 발생: {}", e.getMessage());
                cust.setCustImg("/img/clients/profile.png");
            }
        }
    }

    @GetMapping("")
    public String mypage(Model model, @RequestParam("id") String id, HttpSession session, HttpServletRequest request)
            throws Exception {

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/signin";
        }
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/mypage?id=" + loggedInCustomer.getCustId();
        }
        Customer cust = custService.get(id);
        setDefaultProfileImage(cust, request);

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
            @RequestParam(value = "imgDelete", required = false) String imgDelete,
            HttpServletRequest request) throws Exception {

        Customer dbCust = custService.get(cust.getCustId());
        if (dbCust == null) {
            return "redirect:/signin";
        }

        model.addAttribute("cust", dbCust);

        boolean isKakaoUser = dbCust.getCustId() != null && dbCust.getCustId().startsWith("kakao_");
        if (!isKakaoUser) {
            if (cust.getCustPwd() == null || cust.getCustPwd().isEmpty()) {
                model.addAttribute("msg", "수정을 위해서는 현재 비밀번호를 입력해야 합니다.");
                model.addAttribute("currentPage", "pages");
                model.addAttribute("pageTitle", "마이페이지");
                model.addAttribute("viewName", "mypage");
                model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
                return "index";
            }
            if (!dbCust.getCustPwd().equals(cust.getCustPwd())) {
                model.addAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
                model.addAttribute("currentPage", "pages");
                model.addAttribute("pageTitle", "마이페이지");
                model.addAttribute("viewName", "mypage");
                model.addAttribute("centerPage", "pages/mypage/mypage.jsp");
                return "index";
            }
            if (newPwd != null && !newPwd.isEmpty()) {
                cust.setCustPwd(newPwd);
            } else {
                cust.setCustPwd(dbCust.getCustPwd());
            }
        } else {
            cust.setCustPwd(dbCust.getCustPwd());
        }


        if ("true".equals(imgDelete)) {
            cust.setCustImg(null);
            setDefaultProfileImage(cust, request);
        } else if (!img.isEmpty()) {
            String originalFilename = img.getOriginalFilename();
            String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = cust.getCustId() + "_" + System.currentTimeMillis() + fileExtension;
            String filePath = uploadDirectory + "/cust/" + newFilename;
            String fileUrl = uploadUrlPrefix + "/cust/" + newFilename;

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
            cust.setCustImg(dbCust.getCustImg());
            if (cust.getCustImg() == null || cust.getCustImg().isEmpty()) {
                setDefaultProfileImage(cust, request);
            }
        }

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

        LocalDateTime oneYearAgo = LocalDateTime.now().minusYears(1);
        Date date = Date.from(oneYearAgo.atZone(ZoneId.systemDefault()).toInstant());
        likeService.deleteOlderThan(date);
        List<Like> likes = likeService.getLikesByCustomer(id);
        likes.sort((v1, v2) -> v2.getLikeRdate().compareTo(v1.getLikeRdate()));
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

  @RequestMapping("/likeaddimpl")
  public String likeaddimpl(Model model, @RequestParam("itemKey") int itemKey, HttpSession session) throws Exception {
      Customer loggedInCustomer = (Customer) session.getAttribute("cust");
      if (loggedInCustomer == null) {
        return "redirect:/signin";
      }

      String custId = loggedInCustomer.getCustId();
      List<Like> likes = likeService.getLikesByCustomer(custId);

      boolean alreadyLiked = likes.stream()
        .anyMatch(like -> like.getItemKey() == itemKey);

      if (!alreadyLiked) {
        Like like = Like.builder()
          .itemKey(itemKey)
          .custId(custId)
          .build();
        likeService.add(like);
      }
      return "redirect:/shop/details?itemKey=" + itemKey;
  }

    @RequestMapping("/view")
    public String view(Model model, @RequestParam("id") String id) throws Exception {

        List<RecentView> views = viewService.findAllByCustomer(id);
        views.sort((v1, v2) -> v2.getViewDate().compareTo(v1.getViewDate()));

        for (RecentView view : views) {
            Item item = itemService.get(view.getItemKey());
            view.setItem(item);
        }

        model.addAttribute("views", views);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Recent View Page");
        model.addAttribute("viewName", "recent_view");
        model.addAttribute("centerPage", "pages/mypage/recent_view.jsp");
        return "index";
    }

    @RequestMapping("/viewdelimpl")
    public String viewdelimpl(Model model, @RequestParam("viewKey") int viewKey, HttpSession session) throws Exception {
        viewService.del(viewKey);
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        String custId = loggedInCustomer.getCustId();
        return "redirect:/mypage/view?id=" + custId;
    }

    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

}
