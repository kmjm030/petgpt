package com.mc.util;

import java.util.regex.Pattern;

public class LanguageDetectionUtil {

    private static final Pattern KOREAN_PATTERN = Pattern.compile("[가-힣]");
    private static final Pattern ENGLISH_PATTERN = Pattern.compile("[a-zA-Z]");
    
    public static String detectLanguage(String text) {
        if (text == null || text.trim().isEmpty()) {
            return "unknown";
        }
        
        int koreanCharCount = 0;
        int englishCharCount = 0;
        
        for (char c : text.toCharArray()) {
            if (KOREAN_PATTERN.matcher(String.valueOf(c)).matches()) {
                koreanCharCount++;
            } else if (ENGLISH_PATTERN.matcher(String.valueOf(c)).matches()) {
                englishCharCount++;
            }
        }
        
        double totalLength = text.length();
        double koreanRatio = koreanCharCount / totalLength;
        double englishRatio = englishCharCount / totalLength;
        
        if (koreanRatio > 0.3) {
            return "ko";
        } else if (englishRatio > 0.3) {
            return "en";
        } else {
            return "other";
        }
    }
    
    public static boolean isEnglish(String text) {
        return "en".equals(detectLanguage(text));
    }
    
    public static boolean isKorean(String text) {
        return "ko".equals(detectLanguage(text));
    }
} 