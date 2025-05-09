package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AdminNotice {
  private int id;
  private String adminId;
  private String title;
  private String content;
  private LocalDateTime createdAt;
  private String adminName;
}

