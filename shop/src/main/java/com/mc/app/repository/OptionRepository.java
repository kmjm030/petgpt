package com.mc.app.repository;

import com.mc.app.dto.Address;
import com.mc.app.dto.Option;
import com.mc.app.frame.MCRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface OptionRepository {
    List<Option> findAllByItem(int itemKey) throws Exception;
    Option findById(int optionKey) throws Exception;
    void insert(Option option) throws Exception;
    void delete(int optionKey) throws Exception;
    List<String> findAllSizes() throws Exception;
    List<Integer> findItemKeysBySize(String size) throws Exception;
    List<String> findAllColors() throws Exception;
    List<Integer> findItemKeysByColor(String color) throws Exception;
    Option findNameByKey(int optionKey) throws Exception;
    Option selectOne(int optionKey) throws Exception;

    List<String> findDistinctAvailableSizesByItem(int itemKey) throws Exception;
    List<String> findDistinctAvailableColorsByItem(int itemKey) throws Exception;
}
