package com.mc.controller;

import com.mc.app.service.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

  private final UserService userService;

  public UserController(UserService userService) {
    this.userService = userService;
  }

  @GetMapping("/daily")
  public List<Map<String, Object>> getDailyStats() {
    return userService.getDailyUserStats();
  }

  @GetMapping("/monthly")
  public List<Map<String, Object>> getMonthlyStats() {
    return userService.getMonthlyUserStats();
  }

  @GetMapping("/yearly")
  public List<Map<String, Object>> getYearlyStats() {
    return userService.getYearlyUserStats();
  }
}

