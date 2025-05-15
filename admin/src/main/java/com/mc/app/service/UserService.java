package com.mc.app.service;

import com.mc.app.repository.UserRepository;
import org.springframework.stereotype.Service;

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
}

