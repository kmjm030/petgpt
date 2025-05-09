package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.ItemService;
import com.mc.app.service.QnaBoardService;
import com.mc.app.service.TotalOrderService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/qnaboard")
public class QnaBoardController {

    private final QnaBoardService qnaService;
    private final ItemService itemService;
    private final TotalOrderService totalOrderService;

    @Value("${file.upload.directory}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix}")
    private String uploadUrlPrefix;

    @GetMapping("")
    public String qnaboard(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/signin"; 
        }
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/qnaboard?id=" + loggedInCustomer.getCustId();
        }

        List<QnaBoard> qnaBoards = qnaService.findQnaByCust(id);

        model.addAttribute("qnaBoards", qnaBoards);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Board");
        model.addAttribute("viewName", "qnaboard");
        model.addAttribute("centerPage", "pages/mypage/qnaboard.jsp");
        return "index";
    }

    @RequestMapping("/add")
    public String add(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {
        List<Item> items = itemService.get();
        List<TotalOrder> orders = totalOrderService.findAllByCust(id);
        Map<Integer, String> itemNames = new HashMap<>();

        for (TotalOrder order : orders) {
            Item item = itemService.get(order.getItemKey());
            itemNames.put(order.getOrderKey(), item.getItemName());
        }

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/signin"; 
        }
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/qnaboard?id=" + loggedInCustomer.getCustId(); 
        }

        model.addAttribute("items", items);
        model.addAttribute("orders", orders);
        model.addAttribute("itemNames", itemNames);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Add");
        model.addAttribute("viewName", "qnaboard_add");
        model.addAttribute("centerPage", "pages/mypage/qnaboard_add.jsp");
        return "index";
    }

    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception {

        QnaBoard board = qnaService.get(boardKey);

        model.addAttribute("board", board);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "QnA Detail");
        model.addAttribute("viewName", "qnaboard_detail");
        model.addAttribute("centerPage", "pages/mypage/qnaboard_detail.jsp");
        return "index";
    }

    @PostMapping("/addimpl")
    public String addimpl(Model model, @RequestParam("custId") String custId,
            @RequestParam("img") MultipartFile img, QnaBoard board) throws Exception {

        try {
            board.setCustId(custId);
            if (img != null && !img.isEmpty()) {
                String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
                String originalFilename = img.getOriginalFilename(); 
                String fileExtension = extractExtension(originalFilename); 
                String storedFileName = UUID.randomUUID().toString() + fileExtension; 
                Path targetDirectory = Paths.get(uploadDirectory, dateFolder);
                Path targetLocation = targetDirectory.resolve(storedFileName);

                try {
                    Files.createDirectories(targetDirectory);
                    Files.copy(img.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
                    String webAccessiblePath = uploadUrlPrefix + "/" + dateFolder + "/" + storedFileName;
                    board.setBoardImg(webAccessiblePath);
                    log.info("이미지 저장 성공: {}", targetLocation);
                    log.info("DB 저장 경로: {}", webAccessiblePath);

                } catch (Exception e) {
                    log.error("썸네일 이미지 저장 실패: {}", targetLocation, e);
                }
            }

            log.info("CommunityBoardService.createBoard 호출 직전 - custId: '{}', title: '{}'", board.getCustId(),
                    board.getBoardTitle());
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
            QnaBoard exBoard = qnaService.get(board.getBoardKey());
            String oldImgPath = exBoard.getBoardImg();
            if (img != null && !img.isEmpty()) {
                if (oldImgPath != null && !oldImgPath.isEmpty()) {
                    String relativePath = oldImgPath.replace(uploadUrlPrefix, ""); 
                    Path oldFilePath = Paths.get(uploadDirectory, relativePath);
                    Files.deleteIfExists(oldFilePath);
                    log.info("기존 이미지 삭제됨: {}", oldFilePath);
                }

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

        String dbPath = qnaService.get(boardKey).getBoardImg();
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
