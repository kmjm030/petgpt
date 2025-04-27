package com.mc.app.service;

import com.google.cloud.vision.v1.*;
import com.google.protobuf.ByteString;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class PetBreedAnalysisService {

    public List<BreedAnalysisResult> analyzeImage(MultipartFile imageFile) throws IOException {
        List<BreedAnalysisResult> results = new ArrayList<>();
        log.info("Starting image analysis for file: {}", imageFile.getOriginalFilename());

        try (ImageAnnotatorClient vision = ImageAnnotatorClient.create()) {
            ByteString imgBytes = ByteString.copyFrom(imageFile.getBytes());
            log.debug("Image converted to ByteString (size: {} bytes)", imgBytes.size());

            Image img = Image.newBuilder().setContent(imgBytes).build();

            Feature feat = Feature.newBuilder().setType(Feature.Type.LABEL_DETECTION).setMaxResults(10).build();
            AnnotateImageRequest request = AnnotateImageRequest.newBuilder().addFeatures(feat).setImage(img).build();
            log.info("Sending request to Google Vision API (Label Detection)");

            BatchAnnotateImagesResponse response = vision.batchAnnotateImages(List.of(request));
            List<AnnotateImageResponse> responses = response.getResponsesList();
            log.info("Received response from Google Vision API");

            for (AnnotateImageResponse res : responses) {
                if (res.hasError()) {
                    log.error("Google Vision API Error: {}", res.getError().getMessage());
                    throw new RuntimeException("Vision API Error: " + res.getError().getMessage());
                }

                log.debug("Processing {} label annotations.", res.getLabelAnnotationsCount());
                for (EntityAnnotation annotation : res.getLabelAnnotationsList()) {
                    String description = annotation.getDescription().toLowerCase();
                    float score = annotation.getScore();

                    if (isRelevantLabel(description) && score > 0.6) {
                        String formattedLabel = formatLabel(annotation.getDescription());
                        log.info("Relevant label detected: {} (Score: {})", formattedLabel, score);
                        results.add(new BreedAnalysisResult(formattedLabel, score));
                    } else {
                        log.debug("Ignoring label: {} (Score: {})", annotation.getDescription(), score);
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error during Vision API call or processing", e);
            throw new IOException("Failed to analyze image using Vision API.", e);
        }

        results.sort((r1, r2) -> Float.compare(r2.getScore(), r1.getScore()));
        log.info("Analysis finished. Found {} relevant results.", results.size());

        return results;
    }

    private boolean isRelevantLabel(String description) {
        if (description.contains("dog") || description.contains("cat") || description.contains("puppy")
                || description.contains("kitten")) {
            return true;
        }
        String[] breedKeywords = { "retriever", "bulldog", "terrier", "poodle", "beagle", "dachshund", "shiba inu",
                "maltese", "persian", "siamese", "ragdoll", "bengal" };
        for (String keyword : breedKeywords) {
            if (description.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    private String formatLabel(String originalLabel) {
        if (originalLabel == null || originalLabel.isEmpty()) {
            return "";
        }

        return originalLabel.substring(0, 1).toUpperCase() + originalLabel.substring(1);
    }

    public static class BreedAnalysisResult {
        private String breedName;
        private float score;

        public BreedAnalysisResult(String breedName, float score) {
            this.breedName = breedName;
            this.score = score;
        }

        public String getBreedName() {
            return breedName;
        }

        public float getScore() {
            return score;
        }

        public int getScorePercent() {
            return (int) (score * 100);
        }
    }
}
