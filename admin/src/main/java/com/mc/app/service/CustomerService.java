package com.mc.app.service;

import com.mc.app.dto.Customer;
import com.mc.app.frame.MCService;
import com.mc.app.repository.CustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CustomerService implements MCService<Customer, String> {

    final CustomerRepository custRepository;

    @Override
    public void add(Customer cust) throws Exception {
        custRepository.insert(cust);
    }

    @Override
    public void mod(Customer cust) throws Exception {
        custRepository.update(cust);
    }

    @Override
    public void del(String s) throws Exception {
        custRepository.delete(s);
    }

    @Override
    public Customer get(String s) throws Exception {
        return custRepository.selectOne(s);
    }

    @Override
    public List<Customer> get() throws Exception {
        return custRepository.select();
    }

    public int getCount() throws Exception {
        return custRepository.selectCount();
    }

    public int getTodayJoinCount() throws Exception {
        return custRepository.selectTodayJoinCount();
    }

    public List<Customer> getTodayJoinedCustomers() throws Exception {
        return custRepository.selectTodayJoinedCustomers();
    }

}
