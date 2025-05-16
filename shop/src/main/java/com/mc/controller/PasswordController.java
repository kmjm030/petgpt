package com.mc.controller;

import com.mc.app.dto.Customer;
import com.mc.app.service.CustomerService;
import com.mc.app.service.EmailService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/password")
@RequiredArgsConstructor
@Slf4j
public class PasswordController {

    private final CustomerService customerService;
    private final EmailService emailService;
    
    private static final Map<String, PasswordResetToken> tokenStore = new HashMap<>();
    
    @GetMapping("/forgot")
    public String forgotPassword() {
        return "pages/forgot_password";
    }
    
    @PostMapping("/request-reset")
    @ResponseBody
    public Map<String, Object> requestPasswordReset(
            @RequestParam("custId") String custId,
            @RequestParam("email") String email,
            HttpServletRequest request) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Customer customer = customerService.get(custId);
            
            if (customer == null) {
                response.put("success", false);
                response.put("message", "등록되지 않은 아이디입니다.");
                return response;
            }
            
            if (!email.equals(customer.getCustEmail())) {
                response.put("success", false);
                response.put("message", "아이디와 이메일이 일치하지 않습니다.");
                return response;
            }
            
            String token = generateToken();
            String resetLink = generateResetLink(request, token);
            
            PasswordResetToken resetToken = new PasswordResetToken(
                    token, 
                    custId, 
                    LocalDateTime.now().plusMinutes(30)
            );
            tokenStore.put(token, resetToken);
            
            String subject = "[PetGPT] 비밀번호 재설정 안내";
            String content = emailService.getPasswordResetEmailTemplate(
                    customer.getCustName() != null ? customer.getCustName() : "고객",
                    resetLink
            );
            
            boolean emailSent = emailService.sendEmail(email, subject, content);
            
            if (emailSent) {
                response.put("success", true);
                response.put("message", "비밀번호 재설정 이메일이 발송되었습니다.\n이메일을 확인해주세요.");
                log.info("비밀번호 재설정 이메일 발송 성공: {}", email);
            } else {
                response.put("success", false);
                response.put("message", "이메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.");
                log.error("비밀번호 재설정 이메일 발송 실패: {}", email);
            }
            
        } catch (Exception e) {
            log.error("비밀번호 재설정 처리 중 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
        
        return response;
    }
    
    @GetMapping("/reset")
    public String showResetPasswordForm(@RequestParam("token") String token, Model model) {
        PasswordResetToken resetToken = tokenStore.get(token);
        
        if (resetToken == null || resetToken.isExpired()) {
            model.addAttribute("error", "만료되거나 유효하지 않은 링크입니다. 다시 시도해주세요.");
            return "pages/error_page";
        }
        
        model.addAttribute("token", token);
        return "pages/reset_password";
    }
    
    @PostMapping("/reset")
    @ResponseBody
    public Map<String, Object> resetPassword(
            @RequestParam("token") String token,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            PasswordResetToken resetToken = tokenStore.get(token);
            
            if (resetToken == null || resetToken.isExpired()) {
                response.put("success", false);
                response.put("message", "만료되거나 유효하지 않은 링크입니다. 다시 시도해주세요.");
                return response;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                response.put("success", false);
                response.put("message", "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
                return response;
            }
            
            if (newPassword.length() < 8) {
                response.put("success", false);
                response.put("message", "비밀번호는 8자 이상이어야 합니다.");
                return response;
            }
            
            Customer customer = customerService.get(resetToken.getCustId());
            if (customer == null) {
                response.put("success", false);
                response.put("message", "사용자 정보를 찾을 수 없습니다.");
                return response;
            }
            
            customer.setCustPwd(newPassword);
            customerService.mod(customer);
            
            tokenStore.remove(token);
            
            response.put("success", true);
            response.put("message", "비밀번호가 성공적으로 변경되었습니다.\n새 비밀번호로 로그인해주세요.");
            
        } catch (Exception e) {
            log.error("비밀번호 변경 중 오류: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
        
        return response;
    }
    
    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
    
    private String generateResetLink(HttpServletRequest request, String token) {
        String baseUrl = request.getScheme() + "://" + request.getServerName();
        
        if (request.getServerPort() != 80 && request.getServerPort() != 443) {
            baseUrl += ":" + request.getServerPort();
        }
        
        return baseUrl + "/password/reset?token=" + token;
    }
    
    private static class PasswordResetToken {
        private final String token;
        private final String custId;
        private final LocalDateTime expiryDate;
        
        public PasswordResetToken(String token, String custId, LocalDateTime expiryDate) {
            this.token = token;
            this.custId = custId;
            this.expiryDate = expiryDate;
        }
        
        public boolean isExpired() {
            return LocalDateTime.now().isAfter(expiryDate);
        }
        
        public String getToken() {
            return token;
        }
        
        public String getCustId() {
            return custId;
        }
        
        public LocalDateTime getExpiryDate() {
            return expiryDate;
        }
    }
} 