package com.mc.app.service;

import com.mc.app.dto.TotalOrder;
import com.mc.app.repository.TotalOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TotalOrderService {

    private final TotalOrderRepository totalOrderRepository;

    public int getTotalRevenue() throws Exception {
        return totalOrderRepository.selectTotalRevenue();
    }

    public List<Map<String, Object>> getTop10Items() throws Exception {
        return totalOrderRepository.selectTop10Items();
    }

    public int getOrderCount() throws Exception {
        return totalOrderRepository.selectOrderCount();
    }

    public Map<String, Integer> getOrderStatusCountMap() throws Exception {
        List<Map<String, Object>> rawList = totalOrderRepository.selectOrderStatusCount();

        if (rawList == null || rawList.isEmpty()) {
            return new HashMap<>();
        }

        return rawList.stream()
                .collect(Collectors.toMap(
                        m -> String.valueOf(m.get("order_status")),
                        m -> ((Number) m.get("count")).intValue()
                ));
    }

    public int getUnansweredQnaCount() throws Exception {
        return totalOrderRepository.countUnansweredQna();
    }

    public int getFlaggedReviewCount() throws Exception {
        return totalOrderRepository.countFlaggedReviews();
    }

    public List<TotalOrder> getAll() throws Exception {
        return totalOrderRepository.selectAll();
    }

    public TotalOrder getOne(int orderKey) throws Exception {
        return totalOrderRepository.selectOne(orderKey);
    }

    public List<TotalOrder> getRecentOrders() throws Exception {
        return totalOrderRepository.selectRecentOrders();
    }


    public void deleteOne(int orderKey) throws Exception {
        totalOrderRepository.deleteOne(orderKey);
    }

    public List<Map<String, Object>> getDailySales(int days) throws Exception {
        return totalOrderRepository.findDailySales(days);
    }

    public List<Map<String, Object>> getSalesByCategory() throws Exception {
        return totalOrderRepository.selectSalesByCategory();
    }

}
