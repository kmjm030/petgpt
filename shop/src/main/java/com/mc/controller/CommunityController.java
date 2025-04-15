package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.CommunityBoard;
import com.mc.app.service.CommunityBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpServletRequest;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
public class CommunityController {

    private final CommunityBoardService communityBoardService;

    @GetMapping("/community/detail")
    public String communityDetail(@RequestParam("id") int id, Model model) {
        model.addAttribute("currentPage", "community");
        model.addAttribute("pageTitle", "커뮤니티 글 상세");
        model.addAttribute("centerPage", "pages/blog_details.jsp");
        return "index";
    }

    @GetMapping("/community")
    public String community(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false) String sort,
            Model model) {
        model.addAttribute("currentPage", "community");
        model.addAttribute("pageTitle", "커뮤니티");
        
        if (category != null && !category.isEmpty()) {
            model.addAttribute("selectedCategory", category);
        }
        
        if (sort != null && !sort.isEmpty()) {
            model.addAttribute("selectedSort", sort);
        }
        
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 5);
        
        model.addAttribute("centerPage", "pages/community.jsp");
        return "index";
    }
    
    @GetMapping("/community/view/search")
    public String communitySearch(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false) String sort,
            Model model) {
        model.addAttribute("currentPage", "community");
        model.addAttribute("pageTitle", "커뮤니티 검색");
        
        if (keyword != null && !keyword.isEmpty()) {
            model.addAttribute("keyword", keyword);
            model.addAttribute("resultCount", 0);
        }
        
        if (sort != null && !sort.isEmpty()) {
            model.addAttribute("selectedSort", sort);
        }
        
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", 0);
        
        model.addAttribute("centerPage", "pages/community.jsp");
        return "index";
    }
    
    @GetMapping("/community/write")
    public String communityWrite(Model model) {
        model.addAttribute("currentPage", "community");
        model.addAttribute("pageTitle", "게시글 작성");
        model.addAttribute("centerPage", "pages/community_write.jsp");
        return "index";
    }
    
    @PostMapping("/community/write/submit")
    public String communityWriteSubmit(
            @RequestParam("title") String title,
            @RequestParam("category") String category,
            @RequestParam("content") String content,
            @RequestParam(value = "thumbnailImage", required = false) MultipartFile thumbnailImage,
            @SessionAttribute(name = "cust", required = false) Customer customer,
            HttpServletRequest request) {
        
        // 로그인 확인
        if (customer == null) {
            return "redirect:/login";
        }
        
        try {
            CommunityBoard board = new CommunityBoard();
            board.setBoardTitle(title);
            board.setCategory(category);
            board.setBoardContent(content);
            board.setCustomerId(customer.getCustId());
            
            // 썸네일 이미지 처리
            if (thumbnailImage != null && !thumbnailImage.isEmpty()) {
                // 파일 저장 로직 (FileUploadController와 유사하게 구현)
                String uploadDir = request.getServletContext().getRealPath("/uploads/images");
                String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
                String fileName = UUID.randomUUID().toString() + extractExtension(thumbnailImage.getOriginalFilename());
                
                File directory = new File(uploadDir + "/" + dateFolder);
                if (!directory.exists()) {
                    directory.mkdirs();
                }
                
                Path targetLocation = Paths.get(uploadDir + "/" + dateFolder + "/" + fileName);
                Files.copy(thumbnailImage.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
                
                // DB에 이미지 경로 저장
                board.setBoardImg("/uploads/images/" + dateFolder + "/" + fileName);
            }
            
            // CommunityBoardService를 통해 게시글 저장
            communityBoardService.createBoard(board);
            
            return "redirect:/community";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/community/write?error=true";
        }
    }
    
    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }
} 