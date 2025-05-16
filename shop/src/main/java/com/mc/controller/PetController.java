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
import java.util.List;
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

        Customer loggedInCustomer = (Customer) session.getAttribute("cust");
        if (loggedInCustomer == null) {
            return "redirect:/signin"; 
        }
        if (!loggedInCustomer.getCustId().equals(id)) {
            return "redirect:/pet?id=" + loggedInCustomer.getCustId(); 
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
                    pet.setPetImg(webAccessiblePath);

                } catch (Exception e) {
                    log.error("썸네일 이미지 저장 실패: {}", targetLocation, e);
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
            Pet exPet = petService.get(petKey);
            String oldImgPath = exPet.getPetImg();

            if (petImg != null && !petImg.isEmpty()) {
                if (oldImgPath != null && !oldImgPath.isEmpty()) {
                    String relativePath = oldImgPath.replace(uploadUrlPrefix, ""); 
                    Path oldFilePath = Paths.get(uploadDirectory, relativePath);
                    Files.deleteIfExists(oldFilePath);
                    log.info("기존 이미지 삭제됨: {}", oldFilePath);
                }

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

        String dbPath = petService.get(petKey).getPetImg();
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