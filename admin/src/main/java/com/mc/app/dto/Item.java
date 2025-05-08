package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Item {
  private int itemKey;
  private int categoryKey;
  private String itemName;
  private String itemContent;
  private int itemPrice;
  private int itemSprice;
  private int itemCount;
  private LocalDate itemRdate;
  private LocalDate itemUdate;
  private String itemImg1;
  private String itemImg2;
  private String itemImg3;
  private int salesCount;

  public int getStock() {
    return itemCount;
  }
}
