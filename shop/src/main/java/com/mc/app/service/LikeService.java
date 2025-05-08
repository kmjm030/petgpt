package com.mc.app.service;

import com.mc.app.dto.Like;
import com.mc.app.frame.MCService;
import com.mc.app.repository.LikeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cglib.core.Local;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class LikeService implements MCService<Like, Integer> {

    private final LikeRepository likeRepository;
    
    @Override
    public void add(Like like) throws Exception {
        likeRepository.insert(like);
    }
    
    @Override
    public void mod(Like like) throws Exception {
        likeRepository.update(like);
    }
    
    @Override
    public void del(Integer id) throws Exception {
        likeRepository.delete(id);
    }
    
    @Override
    public Like get(Integer id) throws Exception {
        return likeRepository.selectOne(id);
    }
    
    @Override
    public List<Like> get() throws Exception {
        return likeRepository.select();
    }

    public void deleteForMypage(String custId, Integer itemKey) throws Exception {
        likeRepository.deleteForMypage(custId, itemKey);
    }

    
    public Map<String, Object> toggleLike(String custId, int itemKey) {
        Map<String, Object> resultMap = new HashMap<>();
        
        try {
            Like existingLike = likeRepository.findByCustIdAndItemKey(custId, itemKey);
            
            if (existingLike != null) {
                likeRepository.deleteByCustAndItem(existingLike);
                resultMap.put("success", true);
                resultMap.put("action", "removed");
                resultMap.put("message", "상품이 찜 목록에서 제거되었습니다.");

            } else {
                Like newLike = Like.builder()
                        .custId(custId)
                        .itemKey(itemKey)
                        .build();
                        
                likeRepository.insert(newLike);
                resultMap.put("success", true);
                resultMap.put("action", "added");
                resultMap.put("message", "상품이 찜 목록에 추가되었습니다.");

            }
        } catch (Exception e) {
            log.error("찜하기 토글 중 오류 발생: {}", e.getMessage(), e);
            resultMap.put("success", false);
            resultMap.put("message", "찜하기 처리 중 오류가 발생했습니다.");
        }
        
        return resultMap;
    }
    
    public boolean isLiked(String custId, int itemKey) {
        try {
            return likeRepository.findByCustIdAndItemKey(custId, itemKey) != null;

        } catch (Exception e) {
            log.error("찜하기 확인 중 오류 발생: {}", e.getMessage(), e);
            return false;
        }
    }
    
    public List<Like> getLikesByCustomer(String custId) {
        try {
            return likeRepository.findAllByCustomer(custId);

        } catch (Exception e) {
            log.error("찜 목록 조회 중 오류 발생: {}", e.getMessage(), e);
            return List.of();
        }
    }

    public void deleteOlderThan(Date date) throws Exception {
        likeRepository.deleteOlderThan(date);
    }
    
    public int getLikeCount(String custId) {
        try {
            return likeRepository.countByCustId(custId);
            
        } catch (Exception e) {
            log.error("찜 개수 조회 중 오류 발생: {}", e.getMessage(), e);
            return 0;
        }
    }
} 