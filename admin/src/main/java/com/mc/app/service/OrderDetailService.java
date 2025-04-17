package com.mc.app.service;

import com.mc.app.dto.OrderDetail;
import com.mc.app.repository.OrderDetailRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderDetailService {
    private final OrderDetailRepository orderDetailRepository;

    public List<OrderDetail> getAllOrderDetails() {
        return orderDetailRepository.findAll();
    }

    public OrderDetail getOrderDetailById(int id) {
        return orderDetailRepository.findById(id);
    }

    public void deleteById(int id) {
        orderDetailRepository.deleteById(id);
    }
}
