package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecentView {
    private int viewKey;
    private String custId;
    private int itemKey;
    private Date viewDate;
    private Item item;
}
