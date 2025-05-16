package com.mc.app.service;

import com.mc.app.dto.TotalOrder;
import com.mc.app.frame.MCService;
import com.mc.app.repository.TotalOrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TotalOrderService implements MCService<TotalOrder, Integer> {

    final TotalOrderRepository orderRepository;

    @Override
    public void add(TotalOrder order) throws Exception {
        orderRepository.insert(order);
    }

    @Override
    public void mod(TotalOrder order) throws Exception {
        orderRepository.update(order);
    }

    @Override
    public void del(Integer id) throws Exception {
        orderRepository.delete(id);
    }

    @Override
    public TotalOrder get(Integer id) throws Exception {
        return orderRepository.selectOne(id);
    }

    @Override
    public List<TotalOrder> get() throws Exception {
        return orderRepository.select();
    }

    public List<TotalOrder> findAllByCust(String custId) throws Exception {
        return orderRepository.findAllByCustomer(custId);
    }




}