package com.mc.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
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
        public void addResourceHandlers(@NonNull ResourceHandlerRegistry registry) {
                // uploadDirectory에서 경로 끝에 /가 없으면 자동으로 붙여줌
                String uploadDir = uploadDirectory;
                if (!uploadDir.endsWith(File.separator)) {
                        uploadDir += File.separator;
                }

                // uploadUrlPrefix도 경로 끝에 /가 없으면 붙이고, 마지막엔 **을 붙여서 하위 폴더/파일까지 포함
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

                // HTML 파일에 대한 리소스 매핑 추가 (views 디렉토리)
                registry.addResourceHandler("/views/**")
                                .addResourceLocations("/views/");
        }
}
