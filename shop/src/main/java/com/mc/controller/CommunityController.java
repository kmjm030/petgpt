package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.CommunityBoard;
import com.mc.app.service.CommunityBoardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpServletRequest;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Slf4j
@Controller
@RequiredArgsConstructor
public class CommunityController {
    
    private final CommunityBoardService communityBoardService;

    @Value("${file.upload.directory}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix}")
    private String uploadUrlPrefix;

    @GetMapping("/community/detail")
    public String communityDetail(@RequestParam("id") int id, Model model) {
        try {
            CommunityBoard board = communityBoardService.getBoardDetail(id);
            
            if (board == null) {
                log.warn("존재하지 않는 게시글 ID({}) 조회 시도", id);

                model.addAttribute("errorMessage", "해당 게시글을 찾을 수 없습니다.");
                model.addAttribute("centerPage", "error.jsp"); // 경로 수정
            } else {
                model.addAttribute("board", board); 
                model.addAttribute("pageTitle", board.getBoardTitle()); 
                model.addAttribute("centerPage", "pages/community_detail.jsp"); 
            }
            
        } catch (Exception e) {
            log.error("게시글 상세 조회 중 오류 발생 - ID: {}", id, e);
            model.addAttribute("errorMessage", "게시글을 불러오는 중 오류가 발생했습니다.");
            model.addAttribute("centerPage", "error.jsp"); // 경로 수정
        }
        
        model.addAttribute("currentPage", "community"); 
        return "index"; 
    }

    @GetMapping("/community")
    public String community(

            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false) String sort,
            Model model) {
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
        
        log.info("Entered /community/write/submit POST method"); // 메소드 진입 로그 추가

        // 로그인 확인 1: 세션에 customer 객체가 있는지 확인
        if (customer == null) {
            log.info("세션에 customer 객체가 없습니다. 로그인 페이지로 리다이렉트합니다.");
            return "redirect:/login";
        }

        // 로그인 확인 2: customer 객체는 있지만 ID가 유효하지 않은 경우 확인 (null 또는 빈 문자열)
        String custId = customer.getCustId(); // custId를 변수로 추출
        if (custId == null || custId.trim().isEmpty()) {
             log.info("세션 customer 객체의 custId가 null이거나 비어있습니다. 로그인 페이지로 리다이렉트합니다. custId: {}", custId);
             return "redirect:/login?error=invalid_user"; // 로그인 페이지로 리다이렉트 (에러 파라미터 추가)
        }
        
        try {
            CommunityBoard board = new CommunityBoard();
            board.setBoardTitle(title);
            board.setCategory(category);
            board.setBoardContent(content);
            board.setCustId(customer.getCustId());
            
            // 썸네일 이미지 처리
            if (thumbnailImage != null && !thumbnailImage.isEmpty()) {
                String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
                String originalFilename = thumbnailImage.getOriginalFilename();
                String fileExtension = extractExtension(originalFilename);
                String storedFileName = UUID.randomUUID().toString() + fileExtension; 
                
                // 실제 저장될 전체 경로 계산 (설정값 + 날짜 폴더 + 고유 파일명)
                Path targetDirectory = Paths.get(uploadDirectory, dateFolder);
                Path targetLocation = targetDirectory.resolve(storedFileName);
                
                try {
                    // 디렉토리 생성 (없으면)
                    Files.createDirectories(targetDirectory);
                    // 파일 저장
                    Files.copy(thumbnailImage.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
                    
                    // DB에 저장될 웹 접근 가능 URL 경로 설정 (설정값 + 날짜 폴더 + 고유 파일명)
                    String webAccessiblePath = uploadUrlPrefix + "/" + dateFolder + "/" + storedFileName;
                    board.setBoardImg(webAccessiblePath);
                    log.info("썸네일 이미지 저장 성공: {}", targetLocation);
                    log.info("DB 저장 경로: {}", webAccessiblePath);
                    
                } catch (Exception e) {
                    log.error("썸네일 이미지 저장 실패: {}", targetLocation, e);
                    // 이미지 저장 실패 시 처리를 추가할 수 있음 (예: 에러 메시지 반환)
                    // 여기서는 일단 게시글 저장은 계속 진행하도록 둠
                }
            }
            
            // 서비스 호출 직전 로그 추가: 전달되는 custId 값 확인
            log.info("CommunityBoardService.createBoard 호출 직전 - custId: '{}', title: '{}'", board.getCustId(), board.getBoardTitle());
            communityBoardService.createBoard(board);
            
            return "redirect:/community";
        } catch (Exception e) {
            // 예외 로그 개선
            log.error("게시글 저장 중 오류 발생: custId='{}', title='{}'", customer.getCustId(), title, e);
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
