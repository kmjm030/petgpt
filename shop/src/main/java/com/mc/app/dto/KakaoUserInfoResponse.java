package com.mc.app.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import java.util.Map;

@Getter
@Setter
@ToString
public class KakaoUserInfoResponse {

    private Long id; 

    @JsonProperty("connected_at")
    private String connectedAt; 

    private Map<String, Object> properties; 

    @JsonProperty("kakao_account")
    private KakaoAccount kakaoAccount; 

    @Getter
    @Setter
    @ToString
    public static class KakaoAccount { 

        @JsonProperty("profile_nickname_needs_agreement")
        private Boolean profileNicknameNeedsAgreement; 

        @JsonProperty("profile_image_needs_agreement")
        private Boolean profileImageNeedsAgreement; 

        private Map<String, Object> profile; 

        @JsonProperty("has_email")
        private Boolean hasEmail; 

        @JsonProperty("email_needs_agreement")
        private Boolean emailNeedsAgreement; 

        @JsonProperty("is_email_valid")
        private Boolean isEmailValid; 

        @JsonProperty("is_email_verified")
        private Boolean isEmailVerified; 

        private String email; 
    }
}
