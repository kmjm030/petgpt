package com.mc.controller;

import com.mc.util.SessionCounter;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/traffic")
public class TrafficController {

  @GetMapping("/active-users")
  public Map<String, Integer> getActiveUsers() {
    return Map.of("count", SessionCounter.getActiveSessionCount());
  }
}
