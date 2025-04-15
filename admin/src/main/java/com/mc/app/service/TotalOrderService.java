package com.mc.app.service;

import com.mc.app.dto.TotalOrder;
import com.mc.app.repository.TotalOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TotalOrderService {

    final TotalOrderRepository totalOrderRepository;

    public int getOrderCount() throws Exception {
        return totalOrderRepository.selectOrderCount();
    }

    public int getTodayRevenue() throws Exception {
        return totalOrderRepository.selectTodayRevenue();
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

    public List<TotalOrder> getRecentOrders() throws Exception {
        return totalOrderRepository.selectRecentOrders();
    }

    // ✅ 최근 활동 로그 (등록/수정/삭제)
    public List<TotalOrder> getActivityLog() throws Exception {
        return totalOrderRepository.selectActivityLog();
    }
}


