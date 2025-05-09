package com.mc.controllerrest;

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
