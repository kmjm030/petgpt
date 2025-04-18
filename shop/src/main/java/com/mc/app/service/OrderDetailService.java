package com.mc.app.service;

import com.mc.app.dto.OrderDetail;
import com.mc.app.dto.TotalOrder;
import com.mc.app.frame.MCService;
import com.mc.app.repository.OrderDetailRepository;
import com.mc.app.repository.TotalOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderDetailService implements MCService<OrderDetail, Integer> {

    final OrderDetailRepository orderDetailRepository;

    @Override
    public void add(OrderDetail order) throws Exception {
        orderDetailRepository.insert(order);
    }

    @Override
    public void mod(OrderDetail order) throws Exception {
        orderDetailRepository.update(order);
    }

    @Override
    public void del(Integer id) throws Exception {
        orderDetailRepository.delete(id);
    }

    @Override
    public OrderDetail get(Integer id) throws Exception {
        return orderDetailRepository.selectOne(id);
    }

    @Override
    public List<OrderDetail> get() throws Exception {
        return orderDetailRepository.select();
    }

    public List<OrderDetail> findAllByOrder(Integer orderKey) throws Exception {
        return orderDetailRepository.findAllByOrder(orderKey);
    }




}