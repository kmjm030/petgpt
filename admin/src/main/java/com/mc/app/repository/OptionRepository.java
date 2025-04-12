package com.mc.app.repository;

import com.mc.app.dto.Option;
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
}
