package com.mc.app.msg;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class AdminMsg {
    private int content1;
    private int content2;
    private int content3;
    private int content4;

}
