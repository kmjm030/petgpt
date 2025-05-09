package com.mc.app.service;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    public boolean sendEmail(String to, String subject, String content) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom("hyeonhokim@khu.ac.kr");
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content, true); 
            
            mailSender.send(message);
            log.info("이메일 발송 성공: {}", to);
            return true;
        } catch (Exception e) {
            log.error("이메일 발송 실패: {}", e.getMessage(), e);
            return false;
        }
    }
    
    public String getPasswordResetEmailTemplate(String customerName, String resetLink) {
        return "<div style='font-family: Apple SD Gothic Neo, sans-serif; width: 540px; margin: 0 auto;'>"
            + "<h1 style='color: #3f3f3f; text-align: center; padding: 30px 0;'>PetGPT 비밀번호 재설정</h1>"
            + "<div style='background-color: #f7f7f7; padding: 30px; border-radius: 10px;'>"
            + "<p style='font-size: 15px; line-height: 26px; margin-bottom: 20px;'>"
            + customerName + "님, 안녕하세요.<br/>"
            + "PetGPT 비밀번호 재설정을 위한 링크를 보내드립니다.<br/>"
            + "아래 링크를 클릭하여 비밀번호를 재설정해 주세요."
            + "</p>"
            + "<div style='text-align: center;'>"
            + "<a href='" + resetLink + "' style='display: inline-block; background-color: #3f3f3f; color: #ffffff; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold;'>비밀번호 재설정</a>"
            + "</div>"
            + "<p style='font-size: 13px; line-height: 21px; color: #999; margin-top: 30px;'>"
            + "※ 본 이메일은 발신전용이며, 문의에 대한 회신은 처리되지 않습니다.<br/>"
            + "※ 비밀번호 재설정을 요청하지 않으셨다면 이 메일을 무시하셔도 됩니다."
            + "</p>"
            + "</div>"
            + "<div style='text-align: center; padding: 20px 0;'>"
            + "<p style='font-size: 12px; color: #999;'>© 2025 PetGPT. All rights reserved.</p>"
            + "</div>"
            + "</div>";
    }
} 