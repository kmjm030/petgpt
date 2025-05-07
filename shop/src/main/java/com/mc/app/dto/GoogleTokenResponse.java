package com.mc.app.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GoogleTokenResponse {
    private String access_token;
    private int expires_in;
    private String refresh_token;
    private String scope;
    private String token_type;
    private String id_token;
}
