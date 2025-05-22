package com.mc.app.service;

import com.mc.app.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserService {

  private final UserRepository userRepository;

  public UserService(UserRepository userRepository) {
    this.userRepository = userRepository;
  }

  public List<Map<String, Object>> getDailyUserStats() {
    return userRepository.selectDailyUserStats();
  }

  public List<Map<String, Object>> getMonthlyUserStats() {
    return userRepository.selectMonthlyUserStats();
  }

  public List<Map<String, Object>> getYearlyUserStats() {
    return userRepository.selectYearlyUserStats();
  }

  public Map<String, Long> getUserSummary() {
    Map<String, Long> result = new HashMap<>();
    result.put("today", (long) userRepository.selectTodayUserCount());
    result.put("week", (long) userRepository.selectWeekUserCount());
    result.put("month", (long) userRepository.selectMonthUserCount());
    return result;
  }
}
