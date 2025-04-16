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

            // 원본 파일명 가져오기 및 null 체크
            String rawOriginalFilename = file.getOriginalFilename();
            if (rawOriginalFilename == null) {
                response.put("error", "파일 이름이 유효하지 않습니다.");
                return ResponseEntity.badRequest().body(response);
            }

            // 경로 정리 및 확장자 추출
            String originalFilename = StringUtils.cleanPath(rawOriginalFilename);
            String extension = "";
            if (originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            
            // 날짜 폴더 생성 (YYYY/MM/DD)
            String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            File dateDirectory = new File(uploadDirectory + "/" + dateFolder);
            if (!dateDirectory.exists()) {
                dateDirectory.mkdirs();
            }
            
            // 파일명 수정 (UUID + 확장자)
            String fileName = UUID.randomUUID().toString() + extension;
            
            // 최종 파일 경로 -> Path 타입으로 변환
            String filePath = dateFolder + "/" + fileName;
            Path targetLocation = Paths.get(uploadDirectory + "/" + filePath);
            
            // 파일 저장
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
            
            // 접근 가능한 URL 생성
            String fileUrl = uploadUrlPrefix + "/" + filePath;
            
            response.put("imageUrl", fileUrl);
            return ResponseEntity.ok(response);
            
        } catch (IOException ex) {
            response.put("error", "파일 업로드 중 오류가 발생했습니다: " + ex.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
}
