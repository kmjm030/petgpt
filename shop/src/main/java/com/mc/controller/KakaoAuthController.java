package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.KakaoTokenResponse;
import com.mc.app.dto.KakaoUserInfoResponse;
import com.mc.app.service.CustomerService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j; // Lombok 로깅
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import java.time.LocalDateTime;

@Slf4j
@Controller
@RequestMapping("/auth/kakao") // 이 컨트롤러는 /auth/kakao 로 시작하는 요청 처리
public class KakaoAuthController {

    @Autowired
    private RestTemplate restTemplate; // AppConfig에서 Bean으로 등록한 RestTemplate 주입

    @Autowired
    private CustomerService customerService; // 회원 정보 처리를 위한 서비스 주입

    // signup.properties 파일에서 값 주입
    @Value("${kakao.client.id}")
    private String clientId;

    @Value("${kakao.redirect.uri}")
    private String redirectUri;

    @Value("${kakao.provider.token-uri}")
    private String tokenUri;

    @Value("${kakao.provider.user-info-uri}")
    private String userInfoUri;

    @GetMapping("/callback") // GET /auth/kakao/callback 요청 처리
    public String kakaoCallback(@RequestParam("code") String code, HttpSession session) {
        log.info("카카오 인증 콜백 수신, 인가 코드: {}", code);

        // 1. 인가 코드로 액세스 토큰 요청
        KakaoTokenResponse tokenResponse = requestAccessToken(code);
        if (tokenResponse == null || tokenResponse.getAccessToken() == null) {
            log.error("카카오 토큰 발급 실패");
            return "redirect:/login?error=kakao_token_failed"; // 실패 시 로그인 페이지로
        }
        log.info("카카오 액세스 토큰: {}", tokenResponse.getAccessToken());

        // 2. 액세스 토큰으로 사용자 정보 요청
        KakaoUserInfoResponse userInfo = requestUserInfo(tokenResponse.getAccessToken());
        if (userInfo == null || userInfo.getId() == null) {
            log.error("카카오 사용자 정보 조회 실패");
            return "redirect:/login?error=kakao_userinfo_failed";
        }
        log.info("카카오 사용자 정보: {}", userInfo);

        // 3. 사용자 정보로 회원 확인 및 로그인/가입 처리
        try {
            Long kakaoId = userInfo.getId();
            String generatedCustId = "kakao_" + kakaoId; // 카카오 ID 기반 고유 ID 생성

            Customer customer = customerService.get(generatedCustId); // cust_id로 회원 조회

            if (customer != null) {
                // 기존 회원: 로그인 처리
                log.info("기존 회원 로그인 처리: {}", customer.getCustNick());
                session.setAttribute("cust", customer); // 세션에 'cust' 이름으로 저장
            } else {
                // 신규 회원: 회원 가입 처리
                log.info("신규 회원 가입 및 로그인 처리 (카카오 ID: {})", kakaoId);

                String nickname = userInfo.getProperties() != null ? (String) userInfo.getProperties().get("nickname")
                        : null;
                String email = userInfo.getKakaoAccount() != null ? userInfo.getKakaoAccount().getEmail() : null;
                String profileImageUrl = null;
                if (userInfo.getKakaoAccount() != null && userInfo.getKakaoAccount().getProfile() != null) {
                    profileImageUrl = (String) userInfo.getKakaoAccount().getProfile().get("profile_image_url");
                }

                Customer newCustomer = Customer.builder()
                        .custId(generatedCustId)
                        .custPwd(null) // 소셜 로그인이므로 비밀번호 null
                        .custName(nickname) // 이름은 우선 닉네임으로
                        .custNick(nickname)
                        .custEmail(email)
                        .custImg(profileImageUrl)
                        .custAuth(0) // 기본 권한
                        .custPoint(0) // 초기 포인트
                        .custRdate(LocalDateTime.now())
                        .build();

                customerService.add(newCustomer); // DB에 저장
                log.info("신규 회원 정보 저장 완료: {}", newCustomer.getCustId());

                session.setAttribute("cust", newCustomer); // 세션에 저장
            }

            // 4. 로그인 성공 후 메인 페이지로 리다이렉트
            log.info("카카오 로그인 성공, 메인 페이지로 리다이렉트");
            return "redirect:/"; // 메인 페이지 경로

        } catch (Exception e) {
            log.error("카카오 로그인 처리 중 오류 발생", e);
            return "redirect:/login?error=kakao_process_failed"; // 오류 시 로그인 페이지로
        }
    }

    // 액세스 토큰 요청 메서드
    private KakaoTokenResponse requestAccessToken(String code) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("redirect_uri", redirectUri);
        params.add("code", code);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        try {
            ResponseEntity<KakaoTokenResponse> response = restTemplate.postForEntity(
                    tokenUri, request, KakaoTokenResponse.class);
            return (response.getStatusCode() == HttpStatus.OK) ? response.getBody() : null;
        } catch (Exception e) {
            log.error("카카오 토큰 요청 중 오류 발생", e);
            return null;
        }
    }

    // 사용자 정보 요청 메서드
    private KakaoUserInfoResponse requestUserInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<Void> request = new HttpEntity<>(headers);

        try {
            ResponseEntity<KakaoUserInfoResponse> response = restTemplate.exchange(
                    userInfoUri, HttpMethod.GET, request, KakaoUserInfoResponse.class);
            return (response.getStatusCode() == HttpStatus.OK) ? response.getBody() : null;
        } catch (Exception e) {
            log.error("카카오 사용자 정보 요청 중 오류 발생", e);
            return null;
        }
    }
}
