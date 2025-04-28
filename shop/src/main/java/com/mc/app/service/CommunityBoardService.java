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

    private static final int PAGE_SIZE = 10; // 페이지당 게시글 수

    // 게시글 생성/수정/삭제
    @Transactional
    public int createBoard(CommunityBoard board) {
        board.onCreate();
        return communityBoardRepository.insertBoard(board);
    }

    /**
     * 게시글 수정 (썸네일 이미지 처리 포함)
     * 
     * @param boardKey       수정할 게시글 키
     * @param updatedBoard   업데이트할 내용이 담긴 DTO
     * @param thumbnailImage 새로운 썸네일 파일 (null 가능)
     * @return 업데이트 성공 여부 (1: 성공, 0: 실패)
     * @throws IOException
     */
    @Transactional
    public int updateBoard(Integer boardKey, CommunityBoard updatedBoard, MultipartFile thumbnailImage)
            throws IOException {
        log.debug("게시글 수정 서비스 시작: boardKey={}", boardKey);

        // 1. 기존 게시글 정보 조회
        CommunityBoard originalBoard = communityBoardRepository.selectBoardByKey(boardKey);
        if (originalBoard == null) {
            log.warn("수정하려는 게시글을 찾을 수 없습니다. boardKey={}", boardKey);
            return 0;
        }
        String oldImagePath = originalBoard.getBoardImg();

        // 2. 새 썸네일 이미지 처리 (컨트롤러에서 이미 저장됨, 여기서는 경로 업데이트 및 기존 파일 삭제)
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

        // 3. 업데이트 시간 설정 및 DB 업데이트
        updatedBoard.setBoardKey(boardKey);
        updatedBoard.setCustId(originalBoard.getCustId());
        updatedBoard.setViewCount(originalBoard.getViewCount());
        updatedBoard.setLikeCount(originalBoard.getLikeCount());
        updatedBoard.setCommentCount(originalBoard.getCommentCount());
        updatedBoard.setRegDate(originalBoard.getRegDate());
        updatedBoard.onUpdate(); // 수정 시간 업데이트

        log.debug("게시글 DB 업데이트 시도: {}", updatedBoard);
        int result = communityBoardRepository.updateBoard(updatedBoard);
        log.debug("게시글 DB 업데이트 결과: {}", result);
        return result;
    }

    @Transactional
    public int deleteBoard(int boardKey) {
        return communityBoardRepository.deleteBoard(boardKey);
        // TODO: 게시글 삭제 시 연결된 파일도 삭제하는 로직 추가 필요
    }

    // 게시글 상세 조회
    @Transactional
    public CommunityBoard getBoardDetail(int boardKey) {
        communityBoardRepository.increaseViewCount(boardKey);
        return communityBoardRepository.selectBoardByKey(boardKey);
    }

    public CommunityBoard getBoardDetailWithoutViewCount(int boardKey) {
        return communityBoardRepository.selectBoardByKey(boardKey);
    }

    // 게시글 목록/검색
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

    // 좋아요/댓글 관리
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

    // --- Helper Methods ---

    /**
     * 썸네일 파일을 저장하고 웹 접근 가능 경로를 반환
     * 
     * @param thumbnailFile 저장할 썸네일 파일
     * @return 웹 접근 가능 경로 (e.g., /uploads/2024/04/22/uuid.jpg)
     * @throws IOException 파일 저장 중 오류 발생 시
     */
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
            throw e; // 예외를 다시 던져서 호출한 쪽에서 처리하도록 함
        }

        String webAccessiblePath = uploadUrlPrefix + "/" + dateFolder + "/" + storedFileName;
        log.debug("생성된 웹 접근 경로: {}", webAccessiblePath);
        return webAccessiblePath;
    }

    /**
     * 파일명에서 확장자를 추출
     * 
     * @param fileName 파일명
     * @return 확장자 (e.g., .jpg) 또는 ""
     */
    private String extractExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            log.warn("확장자를 추출할 수 없는 파일명: {}", fileName);
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

    /**
     * 기존 썸네일 파일을 삭제 (파일 시스템에서)
     * 
     * @param webPath 웹 접근 경로 (e.g., /uploads/2024/04/22/uuid.jpg)
     */
    private void deleteOldThumbnailFile(String webPath) {
        if (webPath == null || webPath.isEmpty() || !webPath.startsWith(uploadUrlPrefix)) {
            log.debug("삭제할 기존 썸네일 파일 경로가 유효하지 않거나 없습니다: {}", webPath);
            return;
        }

        // 웹 경로에서 실제 파일 시스템 경로 추출
        // 예: /uploads/2024/04/22/uuid.jpg -> 2024/04/22/uuid.jpg
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
