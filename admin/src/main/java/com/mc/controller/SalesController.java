package com.mc.controller;

import com.mc.app.service.SalesService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/sales")
public class SalesController {

  private final SalesService salesService;

  @GetMapping("/daily")
  public List<Map<String, Object>> getDailySales() {
    return salesService.getDailySales();
  }

  @GetMapping("/weekly")
  public List<Map<String, Object>> getWeeklySales() {
    return salesService.getWeeklySales();
  }

  @GetMapping("/monthly")
  public List<Map<String, Object>> getMonthlySales() {
    return salesService.getMonthlySales();
  }

  @GetMapping("/region")
  public List<Map<String, Object>> getRegionSales() {
    return salesService.getRegionSales();
  }

}
