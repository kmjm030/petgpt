package com.mc.app.service;

import com.mc.app.dto.Option;
import com.mc.app.repository.OptionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OptionService {

    private final OptionRepository optionRepository;

    public Option get(int optionKey) throws Exception {
      return optionRepository.selectOne(optionKey);
    }

    public List<Option> getOptionsByItem(int itemKey) throws Exception {
        return optionRepository.findAllByItem(itemKey);
    }

    public Option getOption(int optionKey) throws Exception {
        return optionRepository.findById(optionKey);
    }

    public Option findNameByKey(int optionKey) throws Exception {
        return optionRepository.findNameByKey(optionKey);
    }

    public void addOption(Option option) throws Exception {
        optionRepository.insert(option);
    }

    public void removeOption(int optionKey) throws Exception {
        optionRepository.delete(optionKey);
    }

    public List<String> getAllSizes() throws Exception {
        return optionRepository.findAllSizes();
    }

    public List<Integer> getItemKeysBySize(String size) throws Exception {
        return optionRepository.findItemKeysBySize(size);
    }

    public List<String> getAllColors() throws Exception {
        return optionRepository.findAllColors();
    }

    public List<Integer> getItemKeysByColor(String color) throws Exception {
        return optionRepository.findItemKeysByColor(color);
    }

    public List<String> getAvailableSizesByItem(int itemKey) throws Exception {
        return optionRepository.findDistinctAvailableSizesByItem(itemKey);
    }

    public List<String> getAvailableColorsByItem(int itemKey) throws Exception {
        return optionRepository.findDistinctAvailableColorsByItem(itemKey);
    }
}
