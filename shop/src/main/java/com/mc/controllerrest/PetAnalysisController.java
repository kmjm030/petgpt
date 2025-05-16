package com.mc.controllerrest;

import com.mc.app.service.PetBreedAnalysisService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/pets")
@RequiredArgsConstructor
@Slf4j
public class PetAnalysisController {

    private final PetBreedAnalysisService analysisService;

    @PostMapping("/analyze-breed")
    public ResponseEntity<?> analyzePetBreed(@RequestParam("image") MultipartFile imageFile) {

        if (imageFile == null || imageFile.isEmpty()) {
            log.warn("Image file is empty or null.");
            return ResponseEntity.badRequest().body("분석할 이미지 파일이 비어있습니다.");
        }

        String contentType = imageFile.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png"))) {
            log.warn("Invalid image file type: {}", contentType);
            return ResponseEntity.badRequest().body("이미지 파일은 JPEG 또는 PNG 형식만 가능합니다.");
        }

        try {
            List<PetBreedAnalysisService.BreedAnalysisResult> results = analysisService.analyzeImage(imageFile);

            if (results.isEmpty()) {
                log.info("Analysis completed, but no relevant breeds found.");
                return ResponseEntity.ok(List.of());
            } else {
                log.info("Analysis successful. Returning {} results.", results.size());
                return ResponseEntity.ok(results); 
            }

        } catch (IOException e) {
            log.error("IOException during pet breed analysis", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("이미지 분석 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        } catch (RuntimeException e) {
            log.error("RuntimeException during pet breed analysis (likely Vision API error)", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("이미지 분석 서비스에서 오류가 발생했습니다: " + e.getMessage());
        } catch (Exception e) {
            log.error("Unexpected error during pet breed analysis", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("알 수 없는 오류가 발생했습니다.");
        }
    }
}