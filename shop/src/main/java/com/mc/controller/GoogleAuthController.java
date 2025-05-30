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
import org.springframework.web.util.UriComponentsBuilder;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

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

    @GetMapping
    public String loginRedirect(HttpSession session) {
        String state = UUID.randomUUID().toString();
        session.setAttribute("oauth_state", state);

        String url = UriComponentsBuilder
                .fromHttpUrl("https://accounts.google.com/o/oauth2/v2/auth")
                .queryParam("client_id", clientId)
                .queryParam("redirect_uri", redirectUri)
                .queryParam("response_type", "code")
                .queryParam("scope", "email profile")
                .queryParam("access_type", "offline")
                .queryParam("state", state)
                .build()
                .toUriString();

        log.debug("Redirecting to Google OAuth: {}", url);
        return "redirect:" + url;
    }

    @GetMapping("/callback")
    public String handleCallback(
            @RequestParam("code") String code,
            @RequestParam("state") String state,
            HttpSession session) {

        String savedState = (String) session.getAttribute("oauth_state");
        if (!Objects.equals(savedState, state)) {
            log.error("Invalid OAuth state: expected={}, actual={}", savedState, state);
            session.removeAttribute("oauth_state");
            return "redirect:/signin?error=invalid_state";
        }

        GoogleTokenResponse tokenResponse = requestAccessToken(code);
        if (tokenResponse == null || tokenResponse.getAccess_token() == null) {
            log.error("구글 토큰 발급 실패");
            return "redirect:/signin?error=google_token_failed";
        }

        GoogleUserInfoResponse userInfo = requestUserInfo(tokenResponse.getAccess_token());
        if (userInfo == null || userInfo.getId() == null) {
            log.error("구글 사용자 정보 조회 실패");
            return "redirect:/signin?error=google_userinfo_failed";
        }

        String generatedCustId = "google_" + userInfo.getId();
        try {
            Customer customer = customerService.get(generatedCustId);
            if (customer != null) {
                log.info("기존 회원 로그인: {}", customer.getCustId());
            } else {
                customer = Customer.builder()
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
                customerService.add(customer);
                log.info("신규 회원 가입 완료: {}", customer.getCustId());
            }
            session.setAttribute("cust", customer);
            
            String redirectURL = (String) session.getAttribute("redirectURL");
            if (redirectURL != null && !redirectURL.isEmpty()) {
                session.removeAttribute("redirectURL");
                return "redirect:" + redirectURL;
            }
            
            return "redirect:/";
        } catch (Exception e) {
            log.error("Google 로그인 프로세스 실패", e);
            return "redirect:/signin?error=google_process_failed";
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
            ResponseEntity<GoogleTokenResponse> resp = restTemplate.postForEntity(
                    tokenUri, request, GoogleTokenResponse.class);
            return resp.getStatusCode() == HttpStatus.OK ? resp.getBody() : null;
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
            ResponseEntity<GoogleUserInfoResponse> resp = restTemplate.exchange(
                    userInfoUri, HttpMethod.GET, request, GoogleUserInfoResponse.class);
            return resp.getStatusCode() == HttpStatus.OK ? resp.getBody() : null;
        } catch (Exception e) {
            log.error("구글 사용자 정보 요청 중 오류", e);
            return null;
        }
    }
}
