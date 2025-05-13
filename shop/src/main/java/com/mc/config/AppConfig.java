package com.mc.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.web.client.RestTemplate;

import javax.annotation.PostConstruct;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Logger;

@Configuration
@PropertySource("classpath:/properties/signup.properties")
public class AppConfig {
    private static final Logger logger = Logger.getLogger(AppConfig.class.getName());

    @Value("${google.vision.credentials.path:}")
    private String googleCredentialsPath;

    @Bean
    public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
    
    @PostConstruct
    public void setupGoogleCredentials() {
        // 환경 변수가 이미 설정되어 있는 경우
        String existingCredPath = System.getenv("GOOGLE_APPLICATION_CREDENTIALS");
        if (existingCredPath != null && !existingCredPath.isEmpty()) {
            logger.info("기존 GOOGLE_APPLICATION_CREDENTIALS: " + existingCredPath);
        }
        
        // 프로퍼티로 설정된 경로 확인
        if (googleCredentialsPath != null && !googleCredentialsPath.isEmpty()) {
            Path path = Paths.get(googleCredentialsPath);
            if (Files.exists(path)) {
                System.setProperty("GOOGLE_APPLICATION_CREDENTIALS", googleCredentialsPath);
                logger.info("GOOGLE_APPLICATION_CREDENTIALS 설정됨: " + googleCredentialsPath);
            } else {
                logger.warning("자격 증명 파일을 찾을 수 없음: " + googleCredentialsPath);
            }
        } else {
            logger.info("Google 자격 증명 경로가 설정되지 않았습니다.");
        }
    }
}