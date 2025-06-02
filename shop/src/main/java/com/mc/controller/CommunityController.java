package com.mc.controller;

import com.mc.app.dto.Comments;
import com.mc.app.dto.Customer;
import com.mc.app.dto.CommunityBoard;
import com.mc.app.service.CommentsService;
import com.mc.app.service.CommunityBoardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import jakarta.servlet.http.HttpSession;

import java.util.Map;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/community")
public class CommunityController {

    private final CommunityBoardService communityBoardService;
    private final CommentsService commentsService;

    @GetMapping
    public String community(
            @RequestParam(name = "category", required = false) String category,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false, defaultValue = "comments") String sort,
            Model model) {

        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("currentPage", page);

        model.addAttribute("pageTitle", "커뮤니티");
        model.addAttribute("centerPage", "pages/community.jsp");
        model.addAttribute("viewName", "community");
        return "index";
    }

    @GetMapping("/detail")
    public String communityDetail(@RequestParam("id") int id, Model model, HttpSession session) {
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

                String boardAuthorId = board.getCustId();
                Customer loggedInUser = (Customer) session.getAttribute("cust");
                String loggedInUserId = null;
                if (loggedInUser != null) {
                    model.addAttribute("loggedInUser", loggedInUser);
                    loggedInUserId = loggedInUser.getCustId();
                }

                try {
                    List<Comments> commentsData = commentsService.getCommentsByPboardKey(id, loggedInUserId);
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm");

                    List<Map<String, Object>> commentViews = new ArrayList<>();
                    for (Comments comment : commentsData) {
                        Map<String, Object> viewMap = new HashMap<>();
                        viewMap.put("commentsKey", comment.getCommentsKey());
                        viewMap.put("custId", comment.getCustId());
                        viewMap.put("custName", comment.getCustName());
                        viewMap.put("commentsContent", comment.getCommentsContent());
                        viewMap.put("custProfileImgUrl", comment.getCustProfileImgUrl());
                        viewMap.put("likeCount", comment.getLikeCount());
                        viewMap.put("likedByCurrentUser", comment.isLikedByCurrentUser());
                        viewMap.put("depth", comment.getDepth());
                        viewMap.put("parentCustId", comment.getParentCustId());
                        boolean isAuthorComment = boardAuthorId != null && boardAuthorId.equals(comment.getCustId());
                        viewMap.put("isAuthorComment", isAuthorComment);

                        String formattedDate = comment.getCommentsRdate() != null
                                ? comment.getCommentsRdate().format(formatter)
                                : "";
                        viewMap.put("formattedCommentsRdate", formattedDate);

                        commentViews.add(viewMap);
                    }

                    model.addAttribute("comments", commentViews);
                    model.addAttribute("commentCount", commentViews.size());

                } catch (Exception commentEx) {
                    log.error("게시글 ID {}의 댓글 조회 중 오류 발생", id, commentEx);
                    model.addAttribute("commentErrorMessage", "댓글을 불러오는 중 오류가 발생했습니다.");
                }
            }

        } catch (Exception e) {
            log.error("게시글 상세 조회 중 오류 발생 - ID: {}", id, e);
            model.addAttribute("errorMessage", "게시글을 불러오는 중 오류가 발생했습니다.");
            model.addAttribute("centerPage", "error.jsp");
        }

        model.addAttribute("currentPage", "community");
        return "index";
    }

    @GetMapping("/search")
    public String communitySearch(
            @RequestParam(name = "keyword") String keyword, 
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "sort", required = false, defaultValue = "comments") String sort,
            Model model) {

        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("currentPage", page); 
        model.addAttribute("pageTitle", "커뮤니티 검색");
        model.addAttribute("centerPage", "pages/community.jsp"); 
        model.addAttribute("viewName", "community"); 
        return "index";
    }

    @GetMapping("/write")
    public String communityWriteForm(Model model,
            @SessionAttribute(name = "cust", required = false) Customer customer,
            @RequestParam(name = "redirectAfterLogin", required = false) String redirectAfterLogin) {

        if (customer == null) {
            log.info("세션에 customer 객체가 없습니다. 로그인 페이지로 리다이렉트.");
            if (redirectAfterLogin != null && redirectAfterLogin.equals("true")) {
                return "redirect:/gologin?redirectURL=/community/write";
            }
            return "redirect:/gologin";
        }

        model.addAttribute("currentPage", "community");
        model.addAttribute("pageTitle", "게시글 작성");
        model.addAttribute("viewName", "community_write");
        model.addAttribute("centerPage", "pages/community_write.jsp");
        return "index";
    }

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

            model.addAttribute("board", board);
            model.addAttribute("boardKey", boardKey);
            model.addAttribute("currentPage", "community");
            model.addAttribute("pageTitle", "게시글 수정");
            model.addAttribute("viewName", "community_edit");
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
