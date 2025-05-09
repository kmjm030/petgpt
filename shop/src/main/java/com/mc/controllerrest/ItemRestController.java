package com.mc.controllerrest;

import com.mc.app.dto.Item;
import com.mc.app.service.ItemService;
import com.mc.app.dto.QnaBoard;
import com.mc.app.service.QnaBoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections; 
import java.util.List;

@RestController
@RequestMapping("/api/items")
@RequiredArgsConstructor
public class ItemRestController {

    private final ItemService itemService;
    private final QnaBoardService qnaBoardService;

    private void addReviewInfo(List<Item> items) {
        for (Item item : items) {
            try {
                List<QnaBoard> reviews = qnaBoardService.findReviewByItem(item.getItemKey());
                int reviewCount = reviews.size();
                double totalScore = 0;
                for (QnaBoard review : reviews) {
                    totalScore += review.getBoardScore();
                }
                double avgScore = reviewCount > 0 ? Math.round((totalScore / reviewCount) * 10) / 10.0 : 0;

                item.setAvgScore(avgScore);
                item.setReviewCount(reviewCount);

            } catch (Exception e) {
                System.err.println("상품 평점 및 리뷰 개수 계산 중 오류 발생: " + e.getMessage());
                item.setAvgScore(0.0);
                item.setReviewCount(0);
            }
        }
    }

    @GetMapping("/bestsellers")
    public List<Item> getBestSellers() {
        int limit = 8;

        try {
            List<Item> items = itemService.getBestSellingItems(limit);
            addReviewInfo(items);
            return items;

        } catch (Exception e) {
            System.err.println("Error fetching bestsellers: " + e.getMessage());
            e.printStackTrace(); 
            return Collections.emptyList();
        }
    }

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
