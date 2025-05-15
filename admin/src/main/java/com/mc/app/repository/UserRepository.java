package com.mc.app.repository;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserRepository {
  List<Map<String, Object>> selectDailyUserStats();
  List<Map<String, Object>> selectMonthlyUserStats();
  List<Map<String, Object>> selectYearlyUserStats();
}
