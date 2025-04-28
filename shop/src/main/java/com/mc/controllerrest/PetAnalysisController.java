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
        log.info("Received request for /api/pets/analyze-breed");

        // 1. 입력 파일 유효성 검사
        if (imageFile == null || imageFile.isEmpty()) {
            log.warn("Image file is empty or null.");
            return ResponseEntity.badRequest().body("분석할 이미지 파일이 비어있습니다.");
        }

        // 2. 파일 타입 검증 (JPEG, PNG만 허용 - 선택 사항이지만 권장)
        String contentType = imageFile.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png"))) {
            log.warn("Invalid image file type: {}", contentType);
            return ResponseEntity.badRequest().body("이미지 파일은 JPEG 또는 PNG 형식만 가능합니다.");
        }

        log.info("Processing image file: Name='{}', Type='{}', Size={} bytes",
                imageFile.getOriginalFilename(), contentType, imageFile.getSize());

        try {
            // 3. 서비스 호출하여 이미지 분석 수행
            List<PetBreedAnalysisService.BreedAnalysisResult> results = analysisService.analyzeImage(imageFile);

            // 4. 결과 반환
            if (results.isEmpty()) {
                log.info("Analysis completed, but no relevant breeds found.");
                // 결과가 없어도 성공(200 OK)으로 처리하고 빈 리스트 반환
                return ResponseEntity.ok(List.of());
            } else {
                log.info("Analysis successful. Returning {} results.", results.size());
                return ResponseEntity.ok(results); // 분석 결과 리스트 반환
            }

        } catch (IOException e) {
            // 서비스에서 발생한 IOException (API 호출 실패 등)
            log.error("IOException during pet breed analysis", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("이미지 분석 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        } catch (RuntimeException e) {
            // 서비스에서 발생한 RuntimeException (Vision API 자체 오류 등)
            log.error("RuntimeException during pet breed analysis (likely Vision API error)", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("이미지 분석 서비스에서 오류가 발생했습니다: " + e.getMessage());
        } catch (Exception e) {
            // 예상치 못한 기타 예외 처리
            log.error("Unexpected error during pet breed analysis", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("알 수 없는 오류가 발생했습니다.");
        }
    }
}