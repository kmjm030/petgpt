package com.mc.controllerrest;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/community")
@RequiredArgsConstructor
public class FileUploadController {

    @Value("${file.upload.directory:/tmp/uploads/images}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix:/uploads/images}")
    private String uploadUrlPrefix;

    @PostMapping("/upload/image")
    public ResponseEntity<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file) {
        Map<String, String> response = new HashMap<>();
        
        if (file.isEmpty()) {
            response.put("error", "업로드할 파일이 없습니다.");
            return ResponseEntity.badRequest().body(response);
        }
        
        try {
            File directory = new File(uploadDirectory);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            String rawOriginalFilename = file.getOriginalFilename();
            if (rawOriginalFilename == null) {
                response.put("error", "파일 이름이 유효하지 않습니다.");
                return ResponseEntity.badRequest().body(response);
            }

            String originalFilename = StringUtils.cleanPath(rawOriginalFilename);
            String extension = "";
            if (originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            
            String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            File dateDirectory = new File(uploadDirectory + "/" + dateFolder);
            if (!dateDirectory.exists()) {
                dateDirectory.mkdirs();
            }
            
            String fileName = UUID.randomUUID().toString() + extension;
            String filePath = dateFolder + "/" + fileName;
            Path targetLocation = Paths.get(uploadDirectory + "/" + filePath);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
            String fileUrl = uploadUrlPrefix + "/" + filePath;
            
            response.put("imageUrl", fileUrl);
            return ResponseEntity.ok(response);
            
        } catch (IOException ex) {
            response.put("error", "파일 업로드 중 오류가 발생했습니다: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
}
