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

    private Long id; // 카카오 회원번호 (고유 식별자)

    @JsonProperty("connected_at")
    private String connectedAt; // 서비스 연결 시각 (ISO 8601 형식)

    private Map<String, Object> properties; // 사용자 프로퍼티 (닉네임, 프로필 이미지 등 포함)
                                            // 예: properties.get("nickname"), properties.get("profile_image")

    @JsonProperty("kakao_account")
    private KakaoAccount kakaoAccount; // 카카오계정 정보

    @Getter
    @Setter
    @ToString
    public static class KakaoAccount { // 중첩 클래스로 카카오 계정 정보 표현

        @JsonProperty("profile_nickname_needs_agreement")
        private Boolean profileNicknameNeedsAgreement; // 닉네임 동의 필요 여부

        @JsonProperty("profile_image_needs_agreement")
        private Boolean profileImageNeedsAgreement; // 프로필 이미지 동의 필요 여부

        private Map<String, Object> profile; // 프로필 정보 (닉네임, 썸네일/프로필 이미지 URL 등)
                                             // 예: profile.get("nickname"), profile.get("thumbnail_image_url")

        @JsonProperty("has_email")
        private Boolean hasEmail; // 이메일 보유 여부

        @JsonProperty("email_needs_agreement")
        private Boolean emailNeedsAgreement; // 이메일 동의 필요 여부

        @JsonProperty("is_email_valid")
        private Boolean isEmailValid; // 이메일 유효성

        @JsonProperty("is_email_verified")
        private Boolean isEmailVerified; // 이메일 인증 여부

        private String email; // 사용자 이메일 (동의한 경우)
    }
}
