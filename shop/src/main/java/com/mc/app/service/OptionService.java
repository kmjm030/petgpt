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

    public List<Option> getOptionsByItem(int itemKey) throws Exception {
        return optionRepository.findAllByItem(itemKey);
    }

    public Option getOption(int optionKey) throws Exception {
        return optionRepository.findById(optionKey);
    }

    public void addOption(Option option) throws Exception {
        optionRepository.insert(option);
    }

    public void removeOption(int optionKey) throws Exception {
        optionRepository.delete(optionKey);
    }

    // 필요한 경우 옵션 수정, 재고 관리 등의 메소드 추가하기기
}
