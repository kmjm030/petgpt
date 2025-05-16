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
                String uploadDir = uploadDirectory;
                if (!uploadDir.endsWith(File.separator)) {
                        uploadDir += File.separator;
                }

                String baseUploadUrlPattern = uploadUrlPrefix;
                if (!baseUploadUrlPattern.endsWith("/")) {
                        baseUploadUrlPattern += "/";
                }
                baseUploadUrlPattern += "**";

                String fileSystemPath = "file:///" + uploadDir.replace("\\", "/");

                registry.addResourceHandler(baseUploadUrlPattern)
                                .addResourceLocations(fileSystemPath);

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

                registry.addResourceHandler("/views/**")
                                .addResourceLocations("/views/");
        }
}
