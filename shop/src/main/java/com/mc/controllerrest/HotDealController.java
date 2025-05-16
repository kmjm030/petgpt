package com.mc.controllerrest;

import com.mc.app.dto.HotDealItem;
import com.mc.app.dto.Item;
import com.mc.app.service.HotDealService;
import com.mc.app.service.ItemService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/hotdeal")
@RequiredArgsConstructor
@Slf4j
public class HotDealController {

    private final HotDealService hotDealService;
    private final ItemService itemService;

    @GetMapping("/current")
    public ResponseEntity<HotDealItem> getCurrentHotDeal() {
        Integer currentItemKey = hotDealService.getCurrentHotDealItemKey();
        LocalDateTime expiryTime = hotDealService.getHotDealExpiryTime();

        if (currentItemKey == null || currentItemKey <= 0 || expiryTime == null) {
            log.info("현재 진행 중인 핫딜이 없습니다.");
            return ResponseEntity.noContent().build(); 
        }

        if (expiryTime.isBefore(LocalDateTime.now())) {
            log.info("현재 진행 중인 핫딜이 만료되었습니다. (key: {}).", currentItemKey);
            return ResponseEntity.noContent().build(); 
        }

        try {
            Item hotDealItemData = itemService.get(currentItemKey);

            if (hotDealItemData == null) {
                log.warn("데이터베이스에서 핫딜 아이템을 찾을 수 없습니다: itemKey={}", currentItemKey);
                return ResponseEntity.notFound().build(); 
            }

            HotDealItem dto = HotDealItem.from(hotDealItemData, expiryTime);
            log.info("핫딜 아이템: {}", dto);
            return ResponseEntity.ok(dto); 

        } catch (Exception e) {
            log.error("Error fetching current hot deal details for itemKey: " + currentItemKey, e);
            return ResponseEntity.internalServerError().build(); 
        }
    }
}
