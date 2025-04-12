package com.mc.app.service;

import com.mc.app.dto.Address;
import com.mc.app.frame.MCService;
import com.mc.app.repository.AddressRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AddressService implements MCService<Address, Integer> {

    final AddressRepository addressRepository;

    @Override
    public void add(Address address) throws Exception {
        addressRepository.insert(address);
    }

    @Override
    public void mod(Address address) throws Exception {
        addressRepository.update(address);
    }

    @Override
    public void del(Integer integer) throws Exception {
        addressRepository.delete(integer);
    }

    @Override
    public Address get(Integer integer) throws Exception {
        return addressRepository.selectOne(integer);
    }

    @Override
    public List<Address> get() throws Exception {
        return addressRepository.select();
    }

    public List<Address> findAllByCustomer(String id) throws Exception {
        return addressRepository.findAllByCustomer(id);
    }
    public Address findById(Integer id) throws Exception {
        return addressRepository.findById(id);
    }
}