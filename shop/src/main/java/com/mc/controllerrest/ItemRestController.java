package com.mc.controllerrest;

import com.mc.app.dto.Item;
import com.mc.app.service.ItemService;
import com.mc.app.dto.QnaBoard;
import com.mc.app.service.QnaBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus; // HttpStatus 사용 시 필요
import org.springframework.http.ResponseEntity; // ResponseEntity 사용 시 필요
import org.springframework.web.bind.annotation.ExceptionHandler; // ExceptionHandler 사용 시 필요
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Collections; // Collections.emptyList() 사용 시 필요
import java.util.List;

@RestController
@RequestMapping("/api/items")
@RequiredArgsConstructor
public class ItemRestController {

    private final ItemService itemService;
    private final QnaBoardService qnaBoardService;

    // 상품에 별점 및 리뷰 정보 추가하는 공통 메소드
    private void addReviewInfo(List<Item> items) {
        for (Item item : items) {
            try {
                List<QnaBoard> reviews = qnaBoardService.findReviewByItem(item.getItemKey());
                int reviewCount = reviews.size();

                // 평균 별점 계산
                double totalScore = 0;
                for (QnaBoard review : reviews) {
                    totalScore += review.getBoardScore();
                }

                double avgScore = reviewCount > 0 ? Math.round((totalScore / reviewCount) * 10) / 10.0 : 0;

                // Item 객체에 평균 별점과 리뷰 개수 저장
                item.setAvgScore(avgScore);
                item.setReviewCount(reviewCount);
            } catch (Exception e) {
                System.err.println("상품 평점 및 리뷰 개수 계산 중 오류 발생: " + e.getMessage());
                item.setAvgScore(0.0);
                item.setReviewCount(0);
            }
        }
    }

    // 베스트셀러 8개 조회 (판매량 순)
    @GetMapping("/bestsellers")
    public List<Item> getBestSellers() {
        int limit = 8;
        try {
            List<Item> items = itemService.getBestSellingItems(limit);
            addReviewInfo(items);
            return items;
        } catch (Exception e) {
            System.err.println("Error fetching bestsellers: " + e.getMessage());
            e.printStackTrace(); // 개발 중 상세 오류 확인
            // 예외 발생 시 빈 리스트 반환
            return Collections.emptyList();
        }
    }

    // 신상품 8개 조회 (최신 등록 순)
    @GetMapping("/newarrivals")
    public List<Item> getNewArrivals() {
        int limit = 8;
        try {
            List<Item> items = itemService.getNewestItems(limit);
            addReviewInfo(items);
            return items;
        } catch (Exception e) {
            System.err.println("Error fetching new arrivals: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // 할인 상품 8개 조회 (할인율 높은 순)
    @GetMapping("/hotsales")
    public List<Item> getHotSales() {
        int limit = 8;
        try {
            List<Item> items = itemService.getHighestDiscountItems(limit);
            addReviewInfo(items);
            return items;
        } catch (Exception e) {
            System.err.println("Error fetching hot sales: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
