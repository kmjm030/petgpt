package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.GoogleTokenResponse;
import com.mc.app.dto.GoogleUserInfoResponse;
import com.mc.app.service.CustomerService;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
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
@RequestMapping("/auth/google")
public class GoogleAuthController {

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private CustomerService customerService;

    @Value("${google.client.id}")
    private String clientId;

    @Value("${google.client.secret}")
    private String clientSecret;

    @Value("${google.redirect.uri}")
    private String redirectUri;

    @Value("${google.provider.token-uri}")
    private String tokenUri;

    @Value("${google.provider.user-info-uri}")
    private String userInfoUri;

    @GetMapping("/callback")
    public String googleCallback(@RequestParam("code") String code, HttpSession session) {
        log.info("구글 인증 콜백 도착, code: {}", code);

        // 1. 액세스 토큰 요청
        GoogleTokenResponse tokenResponse = requestAccessToken(code);
        if (tokenResponse == null || tokenResponse.getAccess_token() == null) {
            log.error("구글 토큰 발급 실패");
            return "redirect:/login?error=google_token_failed";
        }

        // 2. 사용자 정보 요청
        GoogleUserInfoResponse userInfo = requestUserInfo(tokenResponse.getAccess_token());
        if (userInfo == null || userInfo.getId() == null) {
            log.error("구글 사용자 정보 조회 실패");
            return "redirect:/login?error=google_userinfo_failed";
        }

        // 3. 고객 정보 확인 또는 생성
        String generatedCustId = "google_" + userInfo.getId();
        try {
            Customer customer = customerService.get(generatedCustId);

            if (customer != null) {
                log.info("기존 회원 로그인: {}", customer.getCustId());
                session.setAttribute("cust", customer);
            } else {
                Customer newCustomer = Customer.builder()
                        .custId(generatedCustId)
                        .custPwd(null)
                        .custName(userInfo.getName())
                        .custNick(userInfo.getGiven_name())
                        .custEmail(userInfo.getEmail())
                        .custImg(userInfo.getPicture())
                        .custAuth(0)
                        .custPoint(0)
                        .custRdate(LocalDateTime.now())
                        .build();

                customerService.add(newCustomer);
                log.info("신규 회원 가입 완료: {}", newCustomer.getCustId());
                session.setAttribute("cust", newCustomer);
            }

            return "redirect:/";

        } catch (Exception e) {
            log.error("구글 로그인 처리 중 오류 발생", e);
            return "redirect:/login?error=google_process_failed";
        }
    }

    private GoogleTokenResponse requestAccessToken(String code) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("code", code);
        params.add("client_id", clientId);
        params.add("client_secret", clientSecret);
        params.add("redirect_uri", redirectUri);
        params.add("grant_type", "authorization_code");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        try {
            ResponseEntity<GoogleTokenResponse> response = restTemplate.postForEntity(
                    tokenUri, request, GoogleTokenResponse.class);
            return response.getStatusCode() == HttpStatus.OK ? response.getBody() : null;
        } catch (Exception e) {
            log.error("구글 토큰 요청 중 오류", e);
            return null;
        }
    }

    private GoogleUserInfoResponse requestUserInfo(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<Void> request = new HttpEntity<>(headers);

        try {
            ResponseEntity<GoogleUserInfoResponse> response = restTemplate.exchange(
                    userInfoUri, HttpMethod.GET, request, GoogleUserInfoResponse.class);
            return response.getStatusCode() == HttpStatus.OK ? response.getBody() : null;
        } catch (Exception e) {
            log.error("구글 사용자 정보 요청 중 오류", e);
            return null;
        }
    }

}
