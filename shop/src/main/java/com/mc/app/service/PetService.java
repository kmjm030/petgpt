package com.mc.app.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.mc.app.dto.Customer;
import com.mc.app.dto.Pet;
import com.mc.app.frame.MCService;
import com.mc.app.repository.CustomerRepository;
import com.mc.app.repository.PetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PetService implements MCService<Pet, Integer> {

    final PetRepository petRepository;

    @Override
    public void add(Pet pet) throws Exception {
        petRepository.insert(pet);
    }

    @Override
    public void mod(Pet pet) throws Exception {
        petRepository.update(pet);
    }

    @Override
    public void del(Integer id) throws Exception {
        petRepository.delete(id);
    }

    @Override
    public Pet get(Integer id) throws Exception {
        return petRepository.selectOne(id);
    }

    @Override
    public List<Pet> get() throws Exception {
        return petRepository.select();
    }

    public List<Pet> findByCust(String custId) throws Exception {
        return petRepository.findByCust(custId);
    }


}