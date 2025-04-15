package com.mc.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${file.upload.directory:C:/petshop/uploads/images}")
    private String uploadDirectory;

    @Value("${file.upload.url.prefix:/uploads/images}")
    private String uploadUrlPrefix;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 업로드 디렉토리 경로의 마지막에 슬래시 추가 확인
        String uploadDir = uploadDirectory;
        if (!uploadDir.endsWith(File.separator)) {
            uploadDir += File.separator;
        }

        // 업로드된 이미지 파일에 접근하기 위한 URL 패턴과 실제 파일 시스템 경로 매핑
        String baseUploadUrlPattern = uploadUrlPrefix;
        if (!baseUploadUrlPattern.endsWith("/")) {
            baseUploadUrlPattern += "/";
        }
        baseUploadUrlPattern += "**";

        // 윈도우 경로 표기법 조정
        String fileSystemPath = "file:///" + uploadDir.replace("\\", "/");

        registry.addResourceHandler(baseUploadUrlPattern)
                .addResourceLocations(fileSystemPath);

        // CSS, JS, 이미지 등의 정적 리소스 매핑 추가
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");
        
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");
        
        registry.addResourceHandler("/img/**")
                .addResourceLocations("classpath:/static/img/");
        
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("classpath:/static/fonts/");
        
        registry.addResourceHandler("/vendor/**")
                .addResourceLocations("classpath:/static/vendor/");
                
        // /community/로 시작하는 경로에 대한 리소스 매핑 추가
        registry.addResourceHandler("/community/css/**")
                .addResourceLocations("classpath:/static/css/");
                
        registry.addResourceHandler("/community/js/**")
                .addResourceLocations("classpath:/static/js/");
                
        registry.addResourceHandler("/community/img/**")
                .addResourceLocations("classpath:/static/img/");
                
        registry.addResourceHandler("/community/fonts/**")
                .addResourceLocations("classpath:/static/fonts/");
                
        registry.addResourceHandler("/community/vendor/**")
                .addResourceLocations("classpath:/static/vendor/");
    }
} 