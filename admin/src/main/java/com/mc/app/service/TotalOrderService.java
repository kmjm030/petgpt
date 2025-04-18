package com.mc.app.service;

import com.mc.app.dto.TotalOrder;
import com.mc.app.repository.TotalOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class TotalOrderService {

    private final TotalOrderRepository totalOrderRepository;

    public int getOrderCount() throws Exception {
        return totalOrderRepository.selectOrderCount();
    }

    public int getTodayRevenue() throws Exception {
        return totalOrderRepository.selectTodayRevenue();
    }

    public Map<String, Integer> getOrderStatusCountMap() throws Exception {
        List<Map<String, Object>> rawList = totalOrderRepository.selectOrderStatusCount();
        Map<String, Integer> result = new HashMap<>();

        for (Map<String, Object> row : rawList) {
            String status = (String) row.get("order_status");
            Integer count = ((Number) row.get("count")).intValue();
            result.put(status, count);
        }

        return result;
    }

    public int getUnansweredQnaCount() throws Exception {
        return totalOrderRepository.countUnansweredQna();
    }

    public int getFlaggedReviewCount() throws Exception {
        return totalOrderRepository.countFlaggedReviews();
    }

    public List<TotalOrder> getAll() throws Exception {
        return totalOrderRepository.select();
    }

    public TotalOrder getOne(int orderKey) throws Exception {
        return totalOrderRepository.selectOne(orderKey);
    }

    public void add(TotalOrder order) throws Exception {
        totalOrderRepository.insert(order);
    }

    public void mod(TotalOrder order) throws Exception {
        totalOrderRepository.update(order);
    }

    public void del(int orderKey) throws Exception {
        totalOrderRepository.delete(orderKey);
    }
}
