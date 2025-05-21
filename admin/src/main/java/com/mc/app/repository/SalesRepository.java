package com.mc.app.repository;

import lombok.RequiredArgsConstructor;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class SalesRepository {

  private final SqlSession sql;
  private static final String NAMESPACE = "com.mc.app.mapper.SalesMapper.";

  public List<Map<String, Object>> getDailySales() {
    return sql.selectList(NAMESPACE + "selectDailySales");
  }

  public List<Map<String, Object>> getWeeklySales() {
    return sql.selectList(NAMESPACE + "selectWeeklySales");
  }

  public List<Map<String, Object>> getMonthlySales() {
    return sql.selectList(NAMESPACE + "selectMonthlySales");
  }

  public List<Map<String, Object>> getRegionSales() {
    return sql.selectList(NAMESPACE + "selectRegionSales");
  }
}
