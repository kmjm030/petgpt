package com.mc.app.service;

import com.mc.app.repository.ItemRepository;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

@Service
@Slf4j
@RequiredArgsConstructor
@Getter
public class HotDealService {

    private final ItemRepository itemRepository;
    private final Random random = new Random();

    private Integer currentHotDealItemKey = null;
    private LocalDateTime hotDealExpiryTime = null;

    @Scheduled(fixedRate = 10 * 60 * 1000)
    public void selectNewHotDealItem() {
        log.info("새로운 핫딜 아이템을 선정중...");
        try {
            List<Integer> allItemKeys = itemRepository.selectAllItemKeys();

            if (allItemKeys == null || allItemKeys.isEmpty()) {
                log.warn("아이템을 찾을 수 없습니다.");
                currentHotDealItemKey = null;
                hotDealExpiryTime = null;
                return;
            }

            int randomIndex = random.nextInt(allItemKeys.size());
            int selectedItemKey = allItemKeys.get(randomIndex);

            LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(10);

            currentHotDealItemKey = selectedItemKey;
            hotDealExpiryTime = expiryTime;

            log.info("새로운 핫딜 아이템: itemKey={}, expiryTime={}", selectedItemKey, expiryTime);

        } catch (Exception e) {
            log.error("핫딜 아이템 선정 중 에러 발생", e);
            currentHotDealItemKey = null;
            hotDealExpiryTime = null;
        }
    }
}
