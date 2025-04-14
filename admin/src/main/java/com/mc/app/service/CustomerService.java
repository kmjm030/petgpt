package com.mc.app.service;

//import com.github.pagehelper.Page;
//import com.github.pagehelper.PageHelper;
import com.mc.app.dto.Customer;
import com.mc.app.frame.MCService;
import com.mc.app.repository.CustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

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

//    public Page<Customer> getPage(int pageNo) throws Exception {
//        PageHelper.startPage(pageNo, 3); // pageSize: 한화면에 출력되는 개수
//        return custRepository.getpage();
//    }
}