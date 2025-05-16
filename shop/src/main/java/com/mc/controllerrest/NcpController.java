package com.mc.controllerrest;

import com.mc.util.LanguageDetectionUtil;
import com.mc.util.PapagoUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@Slf4j
public class NcpController {

    @Value("${ncp.papago.id}")
    String papagoId;
    @Value("${ncp.papago.key}")
    String papagoKey;

    // @Value("${ncp.chatbot.url}")
    // String chatbotUrl;
    // @Value("${ncp.chatbot.key}")
    // String chatbotKey;

    // @Value("${ncp.ocr.url}")
    // String url;
    // @Value("${ncp.ocr.key}")
    // String key;
    // @Value("${app.dir.uploadimgdir}")
    // String uploadImgDir;

    @PostMapping("/api/translate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> translateText(@RequestBody Map<String, String> payload) {
        try {
            String text = payload.get("text");
            String targetLang = payload.get("targetLang");

            if (targetLang == null || targetLang.isEmpty()) {
                targetLang = "ko";
            }

            log.info("번역 요청: 텍스트={}, 대상 언어={}", text, targetLang);
            String translatedText = PapagoUtil.getMsg(papagoId, papagoKey, text, targetLang);
            Map<String, String> response = new HashMap<>();
            response.put("translatedText", translatedText);
            log.info("번역 완료: {}", translatedText);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("번역 중 오류 발생", e);
            Map<String, String> error = new HashMap<>();
            error.put("error", "번역 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @PostMapping("/api/chat/detect-language")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> detectLanguage(@RequestBody Map<String, String> payload) {
        try {
            String text = payload.get("text");
            if (text == null || text.isEmpty()) {
                Map<String, Object> error = new HashMap<>();
                error.put("error", "텍스트가 제공되지 않았습니다.");
                return ResponseEntity.badRequest().body(error);
            }
            
            String detectedLang = LanguageDetectionUtil.detectLanguage(text);
            boolean isEnglish = "en".equals(detectedLang);
            
            Map<String, Object> response = new HashMap<>();
            response.put("language", detectedLang);
            response.put("isEnglish", isEnglish);
            response.put("text", text);
            
            log.info("언어 감지 결과: 텍스트={}, 언어={}", text, detectedLang);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("언어 감지 중 오류 발생", e);
            Map<String, Object> error = new HashMap<>();
            error.put("error", "언어 감지 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @PostMapping("/api/chat/toggle-translation")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleTranslation(@RequestBody Map<String, Object> payload) {
        try {
            String userId = (String) payload.get("userId");
            boolean enabled = (boolean) payload.getOrDefault("enabled", false);
            
            Map<String, Object> response = new HashMap<>();
            response.put("userId", userId);
            response.put("translationEnabled", enabled);
            response.put("message", enabled ? "번역 서비스가 활성화되었습니다." : "번역 서비스가 비활성화되었습니다.");
            
            log.info("번역 설정 변경: 사용자={}, 활성화={}", userId, enabled);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("번역 설정 변경 중 오류 발생", e);
            Map<String, Object> error = new HashMap<>();
            error.put("error", "번역 설정 변경 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // @RequestMapping("/ocrimpl")
    // public String ocrimpl(Model model, OcrDto ocrDto) throws IOException {
    // String imgname = ocrDto.getImage().getOriginalFilename();
    // log.info("ocrimpl imgname:{}", imgname);
    // FileUploadUtil.saveFile(ocrDto.getImage(), uploadImgDir);
    // JSONObject jsonObject = OCRUtil.getResult(uploadImgDir, imgname, url, key);
    // Map<String, String> map = OCRUtil.getData(jsonObject);

    // model.addAttribute("result", map);
    // model.addAttribute("imgname", imgname);
    // model.addAttribute("center", "link4");
    // return "index";
    // }

    // @MessageMapping("/sendchatbot") 
    // public void sendchat(Msg msg, SimpMessageHeaderAccessor headerAccessor)
    // throws Exception {
    // String id = msg.getSendid();
    // String content = msg.getContent1();
    // log.info("-------------------------");
    // log.info(msg.toString());

    // String result = PapagoUtil.getMsg(papagoId, papagoKey, content, "en");
    // msg.setContent1(result);

    // // String result = ChatBotUtil.getMsg(url,key, content);
    // // msg.setContent1(result);

    // template.convertAndSend("/sendto/" + id, msg);

    // }
}
