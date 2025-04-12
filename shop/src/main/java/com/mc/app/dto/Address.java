package com.mc.app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Address {
    private int addrKey;
    private String custId;
    private String addrName;
    private String addrAddress;
    private String addrDetail;
    private String addrTel;
    private String addrReq;
    private String addrDef;
    private String addrHomecode;
}
