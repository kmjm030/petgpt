package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.ItemService;
import com.mc.app.service.QnaBoardService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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
@RequestMapping("/qnaboard")
public class QnaBoardController {

    private final QnaBoardService qnaService;
    private final ItemService itemService;

    @Value("${file.upload.directory}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix}")
    private String uploadUrlPrefix;


    @GetMapping("")
    public String qnaboard(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {

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

        List<QnaBoard> qnaBoards = qnaService.findQnaByCust(id);
//        for (QnaBoard board : qnaBoards) {
//            if(board.getBoardRe().equals("Y")){
//                board.setBoardRe("답변완료");
//            }else{
//                board.setBoardRe("답변대기");
//            }
//        }
        model.addAttribute("qnaBoards", qnaBoards);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Board");
        model.addAttribute("centerPage", "pages/mypage/qnaboard.jsp");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {
        List<Item> items = itemService.get();

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

        model.addAttribute("items", items);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Add");
        model.addAttribute("centerPage", "pages/mypage/qnaboard_add.jsp");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception {

        QnaBoard board = qnaService.get(boardKey);

        model.addAttribute("board", board);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Detail");
        model.addAttribute("centerPage", "pages/mypage/qnaboard_detail.jsp");
        return "index";
    }

    @PostMapping("/addimpl")
    public String addimpl(Model model, @RequestParam("custId") String custId,
                          @RequestParam("img") MultipartFile img, QnaBoard board) throws Exception {

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

            // 서비스 호출 직전 로그 추가: 전달되는 custId 값 확인
            log.info("CommunityBoardService.createBoard 호출 직전 - custId: '{}', title: '{}'", board.getCustId(), board.getBoardTitle());
            board.setBoardType(1);
            board.setBoardRe("답변대기");
            qnaService.add(board);

        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }

        return "redirect:/qnaboard?id=" + custId;
    }

    @PostMapping("/updateimpl")
    public String updateimpl(Model model, @RequestParam("custId") String custId,
                             @RequestParam("img") MultipartFile img, QnaBoard board) throws Exception {
        try {
            // 기존 게시글을 불러와서 기존 이미지 경로를 알아냄
            QnaBoard exBoard = qnaService.get(board.getBoardKey());
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
            qnaService.mod(board);
        } catch (Exception e) {
            log.error("게시글 수정 중 오류", e);
        }

        return "redirect:/qnaboard?id=" + custId;
    }

    @RequestMapping("/delimpl")
    public String delimpl(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception {

        // DB에서 파일 경로 가져오기
        String dbPath = qnaService.get(boardKey).getBoardImg();

        // 경로가 존재할 때만 삭제 시도
        if (dbPath != null && !dbPath.isEmpty()) {
            String relativePath = dbPath.replace(uploadUrlPrefix, "");
            Path path = Paths.get(uploadDirectory, relativePath);
            Files.deleteIfExists(path);
        }

        qnaService.del(boardKey);
        String custId = session.getId();
        return "redirect:/qnaboard?id=" + custId;
    }

    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }


}
