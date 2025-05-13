package com.mc.app.service;

import com.mc.app.dto.CommunityBoard;
import com.mc.app.repository.CommunityBoardRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.IOException;
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

@Slf4j
@Service
@RequiredArgsConstructor
public class CommunityBoardService {

    private final CommunityBoardRepository communityBoardRepository;

    @Value("${file.upload.directory}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix}")
    private String uploadUrlPrefix;

    private static final int PAGE_SIZE = 10; 

    @Transactional
    public int createBoard(CommunityBoard board) {
        board.onCreate();
        return communityBoardRepository.insertBoard(board);
    }

    @Transactional
    public int updateBoard(Integer boardKey, CommunityBoard updatedBoard, MultipartFile thumbnailImage)
            throws IOException {
        log.debug("게시글 수정 서비스 시작: boardKey={}", boardKey);

        CommunityBoard originalBoard = communityBoardRepository.selectBoardByKey(boardKey);
        if (originalBoard == null) {
            log.warn("수정하려는 게시글을 찾을 수 없습니다. boardKey={}", boardKey);
            return 0;
        }
        String oldImagePath = originalBoard.getBoardImg();

        boolean newImageUploaded = thumbnailImage != null && !thumbnailImage.isEmpty();
        boolean imageRemoved = !newImageUploaded && updatedBoard.getBoardImg() != null
                && updatedBoard.getBoardImg().isEmpty() && oldImagePath != null;

        if (newImageUploaded) {
            log.debug("새 썸네일 이미지 감지. 기존 이미지 삭제 시도: {}", oldImagePath);
            deleteOldThumbnailFile(oldImagePath);

        } else if (imageRemoved) {
            log.debug("썸네일 이미지 제거 요청 감지. 기존 이미지 삭제 시도: {}", oldImagePath);
            deleteOldThumbnailFile(oldImagePath);
            updatedBoard.setBoardImg(null);

        } else {
            updatedBoard.setBoardImg(oldImagePath);
            log.debug("기존 썸네일 이미지 유지: {}", oldImagePath);
        }

        updatedBoard.setBoardKey(boardKey);
        updatedBoard.setCustId(originalBoard.getCustId());
        updatedBoard.setViewCount(originalBoard.getViewCount());
        updatedBoard.setLikeCount(originalBoard.getLikeCount());
        updatedBoard.setCommentCount(originalBoard.getCommentCount());
        updatedBoard.setRegDate(originalBoard.getRegDate());
        updatedBoard.onUpdate(); 

        log.debug("게시글 DB 업데이트 시도: {}", updatedBoard);
        int result = communityBoardRepository.updateBoard(updatedBoard);
        log.debug("게시글 DB 업데이트 결과: {}", result);
        return result;
    }

    @Transactional
    public int deleteBoard(int boardKey) {
        return communityBoardRepository.deleteBoard(boardKey);
    }

    @Transactional
    public CommunityBoard getBoardDetail(int boardKey) {
        communityBoardRepository.increaseViewCount(boardKey);
        return communityBoardRepository.selectBoardByKey(boardKey);
    }

    public CommunityBoard getBoardDetailWithoutViewCount(int boardKey) {
        return communityBoardRepository.selectBoardByKey(boardKey);
    }

    public Map<String, Object> getBoardList(String category, int page, String sort) {
        int offset = (page - 1) * PAGE_SIZE;

        List<CommunityBoard> posts = communityBoardRepository.selectBoardList(
                category, offset, PAGE_SIZE, sort);

        int totalPosts = communityBoardRepository.countBoardsByCategory(category);
        int totalPages = (int) Math.ceil((double) totalPosts / PAGE_SIZE);

        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("totalPosts", totalPosts);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);

        return result;
    }

    public Map<String, Object> searchBoards(String keyword, int page, String sort) {
        int offset = (page - 1) * PAGE_SIZE;

        List<CommunityBoard> posts = communityBoardRepository.searchBoards(
                keyword, offset, PAGE_SIZE, sort);

        int totalPosts = communityBoardRepository.countBoardsByKeyword(keyword);
        int totalPages = (int) Math.ceil((double) totalPosts / PAGE_SIZE);

        Map<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        result.put("totalPosts", totalPosts);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);

        return result;
    }

    @Transactional
    public void addLike(int boardKey) {
        communityBoardRepository.increaseLikeCount(boardKey);
    }

    @Transactional
    public void cancelLike(int boardKey) {
        communityBoardRepository.decreaseLikeCount(boardKey);
    }

    @Transactional
    public void increaseCommentCount(int boardKey) {
        communityBoardRepository.increaseCommentCount(boardKey);
    }

    @Transactional
    public void decreaseCommentCount(int boardKey) {
        communityBoardRepository.decreaseCommentCount(boardKey);
    }

    @Transactional
    public int updateCommentCount(int boardKey) {
        return communityBoardRepository.updateCommentCount(boardKey);
    }

    @Transactional
    public int updateAllCommentCounts() {
        return communityBoardRepository.updateAllCommentCounts();
    }

    public String saveThumbnailFile(MultipartFile thumbnailFile) throws IOException {
        if (thumbnailFile == null || thumbnailFile.isEmpty()) {
            log.warn("저장할 썸네일 파일이 없습니다.");
            return null;
        }

        String dateFolder = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        String originalFilename = thumbnailFile.getOriginalFilename();
        String fileExtension = extractExtension(originalFilename);
        String storedFileName = UUID.randomUUID().toString() + fileExtension;

        Path targetDirectory = Paths.get(uploadDirectory, dateFolder);
        Path targetLocation = targetDirectory.resolve(storedFileName);

        try {
            Files.createDirectories(targetDirectory);
            Files.copy(thumbnailFile.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
            log.info("썸네일 파일 저장 성공: {}", targetLocation);
        } catch (IOException e) {
            log.error("썸네일 파일 저장 중 오류 발생: {}", targetLocation, e);
            throw e; 
        }

        String webAccessiblePath = uploadUrlPrefix + "/" + dateFolder + "/" + storedFileName;
        log.debug("생성된 웹 접근 경로: {}", webAccessiblePath);
        return webAccessiblePath;
    }

    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            log.warn("확장자를 추출할 수 없는 파일명: {}", fileName);
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

    private void deleteOldThumbnailFile(String webPath) {
        if (webPath == null || webPath.isEmpty() || !webPath.startsWith(uploadUrlPrefix)) {
            log.debug("삭제할 기존 썸네일 파일 경로가 유효하지 않거나 없습니다: {}", webPath);
            return;
        }

        String relativePath = webPath.substring(uploadUrlPrefix.length());
        if (relativePath.startsWith("/")) {
            relativePath = relativePath.substring(1);
        }
        Path filePath = Paths.get(uploadDirectory, relativePath);

        try {
            boolean deleted = Files.deleteIfExists(filePath);
            if (deleted) {
                log.info("기존 썸네일 파일 삭제 성공: {}", filePath);
            } else {
                log.warn("삭제할 기존 썸네일 파일이 존재하지 않습니다: {}", filePath);
            }
        } catch (IOException e) {
            log.error("기존 썸네일 파일 삭제 중 오류 발생: {}", filePath, e);
            throw new RuntimeException("Failed to delete old thumbnail file: " + filePath, e);
        }
    }
}
