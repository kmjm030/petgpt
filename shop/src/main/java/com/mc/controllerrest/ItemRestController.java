package com.mc.controllerrest;

import com.mc.app.dto.Item;
import com.mc.app.service.ItemService;
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

    // 베스트셀러 8개 조회 (판매량 순)
    @GetMapping("/bestsellers")
    public List<Item> getBestSellers() {
        int limit = 8;
        try {
            return itemService.getBestSellingItems(limit);
        } catch (Exception e) {
            System.err.println("Error fetching bestsellers: " + e.getMessage());
            e.printStackTrace(); // 개발 중 상세 오류 확인
            // 예외 발생 시 빈 리스트 반환
            return Collections.emptyList();
            // 또는 ResponseEntity를 사용하여 오류 상태 반환
            // return
            // ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Collections.emptyList());
        }
    }

    // 신상품 8개 조회 (최신 등록 순)
    @GetMapping("/newarrivals")
    public List<Item> getNewArrivals() {
        int limit = 8;
        try {
            return itemService.getNewestItems(limit);
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
            return itemService.getHighestDiscountItems(limit);
        } catch (Exception e) {
            System.err.println("Error fetching hot sales: " + e.getMessage());
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
