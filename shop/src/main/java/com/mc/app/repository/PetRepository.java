package com.mc.app.repository;

import com.mc.app.dto.Pet;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface PetRepository extends MCRepository<Pet, Integer> {
    List<Pet> findByCust(String custId) throws Exception;
}