package com.mc.controller;

import com.mc.app.dto.*;
import com.mc.app.service.ItemService;
import com.mc.app.service.PetService;
import com.mc.app.service.QnaBoardService;
import com.mc.app.service.TotalOrderService;
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
@RequestMapping("/pet")
public class PetController {

    @Value("${file.upload.directory}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix}")
    private String uploadUrlPrefix;

    private final PetService petService;

    @GetMapping("")
    public String pet(Model model, @RequestParam("id") String id, HttpSession session) throws Exception {

        // 세션에서 로그인된 사용자 확인
        Customer loggedInCustomer = (Customer) session.getAttribute("cust");

        // 로그인하지 않았다면 로그인 페이지로 리다이렉트
        if (loggedInCustomer == null) {
            return "redirect:/signin"; // 로그인 페이지로 리다이렉트
        }

        // 로그인된 사용자만 자신의 QnA목록를 볼 수 있도록 처리
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/pet?id=" + loggedInCustomer.getCustId(); // 자신의 마이페이지만 보여줌
        }

        List<Pet> pets = petService.findByCust(loggedInCustomer.getCustId());
        model.addAttribute("pets", pets);
        model.addAttribute("currentPage", "pages");
        model.addAttribute("pageTitle", "My Pet");
        model.addAttribute("viewName", "pet");
        model.addAttribute("centerPage", "pages/mypage/pet.jsp");
        return "index";
    }

    @PostMapping("/addimpl")
    public String addimpl(Model model, @RequestParam("custId") String custId,
            @RequestParam("img") MultipartFile img, Pet pet) throws Exception {

        try {
            pet.setCustId(custId);
            // 썸네일 이미지 처리
            if (img != null && !img.isEmpty()) {
                String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
                String originalFilename = img.getOriginalFilename(); // 원래 파일 이름
                String fileExtension = extractExtension(originalFilename); // 확장자만 추출
                String storedFileName = UUID.randomUUID().toString() + fileExtension; // 랜덤한 이름을 붙여서 충돌을 방지함

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
                    pet.setPetImg(webAccessiblePath);

                } catch (Exception e) {
                    log.error("썸네일 이미지 저장 실패: {}", targetLocation, e);
                    // 이미지 저장 실패 시 처리를 추가할 수 있음 (예: 에러 메시지 반환)
                    // 여기서는 일단 게시글 저장은 계속 진행하도록 둠
                }
            }

        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }

        petService.add(pet);
        return "redirect:/pet?id=" + custId;
    }

    @PostMapping("/petimgupdate")
    public String petimgupdate(@RequestParam("petImg") MultipartFile petImg, Model model,
            @RequestParam("petKey") int petKey,
            @RequestParam("custId") String custId) throws Exception {

        try {
            // 기존 게시글을 불러와서 기존 이미지 경로를 알아냄
            Pet exPet = petService.get(petKey);
            String oldImgPath = exPet.getPetImg();

            // 새 이미지가 업로드되었을 경우
            if (petImg != null && !petImg.isEmpty()) {
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
                String originalFilename = petImg.getOriginalFilename();
                String fileExtension = extractExtension(originalFilename);
                String storedFileName = UUID.randomUUID().toString() + fileExtension;
                Path targetDirectory = Paths.get(uploadDirectory, dateFolder);
                Path targetLocation = targetDirectory.resolve(storedFileName);

                Files.createDirectories(targetDirectory);
                Files.copy(petImg.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

                String webAccessiblePath = uploadUrlPrefix + "/" + dateFolder + "/" + storedFileName;
                exPet.setPetImg(webAccessiblePath);
            } else {
                // 이미지가 업로드되지 않았으면 기존 이미지 유지
                exPet.setPetImg(oldImgPath);
            }
            petService.mod(exPet);
        } catch (Exception e) {
            log.error("수정 중 오류", e);
        }

        return "redirect:/pet?id=" + custId;
    }

    @RequestMapping("/delimpl")
    public String delimpl(Model model, @RequestParam("petKey") int petKey, HttpSession session) throws Exception {

        // DB에서 파일 경로 가져오기
        String dbPath = petService.get(petKey).getPetImg();

        // 경로가 존재할 때만 삭제 시도
        if (dbPath != null && !dbPath.isEmpty()) {
            String relativePath = dbPath.replace(uploadUrlPrefix, "");
            Path path = Paths.get(uploadDirectory, relativePath);
            Files.deleteIfExists(path);
        }

        petService.del(petKey);

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        String custId = loggedInCustomer.getCustId();

        return "redirect:/pet?id=" + custId;
    }

    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

}