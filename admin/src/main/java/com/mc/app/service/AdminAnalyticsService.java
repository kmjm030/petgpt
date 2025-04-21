package com.mc.app.service;

import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminAnalyticsService {

    private final SqlSession session;

    public List<Map<String, Object>> getTodayHourlySales() {
        return session.selectList("OrderMapper.getHourlySales");
    }
}
