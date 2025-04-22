package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.CommunityBoard;
import com.mc.app.service.CommunityBoardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
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
@RequestMapping("/community")
public class CommunityController {

    private final CommunityBoardService communityBoardService;

    /**
     * 커뮤니티 목록 페이지 조회
     */
    @GetMapping
    public String community(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false) String sort,
            Model model) {

        if (category != null && !category.isEmpty()) {
            model.addAttribute("selectedCategory", category);
        }

        if (sort != null && !sort.isEmpty()) {
            model.addAttribute("selectedSort", sort);
        }

        model.addAttribute("totalPages", 5); // TODO: 실제 페이지 수로 변경 필요
        model.addAttribute("currentPage", page);
        model.addAttribute("pageTitle", "커뮤니티");
        model.addAttribute("centerPage", "pages/community.jsp");
        return "index";
    }

    /**
     * 게시글 상세 페이지 조회
     */
    @GetMapping("/detail")
    public String communityDetail(@RequestParam("id") int id, Model model) {
        try {
            CommunityBoard board = communityBoardService.getBoardDetail(id);

            if (board == null) {
                log.warn("존재하지 않는 게시글 ID({}) 조회 시도", id);
                model.addAttribute("errorMessage", "해당 게시글을 찾을 수 없습니다.");
                model.addAttribute("centerPage", "error.jsp");
            } else {
                model.addAttribute("board", board);
                model.addAttribute("pageTitle", board.getBoardTitle());

                if (board.getRegDate() != null) {
                    String formattedDate = board.getRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
                    model.addAttribute("formattedRegDate", formattedDate);
                } else {
                    model.addAttribute("formattedRegDate", "작성일 정보 없음");
                }
                model.addAttribute("centerPage", "pages/community_detail.jsp");
            }

        } catch (Exception e) {
            log.error("게시글 상세 조회 중 오류 발생 - ID: {}", id, e);
            model.addAttribute("errorMessage", "게시글을 불러오는 중 오류가 발생했습니다.");
            model.addAttribute("centerPage", "error.jsp");
        }

        model.addAttribute("currentPage", "community");
        return "index";
    }

    /**
     * 커뮤니티 검색 결과 페이지 조회
     */
    @GetMapping("/search")
    public String communitySearch(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false) String sort,
            Model model) {

        if (keyword != null && !keyword.isEmpty()) {
            model.addAttribute("keyword", keyword);
            model.addAttribute("resultCount", 0); // TODO: 실제 검색 결과 수로 변경 필요
        }

        if (sort != null && !sort.isEmpty()) {
            model.addAttribute("selectedSort", sort);
        }

        model.addAttribute("totalPages", 0); // TODO: 실제 페이지 수로 변경 필요
        model.addAttribute("currentPage", page);
        model.addAttribute("pageTitle", "커뮤니티 검색");
        model.addAttribute("centerPage", "pages/community.jsp");
        return "index";
    }

    /**
     * 게시글 작성 페이지 로딩
     */
    @GetMapping("/write")
    public String communityWriteForm(Model model,
            @SessionAttribute(name = "cust", required = false) Customer customer) {

        if (customer == null) {
            log.info("세션에 customer 객체가 없습니다. 로그인 페이지로 리다이렉트.");
            return "redirect:/gologin";
        }

        model.addAttribute("currentPage", "community");
        model.addAttribute("pageTitle", "게시글 작성");
        model.addAttribute("centerPage", "pages/community_write.jsp");
        return "index";
    }

    /**
     * 게시글 수정 페이지 로딩
     */
    @GetMapping("/edit/{boardKey}")
    public String editPostForm(@PathVariable("boardKey") Integer boardKey, Model model,
            @SessionAttribute(name = "cust", required = false) Customer customer) {

        if (customer == null) {
            log.info("세션에 customer 객체가 없습니다. 로그인 페이지로 리다이렉트.");
            return "redirect:/gologin";
        }

        try {
            CommunityBoard board = communityBoardService.getBoardDetail(boardKey);

            if (board == null) {
                log.warn("존재하지 않는 게시글 ID({}) 수정 페이지 접근 시도", boardKey);
                model.addAttribute("errorMessage", "해당 게시글을 찾을 수 없습니다.");
                model.addAttribute("centerPage", "error.jsp");
                return "index";
            }

            if (!board.getCustId().equals(customer.getCustId())) {
                log.warn("게시글 ID({}) 수정 권한 없음 - 로그인: {}, 게시글 작성: {}", boardKey, customer.getCustId(),
                        board.getCustId());
                model.addAttribute("errorMessage", "수정 권한이 없습니다.");
                model.addAttribute("centerPage", "error.jsp");
                return "index";
            }

            // *** 로그 추가: board 객체와 boardImg 값 확인 ***
            log.info("수정 페이지 로딩 - 조회된 board 객체: {}", board);
            log.info("수정 페이지 로딩 - board.getBoardImg(): {}", board.getBoardImg());

            model.addAttribute("board", board);
            model.addAttribute("boardKey", boardKey);
            model.addAttribute("currentPage", "community");
            model.addAttribute("pageTitle", "게시글 수정");
            model.addAttribute("centerPage", "pages/community_edit.jsp");
            return "index";

        } catch (Exception e) {
            log.error("게시글 수정 페이지 로딩 중 오류 발생 - boardKey: {}", boardKey, e);
            model.addAttribute("errorMessage", "페이지를 불러오는 중 오류가 발생했습니다.");
            model.addAttribute("centerPage", "error.jsp");
            return "index";
        }
    }

}
