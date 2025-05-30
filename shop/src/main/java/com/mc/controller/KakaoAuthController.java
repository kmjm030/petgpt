package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.dto.KakaoTokenResponse;
import com.mc.app.dto.KakaoUserInfoResponse;
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
@RequestMapping("/auth/kakao") 
public class KakaoAuthController {

    @Autowired
    private RestTemplate restTemplate; 

    @Autowired
    private CustomerService customerService; 

    @Value("${kakao.client.id}")
    private String clientId;

    @Value("${kakao.redirect.uri}")
    private String redirectUri;

    @Value("${kakao.provider.token-uri}")
    private String tokenUri;

    @Value("${kakao.provider.user-info-uri}")
    private String userInfoUri;

    @GetMapping
    public String loginRedirect() {
        log.info("카카오 로그인 리다이렉트 시작");
        
        String kakaoAuthUrl = "https://kauth.kakao.com/oauth/authorize";
        String redirectUrl = kakaoAuthUrl + "?client_id=" + clientId
                + "&redirect_uri=" + redirectUri
                + "&response_type=code";
                
        log.info("카카오 OAuth URL: {}", redirectUrl);
        return "redirect:" + redirectUrl;
    }

    @GetMapping("/callback") 
    public String kakaoCallback(@RequestParam("code") String code, HttpSession session) {
        log.info("카카오 인증 콜백 수신, 인가 코드: {}", code);

        KakaoTokenResponse tokenResponse = requestAccessToken(code);
        if (tokenResponse == null || tokenResponse.getAccessToken() == null) {
            log.error("카카오 토큰 발급 실패");
            return "redirect:/signin?error=kakao_token_failed"; 
        }
        log.info("카카오 액세스 토큰: {}", tokenResponse.getAccessToken());

        KakaoUserInfoResponse userInfo = requestUserInfo(tokenResponse.getAccessToken());
        if (userInfo == null || userInfo.getId() == null) {
            log.error("카카오 사용자 정보 조회 실패");
            return "redirect:/signin?error=kakao_userinfo_failed";
        }
        log.info("카카오 사용자 정보: {}", userInfo);

        try {
            Long kakaoId = userInfo.getId();
            String generatedCustId = "kakao_" + kakaoId; 

            Customer customer = customerService.get(generatedCustId); 

            if (customer != null) {
                log.info("기존 회원 로그인 처리 시도: {}", generatedCustId);
                boolean needsUpdate = false;
                String nicknameFromKakao = userInfo.getProperties() != null
                        ? (String) userInfo.getProperties().get("nickname")
                        : null;
                String emailFromKakao = userInfo.getKakaoAccount() != null ? userInfo.getKakaoAccount().getEmail()
                        : null;
                String profileImageUrlFromKakao = null;
                if (userInfo.getKakaoAccount() != null && userInfo.getKakaoAccount().getProfile() != null) {
                    profileImageUrlFromKakao = (String) userInfo.getKakaoAccount().getProfile()
                            .get("profile_image_url");
                }

                if (nicknameFromKakao != null && !nicknameFromKakao.equals(customer.getCustNick())) {
                    customer.setCustNick(nicknameFromKakao);
                    customer.setCustName(nicknameFromKakao);
                    needsUpdate = true;
                    log.info("회원 닉네임 업데이트 예정: {}", nicknameFromKakao);
                }

                if (emailFromKakao != null && !emailFromKakao.equals(customer.getCustEmail())) {
                    customer.setCustEmail(emailFromKakao);
                    needsUpdate = true;
                    log.info("회원 이메일 업데이트 예정: {}", emailFromKakao);
                }

                if (profileImageUrlFromKakao != null && !profileImageUrlFromKakao.equals(customer.getCustImg())) {
                    customer.setCustImg(profileImageUrlFromKakao);
                    needsUpdate = true;
                    log.info("회원 프로필 이미지 업데이트 예정");
                }

                if (needsUpdate) {
                    try {
                        customerService.mod(customer); 
                        log.info("기존 회원 정보 업데이트 완료: {}", customer.getCustId());
                    } catch (Exception e) {
                        log.error("기존 회원 정보 업데이트 중 오류 발생", e);
                    }
                }
                session.setAttribute("cust", customer); 
                log.info("기존 회원 로그인 처리 완료: {}", customer.getCustNick()); 

            } else {

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
                        .custPwd(null) 
                        .custName(nickname) 
                        .custNick(nickname)
                        .custEmail(email)
                        .custImg(profileImageUrl)
                        .custAuth(0) 
                        .custPoint(0) 
                        .custRdate(LocalDateTime.now())
                        .build();

                customerService.add(newCustomer); 
                log.info("신규 회원 정보 저장 완료: {}", newCustomer.getCustId());

                session.setAttribute("cust", newCustomer); 
            }

            log.info("카카오 로그인 성공, 메인 페이지로 리다이렉트");
            
            String redirectURL = (String) session.getAttribute("redirectURL");
            if (redirectURL != null && !redirectURL.isEmpty()) {
                session.removeAttribute("redirectURL");
                return "redirect:" + redirectURL;
            }
            
            return "redirect:/"; 
        } catch (Exception e) {
            log.error("카카오 로그인 처리 중 오류 발생: {}", e.getMessage());
            return "redirect:/signin?error=kakao_process_failed"; 
        }
    }

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
