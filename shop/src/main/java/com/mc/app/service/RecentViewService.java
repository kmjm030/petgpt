package com.mc.app.service;

import com.mc.app.dto.RecentView;
import com.mc.app.dto.RecentView;
import com.mc.app.frame.MCService;
import com.mc.app.repository.RecentViewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class RecentViewService implements MCService<RecentView, Integer> {

    final RecentViewRepository viewRepository;

    @Override
    public void add(RecentView view) throws Exception {
        viewRepository.insert(view);
    }

    @Override
    public void mod(RecentView recentView) throws Exception {

    }

    @Override
    public void del(Integer id) throws Exception {
        viewRepository.delete(id);
    }

    @Override
    public RecentView get(Integer id) throws Exception {
        return viewRepository.selectOne(id);
    }

    @Override
    public List<RecentView> get() throws Exception {
        return viewRepository.select();
    }

    public List<RecentView> findAllByCustomer(String id) throws Exception {
        return viewRepository.findAllByCustomer(id);
    }

    public RecentView findByCustAndItem(String custId, int itemKey) throws Exception {
        Map<String, Object> param = new HashMap<>();
        param.put("custId", custId);
        param.put("itemKey", itemKey);
        return viewRepository.findByCustAndItem(param);
    }
}