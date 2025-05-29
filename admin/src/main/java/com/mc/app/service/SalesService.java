package com.mc.app.service;

import com.mc.app.repository.SalesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SalesService {

  private final SalesRepository salesRepository;

  public List<Map<String, Object>> getDailySales() {
    return salesRepository.getDailySales();
  }

  public List<Map<String, Object>> getWeeklySales() {
    return salesRepository.getWeeklySales();
  }

  public List<Map<String, Object>> getMonthlySales() {
    return salesRepository.getMonthlySales();
  }

  public List<Map<String, Object>> getRegionSales() {
    return salesRepository.getRegionSales();
  }

  public List<Map<String, Object>> getTopSellingProducts(int limit) {
    return salesRepository.getTopSellingProducts(limit);
  }

  public List<Map<String, Object>> getHourlySales() {
    return salesRepository.getHourlySales();
  }

  public Map<String, Long> getSalesSummary() {
    Map<String, Long> result = new HashMap<>();
    result.put("today", salesRepository.getTodaySales());
    result.put("week",  salesRepository.getWeekSales());
    result.put("month", salesRepository.getMonthSales());
    return result;
  }
}
