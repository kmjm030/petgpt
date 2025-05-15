package com.mc.app.service;

import com.mc.app.repository.SalesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
}

