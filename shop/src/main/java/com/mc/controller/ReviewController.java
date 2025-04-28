package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.*;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/review")
public class ReviewController {

    private final QnaBoardService boardService;
    private final ItemService itemService;
    private final OptionService optionService;
    private final OrderDetailService orderDetailService;
    private final TotalOrderService totalOrderService;

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
            return "redirect:/review?id=" + loggedInCustomer.getCustId();  // 자신의 마이페이지만 보여줌
        }

        List<QnaBoard> reviews = boardService.findReviewByCust(id);

        for (QnaBoard review : reviews) {
            Item item = itemService.get(review.getItemKey());
            review.setItem(item);
        }

        model.addAttribute("reviews", reviews);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Review");
        model.addAttribute("centerPage", "pages/mypage/review.jsp");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model, HttpSession session,
                      @RequestParam("itemKey") int itemKey,
                      @RequestParam("orderDetailKey") int orderDetailKey,
                      @RequestParam("orderKey") int orderKey,
                      RedirectAttributes redirectAttributes) throws Exception {


        Item item = itemService.get(itemKey);
        OrderDetail orderDetail = orderDetailService.get(orderDetailKey);
        Option option = optionService.findNameByKey(orderDetail.getOptionKey());

        // .. orderdetail을 저장하는게 편했겠다...................................
        // board_type=2인 글들 중에서 orderKey, itemKey 겹치는 board 있으면 등록못하게??
        // ...어려워요......뭐지 ....................머리안굴러감

        List<QnaBoard> boards = boardService.findReviewByItem(itemKey);
        for (QnaBoard board : boards) {
            if(board.getOrderKey() == orderKey) {
                redirectAttributes.addFlashAttribute("msg", "해당 상품에 대해 이미 리뷰를 작성했습니다.");
                return "redirect:/checkout/detail?orderKey=" + orderDetail.getOrderKey();
            }
        }

        model.addAttribute("item", item);
        model.addAttribute("option", option);
        model.addAttribute("orderDetail", orderDetail);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Review Add");
        model.addAttribute("centerPage", "pages/mypage/review_add.jsp");
        return "index";
    }

    @PostMapping("/addimpl")
    public String addimpl(Model model, @RequestParam("custId") String custId,
                          @RequestParam("img") MultipartFile img, QnaBoard board,
                          @RequestParam("itemKey") int itemKey,
                          @RequestParam("orderKey") int orderKey) throws Exception {

        try {
            board.setCustId(custId);
            // 썸네일 이미지 처리
            if (img != null && !img.isEmpty()) {
                String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
                String originalFilename = img.getOriginalFilename();    // 원래 파일 이름
                String fileExtension = extractExtension(originalFilename); // 확장자만 추출
                String storedFileName = UUID.randomUUID().toString() + fileExtension;     // 랜덤한 이름을 붙여서 충돌을 방지함

                // 실제 저장될 전체 경로 계산 (설정값 + 날짜 폴더 + 고유 파일명)
                Path targetDirectory = Paths.get(uploadDirectory, dateFolder);
                Path targetLocation = targetDirectory.resolve(storedFileName);

                try {
                    // 디렉토리 생성 (없으면)
                    Files.createDirectories(targetDirectory);
                    // 파일 저장
                    Files.copy(img.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

                    // DB에 저장될 웹 접근 가능 URL 경로 설정 (설정값 + 날짜 폴더 + 고유 파일명)
                    String webAccessiblePath = uploadUrlPrefix + "/" + dateFolder + "/" + storedFileName;
                    board.setBoardImg(webAccessiblePath);
                    log.info("이미지 저장 성공: {}", targetLocation);
                    log.info("DB 저장 경로: {}", webAccessiblePath);

                } catch (Exception e) {
                    log.error("썸네일 이미지 저장 실패: {}", targetLocation, e);
                    // 이미지 저장 실패 시 처리를 추가할 수 있음 (예: 에러 메시지 반환)
                    // 여기서는 일단 게시글 저장은 계속 진행하도록 둠
                }
            }

            board.setBoardTitle("리뷰");
            board.setBoardType(2);
            board.setItemKey(itemKey);
            board.setOrderKey(orderKey);
            boardService.add(board);

        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }

        return "redirect:/review?id=" + custId;
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception {

        QnaBoard board = boardService.get(boardKey);
        Item item = itemService.get(board.getItemKey());
        board.setItem(item);

        model.addAttribute("board", board);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Review Detail");
        model.addAttribute("centerPage", "pages/mypage/review_detail.jsp");
        return "index";
    }

    @PostMapping("/updateimpl")
    public String updateimpl(Model model, @RequestParam("custId") String custId,
                             @RequestParam("img") MultipartFile img, QnaBoard board) throws Exception {
        try {
            // 기존 게시글을 불러와서 기존 이미지 경로를 알아냄
            QnaBoard exBoard = boardService.get(board.getBoardKey());
            String oldImgPath = exBoard.getBoardImg();

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
                board.setBoardImg(webAccessiblePath);
                log.info("새 이미지 저장 성공: {}", targetLocation);
            } else {
                // 이미지가 업로드되지 않았으면 기존 이미지 유지
                board.setBoardImg(oldImgPath);
            }
            boardService.mod(board);
        } catch (Exception e) {
            log.error("게시글 수정 중 오류", e);
        }

        return "redirect:/review?id=" + custId;
    }

    @RequestMapping("/delimpl")
    public String delimpl(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception {

        // DB에서 파일 경로 가져오기
        String dbPath = boardService.get(boardKey).getBoardImg();

        // 경로가 존재할 때만 삭제 시도
        if (dbPath != null && !dbPath.isEmpty()) {
            String relativePath = dbPath.replace(uploadUrlPrefix, "");
            Path path = Paths.get(uploadDirectory, relativePath);
            Files.deleteIfExists(path);
        }

        boardService.del(boardKey);

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        String custId = loggedInCustomer.getCustId();

        return "redirect:/review?id=" + custId;
    }



    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

}