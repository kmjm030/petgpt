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
import java.util.*;

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

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/signin";
        }
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/review?id=" + loggedInCustomer.getCustId();
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

  @GetMapping("/rest")
  public String reviewRest(Model model, @RequestParam("id") String custId, HttpSession session) throws Exception {

      // 리뷰에는 orderKey가 들어가 있다.
      // orderDetailKey에도 orderKey가 들어가 있다.
      // 리뷰에 없어야만! 떠야함!

    Customer loggedInCustomer = (Customer) session.getAttribute("cust");
    if (loggedInCustomer == null) {
      return "redirect:/signin";
    }
    if (!loggedInCustomer.getCustId().equals(custId)) {
      return "redirect:/review?id=" + loggedInCustomer.getCustId();
    }

    List<OrderDetail> orderDetails = orderDetailService.findNoReview(custId);
    Collections.reverse(orderDetails);

    Map<Integer, Item> itemMap = new HashMap<>();
    Map<Integer, Option> optionMap = new HashMap<>();
    Map<Integer, TotalOrder> orderMap = new HashMap<>();
    for (OrderDetail od : orderDetails) {
      int itemKey = od.getItemKey();
      if (!itemMap.containsKey(itemKey)) {
        Item item = itemService.get(itemKey);
        itemMap.put(itemKey, item);
      }
      int optionKey = od.getOptionKey();
      if(!optionMap.containsKey(optionKey)) {
        Option option = optionService.get(optionKey);
        optionMap.put(optionKey, option);
      }
      int orderKey = od.getOrderKey();
      if(!orderMap.containsKey(orderKey)) {
        TotalOrder order = totalOrderService.get(orderKey);
        orderMap.put(orderKey, order);
      }
    }

    model.addAttribute("itemMap", itemMap);
    model.addAttribute("optionMap", optionMap);
    model.addAttribute("orderMap", orderMap);
    model.addAttribute("orderDetails", orderDetails);
    model.addAttribute("currentPage", "pages");
    model.addAttribute("pageTitle", "Rest Review");
    model.addAttribute("centerPage", "pages/mypage/review_rest.jsp");
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
            if (board.getOrderKey() == orderKey) {
                redirectAttributes.addFlashAttribute("msg", "해당 상품에 대해 이미 리뷰를 작성했습니다.");
                return "redirect:/checkout/detail?orderKey=" + orderDetail.getOrderKey();
            }
        }

        model.addAttribute("item", item);
        model.addAttribute("option", option);
        model.addAttribute("orderDetail", orderDetail);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "Review Add");
        model.addAttribute("viewName", "review_add");
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
        model.addAttribute("viewName", "review_detail");
        model.addAttribute("centerPage", "pages/mypage/review_detail.jsp");
        return "index";
    }

    @PostMapping("/updateimpl")
    public String updateimpl(Model model, @RequestParam("custId") String custId,
            @RequestParam("img") MultipartFile img, QnaBoard board) throws Exception {

        try {
            QnaBoard exBoard = boardService.get(board.getBoardKey());
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
            boardService.mod(board);
        } catch (Exception e) {
            log.error("게시글 수정 중 오류", e);
        }

        return "redirect:/review?id=" + custId;
    }

    @RequestMapping("/delimpl")
    public String delimpl(Model model, @RequestParam("boardKey") int boardKey, HttpSession session) throws Exception {

        String dbPath = boardService.get(boardKey).getBoardImg();
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
